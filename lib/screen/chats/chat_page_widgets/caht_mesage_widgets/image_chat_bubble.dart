import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/cached_file_rsponse/cahed_item_set_state_response.dart';
import 'package:grad_proj/models/message.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/Image_bubble_widgets/image_hero_container.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/caht_mesage_widgets/chat_popup_menu_builder_butons.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/caht_mesage_widgets/months_and_week_map.dart';
import 'package:grad_proj/services/animated_hero_service/animated_hero_dialog.dart';
import 'package:grad_proj/services/file_caching_service/chat_file_caching_service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/services/media_service.dart';

class ImageMessageBubble extends StatefulWidget {
  ImageMessageBubble(
      {super.key,
      required this.chatID,
      required this.message,
      required this.admins});
  final List<String> admins;
  final String chatID;
  final Message message;
  final CustomPopupMenuController cst = CustomPopupMenuController();

  @override
  State<ImageMessageBubble> createState() => _ImageMessageBubbleState();
}

@override
class _ImageMessageBubbleState extends State<ImageMessageBubble>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
// use this to not force re-downloads

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CachedFileResult>(
        stream: ChatFileCachingService.loadCachedFile(
            fileType: "images", fileAdress: widget.message.messageContent),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // return Center(child: CircularProgressIndicator());
            return ImageContainerHeroWidget(
              fileAdress: widget.message.messageContent,
              imageToShow: AssetImage("assets/images/splash.png"),
            );
          }
          return CustomPopupMenu(
            pressType: PressType.longPress,
            menuBuilder: () => ChatPopupMenuBuilderButons.popupMenuBuilder(
                widget.cst, widget.chatID, widget.message, widget.admins),
            child: GestureDetector(
              onTap: () {
                AnimatedHeroDialog.showAnimatedWidgetTransition(
                  context: context,
                  heroID: widget.message.messageContent,
                  displayedWidget: ClipRRect(
                    child: Image(
                        image: snapshot.data!.file != null &&
                                snapshot.data!.isFailed == false
                            ? FileImage(snapshot.data!.file!)
                            : snapshot.data!.isFailed == true
                                ? AssetImage("assets/images/file_not_found.png")
                                : AssetImage(
                                    'assets/images/offline_image.png')), //does not display when loading though
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
                // child: CustomPopupMenu(
                //   pressType: PressType.singleClick,
                //   menuBuilder: () {
                //     // return Container(
                //     //   color: Colors.red,
                //     //   width: 100,
                //     //   height: 100,
                //     // );
                //     return Container();
                //   },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: widget.message.isImportant
                          ? Color(0xFFD3E3F1)
                          : Colors.grey[300]),
                  // gradient: LinearGradient(
                  //     colors: colorScheme,
                  //     stops: [0.40, 0.70],
                  //     begin: widget.isOurs
                  //         ? Alignment.bottomLeft
                  //         : Alignment.bottomRight,
                  //     end: widget.isOurs
                  //         ? Alignment.topRight
                  //         : Alignment.topLeft)),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: widget.message.senderID ==
                            HiveUserContactCashingService.getUserContactData()
                                .id
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.message.senderName,
                        style: TextStyle(
                            color: Colors.black54),
                      ),
                      //where image is displayed
                      snapshot.data!.file != null &&
                              !snapshot.data!
                                  .isFailed //if not null and no error > then image
                          ? ImageContainerHeroWidget(
                              fileAdress: widget.message.messageContent,
                              imageToShow: FileImage(snapshot.data!.file!))
                          : snapshot.data!
                                  .isFailed //if it's failed > show placeholder image
                              ? ImageContainerHeroWidget(
                                  imageToShow: AssetImage(
                                      "assets/images/file_not_found.png"),
                                  fileAdress: widget.message.messageContent,
                                )
                              : snapshot.data!.isLoading ==
                                      false //if it's not loading > show placeholder image
                                  ? ImageContainerHeroWidget(
                                      fileAdress: widget.message.messageContent,
                                      imageToShow: AssetImage(
                                          'assets/images/offline_image.png'),
                                    )
                                  : Container(
                                      // if it's loading > show loading indicator
                                      height:
                                          MediaService.instance.getHeight() *
                                              0.35,
                                      width: MediaService.instance.getWidth() *
                                          0.5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                          child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            CircularProgressIndicator(
                                              color: Colors.greenAccent,
                                            ),
                                            SizedBox(
                                                height: MediaService.instance
                                                        .getHeight() *
                                                    0.02),
                                            Text(
                                                "loading: ${(snapshot.data!.progress).toStringAsFixed(2)} %")
                                          ],
                                        ),
                                      )),
                                    ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${widget.message.timestamp.toDate().hour % 12}: ${widget.message.timestamp.toDate().minute % 60} ${widget.message.timestamp.toDate().hour < 12 ? "am" : "pm"}        ",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
