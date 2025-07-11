import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotter/model/profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileViewModel with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  DocumentReference? userRef;
  ProfileModel profileModel = ProfileModel(
    name: '',
    email: '',
    userId: '',
    profileImage: '',
  );
  File? image;
  final picker = ImagePicker();
  bool isUpload = false;
  String name = '';

  Future pickImage() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
      storeImage();
    } else {
      Fluttertoast.showToast(msg: 'No image selected');
    }
  }

  Future storeImage() async {
    isUpload = true;
    notifyListeners();
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    try {
      Reference storageRef = firebaseStorage.ref().child(
        'profileImage/${profileModel.email}/',
      );
      UploadTask uploadTask = storageRef.putFile(image!);
      await Future.value(uploadTask);
      var newUrl = await storageRef.getDownloadURL();

      userRef = firestore.collection('Users').doc(auth.currentUser!.uid);
      await userRef!.update({'profileImage': newUrl.toString()});
      Fluttertoast.showToast(msg: 'Image Updated');
      getUserData();
      isUpload = false;
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong');
      isUpload = false;
      notifyListeners();
      rethrow;
    }
  }

  void updateName(String name) async {
    userRef = firestore.collection('Users').doc(auth.currentUser!.uid);
    await userRef!.update({'name': name});

    Get.back();
    Fluttertoast.showToast(msg: 'Name Updated');
  }

  Stream<ProfileModel> getUserData() async* {
    DocumentSnapshot snapshot = await firestore
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .get();

    profileModel = ProfileModel.fromMap(
      snapshot.data() as Map<String, dynamic>,
    );
    notifyListeners();
    yield profileModel;
  }
}
