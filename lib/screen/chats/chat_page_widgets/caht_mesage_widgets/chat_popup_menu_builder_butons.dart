import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/feed_items_models/file_feed_item.dart';
import 'package:grad_proj/models/feed_items_models/image_feed_item.dart';
import 'package:grad_proj/models/feed_items_models/message_feed_Item.dart';
import 'package:grad_proj/models/feed_items_models/video_feed_item.dart';
import 'package:grad_proj/models/feed_items_models/voice_feed_item.dart';
import 'package:grad_proj/models/message.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:flutter/services.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:provider/provider.dart';

import '../../../../providers/theme_provider.dart';

class ChatPopupMenuBuilderButons {
  static Widget popupMenuBuilder(CustomPopupMenuController cst, String ChatId,
      Message message, List<String> admins) {
    return PopupWidgetHandler(cst, ChatId, message, admins);
  }
}

class PopupWidgetHandler extends StatelessWidget {
  const PopupWidgetHandler(this.cst, this.ChatId, this.message, this.admins,
      {super.key});

  final CustomPopupMenuController cst;
  final String ChatId;
  final Message message;
  final List<String> admins;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xff2E5077): Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Wrap(
        spacing: 15,
        runSpacing: 10,
        children: [
          if ((message.senderID ==
              HiveUserContactCashingService.getUserContactData()
                  .id &&
              message.timestamp
                  .toDate()
                  .add(Duration(hours: 12))
                  .compareTo(DateTime.now()) > 0) ||
              admins.contains(HiveUserContactCashingService.getUserContactData().id) ||
              HiveUserContactCashingService.getUserContactData().id.length < 10)
            _buildIcon(context, Icons.delete, 'ChatPopup.delete'.tr(), () {
              cst.hideMenu();
              DBService.instance.deleteMessageFromChat(ChatId, message);
            }),
          if (message.type == MessageType.text.name)
            _buildIcon(context, Icons.copy, 'ChatPopup.copy'.tr(), () async {
              cst.hideMenu();
              await Clipboard.setData(
                  ClipboardData(text: message.messageContent));
              SnackBarService.instance.buildContext = context;
              SnackBarService.instance.showsSnackBarSucces(
                  text: 'ChatPopup.copied_to_clipboard'.tr());
            }),
          _buildIcon(context, Icons.star_border_purple500_outlined,
              'ChatPopup.star_message'.tr(), () {
                cst.hideMenu();
                DBService.instance.addStaredFeedItemToUser(
                    _buildFeedItem(message, ChatId),
                    HiveUserContactCashingService.getUserContactData().id);
                SnackBarService.instance.buildContext = context;
                SnackBarService.instance.showsSnackBarSucces(
                    text: 'ChatPopup.added_to_starred_messages'.tr());
              }),
          if (HiveUserContactCashingService.getUserContactData().id.length < 10 ||
              admins.contains(HiveUserContactCashingService.getUserContactData().id))
            _buildIcon(context, Icons.push_pin_outlined,
                'ChatPopup.add_to_feed'.tr(), () {
                  cst.hideMenu();
                  DBService.instance.addFeedItemToChatUsers(
                      _buildFeedItem(message, ChatId), ChatId);
                  DBService.instance.makeMessageIImportant(ChatId, message);
                  SnackBarService.instance.buildContext = context;
                  SnackBarService.instance
                      .showsSnackBarSucces(text: 'ChatPopup.added_to_feed'.tr());
                }),
        ],
      ),
    );
  }

  Widget _buildIcon(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color:  Color(0xffA3BFE0) ,
          shape: CircleBorder(),
          child: IconButton(
            icon: Icon(icon, color: Color(0xff2E5077), size: 24),
            onPressed: () => onTap(),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDarkMode? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  dynamic _buildFeedItem(Message message, String ChatId) {
    switch (message.type) {
      case "text":
        return MessageFeedItem(
          chatID: ChatId,
          messageContent: message.messageContent,
          senderID: message.senderID,
          senderName: message.senderName,
          timestamp: message.timestamp,
        );
      case "image":
        return ImageFeedItem(
          chatID: ChatId,
          messageContent: message.messageContent,
          senderID: message.senderID,
          senderName: message.senderName,
          timestamp: message.timestamp,
        );
      case "voice":
        return VoiceFeedItem(
          chatID: ChatId,
          messageContent: message.messageContent,
          senderID: message.senderID,
          senderName: message.senderName,
          timestamp: message.timestamp,
        );
      case "video":
        return VideoFeedItem(
          chatID: ChatId,
          messagecontent: message.messageContent,
          senderID: message.senderID,
          senderName: message.senderName,
          timestamp: message.timestamp,
        );
      default:
        return FileFeedItem(
          senderID: message.senderID,
          timestamp: message.timestamp,
          chatID: ChatId,
          messageContent: message.messageContent,
          senderName: message.senderName,
        );
    }
  }
}
