import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/feed_Items.dart';
import 'package:grad_proj/models/feed_items_models/schedule_create_item.dart';
import 'package:grad_proj/models/feed_items_models/schedule_delete_item.dart';
import 'package:grad_proj/models/feed_items_models/schedule_update_item.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/widgets/bottom_navegation_bar_screen.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import '../models/contact.dart';
import '../models/Chats.dart';
import '../models/message.dart';
import 'dart:developer' as devtools show log;

enum MessageType { text, image, voice, file, video }

class DBService {
  static DBService instance = DBService();

  FirebaseFirestore _db = FirebaseFirestore.instance;

  DBService() {
    _db = FirebaseFirestore.instance;
  }
//collection sit he name of the Field i want to acces in firebase
  String _UserCollection = "Users";
  String _ChatCollection = "Chats";
  String _FeedCollection = "Feed";
  String _PersonalFeed = "PersonalFeed";
  String _StaredFeed = "StaredFeed";

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
      HiveUserContactCashingService.updateUserContactData(Contact(
              email: email,
              id: userId,
              seatNumber: 0,
              firstName: firstName,
              lastName: lastname,
              classes: [],
              year: 0,
              isComplete: false,
              phoneNumber: phoneNumber)
          .toJson());
      navigationService.instance
          .navigateToReplacement(BottomNavegationBarScreen.id);
    } on Exception catch (e) {
      print(e);
      SnackBarService.instance.showsSnackBarError(text: "Creation error");
    }
  }

  void completeUserProfile(
      {required List<String> classes,
      required int year,
      required String userId,
      required int seatNumber}) async {
    try {
      await _db.collection(_UserCollection).doc(userId).update({
        "academicYear": year,
        "classes": classes,
        "isComplete": true,
        "seatNumber": seatNumber
      });
      Contact currData =
          await HiveUserContactCashingService.getUserContactData();

      HiveUserContactCashingService.updateUserContactData(Contact(
              email: currData.email,
              id: userId,
              seatNumber: seatNumber,
              firstName: currData.firstName,
              lastName: currData.lastName,
              classes: classes,
              year: year,
              isComplete: true,
              phoneNumber: currData.phoneNumber)
          .toJson());

      //SnackBarService.instance.showsSnackBarSucces(text: "data Updated");
    } on Exception catch (e) {
      print(e);
      //SnackBarService.instance.showsSnackBarError(text: "error Happened");
    }
  }

//how to get a file from the cloud as a model
  Stream<Contact> getUserData(String _uid) {
    var ref = _db.collection(_UserCollection).doc(_uid);
    return ref.snapshots().map((_snap) {
      //  Contact data = Contact.fromJson(id: _snap.id, snap: _snap.data()!);
      return Contact.fromJson(id: _snap.id, snap: _snap.data()!);
    });
  }

