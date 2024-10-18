import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPoint {
  final String name;
  final String description;
  final LatLng position;

  LocationPoint(
      {required this.name, required this.description, required this.position});
}
