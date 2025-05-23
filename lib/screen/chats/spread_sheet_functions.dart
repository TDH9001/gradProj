import 'dart:developer' as dev;
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:excel/excel.dart';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:grad_proj/models/contact.dart';
import 'package:grad_proj/screen/chats/chat_data_result_page/spreadsheet_result_page.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/Network_checker_service.dart';
import 'package:grad_proj/services/cloud_Storage_Service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:path/path.dart';

class SpreadSheetFunctions {
  void pickSpreadSheet(BuildContext context, String chatID) async {
    try {
      FilePickerResult? pickedFile = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx', 'xls']);
      if (pickedFile == null) {
        SnackBarService.instance.buildContext = context;
        SnackBarService.instance
            .showsSnackBarError(text: 'SpreadSheetFunctions.error'.tr());
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
      SnackBarService.instance.showsSnackBarSucces(
          text: 'SpreadSheetFunctions.spreadSheet_uploaded'.tr());
    } on Exception catch (e) {
      print(e);
      SnackBarService.instance.buildContext = context;
      SnackBarService.instance
          .showsSnackBarError(text: 'SpreadSheetFunctions.error'.tr());
    }
  }

  Future<void> downloadBaseSheet(BuildContext context, String chatId) async {
    List<Contact> userList =
        await DBService.instance.getChatMembersData(chatId).first;
    var excel = Excel.createExcel();
    var table = excel.sheets;
    for (var sheet in table.values) {
      sheet.appendRow([
        TextCellValue('SpreadSheetFunctions.email'.tr()),
        TextCellValue('SpreadSheetFunctions.seatNumber'.tr()),
        TextCellValue('SpreadSheetFunctions.first_name'.tr()),
        TextCellValue('SpreadSheetFunctions.last_name'.tr()),
        TextCellValue('SpreadSheetFunctions.phone_number'.tr()),
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
      String filePath = "$targetDir/base_spread_sheet.xlsx";
      File(join(filePath)).createSync(recursive: true);
      File(filePath).writeAsBytesSync(fileArray!);

      // var bytes = excel.encode()!;
      // var file = File("${chatId}_spreadSheet.xlsx");
      // await file.writeAsBytes(bytes, flush: true);
      SnackBarService.instance.buildContext = context;
      SnackBarService.instance.showsSnackBarSucces(
          text: 'SpreadSheetFunctions.spreadSheet_downloaded'.tr());
    }
  }

  Future<void> getUserFromSpreadSheet(
      BuildContext context, String chatId) async {
    try {
      String link = await DBService.instance.getSpreadSheetLink(chatId);
      if (link == "") {
        SnackBarService.instance.buildContext = context;
        SnackBarService.instance.showsSnackBarError(
            text: 'SpreadSheetFunctions.spreadSheet_not_yet_uploaded'.tr());
        return;
      }

      var connectResult = await Connectivity().checkConnectivity();

      var fileInfo = await DefaultCacheManager().getFileFromCache(link);
      File? possibleFile = null;

      if (connectResult.contains(ConnectivityResult.none) && fileInfo == null) {
        SnackBarService.instance.buildContext = context;
        SnackBarService.instance.showsSnackBarError(
            text: 'SpreadSheetFunctions.cold_not_connect'.tr());
        return;
      } else if (!await NetworkCheckerService.urlExists(link) &&
          fileInfo == null) {
        SnackBarService.instance.buildContext = context;
        SnackBarService.instance.showsSnackBarError(
            text: 'SpreadSheetFunctions.spreadSheet_not_found'.tr());
        return;
      } else {
        //is not loaded and is connected to int
        possibleFile = await DefaultCacheManager().getSingleFile(link);
        dev.log("file downloaded");
      }

      if (fileInfo != null && await fileInfo.file.exists()) {
        possibleFile = fileInfo.file;
        var bytes = possibleFile.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);
        List<Data?> firstRow =
            []; //excel.tables[0]!.rows[0].asMap().values.toList();
        List<Data?>? targetRow = null;
        for (var table in excel.tables.keys) {
          firstRow = excel.tables[table]!.rows[0].asMap().values.toList();
          for (var row in excel.tables[table]!.rows) {
            dev.log("entered the loop");
            for (var cell in row) {
              if (cell!.value.toString() ==
                  HiveUserContactCashingService.getUserContactData().email) {
                targetRow = row.asMap().values.toList();
              }
            }
          }
          if (targetRow == null) {
            SnackBarService.instance.buildContext = context;
            SnackBarService.instance.showsSnackBarError(
                text:
                    'SpreadSheetFunctions.user_not_found_in_spreadsheet'.tr());
            return;
          }
        }
        dev.log(firstRow.toString());
        dev.log(targetRow.toString());
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return SpreadSheetResult(
            base: firstRow,
            result: targetRow!,
          );
        }));
      }
    } on Exception catch (e) {
      SnackBarService.instance.buildContext = context;
      SnackBarService.instance
          .showsSnackBarError(text: 'SpreadSheetFunctions.error2'.tr());
      print(e);
    }
  }

  Future<void> downloadCurrentSpreadSheet(
      BuildContext context, String chatId) async {
    // try {
    String link = await DBService.instance.getSpreadSheetLink(chatId);
    if (link == "") {
      SnackBarService.instance.buildContext = context;
      SnackBarService.instance.showsSnackBarError(
          text: 'SpreadSheetFunctions.spreadSheet_not_yet_uploaded'.tr());
      return;
    }

    var connectResult = await Connectivity().checkConnectivity();

    var fileInfo = await DefaultCacheManager().getFileFromCache(link);
    File? possibleFile = null;

    if (connectResult.contains(ConnectivityResult.none) && fileInfo == null) {
      SnackBarService.instance.buildContext = context;
      SnackBarService.instance.showsSnackBarError(
          text: 'SpreadSheetFunctions.cold_not_connect'.tr());
      return;
    } else if (!await NetworkCheckerService.urlExists(link) &&
        fileInfo == null) {
      SnackBarService.instance.buildContext = context;
      SnackBarService.instance.showsSnackBarError(
          text: 'SpreadSheetFunctions.spreadSheet_not_found_in_server'.tr());
      return;
    } else {
      //is not loaded and is connected to int
      possibleFile = await DefaultCacheManager().getSingleFile(link);
      dev.log("file downloaded");
    }
    if (fileInfo != null && await fileInfo.file.exists()) {
      possibleFile = fileInfo.file;

      String downloadsPath =
          await ExternalPath.getExternalStoragePublicDirectory(
              ExternalPath.DIRECTORY_DOWNLOAD);

      String targetDir = "$downloadsPath/Sci-Connecet/course-sheets/$chatId";

      await Directory(targetDir).create(recursive: true);

      String filePath = "$targetDir/current_sheet.xlsx";
      File newFile = await possibleFile.copy(filePath);
      SnackBarService.instance.buildContext = context;
      SnackBarService.instance.showsSnackBarSucces(
          text: 'SpreadSheetFunctions.current_spreadSheet_downloaded'.tr());
      return;
      //   }
      // } on Exception catch (e) {
      //   SnackBarService.instance.buildContext = context;
      //   SnackBarService.instance.showsSnackBarError(text: "an error occured");
      //   print(e);
    }
  }
}
