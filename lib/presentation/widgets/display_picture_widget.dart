import 'dart:async'; // For the timer
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';
import '../../data/services/openai/openai_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sustain_u/presentation/widgets/bottom_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    // You might want to return an empty string or throw an exception
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
        break; // Exit loop after the first match
      }
    }
  } catch (e) {
    // Modify the error message
    timer.cancel();
    String errorMessage = "Lost connection to the internet. Make sure you have an internet connection and try again";
    // Rethrow the exception with the new message
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

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  int timerCount = 0; // Timer count in seconds
  late Timer _timer; // Timer object
  bool isTimerActive = false; // To track if the timer is running

  @override
  void initState() {
    super.initState();
    startTimer(); // Start the timer when the screen loads
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
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

  // Function to start the timer
  void startTimer() {
    isTimerActive = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {
          timerCount += 1; // Increment the timer every second
        });
      }
    });
  }

  Future<Map<String, dynamic>> getAnswerWithTiming() async {
    final result = await getAnswer(widget.imagePath, _timer);
    _timer.cancel(); // Stop the timer when the future is completed

    final startTime = DateTime.now(); // Empieza el conteo del tiempo

    final duration = DateTime.now()
        .difference(startTime)
        .inMilliseconds; // Calcular la duración
    final trashType = result['foundTrashType'] ?? 'No Item Detected';

    // Registrar el evento en Firebase Analytics con el tiempo y el resultado
    await logScanToFirestore((duration / 1000).ceil(), trashType);
    await deleteImageFile();
    return result; // Return the result
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
              width: MediaQuery.of(context).size.width * 0.8,
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
                        const SizedBox(height: 1),
                        Row(
                          children: [
                            Icon(
                              data['icon'],
                              size: 60,
                              color: const Color(0xFFB1CC33),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Center(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data['foundTrashType'] ?? 'No result',
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    data['appropriateBin'],
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              )),
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
