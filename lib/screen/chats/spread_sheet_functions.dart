import 'dart:ffi';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:grad_proj/models/contact.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/cloud_Storage_Service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<void> downloadBaseSheet(BuildContext context, String chatId) async {
    List<Contact> userList =
        await DBService.instance.getChatMembersData(chatId).first;
    var excel = Excel.createExcel();
    var table = excel.sheets;
    for (var sheet in table.values) {
      sheet.appendRow([
        TextCellValue("Email"),
        TextCellValue("seatNumber"),
        TextCellValue("firstName"),
        TextCellValue("lastName"),
        TextCellValue("phoneNumber")
      ]);
      for (var user in userList) {
        sheet.appendRow([
          TextCellValue(user.email),
          TextCellValue(user.seatNumber.toString()),
          TextCellValue(user.firstName),
          TextCellValue(user.lastName),
          TextCellValue(user.phoneNumber)
        ]);
      }
      var fileArray = excel.save();
      String downloadsPath =
          await ExternalPath.getExternalStoragePublicDirectory(
              ExternalPath.DIRECTORY_DOWNLOAD);
      String targetDir = "$downloadsPath/Sci-Connecet/course-sheets/$chatId";
      await Directory(targetDir).create(recursive: true);
      String filePath = "$targetDir/spreadSheet.xlsx";
      File(join(filePath)).createSync(recursive: true);
      File(filePath).writeAsBytesSync(fileArray!);

      // var bytes = excel.encode()!;
      // var file = File("${chatId}_spreadSheet.xlsx");
      // await file.writeAsBytes(bytes, flush: true);
      SnackBarService.instance.buildContext = context;
      SnackBarService.instance
          .showsSnackBarSucces(text: "spreadSheet downloaded");
    }
  }
}
