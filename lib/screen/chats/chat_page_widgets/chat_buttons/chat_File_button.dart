import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/message.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/cloud_Storage_Service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/services/snackbar_service.dart';

class ChatFileButton extends StatelessWidget {
  const ChatFileButton({super.key, required this.chatID, required this.cst});
  final String chatID;
  final CustomPopupMenuController cst;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          cst.hideMenu();
          FilePickerResult? result = await FilePicker.platform
              .pickFiles(type: FileType.custom, allowedExtensions: [
            // All common types except video formats
            'pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx',
            'txt', 'jpg', 'jpeg', 'png', 'gif', 'bmp', 'mp3', 'wav',
            'zip', 'rar', '7z', 'json', 'csv', 'xml', 'html', 'css', 'js'
            // Excludes: mp4, mov, avi, mkv, etc.
          ]);
          if (result != null) {
            File file = File(result.files.single.path!);
            var _resilt = await CloudStorageService.instance.uploadChatFile(
                uid: HiveUserContactCashingService.getUserContactData().id,
                fileData: file);
            var fileUrl = await _resilt!.ref.getDownloadURL();
            await DBService.instance.addMessageInChat(
                chatId: chatID,
                messageData: Message(
                    isImportant: false,
                    senderID:
                        HiveUserContactCashingService.getUserContactData().id,
                    messageContent: fileUrl,
                    timestamp: Timestamp.now(),
                    type: "file",
                    senderName:
                        "${HiveUserContactCashingService.getUserContactData().firstName} ${HiveUserContactCashingService.getUserContactData().lastName}"));
          } else {
            SnackBarService.instance.buildContext = context;
            SnackBarService.instance
                .showsSnackBarError(text: "could not upload the file");
          }
        },
        icon: Icon(Icons.file_copy_sharp));
  }
}
