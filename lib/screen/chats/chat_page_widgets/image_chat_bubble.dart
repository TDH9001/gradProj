import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/months_and_week_map.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:http/http.dart' as http;

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

  Future<bool> urlExists(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
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
      if (!await urlExists(widget.FileAdress)) {
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
                Timer(Duration(milliseconds: 750), () {
                  setState(() {
                    progress = fileResponse.progress! / fileResponse.totalSize!;
                  });
                });
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
      onTap: () => showDialog(
        context: context,
        builder: (_) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Image(
              image: cachedImage != null
                  ? FileImage(cachedImage!)
                  : AssetImage('assets/images/offline_image.png'),
            )),
      ),
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
          // mainAxisSize: MainAxisSize.max,
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
                ? Container(
                    height: MediaService.instance.getHeight() * 0.45,
                    width: MediaService.instance.getWidth() * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: FileImage(cachedImage!),
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
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
