import 'dart:async'; // For the timer
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';
import '../../data/services/openai/openai_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sustain_u/presentation/widgets/bottom_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/utils/sustainu_colors.dart';

Future<void> logScanToFirestore(int durationSeconds, String trashType) async {
  try {
    CollectionReference scans = FirebaseFirestore.instance.collection('scans');
    await scans.add({
      'time': durationSeconds,
      'trash_type': trashType,
    });
  } catch (e) {
    print("Error logging scan to Firestore: $e");
  }
}

class TrashTypeIcon {
  final String type;
  final IconData icon;

  TrashTypeIcon(this.type, this.icon);
}

String convertFileToBase64(File imageFile) {
  try {
    Uint8List imageBytes = imageFile.readAsBytesSync();
    return base64Encode(imageBytes);
  } catch (e) {
    print("Error converting file to base64: $e");
    return '';
  }
}

Future<Map<String, dynamic>> getAnswer(String imagePath, Timer timer) async {
  String? openaiAnswer;
  String imageBase64;
  String foundTrashType = 'None';
  String appropriateBin = "Couldn't find an appropriate bin for this item";

  imageBase64 = convertFileToBase64(File(imagePath));
  List<TrashTypeIcon> trashTypes = [
    TrashTypeIcon('Plastic', Icons.local_drink),
    TrashTypeIcon('Aluminum', Icons.business),
    TrashTypeIcon('Glass', Icons.local_drink),
    TrashTypeIcon('Paper Waste', Icons.article),
    TrashTypeIcon('Cardboard', Icons.inventory),
    TrashTypeIcon('Food Scrap', Icons.fastfood),
    TrashTypeIcon('Yard Waste', Icons.grass),
    TrashTypeIcon('Electronic Waste', Icons.computer),
    TrashTypeIcon('Styrofoam', Icons.recycling),
    TrashTypeIcon('Battery', Icons.battery_charging_full),
    TrashTypeIcon('Hazardous Waste', Icons.warning),
    TrashTypeIcon('Textile Waste', Icons.checkroom),
    TrashTypeIcon('Medical Waste', Icons.health_and_safety),
    TrashTypeIcon('Oil Container', Icons.local_gas_station),
    TrashTypeIcon('Paint Can', Icons.palette),
    TrashTypeIcon('No Item Detected', Icons.announcement_outlined),
  ];
  try {
    String trashString = trashTypes.map((e) => e.type).join(', ');
    openaiAnswer = await ChatService().request(
        "Answer for the image: Which of these types of trash is the user taking the picture holding?: $trashString. Answer only with the type",
        imageBase64);
    print(openaiAnswer);

    for (TrashTypeIcon trash in trashTypes) {
      if (openaiAnswer!.toLowerCase().contains(trash.type.toLowerCase())) {
        foundTrashType = trash.type;
        if (foundTrashType != "No Item Detected") {
          openaiAnswer = await ChatService().request(
              "Answer for the image: What is the most appropriate bin to dispose of a $foundTrashType in?. Indicate if none of the present bins are appropriate. Answer only with a maximum of 20 words.",
              imageBase64);
          appropriateBin = openaiAnswer!;
        }
        break;
      }
    }
  } catch (e) {
    timer.cancel();
    String errorMessage =
        "Lost connection to the internet. Make sure you have an internet connection and try again";
    throw Exception(errorMessage);
  }

  return {
    'foundTrashType': foundTrashType,
    'appropriateBin': appropriateBin,
    'icon': trashTypes
        .firstWhere((trash) => trash.type == foundTrashType,
            orElse: () =>
                TrashTypeIcon('No Item Detected', Icons.announcement_outlined))
        .icon,
  };
}

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String userEmail;

  const DisplayPictureScreen({
    Key? key,
    required this.imagePath,
    required this.userEmail,
  }) : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  int timerCount = 0;
  late Timer _timer;
  bool isTimerActive = false;
  bool _hasPointsBeenAdded = false; // Flag to ensure points are only added once.

  @override
  void initState() {
    super.initState();
    
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> deleteImageFile() async {
    try {
      final file = File(widget.imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print("Error deleting image file: $e");
    }
  }

  void startTimer() {
    isTimerActive = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {
          timerCount += 1;
        });
      }
    });
  }

  Future<Map<String, dynamic>> getAnswerWithTiming() async {
    final result = await getAnswer(widget.imagePath, _timer);
    _timer.cancel();

    final trashType = result['foundTrashType'] ?? 'No Item Detected';

    // Validar si el ítem es detectado
    if (trashType != 'No Item Detected') {
      print("Adding points: Item detected");
      await _addPointsToFirestore(50, trashType); // Añadir 50 puntos siempre que haya un ítem detectado
      result['pointsMessage'] = '+50 points!';
    } else {
      print("No points added: No Item Detected");
      result['pointsMessage'] = ''; // No se muestra mensaje si no se detecta ítem
    }

    await deleteImageFile();
    return result;
  }


  Future<void> _addPointsToFirestore(int newPoints, String trashType) async {
    if(_hasPointsBeenAdded)
    {
        return;
    }

    if (trashType == 'No Item Detected') {
      // No sumar puntos si no se detecta un ítem válido
      print("No points added: No Item Detected");
      return;
    }

    try {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(widget.userEmail);

      final docSnapshot = await userDoc.get();

      final todayDate = DateTime.now().toIso8601String().split('T')[0]; // Solo la fecha en formato "YYYY-MM-DD"
      _hasPointsBeenAdded = true;

      if (docSnapshot.exists) {
        // Si el documento ya existe
        final data = docSnapshot.data() as Map<String, dynamic>;
        final points = data['points'] ?? {};
        final history = List<Map<String, dynamic>>.from(points['history'] ?? []);
        final totalPoints = points['total'] ?? 0;

        // Añadir el registro del día
        history.add({
          'date': todayDate,
          'points': newPoints,
        });

        // Actualizar Firestore con el nuevo historial y total
        await userDoc.update({
          'points.history': history,
          'points.total': totalPoints + newPoints,
        });

        print("50 points successfully added for today's scan.");
        
      } else {
        // Si el documento no existe, crea uno nuevo con el historial del escaneo
        await userDoc.set({
          'user_id': widget.userEmail,
          'points': {
            'history': [
              {
                'date': todayDate,
                'points': newPoints,
              },
            ],
            'total': newPoints,
          },
        });

        print("50 points successfully added.");
      }
    } catch (e) {
      print("Error updating Firestore: $e");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Stack(
        children: [
          Image.file(File(widget.imagePath)),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 8.0),
                ],
              ),
              child: FutureBuilder<Map<String, dynamic>>(
                future: getAnswerWithTiming(),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  String title = snapshot.hasData &&
                          snapshot.data!['foundTrashType'] != 'No Item Detected'
                      ? 'Item Detected!'
                      : 'No Item Detected';

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text(
                        'Identifying waste: $timerCount seconds elapsed',
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      'Error: ${snapshot.error}',
                      style: GoogleFonts.montserrat(
                          color: Colors.black, fontSize: 16),
                      textAlign: TextAlign.center,
                    );
                  } else {
                    final data = snapshot.data!;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.montserrat(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              data['icon'],
                              size: 60,
                              color: const Color(0xFFB1CC33),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['foundTrashType'] ?? 'No result',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    data['appropriateBin'],
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black54,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  if (data.containsKey('pointsMessage') &&
                                      data['pointsMessage']!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        data['pointsMessage'],
                                        style: GoogleFonts.montserrat(
                                          color: SustainUColors.limeGreen,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }
}

