import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/cloud_Storage_Service.dart';
import 'package:grad_proj/services/snackbar_service.dart';

class SpreadSheetFunctions {
  void pickSpreadSheet(BuildContext context, String chatID) async {
    try {
      FilePickerResult? pickedFile = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx', 'xls']);
      if (pickedFile == null) {
        SnackBarService.instance.buildContext = context;
        SnackBarService.instance
            .showsSnackBarError(text: "failed to load file");
        return;
      }
      File finalFile = File(pickedFile.files.single.path!);
      //   var bytes = finalFile.readAsBytesSync();
      //  var sheet = Excel.decodeBytes(bytes);
      //add it to DB
      var result = await CloudStorageService.instance
          .uploadCourseSpreadsheet(chatID: chatID, fileData: finalFile);
      var fileUrl = await result!.ref.getDownloadURL();
      DBService.instance.addSpreadsheetToChat(chatID, fileUrl);
      SnackBarService.instance.buildContext = context;
      SnackBarService.instance
          .showsSnackBarSucces(text: "spreadSheet uploaded");
    } on Exception catch (e) {
      print(e);
      SnackBarService.instance.buildContext = context;
      SnackBarService.instance.showsSnackBarError(text: "failed to load file");
    }
  }
}
