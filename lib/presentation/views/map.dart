import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sustain_u/data/models/loc_model.dart';
import 'package:sustain_u/data/repositories/loc_repository.dart';
import 'package:sustain_u/presentation/views/greenpoints.dart';
import 'package:sustain_u/presentation/widgets/bottom_navbar.dart';
import '../../data/services/firestore_service.dart';
import '../widgets/head.dart';

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
    if (currentPosition == null) {
      await _repository.getInitialPoints(myLoc);
      return;
    }

    final pointsList = await _repository.getInitialPoints(currentPosition!);

    setState(() {
      points = pointsList;
      filteredPoints = points;
      setMarkers();
    });
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
            onTap: () async {
              if (isNavigating) return;
              isNavigating = true;
              await _firestoreService.incrementPointCount(point.name);
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GreenPoints(
                    imagePath: point.imgUrl,
                    title: point.name,
                    description: point.description,
                    categories: const [
                      'Disposables',
                      'Non disposables',
                      'Organic',
                    ],
                  ),
                ),
              );
              setState(() {
                isNavigating = false;
              });
            }),
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
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
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
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(point.description),
                                  const SizedBox(height: 5),
                                  GestureDetector(
                                    onTap: () {},
                                    child: const Text(
                                      "Recyclables and Organic",
                                      style: TextStyle(
                                        color: Color.fromRGBO(17, 144, 198, 1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                if (isNavigating) return;
                                isNavigating = true;
                                await _firestoreService
                                    .incrementPointCount(point.name);
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GreenPoints(
                                      imagePath: point.imgUrl,
                                      title: point.name,
                                      description: point.description,
                                      categories: const [
                                        'Disposables',
                                        'Non disposables',
                                        'Organic',
                                      ],
                                    ),
                                  ),
                                );
                                setState(() {
                                  isNavigating = false;
                                });
                              },
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
