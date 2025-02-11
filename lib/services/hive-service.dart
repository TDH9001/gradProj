// import 'package:hive/hive.dart';
// import '../models/chats.dart';
// import '../models/message.dart';
// import '../models/contact.dart';

// class HiveService {
//   static Future<void> initHive() async {
//     Hive.registerAdapter(ChatSnipitsAdapter());
//     Hive.registerAdapter(ChatDataAdapter());
//     Hive.registerAdapter(MessageAdapter());
//     Hive.registerAdapter(ContactAdapter());
//   }

//   static Future<void> openBoxes() async {
//     await Hive.openBox<ChatSnipits>('chatSnipitsBox');
//     await Hive.openBox<ChatData>('chatDataBox');
//     await Hive.openBox<Message>('messageBox');
//     await Hive.openBox<Contact>('contactBox');
//   }

//   // ********* CRUD Operations *********

//   // Add Data
//   static Future<void> addChatSnipit(ChatSnipits chat) async {
//     final box = Hive.box<ChatSnipits>('chatSnipitsBox');
//     await box.put(chat.id, chat);
//   }

//   static Future<void> addChatData(ChatData chat) async {
//     final box = Hive.box<ChatData>('chatDataBox');
//     await box.put(chat.Chatid, chat);
//   }

//   static Future<void> addMessage(Message message) async {
//     final box = Hive.box<Message>('messageBox');
//     await box.add(message);
//   }

//   static Future<void> addContact(Contact contact) async {
//     final box = Hive.box<Contact>('contactBox');
//     await box.put(contact.id, contact);
//   }

//   // Read Data
//   static ChatSnipits? getChatSnipit(String id) {
//     final box = Hive.box<ChatSnipits>('chatSnipitsBox');
//     return box.get(id);
//   }

//   static ChatData? getChatData(String id) {
//     final box = Hive.box<ChatData>('chatDataBox');
//     return box.get(id);
//   }

//   static List<Message> getAllMessages() {
//     final box = Hive.box<Message>('messageBox');
//     return box.values.toList();
//   }

//   static Contact? getContact(String id) {
//     final box = Hive.box<Contact>('contactBox');
//     return box.get(id);
//   }

//   // Update Data
//   static Future<void> updateChatSnipit(ChatSnipits chat) async {
//     final box = Hive.box<ChatSnipits>('chatSnipitsBox');
//     await box.put(chat.id, chat);
//   }

//   static Future<void> updateContact(Contact contact) async {
//     final box = Hive.box<Contact>('contactBox');
//     await box.put(contact.id, contact);
//   }

//   // Delete Data
//   static Future<void> deleteChatSnipit(String id) async {
//     final box = Hive.box<ChatSnipits>('chatSnipitsBox');
//     await box.delete(id);
//   }

//   static Future<void> deleteContact(String id) async {
//     final box = Hive.box<Contact>('contactBox');
//     await box.delete(id);
//   }

//   static Future<void> clearAllData() async {
//     await Hive.box<ChatSnipits>('chatSnipitsBox').clear();
//     await Hive.box<ChatData>('chatDataBox').clear();
//     await Hive.box<Message>('messageBox').clear();
//     await Hive.box<Contact>('contactBox').clear();
//   }
// }
 import 'package:hive/hive.dart';
 import '../models/chats.dart';
 import '../models/message.dart';
 import '../models/contact.dart';

class HiveService {
  static late Box<ChatSnipits> chatSnipitsBox;
  static late Box<ChatData> chatDataBox;
  static late Box<Message> messageBox;
  static late Box<Contact> contactBox;

  //this is for initializing hive and opening boxes
  static Future<void> init() async {
    chatSnipitsBox = await Hive.openBox<ChatSnipits>('chatSnipits');
    chatDataBox = await Hive.openBox<ChatData>('chatData');
    messageBox = await Hive.openBox<Message>('messages');
    contactBox = await Hive.openBox<Contact>('contacts');
  }

  //put-> just to save data
  static Future<void> saveChatSnippet(ChatSnipits chat) async {
    await chatSnipitsBox.put(chat.id, chat);
  }

  static Future<void> saveChatData(ChatData chatData) async {
    await chatDataBox.put(chatData.Chatid, chatData);
  }

  static Future<void> saveMessage(Message message) async {
    await messageBox.put(message.timestamp.toString(), message);
  }

  static Future<void> saveContact(Contact contact) async {
    await contactBox.put(contact.id, contact);
  }

  //get-> just to get data?? aked 
  static ChatSnipits? getChatSnippet(String id) {
    return chatSnipitsBox.get(id);
  }

  static ChatData? getChatData(String chatId) {
    return chatDataBox.get(chatId);
  }

  static Message? getMessage(String timestamp) {
    return messageBox.get(timestamp);
  }

  static Contact? getContact(String id) {
    return contactBox.get(id);
  }

  //this is for fetching all data and returing it as a list
  static List<ChatSnipits> getAllChatSnippets() {
    return chatSnipitsBox.values.toList();
  }

  static List<ChatData> getAllChatData() {
    return chatDataBox.values.toList();
  }

  static List<Message> getAllMessages() {
    return messageBox.values.toList();
  }

  static List<Contact> getAllContacts() {
    return contactBox.values.toList();
  }

  // deleting data
  static Future<void> deleteChatSnippet(String id) async {
    await chatSnipitsBox.delete(id);
  }

  static Future<void> deleteChatData(String chatId) async {
    await chatDataBox.delete(chatId);
  }

  static Future<void> deleteMessage(String timestamp) async {
    await messageBox.delete(timestamp);
  }

  static Future<void> deleteContact(String id) async {
    await contactBox.delete(id);
  }

  
  static Future<void> clearAllData() async {
    await chatSnipitsBox.clear();
    await chatDataBox.clear();
    await messageBox.clear();
    await contactBox.clear();
  }
}
