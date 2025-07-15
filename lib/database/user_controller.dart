import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  // Reactive variable to hold the user's name
  final username = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserName();
  }

  /// Loads the current user's name from Firestore
  void _loadUserName() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        username.value = 'User';
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .get();
      if (doc.exists) {
        username.value = doc['name'] ?? 'User';
      } else {
        username.value = 'User';
      }
    } catch (e) {
      username.value = 'User';
      print('Error fetching username: $e');
    }
  }
}
