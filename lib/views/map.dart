import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  final locationController = Location();
  LatLng myLoc = const LatLng(4.60140465, -74.0649032880709);
  LatLng? currentPosition;
  List<LatLng> positions = [];
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
      body: Column(
        children: [
          // Google Map Section
          Expanded(
            flex: 2, // Set this to control the map height
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: myLoc, zoom: 17),
              markers: markers,
              onMapCreated: (GoogleMapController controller) {
                // You can also do something when the map is created here
              },
            ),
          ),

          // ListView Section (Scroll with locations)
          Expanded(
            flex: 1, // Set this to control the list height
            child: ListView.builder(
              itemCount: positions.length,
              itemBuilder: (context, index) {
                LatLng pos = positions[index];
                return ListTile(
                  leading: Image.asset(
                    "assets/ic_pick.png", // Use the same image path
                    width: 30,
                    height: 30,
                  ),
                  title: Text("Collection Point ${index + 1}"),
                  subtitle:
                      Text("Coordinates: (${pos.latitude}, ${pos.longitude})"),
                  onTap: () {
                    // Optional: Center map on selected location
                    //_moveCameraToPosition(pos);
                  },
                );
              },
            ),
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
