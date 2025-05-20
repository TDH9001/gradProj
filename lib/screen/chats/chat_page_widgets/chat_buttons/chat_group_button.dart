import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/chat_buttons/Chat_video_butoon.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/chat_buttons/chat_File_button.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/chat_buttons/image_message_button.dart';

class ChatGroupButton extends StatelessWidget {
  ChatGroupButton({super.key, required this.chatID});
  final String chatID;
  final CustomPopupMenuController cst = CustomPopupMenuController();
  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      controller: cst,
      pressType: PressType.singleClick,
      menuBuilder: () {
        return Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey,
          ),
          child: Row(
            children: [
              Column(children: [
                ImageMessageButton(chatID: chatID, cst: cst),
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
                  ChatFileButton(chatID: chatID, cst: cst),
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
                  ChatVideoButoon.ChatVideoButton(chatID: chatID, cst: cst),
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
        Icons.attach_file,color: Color(0xff769BC6),
      ),
    );
  }
}
