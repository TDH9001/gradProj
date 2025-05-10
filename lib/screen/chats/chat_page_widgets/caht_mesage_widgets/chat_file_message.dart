import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/cached_file_rsponse/cahed_item_set_state_response.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/Image_bubble_widgets/image_hero_container.dart';
import 'package:grad_proj/services/animated_hero_service/animated_hero_dialog.dart';
import 'package:grad_proj/services/file_caching_service/chat_file_caching_service.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:path/path.dart' as p;
import 'package:universal_file_viewer/universal_file_viewer.dart';

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
        return GestureDetector(
          onTap: () {
            if (snapshot.data!.isFailed == false &&
                snapshot.data!.file != null) {
              //String Extenshion = p.extension(snapshot.data!.file!.path);
              // print(Extenshion);
              //should preview he file when expanded
              AnimatedHeroDialog.showAnimatedWidgetTransition(
                  context: context,
                  heroID: widget.FileAdress,
                  displayedWidget: snapshot.data!.isFailed == false &&
                          snapshot.data!.file != null
                      ? UniversalFileViewer(
                          file: snapshot.data!.file!,
                        )
                      : Image(
                          image:
                              AssetImage('assets/images/file_not_found.png')));
            }
          },
          child: Container(
            height: MediaService.instance.getHeight() * 0.45,
            width: MediaService.instance.getWidth() * 0.7,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.shade400),
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              //mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: widget.isOurs
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Text(
                  widget.senderName,
                  maxLines: 1,
                ),
                SizedBox(
                  height: 2,
                ), //WIDGET HEREEEEEEEEEE
                !snapshot.data!.isLoading
                    ? SizedBox(
                        width: MediaService.instance.getWidth() * 0.63,
                        height: MediaService.instance.getHeight() * 0.3,
                        child: Column(children: [
                          snapshot.data!.isFailed == false &&
                                  snapshot.data!.file != null
                              ? Text(
                                  p.basename(
                                    snapshot.data!.file!.path,
                                  ),
                                  maxLines: 1,
                                )
                              : SizedBox(),
                          snapshot.data!.isFailed == false &&
                                  snapshot.data!.file != null
                              ? UniversalFileViewer(
                                  file: snapshot.data!.file!,
                                )
                              : Image(
                                  image: AssetImage(
                                      'assets/images/file_not_found.png')),
                        ]))
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
                  " ${widget.ts.toDate().hour % 12}: ${widget.ts.toDate().minute % 60} ${widget.ts.toDate().hour < 12 ? "pm" : "am"}        ",
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
