import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sustain_u/views/greenpoints.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  final locationController = Location();
  LatLng myLoc = const LatLng(4.601947165813252, -74.06540188488111);
  LatLng? currentPosition;
  List<LatLng> positions = [];
  List<String> point = [];
  List<String> data = [];

  Set<Marker> markers = {};
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    initData();
    customMarker();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchLocationUpdates();
      setMarkers();
    });
  }

  Future<void> initData() async {
    point.addAll([
      'Mario Laserna',
      'Carlos Pacheco Devia',
      'El Bobo',
      'Z',
      'Santo Domingo'
    ]);
    data.addAll([
      '6th Floor, next to the elevators ',
      '3rd floor near the elevators',
      'Between buildings C and B',
      'In the food court',
      'By the stairs'
    ]);
    positions.addAll(
      [
        const LatLng(4.602796139679612, -74.06469731690541),
        const LatLng(4.602124935457818, -74.06501910977771),
        const LatLng(4.601199293613709, -74.06537508662423),
        const LatLng(4.602362693133353, -74.06544969672042),
        const LatLng(4.604240151032256, -74.0659585186188)
      ],
    );
  }

  Future<void> customMarker() async {
    BitmapDescriptor.asset(
      const ImageConfiguration(),
      "assets/ic_pick.png",
      width: 40,
      height: 40,
    ).then((icon) {
      setState(() {
        customIcon = icon;
        setMarkers();
      });
    });
  }

  void setMarkers() {
    markers.clear();
    for (var position in positions) {
      markers.add(Marker(
        markerId: MarkerId(position.toString()),
        position: position,
        icon: customIcon,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: myLoc, zoom: 17),
            markers: markers,
            onMapCreated: (GoogleMapController controller) {},
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.4,
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
                    const Padding(
                      padding: EdgeInsets.all(8.0),
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
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: positions.length,
                        itemBuilder: (context, index) {
                          LatLng pos = positions[index];
                          String pointName = point[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: Image.asset(
                                "assets/ic_pick.png",
                                width: 30,
                                height: 30,
                              ),
                              title: Text(
                                pointName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data[index]),
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
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GreenPoints(
                                      imagePath: "assets/canecaML.png",
                                      title: point[index],
                                      description: "5th floor - Near cafeteria",
                                      categories: const [
                                        'Disposables',
                                        'Non disposables',
                                        'Organic'
                                      ],
                                    ),
                                  ),
                                );
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
    );
  }

  // Future<void> _moveCameraToPosition(LatLng position) async {
  //   final GoogleMapController controller = await GoogleMapController.init();
  //   controller.animateCamera(CameraUpdate.newLatLng(position));
  // }

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
        });
      }
    });
  }
}
