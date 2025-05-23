import 'package:chewie/chewie.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/cached_file_rsponse/cahed_item_set_state_response.dart';
import 'package:grad_proj/models/message.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/Image_bubble_widgets/image_hero_container.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/caht_mesage_widgets/chat_popup_menu_builder_butons.dart';
import 'package:grad_proj/services/animated_hero_service/animated_hero_dialog.dart';
import 'package:grad_proj/services/file_caching_service/chat_file_caching_service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:video_player/video_player.dart';

class ChatVideoMessage extends StatefulWidget {
  ChatVideoMessage(
      {super.key,
      required this.chatID,
      required this.message,
      required this.admins});
  final List<String> admins;
  final String chatID;
  final Message message;
  final CustomPopupMenuController cst = CustomPopupMenuController();
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  State<ChatVideoMessage> createState() => _ChatVideoMessageState();
}

class _ChatVideoMessageState extends State<ChatVideoMessage>
    with AutomaticKeepAliveClientMixin {
  @override
  void dispose() {
    widget.chewieController.dispose();
    widget.videoPlayerController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
  void initPlayer(AsyncSnapshot<CachedFileResult> snapshot) {
    if (snapshot.data!.isFailed == false && snapshot.data!.file != null) {
      widget.videoPlayerController =
          VideoPlayerController.file(snapshot.data!.file!);
      //  widget.videoPlayerController.initialize();
      widget.chewieController = ChewieController(
          videoPlayerController: widget.videoPlayerController,
          autoPlay: false,
          looping: true,
          autoInitialize: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CachedFileResult>(
      stream: ChatFileCachingService.loadCachedFile(
          fileType: "videos", fileAdress: widget.message.messageContent),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return Center(child: CircularProgressIndicator());
          return ImageContainerHeroWidget(
            fileAdress: widget.message.messageContent,
            imageToShow: AssetImage("assets/images/splash.png"),
          );
        }
        if (snapshot.data!.isFailed == false && snapshot.data!.file != null) {
          initPlayer(snapshot);
        }
        return CustomPopupMenu(
          pressType: PressType.longPress,
          menuBuilder: () => ChatPopupMenuBuilderButons.popupMenuBuilder(
              widget.cst, widget.chatID, widget.message, widget.admins),
          child: GestureDetector(
            onTap: () {
              if (snapshot.data!.isFailed == false &&
                  snapshot.data!.file != null) {
                AnimatedHeroDialog.showAnimatedWidgetTransition(
                    context: context,
                    heroID: widget.message.messageContent,
                    displayedWidget: snapshot.data!.isFailed == false &&
                            snapshot.data!.file != null
                        ? Chewie(
                            controller: widget.chewieController,
                          )
                        : Image(
                            image: AssetImage(
                                'assets/images/file_not_found.png')));
              }
            },
            child: Container(
              height: MediaService.instance.getHeight() * 0.45,
              width: MediaService.instance.getWidth() * 0.7,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: widget.message.isImportant
                      ? Color(0xFFD3E3F1)
                      : Colors.grey[300]),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                //mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: widget.message.senderID ==
                        HiveUserContactCashingService.getUserContactData().id
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  Text(widget.message.senderName.trim(), style: TextStyle(color: Colors.black54),),
                  SizedBox(
                    height: 4,
                  ), //WIDGET HEREEEEEEEEEE
                  !snapshot.data!.isLoading
                      ? SizedBox(
                          width: MediaService.instance.getWidth() * 0.65,
                          height: MediaService.instance.getHeight() * 0.35,
                          child: Column(children: [
                            snapshot.data!.isFailed == false &&
                                    snapshot.data!.file != null
                                ? Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    width:
                                        MediaService.instance.getWidth() * 0.6,
                                    height: MediaService.instance.getHeight() *
                                        0.35,
                                    child: Chewie(
                                      controller: widget.chewieController,
                                    ),
                                  )
                                : Image(
                                    image: AssetImage(
                                        'assets/images/file_not_found.png')),
                          ]))
                      : FittedBox(
                          //while loading
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
                    "${widget.message.timestamp.toDate().hour % 12}: ${widget.message.timestamp.toDate().minute % 60} ${widget.message.timestamp.toDate().hour < 12 ? "am" : "pm"}",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
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
