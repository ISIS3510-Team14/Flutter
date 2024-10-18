import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustain_u/data/models/loc_model.dart';

class LocationPointRepository {
  final List<LocationPoint> _points = [
    LocationPoint(
        name: 'Mario Laserna (ML)',
        description: '6th Floor, next to the elevators',
        position: LatLng(4.602796139679612, -74.06469731690541)),
    LocationPoint(
        name: 'Carlos Pacheco Devia (W)',
        description: '3rd floor near the elevators',
        position: LatLng(4.602124935457818, -74.06501910977771)),
    LocationPoint(
        name: 'Z',
        description: 'In the food court',
        position: LatLng(4.602362693133353, -74.06544969672042)),
    LocationPoint(
        name: 'El Bobo',
        description: 'Between buildings C and B',
        position: LatLng(4.601199293613709, -74.06537508662423)),
    LocationPoint(
        name: 'Santo Domingo (SD)',
        description: '8th Floor, by the stairs',
        position: LatLng(4.604240151032256, -74.0659585186188)),
  ];

  List<LocationPoint> getInitialPoints() {
    return _points;
  }

  List<LocationPoint> filterPoints(String query) {
    return _points
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
