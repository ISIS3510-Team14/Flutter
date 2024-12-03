import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sustain_u/core/utils/sustainu_colors.dart';
import 'package:sustain_u/data/models/loc_model.dart';
import 'package:sustain_u/data/repositories/loc_repository.dart';
import 'package:sustain_u/presentation/views/greenpoints.dart';
import 'package:sustain_u/presentation/widgets/bottom_navbar.dart';
import '../../data/services/firestore_service.dart';
import '../widgets/head.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key});
  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  final locationController = Location();
  final TextEditingController searchController = TextEditingController();
  LatLng myLoc = const LatLng(4.601947165813252, -74.06540188488111);
  LatLng? currentPosition;
  Set<Marker> markers = {};
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  GoogleMapController? _mapController;
  final FirestoreService _firestoreService = FirestoreService();
  final LocationPointRepository _repository = LocationPointRepository();
  List<LocationPoint> points = [];
  List<LocationPoint> filteredPoints = [];
  bool isNavigating = false;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    customMarker();
    fetchInitialLocationPoints();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchLocationUpdates();
      setMarkers();
    });
  }

  Future<void> fetchInitialLocationPoints() async {
    final pointsList =
        await _repository.getInitialPoints(currentPosition ?? myLoc);

    if (pointsList.isEmpty && !_dialogShown) {
      _showNoInfoDialog();
      return;
    }

    updatePoints(pointsList);

    final connectivityResult = await Connectivity().checkConnectivity();
    if ((connectivityResult != ConnectivityResult.wifi &&
            connectivityResult != ConnectivityResult.mobile) &&
        !_dialogShown) {
      final isConnected = await _hasInternetConnection();

      if (!isConnected) {
        print("NO WIFI OR CELLULAR");
        _showNoWifiDialog();
      }
    }
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  void updatePoints(List<LocationPoint> pointsList) {
    setState(() {
      points = pointsList;
      filteredPoints = points;
      setMarkers();
    });
  }

  void _showNoWifiDialog() {
    _dialogShown = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Offline',
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'You are not connected to Wi-Fi. A default map will be displayed.',
            style: GoogleFonts.montserrat(
              color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor: SustainUColors.limeGreen,
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'OK',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNoInfoDialog() {
    _dialogShown = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Offline',
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'You are not connected to Wi-Fi. Points have not been fetched before, please connect to WiFi to get the green points.',
            style: GoogleFonts.montserrat(
              color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor: SustainUColors.limeGreen,
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'OK',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> customMarker() async {
    customIcon = await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(40, 40)), "assets/ic_pick.png");
  }

  void setMarkers() {
    markers.clear();
    for (final point in filteredPoints) {
      markers.add(
        Marker(
          markerId: MarkerId(point.position.toString()),
          position: point.position,
          icon: customIcon,
          onTap: () => _handleOnTap(point),
        ),
      );
    }
  }

  void _filterSearchResults(String query) {
    setState(() {
      filteredPoints =
          query.isEmpty ? points : _repository.filterPoints(points, query);
    });
  }

  void _moveCameraToCurrentPosition() {
    if (_mapController != null && currentPosition != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(currentPosition!),
      );
    }
  }

  final DraggableScrollableController _draggableController =
      DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: screenHeight * 0.65,
            child: GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: currentPosition ?? myLoc, zoom: 16),
              markers: markers,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                _moveCameraToCurrentPosition();
              },
              myLocationEnabled: true,
            ),
          ),
          Positioned(
            top: 36.0,
            left: 16.0,
            right: 16.0,
            child: HeaderWidget(),
          ),
          DraggableScrollableSheet(
            controller: _draggableController,
            initialChildSize: 0.45,
            minChildSize: 0.3,
            maxChildSize: 0.6,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _draggableController.animateTo(1.0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Icon(Icons.keyboard_arrow_up, color: Colors.green),
                            Text(
                              "Find collection points near you",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 4,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            _filterSearchResults(value);
                          },
                          decoration: InputDecoration(
                            hintText: "Enter a location",
                            prefixIcon: const Icon(Icons.search),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(36, 158, 158, 158),
                                width: 0.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(36, 158, 158, 158),
                                width: 0.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 12.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: filteredPoints.length,
                        itemBuilder: (context, index) {
                          final point = filteredPoints[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: RepaintBoundary(
                              child: ListTile(
                                leading: Image.asset(
                                  "assets/ic_pick.png",
                                  width: 30,
                                  height: 30,
                                ),
                                title: Text(
                                  point.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "${point.description}\n",
                                        style:
                                            DefaultTextStyle.of(context).style,
                                      ),
                                      TextSpan(
                                        text: "Recyclables and Organic",
                                        style: const TextStyle(
                                          color:
                                              Color.fromRGBO(17, 144, 198, 1),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () => _handleOnTap(point),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }

  void _handleOnTap(LocationPoint point) async {
    if (isNavigating) return;

    setState(() {
      isNavigating = true;
    });

    final connectivityResult = await Connectivity().checkConnectivity();

    try {
      if (connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.mobile) {
        await _firestoreService.incrementPointCount(point.name);
      } else {
        print("Offline - unable to increment point count.");
      }

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GreenPoints(
            imagePath: point.imgUrl,
            title: point.name,
            description: point.description,
            categories: point.category,
          ),
        ),
      );
    } catch (e) {
      print("Error during navigation or incrementing count: $e");
    } finally {
      setState(() {
        isNavigating = false;
      });
    }
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return;
    }
    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
          fetchInitialLocationPoints();
        });
      }
    });
  }
}
