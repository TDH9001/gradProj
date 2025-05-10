import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/cached_file_rsponse/cahed_item_set_state_response.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/Image_bubble_widgets/image_hero_container.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/months_and_week_map.dart';
import 'package:grad_proj/services/animated_hero_service/animated_hero_dialog.dart';
import 'package:grad_proj/services/file_caching_service/chat_file_caching_service.dart';
import 'package:grad_proj/services/media_service.dart';

class ImageMessageBubble extends StatefulWidget {
  ImageMessageBubble(
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
        stream: ChatFileCachingService.loadCachedImage(
            fileAdress: widget.FileAdress),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // return Center(child: CircularProgressIndicator());
            return ImageContainerHeroWidget(
              fileAdress: widget.FileAdress,
              imageToShow: AssetImage("assets/images/splash.png"),
            );
          }
          return GestureDetector(
            onTap: () {
              AnimatedHeroDialog.showAnimatedWidgetTransition(
                context: context,
                heroID: widget.FileAdress,
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
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade400),
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
                  crossAxisAlignment: widget.isOurs
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Text(widget.senderName),
                    SizedBox(
                      height: 4,
                    ),
                    //where image is displayed
                    snapshot.data!.file != null &&
                            !snapshot.data!
                                .isFailed //if not null and no error > then image
                        ? ImageContainerHeroWidget(
                            fileAdress: widget.FileAdress,
                            imageToShow: FileImage(snapshot.data!.file!))
                        : snapshot.data!
                                .isFailed //if it's failed > show placeholder image
                            ? ImageContainerHeroWidget(
                                imageToShow: AssetImage(
                                    "assets/images/file_not_found.png"),
                                fileAdress: widget.FileAdress,
                              )
                            : snapshot.data!.isLoading ==
                                    false //if it's not loading > show placeholder image
                                ? ImageContainerHeroWidget(
                                    fileAdress: widget.FileAdress,
                                    imageToShow: AssetImage(
                                        'assets/images/offline_image.png'),
                                  )
                                : Container(
                                    // if it's loading > show loading indicator
                                    height: MediaService.instance.getHeight() *
                                        0.35,
                                    width:
                                        MediaService.instance.getWidth() * 0.5,
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
                      "  , ${widget.ts.toDate().hour % 12}: ${widget.ts.toDate().minute % 60} ${widget.ts.toDate().hour < 12 ? "pm" : "am"}        ",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
