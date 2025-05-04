import 'package:flutter/material.dart';
import 'package:grad_proj/models/Chats.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/image_chat_bubble.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/message_field_bubble.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/voice_chat_bubble.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_cashing_service.dart';
import 'package:grad_proj/services/media_service.dart';

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
          //FIXME: possibly not working after a large enough amount of data is sent
          List bubbles = _data!.messages.reversed.toList();
          return ListView.builder(
            itemCount: _snapshot.data!.messages.length, controller: LVC,
            physics: BouncingScrollPhysics(), reverse: true,
            scrollDirection: Axis.vertical,
            // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            itemBuilder: (_Context, index) {
              var ChatdataOfCurrentChat = bubbles[index];

              return Padding(
                  padding: EdgeInsets.only(
                    top: 3,
                    bottom: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment:
                        HiveCashingService.getUserContactData().id ==
                                bubbles[index].senderID
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                    children: [
                      bubbles[index].type == "text"
                          ? chatMessageBubble(
                              message: ChatdataOfCurrentChat.messageContent
                                  .toString(),
                              isOurs:
                                  HiveCashingService.getUserContactData().id ==
                                      bubbles[index].senderID,
                              ts: bubbles[index].timestamp,
                              senderName: bubbles[index].senderName,
                            )
                          : bubbles[index].type == "image"
                              ? ImageMessageBubble(
                                  key: ValueKey(
                                      ChatdataOfCurrentChat), //this to tell flutter it's independant
                                  FileAdress: ChatdataOfCurrentChat
                                      .messageContent
                                      .toString(),
                                  isOurs:
                                      HiveCashingService.getUserContactData()
                                              .id ==
                                          bubbles[index].senderID,
                                  ts: bubbles[index].timestamp,
                                  senderName: bubbles[index].senderName,
                                )
                              : VoiceBubble(
                                  AudioAdress: ChatdataOfCurrentChat
                                      .messageContent
                                      .toString(),
                                  isOurs:
                                      HiveCashingService.getUserContactData()
                                              .id ==
                                          bubbles[index].senderID,
                                  ts: bubbles[index].timestamp,
                                  senderName: bubbles[index].senderName,
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
