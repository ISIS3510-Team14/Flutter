import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustain_u/data/models/loc_model.dart';
import 'package:sustain_u/data/services/firestore_service.dart';

class LocationPointRepository {
  final FirestoreService _firestoreService = FirestoreService();

  Future<List<LocationPoint>> getInitialPoints(LatLng myLoc) async {
    List<LocationPoint> points;

    points = await _firestoreService.fetchLocationPoints();

    if (points.isEmpty) {
      points = await _firestoreService.fetchLocationPointsFromServer();
    }

    return _sortPointsByDistance(points, myLoc);
  }

  List<LocationPoint> filterPoints(List<LocationPoint> points, String query) {
    return points
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<LocationPoint> _sortPointsByDistance(
      List<LocationPoint> points, LatLng myLoc) {
    points.sort((a, b) {
      double distanceA = Geolocator.distanceBetween(
        myLoc.latitude,
        myLoc.longitude,
        a.position.latitude,
        a.position.longitude,
      );

      double distanceB = Geolocator.distanceBetween(
        myLoc.latitude,
        myLoc.longitude,
        b.position.latitude,
        b.position.longitude,
      );

      return distanceA.compareTo(distanceB);
    });

    return points;
  }
}
