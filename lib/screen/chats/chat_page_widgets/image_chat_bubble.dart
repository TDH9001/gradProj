import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/months_and_week_map.dart';
import 'package:grad_proj/services/Network_checker_service.dart';
import 'package:grad_proj/services/animated_hero_service/animated_hero_dialog.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/services/snackbar_service.dart';

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
  File? cachedImage;
  bool isLoading = false;
  double progress = 0;
  bool isFailed = false;

  void initState() {
    super.initState();
    _loadCachedImage();
  }

  @override
  void didUpdateWidget(ImageMessageBubble oldWidget) {
    //tis ameks sure that the iamge is not the same if another is sent
    super.didUpdateWidget(oldWidget);
    if (oldWidget.FileAdress != widget.FileAdress) {
      setState(() {
        cachedImage = null;
        isLoading = true;
        progress = 0.0;
      });
      _loadCachedImage();
    }
  }

/*************  ✨ Windsurf Command ⭐  *************/
  /// This function will check if the image is cached, if not it will check if the user has an internet connection
  /// and if the image is available on the server if yes it will download and cache it
  /// if not it will show an error snackbar
  /// if the image is cached it will load it from the cache
  /// if the image is loading it will show a progress bar
  /// if the image fails to load it will show an error snackbar
/*******  b72076f9-bc07-47d4-983d-aa3d902fdc49  *******/
  Future<void> _loadCachedImage() async {
    var connectResult = await Connectivity().checkConnectivity();
    final fileInfo =
        await DefaultCacheManager().getFileFromCache(widget.FileAdress);
    //get the thing in the DB slot

    if (fileInfo != null && await fileInfo.file.exists()) {
      if (mounted) {
        setState(() {
          cachedImage = fileInfo.file;
        });
      }

      return;
    } else if (!connectResult.contains(ConnectivityResult.none)) {
      if (!await NetworkCheckerService.urlExists(widget.FileAdress)) {
        if (mounted) {
          setState(() {
            isFailed = true;
            cachedImage = null;
            isLoading = false;
          });
        }
        return;
      }
      try {
        {
          if (mounted) {
            setState(() {
              isLoading = true;
            });
          }
          await DefaultCacheManager()
              .getFileStream(widget.FileAdress, withProgress: true)
              .listen((fileResponse) {
            if (fileResponse is DownloadProgress) {
              print(fileResponse.progress! / fileResponse.totalSize!);
              if (mounted) {
                setState(() {
                  progress = fileResponse.progress! / fileResponse.totalSize!;
                });
                Timer(Duration(milliseconds: 750), () {});
              }
            } else if (fileResponse is FileInfo &&
                mounted &&
                widget.FileAdress == fileResponse.originalUrl) {
              if (mounted) {
                print(
                    "Download complete, file path: ${fileResponse.file.path}");
                setState(() {
                  progress = 1.0;
                  isLoading = false;
                  cachedImage = fileResponse.file;
                });
              }
            }
          });
        }
      } catch (e) {
        print(e);
        setState(() {
          cachedImage = null;
          isFailed = true;
        });
        if (mounted) {
          SnackBarService.instance.buildContext = context;
          SnackBarService.instance.showsSnackBarError(
              text:
                  "the iamge faled to laod > please ensure you have an internet connection");
        }
      }
    } else {
      cachedImage = null;
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colorScheme = widget.isOurs
        ? [Color(0xFFA3BFE0), Color(0xFF769BC6)]
        : [
            Color(0xFFA3BFE0),
            Color(0xFF769BC6),
          ];
    return GestureDetector(
      onTap: () {
        AnimatedHeroDialog.showAnimatedWidgetTransition(
          context: context,
          heroID: widget.FileAdress,
          displayedWidget: ClipRRect(
            child: Image(
                image: cachedImage != null && !isFailed
                    ? FileImage(cachedImage!)
                    : isFailed
                        ? AssetImage("assets/images/file_not_found.png")
                        : AssetImage(
                            'assets/images/offline_image.png')), //does not display when loading though
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
                colors: colorScheme,
                stops: [0.40, 0.70],
                begin: widget.isOurs
                    ? Alignment.bottomLeft
                    : Alignment.bottomRight,
                end: widget.isOurs ? Alignment.topRight : Alignment.topLeft)),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment:
              widget.isOurs ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(widget.senderName),
            SizedBox(
              height: 9,
            ),
            //where image is displayed
            cachedImage != null &&
                    !isFailed //if not null and no error > then image
                ? Hero(
                    tag: widget.FileAdress,
                    child: Container(
                      height: MediaService.instance.getHeight() * 0.45,
                      width: MediaService.instance.getWidth() * 0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: FileImage(cachedImage!),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ))
                : isFailed //if it's failed > show placeholder image
                    ? Container(
                        height: MediaService.instance.getHeight() * 0.2,
                        width: MediaService.instance.getWidth() * 0.4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/file_not_found.png"),
                              fit: BoxFit.fitWidth,
                            )),
                      )
                    : isLoading ==
                            false //if it's not loading > show placeholder image
                        ? Container(
                            height: MediaService.instance.getHeight() * 0.2,
                            width: MediaService.instance.getWidth() * 0.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/offline_image.png'),
                                  fit: BoxFit.fitWidth,
                                )),
                          )
                        : Container(
                            // if it's loading > show loading indicator
                            height: MediaService.instance.getHeight() * 0.2,
                            width: MediaService.instance.getWidth() * 0.4,
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
                                      height:
                                          MediaService.instance.getHeight() *
                                              0.02),
                                  Text(
                                      "loading: ${(progress * 100).toStringAsFixed(2)} %")
                                ],
                              ),
                            )),
                          ),
            SizedBox(
              height: 15,
            ),
            Text(
              "${MonthAndWeekMap.weekmap[widget.ts.toDate().weekday]} ${MonthAndWeekMap.numMap[widget.ts.toDate().month]} ${widget.ts.toDate().day} , ${widget.ts.toDate().hour % 12}: ${widget.ts.toDate().minute % 60} ${widget.ts.toDate().hour < 12 ? "pm" : "am"}        ",
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
