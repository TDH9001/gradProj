import 'package:flutter/material.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/image_message_button.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/send_message_button.dart';
import 'package:grad_proj/services/hive_caching_service/hive_cashing_service.dart';
import 'package:grad_proj/services/media_service.dart';

class MessageField extends StatefulWidget {
  MessageField(
      {super.key,
      required this.GK,
      required this.txt,
      required this.chatID,
      required this.admins,
      required this.isRecording});
  final GlobalKey<FormState> GK;
  final TextEditingController txt;
  final String chatID;
  final List<String> admins;
  bool isRecording;

  @override
  State<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: _height * 0.1,
      width: MediaService.instance.getWidth(),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(22)),
      margin: EdgeInsets.symmetric(
          horizontal: MediaService.instance.getWidth() * 0.02,
          vertical: MediaService.instance.getHeight() * 0.02),
      child: Form(
          key: widget.GK,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: widget.admins
                    .contains(HiveCashingService.getUserContactData().id.trim())
                ? [
                    _messageTextField(widget.txt),
                    SendMessageButton(
                      GK: widget.GK,
                      chatID: widget.chatID,
                      isRecording: widget.isRecording,
                      txt: widget.txt,
                    ),
                    ImageMessageButton(
                      chatID: widget.chatID,
                    )
                  ]
                : [
                    Text("only admins can contribute to this chat"),
                  ],
          )),
    );
  }

  Widget _messageTextField(final TextEditingController txt) {
    return SizedBox(
      width: MediaService.instance.getWidth() * 0.5,
      child: TextFormField(
        controller: txt,
        onTap: () {
          txt.text += " ";
        },
        validator: (data) {
          if (data == null || data.trim().isEmpty) {
            return "The message cannot be empty";
          }
          return null;
        },
        cursorColor: Colors.black,
        autocorrect: false,
        decoration: InputDecoration(
            border: InputBorder.none, hintText: "type a Massage ... "),
      ),
    );
  }
}
