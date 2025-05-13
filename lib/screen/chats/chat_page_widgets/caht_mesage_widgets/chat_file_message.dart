import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/cached_file_rsponse/cahed_item_set_state_response.dart';
import 'package:grad_proj/models/message.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/Image_bubble_widgets/image_hero_container.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/caht_mesage_widgets/chat_popup_menu_builder_butons.dart';
import 'package:grad_proj/services/file_caching_service/chat_file_caching_service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:path/path.dart' as p;

import 'package:open_file/open_file.dart';
import 'package:universal_file_viewer/universal_file_viewer.dart';

class ChatFileMessage extends StatefulWidget {
  ChatFileMessage({
    super.key,
    required this.message,
    required this.chatId,

  });
 
  final Message message;
  final String chatId;
  final CustomPopupMenuController controller = CustomPopupMenuController();

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
      stream: ChatFileCachingService.loadCachedFile(
          fileAdress: widget.message.messageContent),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return Center(child: CircularProgressIndicator());
          return ImageContainerHeroWidget(
            fileAdress: widget.message.messageContent,
            imageToShow: AssetImage("assets/images/splash.png"),
          );
        }
        return CustomPopupMenu(
          controller: widget.controller,
          pressType: PressType.longPress,
          menuBuilder: () => ChatPopupMenuBuilderButons.popupMenuBuilder(
              widget.controller, widget.chatId, widget.message),
          child: GestureDetector(
            onTap: () async {
              if (snapshot.data!.isFailed == false &&
                  snapshot.data!.file != null) {
                OpenFile.open(snapshot.data!.file!.path);
              }
            },
            child: Container(
              height: MediaService.instance.getHeight() * 0.45,
              width: MediaService.instance.getWidth() * 0.7,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: widget.message.isImportant
                      ? Color(0xFFE7CD78)
                      : Colors.grey.shade400),
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                //mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: widget.message.senderID ==
                        HiveUserContactCashingService.getUserContactData().id
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.message.senderName,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 2,
                  ), //WIDGET HEREEEEEEEEEE
                  !snapshot.data!.isLoading
                      ? Column(children: [
                          snapshot.data!.isFailed == false &&
                                  snapshot.data!.file != null
                              ? Row(
                                  children: [
                                    SizedBox(
                                      width: MediaService.instance.getWidth() *
                                          0.4,
                                      child: Text(
                                        p.basename(
                                          snapshot.data!.file!.path,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Text(
                                        "  ${p.extension(snapshot.data!.file!.path)}")
                                  ],
                                )
                              : SizedBox(),
                          snapshot.data!.isFailed == false &&
                                  snapshot.data!.file != null
                              ? Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)),
                                  width: MediaService.instance.getWidth() * 0.6,
                                  height:
                                      MediaService.instance.getHeight() * 0.35,
                                  child: p.extension(
                                              snapshot.data!.file!.path) ==
                                          ".xlsx"
                                      ? Image(
                                          image: AssetImage(
                                              'assets/images/xlsx.png'))
                                      : p.extension(snapshot
                                                      .data!.file!.path) ==
                                                  ".ppt" ||
                                              p.extension(snapshot
                                                      .data!.file!.path) ==
                                                  ".pptx"
                                          ? Image(
                                              image: AssetImage(
                                                  "assets/images/ppt.png"),
                                            )
                                          : UniversalFileViewer(
                                              file: snapshot.data!.file!))
                              : Image(
                                  image: AssetImage(
                                      'assets/images/file_not_found.png'))
                        ])
                      : FittedBox(
                          child: Column(children: [
                          Text(
                              "loading : ${(snapshot.data!.progress).toStringAsFixed(2)} %"),
                          SizedBox(
                            height: 5,
                          ),
                          CircularProgressIndicator(
                            color: Colors.greenAccent,
                          ),
                        ])),
                  Text(
                    " ${widget.message.timestamp.toDate().hour % 12}: ${widget.message.timestamp.toDate().minute % 60} ${widget.message.timestamp.toDate().hour < 12 ? "am" : "pm"}        ",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
