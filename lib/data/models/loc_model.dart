import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPoint {
  final String name;
  final String description;
  final String info;
  final LatLng position;
  final String imgUrl;
  final List<dynamic> category;

  LocationPoint(
      {required this.name,
      required this.description,
      required this.info,
      required this.position,
      required this.imgUrl,
      required this.category});
}
