import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotter/constant-widgets/bottom_nav_bar.dart';
import 'package:spotter/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ReportViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addCrimeReport({
    required String name,
    required String cnic,
    required String category,
    required String location,
    required String date,
    required String time,
    required String description,
    required String crimeType,
    required String timeOfCrime,
  }) async {
    EasyLoading.show(status: 'Submitting report...');

    final user = _auth.currentUser;
    if (user == null) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: 'User not logged in');
      return;
    }

    try {
      await _firestore.collection('Posts').add({
        'userId': user.uid,
        'userEmail': user.email ?? 'unknown',
        'reporterName': name,
        'reporterCnic': cnic,
        'crimeType': category,
        'location': location,
        'date': date,
        'timeOfCrime': time,
        'description': description,
        'timestamp': Timestamp.now(),
        'approved': false,
      });

      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: 'Report submitted successfully');

      LocalNotificationService.sendNotification(
        title: 'New Crime Reported',
        message: '$category in $location',
      );

      // Clear navigation stack and go to homepage
      Get.offAll(() => const BottomNavigationBarWidget());
    } catch (e) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: 'Error submitting report: $e');
    }
  }
}
