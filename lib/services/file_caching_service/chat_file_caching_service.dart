import 'dart:async';
import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:grad_proj/models/cached_file_rsponse/cahed_item_set_state_response.dart';
import 'package:grad_proj/services/Network_checker_service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:path/path.dart' as p;
import 'dart:developer' as dev;

class ChatFileCachingService {
  static Stream<CachedFileResult> loadCachedFile(
      {required String fileAdress, required String fileType}) async* {
    double lastyieldedProgress = 0.0;
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
      return;
    } else if (!connectResult.contains(ConnectivityResult.none)) {
      if (!await NetworkCheckerService.urlExists(fileAdress)) {
        yield CachedFileResult(
            isFailed: true, isLoading: false, progress: 0.0, file: null);
        return;
      }
      try {
        await for (final fileResponse in DefaultCacheManager()
            .getFileStream(fileAdress, withProgress: true))
        //.listen((fileResponse) {
        {
          if (fileResponse is DownloadProgress) {
            if (fileResponse.progress! - lastyieldedProgress > 0.05) {
              lastyieldedProgress = fileResponse.progress!;
              yield CachedFileResult(
                isFailed: false,
                isLoading: true,
                progress: fileResponse.progress! * 100,
                file: null,
              );
            }
          } else if (fileResponse is FileInfo &&
              fileAdress == fileResponse.originalUrl) {
            if (HiveUserContactCashingService.getUserContactData().id.length >
                10) {
              String downloadsPath =
                  await ExternalPath.getExternalStoragePublicDirectory(
                      ExternalPath.DIRECTORY_DOWNLOAD);
              dev.log(downloadsPath);
              String targetDir = "$downloadsPath/Sci-Connecet/$fileType";
              await Directory(targetDir)
                  .create(recursive: true); 
              String pathToStoreIn =
                  "$downloadsPath/Sci-Connecet/$fileType/${p.basename(fileResponse.file.path)}";
              File newFile = await fileResponse.file.copy(pathToStoreIn);
              // await FileSaver.instance.saveFile(
              //     name: p.basename(fileResponse.file.path),
              //     file: fileResponse.file);
            }

            yield CachedFileResult(
              isFailed: false,
              isLoading: false,
              progress: 1.0,
              file: fileResponse.file,
            );
            return;
          }
        }
      } on Exception catch (e) {
        print(e);
      }
    } else {
      yield CachedFileResult(
          isFailed: true, isLoading: false, progress: 0.0, file: null);
      return;
    }
  }
}
