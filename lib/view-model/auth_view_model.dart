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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(
    BuildContext context,
    String name,
    String email,
    String password,
  ) async {
    final dialog = _showProgressDialog(context, 'Signing Up', 'Please wait');

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        await _createOrUpdateUserDoc(user.uid, name, email);
        await _storeLoginState();

        Fluttertoast.showToast(msg: 'Sign Up Successful');
        _navigateToHome();
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: _mapFirebaseError(e.code));
    } catch (e) {
      debugPrint('Unexpected error during sign up: $e');
      Fluttertoast.showToast(msg: 'Unexpected error during sign up');
    } finally {
      dialog.dismiss();
    }
  }

  Future<void> loginUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    final dialog = _showProgressDialog(context, 'Signing In', 'Please wait');

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        await _createOrUpdateUserDoc(user.uid, null, user.email);
        await _storeLoginState();

        Fluttertoast.showToast(msg: 'Login Successful');
        Get.off(() => const BottomNavigationBarWidget());
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: _mapFirebaseError(e.code));
    } catch (e) {
      debugPrint('Unexpected error during login: $e');
      Fluttertoast.showToast(msg: 'Unexpected error during login');
    } finally {
      dialog.dismiss();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(msg: 'Reset link sent. Check your email.');
      Get.back();
    } catch (e) {
      debugPrint('Reset password error: $e');
      Fluttertoast.showToast(msg: 'Failed to send reset link');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Get.offAll(() => const LoginView());
    } catch (e) {
      debugPrint('Sign out error: $e');
      Fluttertoast.showToast(msg: 'Sign out failed');
    }
  }

  Future<void> _createOrUpdateUserDoc(
    String userId,
    String? name,
    String? email,
  ) async {
    try {
      final userRef = _firestore.collection('Users').doc(userId);
      final userSnapshot = await userRef.get();

      if (!userSnapshot.exists) {
        await userRef.set({
          'userId': userId,
          'email': email ?? '',
          'name': name ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });
        debugPrint('Created user document for $userId');
      } else {
        debugPrint('User document already exists for $userId');
      }
    } catch (e) {
      debugPrint('Firestore error: $e');
      Fluttertoast.showToast(msg: 'Failed to sync user profile');
      rethrow;
    }
  }

  ProgressDialog _showProgressDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    final dialog = ProgressDialog(
      context,
      title: Text(title),
      message: Text(message),
    );
    dialog.show();
    return dialog;
  }

  Future<void> _storeLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  void _navigateToHome() {
    Future.delayed(const Duration(milliseconds: 300), () {
      Get.offAll(() => const BottomNavigationBarWidget());
    });
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email already in use';
      case 'weak-password':
        return 'Password too weak';
      case 'invalid-email':
        return 'Invalid email format';
      case 'wrong-password':
        return 'Incorrect password';
      case 'user-not-found':
        return 'Account not found';
      case 'network-request-failed':
        return 'No internet connection';
      default:
        return 'Authentication failed';
    }
  }
}
