import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/Chats.dart';
import 'package:grad_proj/models/message.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/caht_mesage_widgets/caht_Video_message.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/caht_mesage_widgets/chat_file_message.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/caht_mesage_widgets/image_chat_bubble.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/caht_mesage_widgets/message_bubble.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/caht_mesage_widgets/voice_chat_bubble.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_caht_data_caching_service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/services/media_service.dart';
import 'dart:developer' as dev;

class MessageListViewChatList extends StatelessWidget {
  MessageListViewChatList({super.key, required this.LVC, required this.chatID});
  final LVC;
  final chatID;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaService.instance.getHeight() * 0.815,
      child: StreamBuilder<ChatData>(
        stream: DBService.instance.getChat(chatID),
        builder: (_context, _snapshot) {
          var _data = _snapshot.data;

          //used to tell the builder to start from the end
          if (_snapshot.connectionState == ConnectionState.waiting ||
              _snapshot.connectionState == ConnectionState.none) {
            return Center(
                child: Image(image: AssetImage('assets/images/splash.png')));
          }
          if (_snapshot.hasError) {
            return Center(
                child: Text(
                    "Error: ${_snapshot.error} \n please update your data and the data field mising"));
          }
          List<Message> bubbles = _data!.messages.reversed.toList();
          HiveCahtMessaegsCachingService.addChatData(chatID, bubbles);
          //storing the data of the current chat into the box
          return ListView.builder(
            itemCount: _snapshot.data!.messages.length, controller: LVC,
            physics: BouncingScrollPhysics(), reverse: true,
            scrollDirection: Axis.vertical,
            // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            itemBuilder: (_Context, index) {
              var ChatdataOfCurrentChat = bubbles[index];
              dev.log(ChatdataOfCurrentChat.toString());

              return Padding(
                  padding: EdgeInsets.only(
                    top: 3,
                    bottom: 10,
                  ),
                  child: Column(
                    children: <Widget>[
                      (index > 0 &&
                              index < bubbles.length - 1 &&
                              bubbles[index].timestamp.toDate().day !=
                                  bubbles[index + 1].timestamp.toDate().day)
                          ? Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Center(
                                child: DateChip(
                                  date: bubbles[index].timestamp.toDate(),
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : SizedBox(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment:
                            HiveUserContactCashingService.getUserContactData()
                                        .id ==
                                    bubbles[index].senderID
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        children: [
                          bubbles[index].type == messageType.text.name
                              ? chatMessageBubble(
                                  chatID: chatID,
                                  message: ChatdataOfCurrentChat)
                              : bubbles[index].type == messageType.image.name
                                  ? ImageMessageBubble(
                                      isImportant:
                                          ChatdataOfCurrentChat.isImportant,
                                      key: ValueKey(
                                          ChatdataOfCurrentChat), //this to tell flutter it's independant
                                      FileAdress: ChatdataOfCurrentChat
                                          .messageContent
                                          .toString(),
                                      isOurs: HiveUserContactCashingService
                                                  .getUserContactData()
                                              .id ==
                                          bubbles[index].senderID,
                                      ts: bubbles[index].timestamp,
                                      senderName: bubbles[index].senderName,
                                    )
                                  : bubbles[index].type ==
                                          messageType.voice.name
                                      ? VoiceBubble(
                                          isImportant:
                                              ChatdataOfCurrentChat.isImportant,
                                          key: ValueKey(ChatdataOfCurrentChat),
                                          AudioAdress: ChatdataOfCurrentChat
                                              .messageContent
                                              .toString(),
                                          isOurs: HiveUserContactCashingService
                                                      .getUserContactData()
                                                  .id ==
                                              bubbles[index].senderID,
                                          ts: bubbles[index].timestamp,
                                          senderName: bubbles[index].senderName,
                                        )
                                      : bubbles[index].type ==
                                              messageType.file.name
                                          ? ChatFileMessage(
                                              message: ChatdataOfCurrentChat,
                                              chatId: chatID,

                                              key: ValueKey(
                                                  ChatdataOfCurrentChat), //this to tell flutter it's independant
                                            )
                                          : ChatVideoMessage(
                                              isImportant: ChatdataOfCurrentChat
                                                  .isImportant,
                                              key: ValueKey(
                                                  ChatdataOfCurrentChat), //this to tell flutter it's independant
                                              FileAdress: ChatdataOfCurrentChat
                                                  .messageContent
                                                  .toString(),
                                              isOurs: HiveUserContactCashingService
                                                          .getUserContactData()
                                                      .id ==
                                                  bubbles[index].senderID,
                                              ts: bubbles[index].timestamp,
                                              senderName:
                                                  bubbles[index].senderName,
                                            ),
                        ],
                      ),
                    ],
                  ));
            },
          );
        },
      ),
    );
  }
}
