import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/constants.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import '../models/contact.dart';
import '../models/Chats.dart';
import '../models/message.dart';

class DBService {
  static DBService instance = DBService();

  FirebaseFirestore _db = FirebaseFirestore.instance;

  DBService() {
    _db = FirebaseFirestore.instance;
  }
//collection sit he name of the Field i want to acces in firebase
  String _UserCollection = "Users";
  String _ChatCollection = "Chats";

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
        // "lastSeen": DateTime.now().toUtc(),
        "isComplete": false,
        "classes": [],
        "academicYear": 0,
      });
    } catch (e) {
      print(e);
      SnackBarService.instance.showsSnackBarError(text: "Creation error");
    }
  }

  void addUserClasesAndYear({
    required List<String> classes,
    required int year,
    required String userId,
  }) async {
    try {
      await _db.collection(_UserCollection).doc(userId).update(
          {"academicYear": year, "classes": classes, "isComplete": true});
      SnackBarService.instance.showsSnackBarSucces(text: "data Updated");
    } catch (e) {
      print(e);
      SnackBarService.instance.showsSnackBarError(text: "error Happened");
    }
  }

//how to get a file from the cloud as a model
  Stream<contact> getUserData(String _uid) {
    var ref = _db.collection(_UserCollection).doc(_uid);
    return ref.snapshots().map((_snap) {
      print(contact.fromFirestore(_snap));
      return contact.fromFirestore(_snap);
    });
  }

  Stream<List<ChatSnipits>> getUserChats(String _uid) {
    var ref =
        _db.collection(_UserCollection).doc(_uid).collection(_ChatCollection);
    return ref.snapshots().map((_snap) {
      //print(ChatSnipits.fromFirestore(_snap));
      return _snap.docs.map((_doc) {
        return ChatSnipits.fromFirestore(_doc);
      }).toList();
    });
  }

  Stream<ChatData> getChat(String ChatId) {
    var ref = _db.collection(_ChatCollection).doc(ChatId);
    return ref.snapshots().map((_snap) {
      return ChatData.fromFirestore(_snap);
    });
  }

  Future<void> addMessageInChat(
      {required String chatId, required Message messageData}) {
    var ref = _db.collection(_ChatCollection).doc(chatId);
    String type = "";
    switch (messageData.type) {
      case messageType.Text:
        type = "text";
        break;
      case messageType.image:
        type = "image";
        break;
      default:
        break;
    }
    return ref.update({
      //when adding a value to an array
      "messages": FieldValue.arrayUnion([
        {
          "message": messageData.messageContent,
          "senderID": messageData.senderID,
          "senderName": messageData.senderName,
          "timestamp": messageData.timestamp,
          "type": type //messageData.type
        }
      ])
    });
  }
}
