import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/constants.dart';
import 'package:grad_proj/services/snackbar_service.dart';

class DBService {
  static DBService instance = DBService();

  FirebaseFirestore _db = FirebaseFirestore.instance;

  DBService() {
    _db = FirebaseFirestore.instance;
  }
//collection sit he name of the Field i want to acces in firebase
  String _UserCollection = "Users";

  Future<void> createUserInDB({
    required String userId,
    required String firstName,
    required String lastname,
    required String email,
    required String phoneNumber,
    required String
        password, // possibly add an image url one tro send the image user stores
  }) async {
    try {
      await _db.collection(_UserCollection).doc(userId).set({
        "firstName": firstName,
        "lastName": lastname,
        "Email": email,
        "PhoneNumber": phoneNumber,
        "Password": password, //stupid move > should nto be added here
        "lastSeen": DateTime.now().toUtc()
      });
    } catch (e) {
      print(e);
      SnackBarService.instance.showsSnackBarError(text: "Creation error");
    }
  }
}
