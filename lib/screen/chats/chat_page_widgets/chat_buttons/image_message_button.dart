import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/message.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/services/cloud_Storage_Service.dart';
import 'package:grad_proj/services/media_service.dart';

import '../../../theme/light_theme.dart';

class ImageMessageButton extends StatelessWidget {
  ImageMessageButton({super.key, required this.chatID, required this.cst});
  final String chatID;
  final CustomPopupMenuController cst;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        // height: MediaService.instance.getHeight() * 0.07,
        // width: MediaService.instance.getWidth() * 0.1,
        child: IconButton(
            onPressed: () async {
              cst.hideMenu();
              var _image = await MediaService.instance.getImageFromLibrary();
              if (_image != null) {
                var _resilt = await CloudStorageService.instance.uploadChatFile(
                    uid: HiveUserContactCashingService.getUserContactData().id,
                    fileData: _image);
                var _imageurl = await _resilt!.ref.getDownloadURL();
                await DBService.instance.addMessageInChat(
                    chatId: chatID,
                    messageData: Message(
                        isImportant: false,
                        senderID:
                            HiveUserContactCashingService.getUserContactData()
                                .id,
                        messageContent: _imageurl,
                        timestamp: Timestamp.now(),
                        type: "image",
                        senderName:
                            "${HiveUserContactCashingService.getUserContactData().firstName} ${HiveUserContactCashingService.getUserContactData().lastName}"));
              }
              // FocusScope.of(context).unfocus();
            },
            icon: Icon(Icons.camera_alt, color: LightTheme.secondary)));
  }
}
