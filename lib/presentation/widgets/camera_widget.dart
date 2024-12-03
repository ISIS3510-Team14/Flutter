import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sustain_u/presentation/widgets/display_picture_widget.dart';
import '../../core/utils/sustainu_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/services/storage_service.dart';


class CameraWidget extends StatefulWidget {
  final CameraDescription camera;

  const CameraWidget({required this.camera});

  @override
  CameraWidgetState createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isConnected = true;
  String? userEmail;
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();

    // Obtener el email del usuario
    _getUserEmail();


    // Check initial connectivity and listen for connectivity changes
    _checkInternetConnection();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _checkInternetConnection();
    });
  }

  Future<void> _getUserEmail() async {
    final userCredentials = await _storageService.getUserCredentials();
    setState(() {
      userEmail = userCredentials?['email']; // Obtiene el campo 'email' desde SharedPreferences
    });
  }


  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
    });
  }

  /// Método para agregar puntos al Firestore
  Future<void> _addPointsToFirestore(int newPoints) async {
    if (userEmail == null) {
      print("El correo del usuario no está disponible.");
      return;
    }

    try {
      // Referencia al documento del usuario en Firestore
      final userDoc = FirebaseFirestore.instance.collection('users').doc(userEmail);

      // Obtiene el documento del usuario
      final docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        // Si el documento ya existe, actualiza los puntos
        final data = docSnapshot.data() as Map<String, dynamic>;
        final points = data['points'] ?? {};
        final history = List<Map<String, dynamic>>.from(points['history'] ?? []);
        final totalPoints = points['total'] ?? 0;

        // Agrega la nueva entrada al historial
        history.add({
          'date': DateTime.now().toIso8601String().split('T')[0], // Solo la fecha
          'points': newPoints,
        });

        // Actualiza los puntos y el historial en Firestore
        await userDoc.update({
          'points.history': history,
          'points.total': totalPoints + newPoints,
        });
      } else {
        // Si el documento no existe, crea uno nuevo
        await userDoc.set({
          'user_id': userEmail,
          'points': {
            'history': [
              {
                'date': DateTime.now().toIso8601String().split('T')[0],
                'points': newPoints,
              },
            ],
            'total': newPoints,
          },
        });
      }

      // Show notification when points are added
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Congratulations, You earned $newPoints points!",
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          backgroundColor: SustainUColors.limeGreen,
          duration: Duration(seconds: 3),
        ),
      );

      print("Puntos añadidos correctamente.");
    } catch (e) {
      print("Error al actualizar Firestore: $e");
    }
  }

  /// Simulate detecting an item
  Future<String> _detectItem() async {
    // Replace this placeholder with actual detection logic
    await Future.delayed(Duration(seconds: 1)); // Simulate delay for detection
    return "item detected"; // Change to "item not detected" for testing
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Create a 16:9 aspect ratio container for the camera preview
          return Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: CameraPreview(_controller),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () async {
                      try {
                        if (!_isConnected) {
                          // Show dialog for no internet connection
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: Text(
                                  'No Internet Connection',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Please check your connection and try again.',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.black54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'What would you like to do?',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/recycle');
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  SustainUColors.limeGreen,
                                              minimumSize: const Size(200, 50),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              'Review Recycling Tips',
                                              style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Center(
                                          child: TextButton(
                                            onPressed: () async {
                                              try {
                                                await _initializeControllerFuture;
                                                // Capture the picture
                                                final image = await _controller
                                                    .takePicture();

                                                // Get the temporary directory
                                                final directory =
                                                    await getTemporaryDirectory();
                                                // Define the new file path in the temporary directory
                                                final String filePath =
                                                    '${directory.path}/saved_image_${DateTime.now().millisecondsSinceEpoch}.jpg';

                                                // Save the picture in the temporary directory
                                                final savedImage =
                                                    await File(image.path)
                                                        .copy(filePath);

                                                // Optionally show a confirmation
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Picture saved to temporary storage!'),
                                                  ),
                                                );

                                                Navigator.pop(context);
                                              } catch (e) {
                                                print(
                                                    "Error saving picture: $e");
                                              }
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  SustainUColors.limeGreen,
                                              minimumSize: const Size(200, 50),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              'Save Picture for Later',
                                              style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Center(
                                          child: TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  SustainUColors.limeGreen,
                                              minimumSize: const Size(200, 50),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              'Cancel',
                                              style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          await _initializeControllerFuture;
                          final image = await _controller.takePicture();

                          // Lógica para guardar puntos en Firestore
                          await _addPointsToFirestore(50); // Añade 50 puntos por foto

                          if (!context.mounted) return;
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  DisplayPictureScreen(imagePath: image.path),
                            ),
                          );
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                      size: 32.0,
                    ),
                    shape: const CircleBorder(),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}