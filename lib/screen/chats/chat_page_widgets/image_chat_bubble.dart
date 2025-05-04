import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
class _ImageMessageBubbleState extends State<ImageMessageBubble> {
  File? cachedImage;

  void initState() {
    super.initState();
    _loadCachedImage();
  }

  Future<void> _loadCachedImage() async {
    var connectResult = await Connectivity().checkConnectivity();
    final fileInfo =
        await DefaultCacheManager().getFileFromCache(widget.FileAdress);
    //get the thing in the DB slot

    if (fileInfo != null && await fileInfo.file.exists()) {
      setState(() {
        cachedImage = fileInfo.file;
      });
      return;
    } else if (!connectResult.contains(ConnectivityResult.none)) {
      try {
        {
          // Download and cache the file if not already cached
          final downloadedFile =
              await DefaultCacheManager().getSingleFile(widget.FileAdress);
          if (mounted) {
            setState(() {
              cachedImage = downloadedFile;
            });
          }
        }
      } catch (e) {
        print(e);
        setState(() {
          cachedImage = null;
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

  final _numMap = {
    1: "jan ",
    2: "feb",
    3: "mar",
    4: 'apr',
    5: "may",
    6: "jun",
    7: "jul",
    8: "aug",
    9: "sep",
    10: "oct",
    11: "nov",
    12: "dec"
  };

  final _weekmap = {
    6: "saturday",
    7: 'sunday',
    1: "monday",
    2: "tuesday",
    3: "wednesday",
    4: "thursday",
    5: "friday"
  };

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
            cachedImage != null // if image file is null >  do not show it
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
                : Container(
                    height: MediaService.instance.getHeight() * 0.2,
                    width: MediaService.instance.getWidth() * 0.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage('assets/images/offline_image.png'),
                          fit: BoxFit.fitWidth,
                        )),
                    // child: Center(
                    //   child:
                    //       GestureDetector(child: CircularProgressIndicator()),
                    // ),
                  ),
            SizedBox(
              height: 15,
            ),
            Text(
              "${_weekmap[widget.ts.toDate().weekday]} ${_numMap[widget.ts.toDate().month]} ${widget.ts.toDate().day} , ${widget.ts.toDate().hour % 12}: ${widget.ts.toDate().minute % 60} ${widget.ts.toDate().hour < 12 ? "pm" : "am"}        ",
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
