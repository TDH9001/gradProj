import 'package:grad_proj/models/message.dart';
import 'package:grad_proj/services/hive_caching_service/cashing_service_hive_keys.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class HiveCahtMessaegsCachingService {
  static late Box _chatDataBox;

  static Future<void> initHive() async {
    await Hive.initFlutter();
    _chatDataBox = await Hive.openBox(CashingServiceHiveKeys.userChatsData);
  }

  static List<Message> getChatData(String cahtId) {
    //want is to return the lsit of messages in a spicific caht id
    //this can be done if i have a Map<String, List<Message>>
    //where those messages the full lsit of Chat messages
    var data =
        _chatDataBox.get("${CashingServiceHiveKeys.userChatsData}-$cahtId") ??
            {};
    if (data != null && data is Map) {
      final mappedData = Map<String, dynamic>.from(
          data); //all im going to store is the lsit of messages
      return mappedData.values.map((e) => Message.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  static void addChatData(String cahtId, List<Message> message) {
    Map<String, dynamic> messages = {"messageList": message};
    print(messages);
    //gets a Map<String,Dynamic> ad stores it
    _chatDataBox.put(
        "${CashingServiceHiveKeys.userChatsData}-$cahtId", messages);
  }

  static void addMesageToChatBox(String cahtId, Message message) {
    var data = HiveCahtMessaegsCachingService.getChatData(cahtId);
    data.add(message);
    HiveCahtMessaegsCachingService.addChatData(cahtId, data);
  }

  static void removeChatData(String cahtId) {
    _chatDataBox.delete("${CashingServiceHiveKeys.userChatsData}-$cahtId");
  }
}
