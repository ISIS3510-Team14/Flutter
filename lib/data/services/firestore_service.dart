import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustain_u/data/models/loc_model.dart';
import 'local_storage_service.dart';

class FirestoreService {
  final FirebaseFirestore _db;
  final LocalStorageService _localStorageService;

  FirestoreService()
      : _db = FirebaseFirestore.instance,
        _localStorageService = LocalStorageService() {
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

  Future<void> incrementMapAccessCount(String way) async {
    var collection = _db.collection('eventdb');
    var snapshot =
        await collection.where('name', isEqualTo: 'MapView').limit(1).get();

    if (snapshot.docs.isNotEmpty) {
      var doc = snapshot.docs.first;

      int currentCount = doc['count'] as int;
      int currentHour = DateTime.now().hour;
      print('HORA $currentHour');
      String hourField = '$currentHour';

      int currentHourAccess = doc[hourField] as int? ?? 0;

      String? fieldToIncrement;
      if (way == "nav") {
        fieldToIncrement = 'NavBar';
      } else if (way == "home") {
        fieldToIncrement = 'MainMenu';
      } else {
        fieldToIncrement = null;
      }

      Map<String, dynamic> updates = {
        'count': currentCount + 1,
        hourField: currentHourAccess + 1,
      };

      if (fieldToIncrement != null) {
        int currentFieldCount = doc[fieldToIncrement] as int? ?? 0;
        updates[fieldToIncrement] = currentFieldCount + 1;
      }

      await doc.reference.update(updates);
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
          category: data['info3'] ?? '',
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
          category: data['info3'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error fetching location points from server: $e');
      return [];
    }
  }

  Future<List<DateTime>> fetchHistoryEntries(String userEmail) async {
    try {
      final snapshot = await _db
          .collection('users')
          .doc(userEmail)
          .get(GetOptions(source: Source.server));

      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null &&
            data['points'] != null &&
            data['points']['history'] != null) {
          final historyList = data['points']['history'] as List;

          final entries = historyList.map((entry) {
            return DateTime.parse(entry['date']);
          }).toList();

          // Save to local storage for offline use
          await _localStorageService.saveHistoryEntries(entries);

          return entries;
        }
      }
    } catch (e) {
      print('Error fetching history entries from Firestore: $e');
    }

    // Fallback to local storage
    print('Fetching history entries from local storage...');
    return await _localStorageService.getHistoryEntries();
  }
}