//edit getUserChats to work differently when admin
  Future<void> makeChat(String chatId, String _uid) async {
    var ref = await _db.collection(_ChatCollection).doc(chatId);
    if ((await _db.collection(_ChatCollection).doc(chatId).get()).exists) {
      devtools.log("chat already exists : $chatId");
      return;
    }

    devtools.log("create he brand new : $chatId");
    return await ref.set({
      "ChatAccesability": ChatAccesabilityEnum.admin_only.index,
      "leaders": [],
      "members": [_uid],
      "messages": [],
      "ownerID": [""],
      "permanantScedules": [],
      "temporaryScedule": []
    }, SetOptions(merge: true));
  }

  Stream<List<ChatSnipits>> getUserChats(String _uid, String searched) {
    List<String> generateSubstrings(String text) {
      text = text.toLowerCase().trim();
      final substrings = <String>{};
      for (int i = 0; i < text.length; i++) {
        for (int j = i + 1; j <= text.length; j++) {
          substrings.add(text.substring(i, j));
        }
      }
      devtools.log(substrings.toList().toString());
      return substrings.toList();
    }

    //print();
    //, String name
    var ref = _db
        .collection(_UserCollection)
        .doc(_uid)
        .collection(_ChatCollection)
        //.where("name", arrayContains: generateSubstrings(searched));
        .where("name", isGreaterThanOrEqualTo: searched)
        .where("name", isLessThan: "${searched}z");

    return ref.snapshots().map((_snap) {
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
      "messages": FieldValue.arrayUnion([messageData.toJson()])
    });
  }

  Future<List<String>> getMembersOfChat(String chatID) async {
    var snap = await _db.collection(_ChatCollection).doc(chatID).get();
    if (snap.exists) {
      List<String> mem = List<String>.from(snap.get("members"));
      print(mem);
      return mem;
    } else {
      print("ERRRRORRRORROROROROROORORORROOR , Document does not exist");
      return [];
      //throw Exception('Document does not exist');
    }
  }

  Stream<List<Contact>> getChatMembersData(String chatId) {
    devtools.log((Stream.fromFuture(getMembersOfChat(chatId)))
        .asyncExpand((data) {})
        .toString());
    return Stream.fromFuture(getMembersOfChat(chatId)).asyncExpand((userIds) {
      if (userIds.isEmpty) {
        return Stream.value([]); // Return empty list if no members
      }

      // Listen to real-time updates instead of fetching once
      return _db
          .collection(_UserCollection)
          .where(FieldPath.documentId, whereIn: userIds) // very efficiant
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Contact.fromJson(id: doc.id, snap: doc.data()))
              .toList());
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

  Future<void> addChatToUser(String uid, String chatID) async {
    var chat = await _db.collection(_ChatCollection).doc(chatID).get();
    if (!chat.exists) {
      // Optionally throw an exception or handle this case gracefully
      devtools.log("Chat with ID '$chatID' does not exist.");
      return;
    }

    var ref = _db
        .collection(_UserCollection)
        .doc(uid)
        .collection(_ChatCollection)
        .doc(chatID);

    return ref.set({
      "chatID": chatID,
      "name": chatID,
      "unseenCount": 0,
      "admins": (chat.data()) == null ? [] : (chat.data())!["admins"] ?? [],
      "lastMessage": "welcome New User",
      "senderID": "",
      "senderName": "",
      "timestamp": Timestamp.now(),
      "type": 0,
      "ChatAccesability": (chat.data()) == null
          ? ChatAccesabilityEnum.admin_only.name
          : (chat.data())!["ChatAccesability"],
      "leaders": (chat.data()) == null ? [] : (chat.data())!["leaders"],
    }, SetOptions(merge: true));
  }

  Future<void> addMembersToChat(String uid, String chatID) async {
    var ref2 = _db.collection(_ChatCollection).doc(chatID);
    if (!(await ref2.get()).exists) {
      // Optionally throw an exception or handle this case gracefully
      devtools.log("Chat with ID '$chatID' does not exist. > to add user");
      return;
    }
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
        ref.update({
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
        ref.update({
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
        userRef.update({
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
      await DBService.instance.addFeedItemToChatUsers(
          SceduleCreateFeedItem(
              chatID: chatID,
              senderID: uid,
              senderName:
                  "${HiveUserContactCashingService.getUserContactData().firstName} ${HiveUserContactCashingService.getUserContactData().lastName}",
              timestamp: Timestamp.now(),
              scheduleItem: scl),
          chatID);
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> removeSceduleItem(
      ScheduleItemClass scl, String uid, String chatId) async {
    var ref = _db.collection(_ChatCollection).doc(chatId);
    try {
      if (scl.type == 1) {
        //permanantScedules
        ref.update({
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
        ref.update({
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
        userRef.update({
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
      await DBService.instance.addFeedItemToChatUsers(
          ScheduleDeleteFeedItem(
              chatID: chatId,
              senderID: uid,
              senderName:
                  "${HiveUserContactCashingService.getUserContactData().firstName} ${HiveUserContactCashingService.getUserContactData().lastName}",
              timestamp: Timestamp.now(),
              scheduleItem: scl),
          chatId);
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> updateSceduleItem(ScheduleItemClass newscl,
      ScheduleItemClass oldscl, String uid, String chatId) async {
    try {
      var ref = _db.collection(_ChatCollection).doc(chatId);
      await DBService.instance.removeSceduleItem(oldscl, uid, chatId);
      await DBService.instance.addSceduleItem(uid, chatId, newscl);
      await DBService.instance.addFeedItemToChatUsers(
          ScheduleUpdateItem(
              chatID: chatId,
              senderID: uid,
              senderName: newscl.creatorName,
              timestamp: Timestamp.now(),
              newScheduleItem: newscl,
              oldScheduleItem: oldscl),
          chatId);
    } on Exception catch (e) {
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

  Future<void> addFeedItemToUser(FeedItems feedItem, String uid) async {
    try {
      _db
          .collection(_UserCollection)
          .doc(uid)
          .collection(_FeedCollection)
          .doc(_PersonalFeed)
          .update({
        "PersonalFeed": FieldValue.arrayUnion([feedItem.toMap()])
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> addStaredFeedItemToUser(FeedItems feedItem, String uid) async {
    try {
      _db
          .collection(_UserCollection)
          .doc(uid)
          .collection(_FeedCollection)
          .doc(_PersonalFeed)
          .set({
        "StaredFeed": FieldValue.arrayUnion([feedItem.toMap()])
      }, SetOptions(merge: true));
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> addFeedItemToChatUsers(FeedItems feedItem, String chatID) async {
    try {
      List<String> userIDs = await getMembersOfChat(chatID);
      print(userIDs);
      for (int i = 0; i < userIDs.length; i++) {
        _db
            .collection(_UserCollection)
            .doc(userIDs[i])
            .collection(_FeedCollection)
            .doc(_PersonalFeed)
            .set({
          "PersonalFeed": FieldValue.arrayUnion([feedItem.toMap()])
        }, SetOptions(merge: true));
        print('failed to add');
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  /// Retrieves a stream of the user's personal feed items from the database.
  ///
  Stream<List<FeedItems>> getUserFeed(String uid, String searched) {
    return _db
        .collection(_UserCollection)
        .doc(uid)
        .collection(_FeedCollection)
        .doc(_PersonalFeed)
        .snapshots()
        .map((snap) {
      if (snap.exists) {
        if (snap.data()!.containsKey("PersonalFeed")) {
          List<dynamic> currentData = snap["PersonalFeed"];
          return currentData
              .where((item) => item["chatID"]
                  .toString()
                  .toLowerCase()
                  .contains(searched.toLowerCase()))
              .map((item) {
            return FeedItems.getFeedItemFromSubClass(item);
          }).toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    });
  }

  Stream<List<FeedItems>> getUserStaredFeed(String uid) {
    return _db
        .collection(_UserCollection)
        .doc(uid)
        .collection(_FeedCollection)
        .doc(_StaredFeed)
        .snapshots()
        .map((snap) {
      if (snap.exists) {
        if (snap.data()!.containsKey("StaredFeed")) {
          List<dynamic> currentData = snap["StaredFeed"];
          return currentData.map((item) {
            return FeedItems.getFeedItemFromSubClass(item);
          }).toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    });
  }

  Future<void> changeChatAccesabilitySetting(
      String chatId, int newSetting, BuildContext context) async {
    print(newSetting);
    var ref = _db.collection(_ChatCollection).doc(chatId);
    try {
      ref.update({"ChatAccesability": newSetting});
      SnackBarService.instance.buildContext = context;
      SnackBarService.instance
          .showsSnackBarSucces(text: "Chat Accesability Updated Succesfully");
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> makeUserChatLeader(String chatId, String uid) {
    var ref = _db.collection(_ChatCollection).doc(chatId);
    return ref.update({
      "leaders": FieldValue.arrayUnion([uid])
    });
  }

  Future<void> deleteMessageFromChat(String chatId, Message message) async {
    var ref = _db.collection(_ChatCollection).doc(chatId);

    var js = message.toJson();
    var data = js.remove("IsImportant");

    ref.update({
      "messages": FieldValue.arrayRemove([message.toJson()])
    });
    return;
  }

  Future<void> makeMessageIImportant(String chatId, Message message) async {
    var modefiedMessage = Message(
        senderID: message.senderID,
        messageContent: message.messageContent,
        timestamp: message.timestamp,
        type: message.type,
        senderName: message.senderName,
        isImportant: true);

    var ref = _db.collection(_ChatCollection).doc(chatId);
    DBService.instance.deleteMessageFromChat(chatId, message);
    ref.update({
      "messages": FieldValue.arrayUnion([modefiedMessage.toJson()])
    });
  }

  Future<void> removeAdminFromChat(String chatId, String uid) async {
    var ref = _db.collection(_ChatCollection).doc(chatId);
    return ref.update({
      "ownerID": FieldValue.arrayRemove([uid])
    });
  }

  Future<void> removeLeaderFromChat(String chatId, String uid) async {
    var ref = _db.collection(_ChatCollection).doc(chatId);
    return ref.update({
      "leaders": FieldValue.arrayRemove([uid])
    });
  }

  Stream<List<ChatSnipits>> getAllChatsForAdmin(String chatName) {
    final normalized = chatName.toLowerCase();

    var ref = _db.collection(_ChatCollection);

    return ref.snapshots().map((_snap) {
      return _snap.docs
          .where((doc) => doc.id.toLowerCase().contains(normalized))
          .map((_doc) {
        return ChatSnipits(
          id: _doc.id,
          leaders: (_doc["leaders"] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
          chatAccesability: ChatAccesabilityEnum
              .values[_doc["ChatAccesability"]]
              .name, // _doc["ChatAccesability"],
          chatId: _doc.id,
          lastMessage: "",
          senderName: "",
          unseenCount: 0,
          timestamp: Timestamp.now(),
          adminId: (_doc["ownerID"] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
          type: MessageType.text.name,
        );
      }).toList();
    });
  }
}
