import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustain_u/data/models/loc_model.dart';
import 'package:sustain_u/data/services/firestore_service.dart';

class LocationPointRepository {
  final FirestoreService _firestoreService = FirestoreService();

  Future<List<LocationPoint>> getInitialPoints() async {
    return await _firestoreService.fetchLocationPoints();
  }

  List<LocationPoint> filterPoints(List<LocationPoint> points, String query) {
    return points
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
