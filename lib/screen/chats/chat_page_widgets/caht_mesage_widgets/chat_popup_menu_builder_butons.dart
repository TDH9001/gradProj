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
    return Container(
      // height: MediaService.instance.getHeight() * 0.05,
      color: Color(0xff2E5077),
      child: Wrap(
        direction: Axis.horizontal,
        children: [
          if ((message.senderID ==
                          HiveUserContactCashingService.getUserContactData()
                              .id &&
                      message.timestamp
                              .toDate()
                              .add(Duration(hours: 12))
                              .compareTo(DateTime
                                  .now()) > // if its the same person and within 12 hours
                          0) ||
                  admins.contains(
                      HiveUserContactCashingService.getUserContactData()
                          .id) //or admin
                  ||
                  HiveUserContactCashingService.getUserContactData().id.length <
                      10 // global admin
              )
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        cst.hideMenu();
                        DBService.instance
                            .deleteMessageFromChat(ChatId, message);
                      }),
                  Text('ChatPopup.delete'.tr()),
                ],
              ),
            ),
          if (message.type == MessageType.text.name)
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () async {
                        cst.hideMenu();
                        await Clipboard.setData(
                            ClipboardData(text: message.messageContent));
                        SnackBarService.instance.buildContext = context;
                        SnackBarService.instance
                            .showsSnackBarSucces(text: 'ChatPopup.copied_to_clipboard'.tr());
                      }),
                  Text('ChatPopup.copy'.tr()),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                IconButton(
                    icon: Icon(Icons.star_border_purple500_outlined),
                    onPressed: () {
                      cst.hideMenu();
                      DBService.instance.addStaredFeedItemToUser(
                          message.type == MessageType.text.name
                              ? MessageFeedItem(
                                  chatID: ChatId,
                                  messageContent: message.messageContent,
                                  senderID: message.senderID,
                                  senderName: message.senderName,
                                  timestamp: message.timestamp,
                                )
                              : message.type == MessageType.image.name
                                  ? ImageFeedItem(
                                      chatID: ChatId,
                                      messageContent: message.messageContent,
                                      senderID: message.senderID,
                                      senderName: message.senderName,
                                      timestamp: message.timestamp,
                                    )
                                  : message.type == MessageType.voice.name
                                      ? VoiceFeedItem(
                                          chatID: ChatId,
                                          messageContent:
                                              message.messageContent,
                                          senderID: message.senderID,
                                          senderName: message.senderName,
                                          timestamp: message.timestamp,
                                        )
                                      : message.type == MessageType.video.name
                                          ? VideoFeedItem(
                                              chatID: ChatId,
                                              messagecontent:
                                                  message.messageContent,
                                              senderID: message.senderID,
                                              senderName: message.senderName,
                                              timestamp: message.timestamp,
                                            )
                                          : FileFeedItem(
                                              senderID: message.senderID,
                                              timestamp: message.timestamp,
                                              chatID: ChatId,
                                              messageContent:
                                                  message.messageContent,
                                              senderName: message.senderName),
                          HiveUserContactCashingService.getUserContactData()
                              .id);
                      SnackBarService.instance.buildContext = context;
                      SnackBarService.instance.showsSnackBarSucces(
                          text: 'ChatPopup.added_to_starred_messages'.tr());
                    }),
                Text('ChatPopup.star_message'.tr()),
              ],
            ),
          ),
          if (HiveUserContactCashingService.getUserContactData().id.length <
                  10 ||
              admins.contains(
                  HiveUserContactCashingService.getUserContactData().id))
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  IconButton(
                      icon: Icon(Icons.push_pin_outlined),
                      onPressed: () {
                        cst.hideMenu();
                        DBService.instance.addFeedItemToChatUsers(
                            message.type == MessageType.text.name
                                ? MessageFeedItem(
                                    chatID: ChatId,
                                    messageContent: message.messageContent,
                                    senderID: message.senderID,
                                    senderName: message.senderName,
                                    timestamp: message.timestamp,
                                  )
                                : message.type == MessageType.image.name
                                    ? ImageFeedItem(
                                        chatID: ChatId,
                                        messageContent: message.messageContent,
                                        senderID: message.senderID,
                                        senderName: message.senderName,
                                        timestamp: message.timestamp,
                                      )
                                    : message.type == MessageType.voice.name
                                        ? VoiceFeedItem(
                                            chatID: ChatId,
                                            messageContent:
                                                message.messageContent,
                                            senderID: message.senderID,
                                            senderName: message.senderName,
                                            timestamp: message.timestamp,
                                          )
                                        : message.type == MessageType.video.name
                                            ? VideoFeedItem(
                                                chatID: ChatId,
                                                messagecontent:
                                                    message.messageContent,
                                                senderID: message.senderID,
                                                senderName: message.senderName,
                                                timestamp: message.timestamp,
                                              )
                                            : FileFeedItem(
                                                senderID: message.senderID,
                                                timestamp: message.timestamp,
                                                chatID: ChatId,
                                                messageContent:
                                                    message.messageContent,
                                                senderName: message.senderName),
                            ChatId);
                        DBService.instance
                            .makeMessageIImportant(ChatId, message);
                        SnackBarService.instance.buildContext = context;
                        SnackBarService.instance
                            .showsSnackBarSucces(text: 'ChatPopup.added_to_feed'.tr());
                      }),
                  Text('ChatPopup.add_to_feed'.tr()),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
