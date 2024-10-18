import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
}
