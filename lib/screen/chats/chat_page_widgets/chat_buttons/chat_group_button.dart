import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/chat_buttons/Chat_video_butoon.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/chat_buttons/chat_File_button.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/chat_buttons/image_message_button.dart';

class ChatGroupButton extends StatelessWidget {
  const ChatGroupButton({super.key, required this.chatID});
  final String chatID;
  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      pressType: PressType.singleClick,
      menuBuilder: () {
        return Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey,
          ),
          child: Row(
            children: [
              Column(children: [
                ImageMessageButton(chatID: chatID),
                SizedBox(
                  height: 2,
                ),
                Text("Pick Image")
              ]),
              SizedBox(
                width: 4,
              ),
              Column(
                children: [
                  ChatFileButton(chatID: chatID),
                  SizedBox(
                    height: 2,
                  ),
                  Text("Pick File")
                ],
              ),
              SizedBox(
                width: 4,
              ),
              Column(
                children: [
                  ChatVideoButoon.ChatVideoButton(
                    chatID: chatID,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text("Pick Video")
                ],
              )
            ],
          ),
        );
      },
      child: Icon(
        IconData(
          0xf732,
        ),
      ),
    );
  }
}
