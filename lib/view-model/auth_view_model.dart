import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:spotter/constant-widgets/bottom_nav_bar.dart';
import 'package:spotter/view/auth-view/login_view.dart';

class AuthViewModel with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Registers a new user and stores user data in Firestore
  Future<void> createUser(
    BuildContext context,
    String name,
    String email,
    String password,
  ) async {
    ProgressDialog progressDialog = ProgressDialog(
      context,
      title: const Text('Signing Up'),
      message: const Text('Please wait'),
    );
    progressDialog.show();

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        try {
          await _createUserDocumentIfMissing(name: name);
        } catch (e) {
          debugPrint('Firestore user doc creation failed: $e');
          Fluttertoast.showToast(msg: 'Failed to save user data');
        }

        progressDialog.dismiss();
        Fluttertoast.showToast(msg: 'Sign Up Successfully');
        Get.off(() => const LoginView());
      }
    } on FirebaseAuthException catch (e) {
      progressDialog.dismiss();
      Fluttertoast.showToast(msg: _firebaseErrorToMessage(e.code));
    } catch (e) {
      progressDialog.dismiss();
      debugPrint('Unexpected sign-up error: $e');
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  /// Logs in an existing user and ensures Firestore user document exists
  Future<void> loginUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    ProgressDialog progressDialog = ProgressDialog(
      context,
      title: const Text('Signing In'),
      message: const Text('Please wait'),
    );
    progressDialog.show();

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        try {
          await _createUserDocumentIfMissing(); // Firestore sync
        } catch (e) {
          debugPrint('Firestore login sync failed: $e');
        }

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        progressDialog.dismiss();
        Fluttertoast.showToast(msg: 'Login Successfully');
        Get.off(() => const BottomNavigationBarWidget());
      }
    } on FirebaseAuthException catch (e) {
      progressDialog.dismiss();
      Fluttertoast.showToast(msg: _firebaseErrorToMessage(e.code));
    } catch (e) {
      progressDialog.dismiss();
      debugPrint('Unexpected login error: $e');
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  /// Sends a password reset email to the given email address
  void resetPassword(String email) {
    try {
      auth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(msg: 'Please check email and reset password');
      Get.back();
    } catch (e) {
      debugPrint('Reset password error: $e');
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  /// Logs the user out and clears local data
  Future<void> signOut() async {
    try {
      await auth.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Get.offAll(() => LoginView());
    } catch (e) {
      debugPrint('Logout error: $e');
      Fluttertoast.showToast(msg: 'Failed to sign out');
    }
  }

  /// Creates user Firestore document if it doesn't exist
  Future<void> _createUserDocumentIfMissing({String? name}) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        debugPrint('No authenticated user found');
        return;
      }

      final userDoc = firestore.collection('Users').doc(currentUser.uid);
      final snapshot = await userDoc.get();

      if (!snapshot.exists) {
        await userDoc.set({
          'userId': currentUser.uid,
          'email': currentUser.email ?? '',
          'name': name ?? currentUser.displayName ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });
        debugPrint('Firestore user document created for ${currentUser.uid}');
      } else {
        debugPrint('User document already exists for ${currentUser.uid}');
      }
    } catch (e) {
      debugPrint('Firestore user doc creation error: $e');
      rethrow;
    }
  }

  /// Translates FirebaseAuth error codes into user-friendly messages
  String _firebaseErrorToMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email already in use';
      case 'weak-password':
        return 'Password is too weak';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-not-found':
        return 'No account found for this email';
      case 'network-request-failed':
        return 'No internet connection';
      default:
        return 'Authentication error';
    }
  }
}
