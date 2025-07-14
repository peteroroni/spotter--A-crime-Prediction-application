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
        await _createUserDocumentIfMissing(name: name);
        progressDialog.dismiss();
        Fluttertoast.showToast(msg: 'Sign Up Successfully');
        Get.off(() => const LoginView());
      }
    } on FirebaseAuthException catch (e) {
      progressDialog.dismiss();
      Fluttertoast.showToast(msg: _firebaseErrorToMessage(e.code));
    } catch (e) {
      progressDialog.dismiss();
      debugPrint('CreateUser error: $e');
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  /// Logs in a user and ensures Firestore document exists
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
        await _createUserDocumentIfMissing(); // Firestore sync for login
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
      debugPrint('Login error: $e');
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  /// Sends a password reset email
  void resetPassword(String email) {
    try {
      auth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(msg: 'Please check email and reset password');
      Get.back();
    } catch (e) {
      debugPrint('ResetPassword error: $e');
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  /// Logs out the user and clears local session
  Future<void> signOut() async {
    await auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(() => LoginView());
  }

  /// Ensures user document exists in Firestore
  Future<void> _createUserDocumentIfMissing({String? name}) async {
    final currentUser = auth.currentUser;
    if (currentUser == null) return;

    final userDoc = firestore.collection('Users').doc(currentUser.uid);
    final snapshot = await userDoc.get();

    if (!snapshot.exists) {
      await userDoc.set({
        'userId': currentUser.uid,
        'email': currentUser.email,
        'name': name ?? currentUser.displayName ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
      debugPrint('Firestore user document created for ${currentUser.uid}');
    } else {
      debugPrint(
        'Firestore user document already exists for ${currentUser.uid}',
      );
    }
  }

  /// Converts FirebaseAuth error codes to readable messages
  String _firebaseErrorToMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email already in use';
      case 'weak-password':
        return 'Password is weak';
      case 'wrong-password':
        return 'Invalid Password';
      case 'invalid-email':
        return 'Invalid Email';
      case 'user-not-found':
        return 'User not found';
      default:
        return 'Authentication error';
    }
  }
}
