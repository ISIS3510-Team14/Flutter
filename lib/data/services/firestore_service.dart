import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustain_u/data/models/loc_model.dart';

class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService() : _db = FirebaseFirestore.instance {
    _db.settings = Settings(persistenceEnabled: true);
  }

  Future<void> incrementPointCount(String pointName) async {
    var collection = _db.collection('locationdb');
    var snapshot =
        await collection.where('name', isEqualTo: pointName).limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      var doc = snapshot.docs.first;
      int currentCount = doc['count'] as int;
      await doc.reference.update({'count': currentCount + 1});
    }
  }

  Future<void> incrementMapAccessCount(String pointName) async {
    var collection = _db.collection('eventdb');
    var snapshot =
        await collection.where('name', isEqualTo: 'MapView').limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      var doc = snapshot.docs.first;
      int currentCount = doc['count'] as int;
      await doc.reference.update({'count': currentCount + 1});
    }
  }

  Future<List<LocationPoint>> fetchLocationPoints() async {
    try {
      final snapshot = await _db
          .collection('locationdb')
          .get(GetOptions(source: Source.cache));
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final geoPoint = data['loc'] as GeoPoint;

        return LocationPoint(
          name: data['name'] ?? '',
          description: data['info1'] ?? '',
          info: data['info2'] ?? '',
          position: LatLng(geoPoint.latitude, geoPoint.longitude),
          imgUrl: data['img'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error fetching location points from cache: $e');
      return [];
    }
  }

  Future<List<LocationPoint>> fetchLocationPointsFromServer() async {
    try {
      final snapshot = await _db
          .collection('locationdb')
          .get(GetOptions(source: Source.server));
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final geoPoint = data['loc'] as GeoPoint;
        return LocationPoint(
          name: data['name'] ?? '',
          description: data['info1'] ?? '',
          info: data['info2'] ?? '',
          position: LatLng(geoPoint.latitude, geoPoint.longitude),
          imgUrl: data['img'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error fetching location points from server: $e');
      return [];
    }
  }
}
