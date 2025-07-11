import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotter/constant-widgets/bottom_nav_bar.dart';
import 'package:spotter/view/auth-view/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
        String uId = auth.currentUser!.uid;

        DocumentReference documentReference = firestore
            .collection('Users')
            .doc(uId);
        await documentReference.set({
          'name': name,
          'email': email,
          'userId': uId,
        });
        progressDialog.dismiss();
        Fluttertoast.showToast(msg: 'Sign Up Successfully');
        Get.off(() => const LoginView());
      }
    } on FirebaseAuthException catch (e) {
      progressDialog.dismiss();
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: 'Email already in use');
        return;
      } else if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: 'Password is weak');
        return;
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'Invalid Password');
      } else if (e.code == 'invalid-email') {
        Fluttertoast.showToast(msg: 'Invalid Email');
      } else if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'User not found');
      }
    } catch (e) {
      progressDialog.dismiss();
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

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
        progressDialog.dismiss();
        Fluttertoast.showToast(msg: 'Login Successfully');
        final SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setBool('isLoggedIn', true);

        Get.off(() => const BottomNavigationBarWidget());
      }
    } on FirebaseAuthException catch (e) {
      progressDialog.dismiss();
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: 'Email already in use');
        return;
      } else if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: 'Password is weak');
        return;
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'Invalid Password');
      } else if (e.code == 'invalid-email') {
        Fluttertoast.showToast(msg: 'Invalid Email');
      } else if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'User not found');
      }
    } catch (e) {
      progressDialog.dismiss();
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  void resetPassword(String email) {
    try {
      auth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(msg: 'Please check email and reset password');
      Get.back();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  void signOut() async {
    await auth.signOut().then((value) async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.clear();
      Get.offAll(() => LoginView());
    });
  }
}
