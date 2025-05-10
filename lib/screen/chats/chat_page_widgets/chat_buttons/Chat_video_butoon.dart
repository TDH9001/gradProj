import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
          } else {
            SnackBarService.instance.buildContext = context;
            SnackBarService.instance
                .showsSnackBarError(text: "could not uplaod the file");
          }
        },
        icon: Icon(Icons.ondemand_video_sharp));
  }
}
