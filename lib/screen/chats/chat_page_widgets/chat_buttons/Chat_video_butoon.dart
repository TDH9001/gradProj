import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/message.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/cloud_Storage_Service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/services/snackbar_service.dart';

class ChatVideoButoon extends StatelessWidget {
  const ChatVideoButoon.ChatVideoButton({super.key, required this.chatID});
  final String chatID;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          FilePickerResult? result =
              await FilePicker.platform.pickFiles(type: FileType.video);
          if (result != null) {
            File file = File(result.files.single.path!);
            var _resilt = await CloudStorageService.instance.uploadChatFile(
                uid: HiveUserContactCashingService.getUserContactData().id,
                fileData: file);
            var fileUrl = await _resilt!.ref.getDownloadURL();
            await DBService.instance.addMessageInChat(
                chatId: chatID,
                messageData: Message(
                    senderID:
                        HiveUserContactCashingService.getUserContactData().id,
                    messageContent: fileUrl,
                    timestamp: Timestamp.now(),
                    type: "file",
                    senderName:
                        "${HiveUserContactCashingService.getUserContactData().firstName} ${HiveUserContactCashingService.getUserContactData().lastName}"));
            //     FocusScope.of(context).unfocus();
            //returnthe size as BYTES result.files.single.size;
          } else {
            SnackBarService.instance.buildContext = context;
            SnackBarService.instance
                .showsSnackBarError(text: "could not uplaod the file");
          }
        },
        icon: Icon(Icons.ondemand_video_sharp));
  }
}
