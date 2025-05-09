import 'package:flutter/material.dart';
import 'package:grad_proj/models/Chats.dart';
import 'package:grad_proj/screen/chats/caht_cubit/caht_cubit.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/chat_bloc_consumer.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/image_message_button.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/services/media_service.dart';

class MessageField extends StatefulWidget {
  MessageField(
      {super.key,
      required this.GK,
      required this.chatID,
      required this.admins,
      required this.isRecording,
      required this.leaders,
      required this.chatAccesability});
  final List<String> leaders;
  final String chatAccesability;
  final GlobalKey<FormState> GK;
  //final TextEditingController txt;
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
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: widget.admins.contains(
                        HiveUserContactCashingService.getUserContactData()
                            .id
                            .trim()) || // adminsa re always allowed
                    (widget.chatAccesability ==
                            ChatAccesabilityEnum.allow_Leaders.name &&
                        widget.leaders.contains(
                            HiveUserContactCashingService.getUserContactData()
                                .id
                                .trim())) // leaders are allowed when spicified
                    ||
                    widget.chatAccesability ==
                        ChatAccesabilityEnum.allow_All
                            .name // if it's y name > all can contribute
                    ||
                    HiveUserContactCashingService.getUserContactData()
                            .id
                            .trim()
                            .length <
                        10 // when GLOBAL ADMIN
                ? [
                    Spacer(
                      flex: 1,
                    ),
                    ImageMessageButton(
                      chatID: widget.chatID,
                    ),
                    _messageTextField(ChatCubit.get(context).txt),
                    Spacer(
                      flex: 4,
                    ),
                    ChatBlocConsumer(
                      GK: widget.GK,
                      chatID: widget.chatID,
                    ),
                    Spacer(
                      flex: 1,
                    ),
                  ]
                : [
                    Text("you are not able to contribute to this Chat"),
                  ],
          )),
    );
  }

  Widget _messageTextField(final TextEditingController txt) {
    return SizedBox(
      width: MediaService.instance.getWidth() * 0.7,
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
        onChanged: ChatCubit.get(context).onTextChanged,
        decoration: InputDecoration(
            border: InputBorder.none, hintText: "type a Massage ... "),
      ),
    );
  }
}
