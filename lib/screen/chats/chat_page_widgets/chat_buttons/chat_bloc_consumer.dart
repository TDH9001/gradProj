import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_proj/models/message.dart';
import 'package:grad_proj/screen/chats/caht_cubit/caht_cubit.dart';
import 'package:grad_proj/screen/chats/caht_cubit/chat_cubit_states.dart';
import 'package:grad_proj/screen/theme/light_theme.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/services/media_service.dart';

class ChatBlocConsumer extends StatelessWidget {
  const ChatBlocConsumer({super.key, required this.chatID, required this.GK});
  final String chatID;
  final GlobalKey<FormState> GK;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ChatCubitInitial) {
          return SizedBox(
            // height: _height * 0.1,
            width: MediaService.instance.getWidth() * 0.09,
            child: IconButton(
              icon: Icon(Icons.mic, color: LightTheme.primary),
              onPressed: () async {
                ChatCubit.get(context)
                    .startRecord(ChatCubit.get(context).record);
              },
            ),
          );
        } else if (state is ChatCubitRecording) {
          return SizedBox(
            // height: _height * 0.1,
            width: MediaService.instance.getWidth() * 0.09,
            child: IconButton(
              icon: Icon(Icons.stop, color: LightTheme.primary),
              onPressed: () async {
                String? VoiceUrl = await ChatCubit.get(context)
                    .stopRecord(ChatCubit.get(context).record);
                DBService.instance.addMessageInChat(
                    chatId: chatID,
                    messageData: Message(
                        isImportant: false,
                        senderID:
                            HiveUserContactCashingService.getUserContactData()
                                .id,
                        messageContent: VoiceUrl!,
                        timestamp: Timestamp.now(),
                        type: "voice",
                        senderName:
                            "${HiveUserContactCashingService.getUserContactData().firstName} ${HiveUserContactCashingService.getUserContactData().lastName}"));
              },
            ),
          );
        } else if (state is ChatCubitTyping) {
          return SizedBox(
            // height: _height * 0.1,
            width: MediaService.instance.getWidth() * 0.09,
            child: IconButton(
              icon: Icon(Icons.send, color: LightTheme.primary),
              onPressed: () async {
                if (GK.currentState!.validate() &&
                    ChatCubit.get(context).txt.text.isNotEmpty) {
                  ChatCubit.get(context).chageStateForChat();
                  // txt.text.trim();
                  DBService.instance.addMessageInChat(
                      chatId: chatID,
                      messageData: Message(
                          isImportant: false,
                          senderID:
                              HiveUserContactCashingService.getUserContactData()
                                  .id,
                          messageContent:
                              ChatCubit.get(context).txt.text.trim(),
                          timestamp: Timestamp.now(),
                          type: "text",
                          senderName:
                              "${HiveUserContactCashingService.getUserContactData().firstName} ${HiveUserContactCashingService.getUserContactData().lastName}"));
                }
                ChatCubit.get(context).txt.text = "";
                FocusScope.of(context).unfocus();
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
