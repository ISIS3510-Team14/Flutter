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
    // Referencia a la colección 'scans' en Firestore
    CollectionReference scans = FirebaseFirestore.instance.collection('scans');

    // Añadir un nuevo documento a la colección
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
  Uint8List imageBytes = imageFile.readAsBytesSync();
  return base64Encode(imageBytes);
}

Future<Map<String, dynamic>> getAnswer(String imagePath) async {
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

  String trashString = trashTypes.map((e) => e.type).join(', ');
  openaiAnswer = await ChatService().request(
      "Answer for the image: Which of these types of trash is the user taking the picture holding?: $trashString. Answer only with the type",
      imageBase64);

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

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  Future<Map<String, dynamic>> getAnswerWithTiming() async {
    final startTime = DateTime.now(); // Empieza el conteo del tiempo

    // Obtener la respuesta del análisis de la imagen
    final result = await getAnswer(imagePath);

    final duration = DateTime.now()
        .difference(startTime)
        .inMilliseconds; // Calcular la duración
    final trashType = result['foundTrashType'] ?? 'No Item Detected';

    // Registrar el evento en Firebase Analytics con el tiempo y el resultado
    await logScanToFirestore((duration / 1000).ceil(), trashType);

    return result; // Devolver el resultado original
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Stack(
        children: [
          Image.file(File(imagePath)),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width *
                  0.8, // 80% of the screen width
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 8.0),
                ],
              ),
              child: FutureBuilder<Map<String, dynamic>>(
                future: getAnswerWithTiming(), // Call the async function here
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  String title = snapshot.hasData &&
                          snapshot.data!['foundTrashType'].isNotEmpty
                      ? 'Item Detected!'
                      : 'No Item Detected';

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child:
                            CircularProgressIndicator(), // Show loading indicator while waiting
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
                              color: const Color(0xFFB1CC33), // Icon color
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
