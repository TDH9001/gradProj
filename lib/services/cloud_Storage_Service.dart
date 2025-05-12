import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'package:flutter/material.dart';

class CloudStorageService {
  static CloudStorageService instance = CloudStorageService();

  FirebaseStorage _storage = FirebaseStorage.instance;

  Reference baseRef = FirebaseStorage.instance.ref();

  final String _profileimages = "profile image of user";
  final String _messageFiles = "messageFiles of chats";
  final String _images = "images";
  final String _voice = "voices";

  CloudStorageService() {
    _storage = FirebaseStorage.instance;
    Reference _baseRef = FirebaseStorage.instance.ref();
    // the refereance of the storage lcoation
  }

  Future<TaskSnapshot?> upLoadUserProfileImage(
      {required String uid, required File image}) async {
    try {
      return await baseRef.child(_profileimages).child(uid).putFile(image);
    } on Exception catch (e) {
      if (e is SocketException) {
        print(e);
      }
      print(e);
    }
  }

  Future<TaskSnapshot?> uploadChatFile(
      {required String uid, required File fileData}) async {
    var _timestamp = Timestamp.now();
    var _Filename = p.basename(
        fileData.path); //for when the file is not taken from the galary
    // _Filename += "_${_timestamp.toString()}";
    try {
      return baseRef
          .child(_messageFiles)
          .child(uid)
          .child(_images)
          .child(_Filename)
          .putFile(fileData);
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<TaskSnapshot?> uploadVoice({
    required String uid,
    required File fileData,
  }) async {
    var _timestamp = Timestamp.now();
    var _Filename = p.basename(fileData.path);
    try {
      var data = await baseRef
          .child(_voice)
          .child(uid)
          .child(_Filename)
          .putFile(fileData);
      print("uploaded");
      return data;
    } on Exception catch (e) {
      print(e);
    }
  }
}
