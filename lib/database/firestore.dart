import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreDatabase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference posts = FirebaseFirestore.instance.collection(
    'Posts',
  );

  /// Add a new crime report to Firestore
  Future<bool> addCrimeReport({
    required String crimeType,
    required String location,
    required String timeOfCrime,
    required String date,
    required String description,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      print('Error: No user is logged in.');
      return false;
    }

    try {
      await posts.add({
        'userId': user.uid,
        'userEmail': user.email ?? 'unknown',
        'crimeType': crimeType,
        'location': location,
        'timeOfCrime': timeOfCrime,
        'date': date,
        'description': description,
        'timestamp': Timestamp.now(),
        'approved': false, // for future moderation use
      });
      return true;
    } catch (e) {
      print('Firestore error: $e');
      return false;
    }
  }

  /// Stream of all crime reports ordered by newest
  Stream<QuerySnapshot> getPostStream() {
    return posts.orderBy('timestamp', descending: true).snapshots();
  }

  /// Stream of today’s crime reports (grouping handled in UI)
  Stream<List<QueryDocumentSnapshot>> getTodaysPosts() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final starttimestamp = Timestamp.fromDate(startOfDay);

    return posts
        .where('timestamp', isGreaterThanOrEqualTo: starttimestamp)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }
}
