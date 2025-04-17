import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/constants.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:grad_proj/widgets/bottom_navegation_bar_screen.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:grad_proj/widgets/sceduleitem.dart';
import '../models/contact.dart';
import '../models/Chats.dart';
import '../models/message.dart';

enum MessageType { text, image, voice }

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
      SnackBarService.instance.showsSnackBarSucces(
          text: "welcome New User ${firstName} ${lastname}");

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
      navigationService.instance
          .navigateToReplacement(BottomNavegationBarScreen.id);
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
      //SnackBarService.instance.showsSnackBarSucces(text: "data Updated");
    } catch (e) {
      print(e);
      //SnackBarService.instance.showsSnackBarError(text: "error Happened");
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

  Future<List<String>> getUserChatIDs(String _uid) async {
    var ref = await _db
        .collection(_UserCollection)
        .doc(_uid)
        .collection(_ChatCollection)
        .get();
    List<String> data = [];
    for (int i = 0; i < ref.docs.length; i++) {
      if (ref.docs[i].exists) {
        String s = ref.docs[i].get(("chatID")).toString();
        data.add(s);
      }
    }
    return data;
  }

  Stream<ChatData> getChat(String ChatId) {
    var ref = _db.collection(_ChatCollection).doc(ChatId);
    return ref.snapshots().map((_snap) {
      return ChatData.fromFirestore(_snap);
    });
  }

// to be updated
  Future<void> addMessageInChat(
      {required String chatId, required Message messageData}) {
    var ref = _db.collection(_ChatCollection).doc(chatId);

    return ref.update({
      //when adding a value to an array
      "messages": FieldValue.arrayUnion([
        {
          "message": messageData.messageContent,
          "senderID": messageData.senderID,
          "senderName": messageData.senderName,
          "timestamp": messageData.timestamp,
          "type": MessageType.values
              .byName(messageData.type)
              .index //messageData.type
        }
      ])
    });
  }

  Future<List<String>> getMembersOfChat(String chatID) async {
    var snap = await _db.collection(_ChatCollection).doc(chatID).get();
    if (snap.exists) {
      List<String> mem = List<String>.from(snap.get("members"));
      print(mem);
      return mem;
    } else {
      print("ERRRRORRRORROROROROROORORORROOR");

      throw Exception('Document does not exist');
    }
  }

  Stream<List<contact>> getChatMembersData(String chatId) {
    return Stream.fromFuture(getMembersOfChat(chatId)).asyncExpand((userIds) {
      if (userIds.isEmpty) {
        return Stream.value([]); // Return empty list if no members
      }

      // Listen to real-time updates instead of fetching once
      return _db
          .collection(_UserCollection)
          .where(FieldPath.documentId, whereIn: userIds) // very efficiant
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => contact.fromFirestore(doc)).toList());
    });
  }

  Future<void> makeAdmin(String uid, String chatID) {
    var ref = _db.collection(_ChatCollection).doc(chatID);
    return ref.update({
      //when adding a value to an array
      "ownerID": FieldValue.arrayUnion([uid])
    });
    //does nto create duplicates
  }

  Future<void> resetUnseenCount(String uid, String chatID) {
    var ref = _db
        .collection(_UserCollection)
        .doc(uid)
        .collection(_ChatCollection)
        .doc(chatID);
    return ref.update({"unseenCount": 0});
  }

  Future<void> addChatsToUser(String uid, String chatID) {
    var ref = _db
        .collection(_UserCollection)
        .doc(uid)
        .collection(_ChatCollection)
        .doc(chatID);
    return ref.set({
      "chatID": chatID,
      "name": chatID,
      "unseenCount": 0,
      "admins": [],
      "lastMessage": "welcome New User",
      "senderID": "",
      "senderName": "dev_lead",
      "timestamp": Timestamp.now(),
      "type": "text"
    });
  }

  Future<void> addMembersToChat(String uid, String chatID) {
    var ref2 = _db.collection(_ChatCollection).doc(chatID);
    return ref2.update({
      "members": FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> addSceduleItem(
      String uid, String chatID, ScheduleItemClass scl) async {
    var ref = _db.collection(_ChatCollection).doc(chatID);
    try {
      if (scl.type == 1) {
        //permanantScedules
        return ref.update({
          "permanantScedules": FieldValue.arrayUnion([
            {
              "name": scl.name,
              "startTime": scl.startTime,
              "endTime": scl.endTime,
              "creatorName": scl.creatorName,
              "creatorId": scl.creatorId,
              "location": scl.location,
              "day": scl.day,
              "type": scl.type
            }
          ])
        });
      } else if (scl.type == 2) {
        //temporaryScedule
        return ref.update({
          "temporaryScedule": FieldValue.arrayUnion([
            {
              "name": scl.name,
              "startTime": scl.startTime,
              "endTime": scl.endTime,
              "creatorName": scl.creatorName,
              "creatorId": scl.creatorId,
              "location": scl.location,
              "day": scl.day,
              "type": scl.type,
              "endDate": scl.endDate
            }
          ])
        });
      } else if (scl.type == 3) {
        //personalScedules
        var userRef = _db.collection(_UserCollection).doc(uid);
        return userRef.update({
          "personalScedules": FieldValue.arrayUnion([
            {
              "name": scl.name,
              "startTime": scl.startTime,
              "endTime": scl.endTime,
              "creatorName": scl.creatorName,
              "creatorId": scl.creatorId,
              "location": scl.location,
              "day": scl.day,
              "type": scl.type,
              "endDate": scl.endDate
            }
          ])
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeSceduleItem(
      ScheduleItemClass scl, String uid, String chatId) async {
    var ref = _db.collection(_ChatCollection).doc(chatId);
    try {
      if (scl.type == 1) {
        //permanantScedules
        return ref.update({
          "permanantScedules": FieldValue.arrayRemove([
            {
              "name": scl.name,
              "startTime": scl.startTime,
              "endTime": scl.endTime,
              "creatorName": scl.creatorName,
              "creatorId": scl.creatorId,
              "location": scl.location,
              "day": scl.day,
              "type": scl.type,
            }
          ])
        });
      } else if (scl.type == 2) {
        return ref.update({
          //temporaryScedule
          "temporaryScedule": FieldValue.arrayRemove([
            {
              "name": scl.name,
              "startTime": scl.startTime,
              "endTime": scl.endTime,
              "creatorName": scl.creatorName,
              "creatorId": scl.creatorId,
              "location": scl.location,
              "day": scl.day,
              "type": scl.type,
              "endDate": scl.endDate
            }
          ])
        });
      } else if (scl.type == 3) {
        //personalScedules
        var userRef = _db.collection(_UserCollection).doc(uid);
        return userRef.update({
          "personalScedules": FieldValue.arrayRemove([
            {
              "name": scl.name,
              "startTime": scl.startTime,
              "endTime": scl.endTime,
              "creatorName": scl.creatorName,
              "creatorId": scl.creatorId,
              "location": scl.location,
              "day": scl.day,
              "type": scl.type,
              "endDate": scl.endDate
            }
          ])
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateSceduleItem(ScheduleItemClass newscl,
      ScheduleItemClass oldscl, String uid, String chatId) async {
    try {
      var ref = _db.collection(_ChatCollection).doc(chatId);
      await DBService.instance.removeSceduleItem(oldscl, uid, chatId);
      await DBService.instance.addSceduleItem(uid, chatId, newscl);
    } catch (e) {
      print(e);
    }
  }

//how to retrive it as a steam
  Stream<List<ScheduleItemClass>> getTemporarySceduleItems(String chatId) {
    return _db
        .collection(_ChatCollection)
        .doc(chatId)
        .snapshots() // to get a stream you need to watch the snapshots
        .map((snap) {
      if (snap.exists) {
        List<dynamic> currentData = snap["temporaryScedule"];
        // List<ScheduleItemClass> data =
        return currentData.map((item) {
          return ScheduleItemClass(
              creatorId: item["creatorId"],
              creatorName: item["creatorName"],
              day: item["day"],
              endTime: item["endTime"],
              location: item["location"],
              name: item["name"],
              startTime: item["startTime"],
              endDate: item["endDate"],
              type: item["type"]);
        }).toList();
      } else {
        return [];
      }
    });
  }

  Stream<List<ScheduleItemClass>> getPermanantSceduleItems(String chatId) {
    return _db
        .collection(_ChatCollection)
        .doc(chatId)
        .snapshots() // to get a stream you need to watch the snapshots
        .map((snap) {
      if (snap.exists) {
        List<dynamic> currentData = snap["permanantScedules"];
        // List<ScheduleItemClass> data =
        return currentData.map((item) {
          return ScheduleItemClass(
              creatorId: item["creatorId"],
              creatorName: item["creatorName"],
              day: item["day"],
              endTime: item["endTime"],
              location: item["location"],
              name: item["name"],
              startTime: item["startTime"],
              type: item["type"]);
        }).toList();
      } else {
        return [];
      }
    });
  }

  Stream<List<ScheduleItemClass>> getUserPermanatScedules(String uid) {
    return Stream.fromFuture(getUserChatIDs(uid)).asyncExpand((chatIDs) {
      if (chatIDs.isEmpty) {
        return Stream.value([]);
      }
      return _db
          .collection(_ChatCollection)
          .where(FieldPath.documentId, whereIn: chatIDs)
          .snapshots()
          .map((chatData) {
        // caht data here is the chatDocument
        List<ScheduleItemClass> finalData = [];
        for (int i = 0; i < chatData.docs.length; i++) {
          if (chatData.docs[i].data().containsKey("permanantScedules")) {
            var scheduleList =
                chatData.docs[i]["permanantScedules"] as List<dynamic>? ?? null;
            if (scheduleList != null) {
              finalData.addAll(scheduleList
                  .map((item) => ScheduleItemClass.fromMap(item))
                  .toList());
            }
          } else {
            print(
                "Document ${chatData.docs[i].id} does not contain 'temporaryScedule'");
          }
        }
        return finalData;
      });

      // List<ScheduleItemClass> data = [];
      // for (int i = 0; i < ref.length; i++) {}
    });
  }

  Stream<List<ScheduleItemClass>> getUserTemporaryScedules(String uid) {
    return Stream.fromFuture(getUserChatIDs(uid)).asyncExpand((chatIDs) {
      if (chatIDs.isEmpty) {
        return Stream.value([]);
      }
      return _db
          .collection(_ChatCollection)
          .where(FieldPath.documentId, whereIn: chatIDs)
          .snapshots()
          .map((chatData) {
        // caht data here is the chatDocument
        List<ScheduleItemClass> finalData = [];
        for (int i = 0; i < chatData.docs.length; i++) {
          if (chatData.docs[i].data().containsKey("temporaryScedule")) {
            var scheduleList =
                chatData.docs[i]["temporaryScedule"] as List<dynamic>? ?? null;
            if (scheduleList != null) {
              finalData.addAll(scheduleList
                  .map((item) => ScheduleItemClass.fromMap(item))
                  .toList());
            }
          } else {
            print(
                "Document ${chatData.docs[i].id} does not contain 'permanantScedules'");
          }
        }
        return finalData;
      });

      // List<ScheduleItemClass> data = [];
      // for (int i = 0; i < ref.length; i++) {}
    });
  }

  Stream<List<ScheduleItemClass>> getUserPersonalScedule(String uid) {
    return _db.collection(_UserCollection).doc(uid).snapshots().map((snap) {
      if (snap.exists) {
        if (snap.data()!.containsKey("personalScedules")) {
          List<dynamic> currentData = snap["personalScedules"];
          // List<ScheduleItemClass> data =
          return currentData.map((item) {
            return ScheduleItemClass(
                creatorId: item["creatorId"],
                creatorName: item["creatorName"],
                day: item["day"],
                endTime: item["endTime"],
                location: item["location"],
                name: item["name"],
                startTime: item["startTime"],
                type: item["type"]);
          }).toList();
        } else {
          return [];
        }
      } else {
        print("this user does not have any personal Scedules");
        return [];
      }
    });
  }
}
