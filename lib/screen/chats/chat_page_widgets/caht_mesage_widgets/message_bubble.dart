import 'dart:ui';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/message.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/caht_mesage_widgets/chat_popup_menu_builder_butons.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/services/media_service.dart';

Widget chatMessageBubble(
    {required String chatID,
    required Message message,
    required List<String> admins}) {
  final CustomPopupMenuController cst = CustomPopupMenuController();
  return CustomPopupMenu(
    pressType: PressType.longPress,
    menuBuilder: () => ChatPopupMenuBuilderButons.popupMenuBuilder(
        cst, chatID, message, admins),
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: message.isImportant ? Color(0xFFD3E3F1) : Colors.grey[300]),

      padding: EdgeInsets.symmetric(horizontal: 15),
      // height:
      //     _height * 0.13 + ((message.length * 3.5 + senderName.length) / 10),
      width: MediaService.instance.getWidth() * 0.80,
      child: Column(
        //mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: message.senderID ==
                HiveUserContactCashingService.getUserContactData().id.trim()
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Text(
            message.senderName.trim(),
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
          SizedBox(
            height: 5,
          ),
          // LinkifyText(
          //   message.messageContent.trim(),
          // ),
          Text(
            message.messageContent.trim(),
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
          // SizedBox(
          //   height: 15,
          // ),
          Text(
            " ${message.timestamp.toDate().hour % 12}: ${message.timestamp.toDate().minute % 60} ${message.timestamp.toDate().hour < 12 ? "am" : "pm"}        ",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          )
        ],
      ),
    ),
  );
}
