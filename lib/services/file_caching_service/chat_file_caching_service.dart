import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:grad_proj/models/cached_file_rsponse/cahed_item_set_state_response.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/image_chat_bubble.dart';
import 'package:grad_proj/services/Network_checker_service.dart';
import 'package:grad_proj/services/snackbar_service.dart';

class ChatFileCachingService {
  static Stream<CachedFileResult> loadCachedImage(
      {required String fileAdress}) async* {
    var connectResult = await Connectivity().checkConnectivity();
    final fileInfo = await DefaultCacheManager().getFileFromCache(fileAdress);
    //get the thing in the DB slot

    if (fileInfo != null && await fileInfo.file.exists()) {
      //returns the file itself
      yield CachedFileResult(
          file: fileInfo.file,
          isFailed: false,
          isLoading: false,
          progress: 0.0);
    } else if (!connectResult.contains(ConnectivityResult.none)) {
      if (!await NetworkCheckerService.urlExists(fileAdress)) {
        yield CachedFileResult(
            isFailed: true, isLoading: false, progress: 0.0, file: null);
      }
      try {
          //possibly that that IMP
          // if (mounted) {
          //   setState(() {
          //     isLoading = true;
          //   });
          // }
           DefaultCacheManager()
              .getFileStream(fileAdress, withProgress: true)
              .listen((fileResponse) {
            if (fileResponse is DownloadProgress)   {
              print(fileResponse.progress! / fileResponse.totalSize!);
              // if (mounted) {
              //   setState(() {
              //     progress = fileResponse.progress! / fileResponse.totalSize!;
              //   });
              // // Timer(Duration(milliseconds: 750), () {});
              // }
              yield CachedFileResult(
                isFailed: false,
                isLoading: true,
                progress: fileResponse.progress! / fileResponse.totalSize!,
                file: null,
              );
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
      return CachedFileResult(
          isFailed: true, isLoading: false, progress: 0.0, file: null);
    }
  }
}
