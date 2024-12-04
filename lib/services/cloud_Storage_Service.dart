import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:flutter/material.dart';

class CloudStorageService {
  static CloudStorageService instance = CloudStorageService();

  FirebaseStorage _storage = FirebaseStorage.instance;
  Reference _baseRef = FirebaseStorage.instance.ref();
  String _profileimages = "profile image of user";
  CloudStorageService() {
    _storage = FirebaseStorage.instance;
    Reference _baseRef = FirebaseStorage.instance
        .ref(); // the refereance of the storage lcoation
  }

  Future<TaskSnapshot?> upLoadUserProfileImage(
      {required BuildContext cont,
      required String uid,
      required File image}) async {
    try {
      return await _baseRef.child(_profileimages).child(uid).putFile(image);
    } catch (e) {
      print(e);
    }
  }
}
