import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/cached_file_rsponse/cahed_item_set_state_response.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/Image_bubble_widgets/image_hero_container.dart';
import 'package:grad_proj/services/animated_hero_service/animated_hero_dialog.dart';
import 'package:grad_proj/services/file_caching_service/chat_file_caching_service.dart';
import 'package:path/path.dart' as p;

class ChatFileMessage extends StatefulWidget {
  ChatFileMessage(
      {super.key,
      required this.FileAdress,
      required this.isOurs,
      required this.ts,
      required this.senderName});
  final String FileAdress;
  final bool isOurs;
  final Timestamp ts;
  final String senderName;

  @override
  State<ChatFileMessage> createState() => _ChatFileMessageState();
}

class _ChatFileMessageState extends State<ChatFileMessage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CachedFileResult>(
      stream:
          ChatFileCachingService.loadCachedImage(fileAdress: widget.FileAdress),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return Center(child: CircularProgressIndicator());
          return ImageContainerHeroWidget(
            fileAdress: widget.FileAdress,
            imageToShow: AssetImage("assets/images/splash.png"),
          );
        }
        return GestureDetector(onTap: () {
          // AnimatedHeroDialog.showAnimatedWidgetTransition(
          //   context: context,
          //   heroID: widget.FileAdress,
          //   displayedWidget: ClipRRect(
          //     child: Image(
          //         image: snapshot.data!.file != null &&
          //                 snapshot.data!.isFailed == false
          //             ? FileImage(snapshot.data!.file!)
          //             : snapshot.data!.isFailed == true
          //                 ? AssetImage("assets/images/file_not_found.png")
          //                 : AssetImage(
          //                     'assets/images/offline_image.png')), //does not display when loading though
          //   ),
          // );
          if (snapshot.data!.isFailed == false && snapshot.data!.file != null) {
            String Extenshion = p.extension(snapshot.data!.file!.path);
            print(Extenshion);
          }
        });
      },
    );
  }
}
