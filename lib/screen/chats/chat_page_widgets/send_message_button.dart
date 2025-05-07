import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/message.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/services/cloud_Storage_Service.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

import '../../theme/light_theme.dart';

class SendMessageButton extends StatefulWidget {
  SendMessageButton(
      {super.key,
      //  required BuildContext context,
      required this.txt,
      required this.isRecording,
      required this.chatID,
      required this.GK});
  final TextEditingController txt;
  bool isRecording;
  final record = AudioRecorder();
  final String chatID;
  GlobalKey<FormState> GK;

  @override
  State<SendMessageButton> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SendMessageButton> {
  // void startRecord(AudioRecorder rec) async {
  //   var location = await getApplicationDocumentsDirectory();
  //   String fileName = Uuid().v4();
  //   if (await rec.hasPermission()) {
  //     await rec.start(RecordConfig(), path: location.path + fileName + '.m4a');
  //     setState(() {
  //       widget.isRecording = true;
  //     });
  //   }
  // }

  Future<String?> stopRecord(AudioRecorder rec) async {
    String? finalPath = await rec.stop();
    setState(() {
      widget.isRecording = false;
    });
    if (finalPath != null) {
      var _result = await CloudStorageService.instance.uploadVoice(
          uid: HiveUserContactCashingService.getUserContactData().id,
          fileData: File(finalPath));
      return await _result!.ref.getDownloadURL();
    } else {
      SnackBarService.instance
          .showsSnackBarError(text: "could not uplaod the file");
    }
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    return SizedBox(
      // height: _height * 0.1,
      width: MediaService.instance.getWidth() * 0.09,
      child: IconButton(
        icon: Icon(
            widget.txt.text.isEmpty
                ? (widget.isRecording ? Icons.stop : Icons.mic)
                : Icons.send,
            color: LightTheme.primary),
        onPressed: () async {
          if (widget.txt.text.isEmpty) {
            if (!widget.isRecording) {
              //  startRecord(widget.record);
            } else {
              String? VoiceUrl = await stopRecord(widget.record);
              DBService.instance.addMessageInChat(
                  chatId: widget.chatID,
                  messageData: Message(
                      senderID:
                          HiveUserContactCashingService.getUserContactData().id,
                      messageContent: VoiceUrl!,
                      timestamp: Timestamp.now(),
                      type: "voice",
                      senderName:
                          "${HiveUserContactCashingService.getUserContactData().firstName} ${HiveUserContactCashingService.getUserContactData().lastName}"));
            }
          } else if (widget.GK.currentState!.validate() &&
              widget.txt.text.isNotEmpty) {
            // txt.text.trim();
            DBService.instance.addMessageInChat(
                chatId: widget.chatID,
                messageData: Message(
                    senderID:
                        HiveUserContactCashingService.getUserContactData().id,
                    messageContent: widget.txt.text.trim(),
                    timestamp: Timestamp.now(),
                    type: "text",
                    senderName:
                        "${HiveUserContactCashingService.getUserContactData().firstName} ${HiveUserContactCashingService.getUserContactData().lastName}"));
          }
          widget.txt.text = "";
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
