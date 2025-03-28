//will allowus to get files from device library
import 'dart:io';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

// import '../services/media_service.dart';
// import 'dart:io';

class MediaService {
  double getWidth() {
    return PlatformDispatcher.instance.views.first.physicalSize.width /
        PlatformDispatcher.instance.views.first.devicePixelRatio;
  }

  double getHeight() {
    return PlatformDispatcher.instance.views.first.physicalSize.height /
        PlatformDispatcher.instance.views.first.devicePixelRatio;
  }

  static MediaService instance = MediaService();

  Future<File?> getImageFromLibrary() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  void playAudio(AudioPlayer play, String url) async {
    await play.play(UrlSource(url));
    print("playing");
  }

  void pauseAudio(AudioPlayer play) async {
    await play.pause();
    print("Paused");
  }

  void resumeAudio(AudioPlayer play) async {
    await play.resume();
    print("resuming");
  }

  Future<Map<String, dynamic>> pickAndReadExcelFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        final String fileName = result.files.single.name;
        final file = File(result.files.single.path!);
        return await parseExcelFile(file, fileName);
      } else {
        return {
          'success': false,
          'message': 'No file selected',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error reading Excel file: ${e.toString()}',
      };
    }
  }
  
  Future<Map<String, dynamic>> parseExcelFile(File file, String fileName) async {
    try {
      final bytes = await file.readAsBytes();
      final excel = Excel.decodeBytes(bytes);

      final sheet = excel.tables.keys.first;
      final rows = excel.tables[sheet]!.rows;

      final List<Map<String, String>> data = [];
      
      if (rows.isEmpty) {
        return {
          'success': true,
          'fileName': fileName,
          'data': data,
          'columnCount': 0,
        };
      }

      final headerRow = rows[0];
      final headers = <String>[];
      
      for (int i = 0; i < headerRow.length; i++) {
        final cell = headerRow[i];
        headers.add((cell?.value?.toString() ?? '') != '' 
            ? cell!.value.toString() 
            : i.toString());
      }

      for (int rowIndex = 1; rowIndex < rows.length; rowIndex++) {
        final row = rows[rowIndex];
        
  
        if (row.every((cell) => cell == null || cell.value == null || cell.value.toString().trim() == '')) {
          continue;
        }
        
        final Map<String, String> rowData = {};
        
        for (int colIndex = 0; colIndex < headers.length; colIndex++) {
          final String columnKey = colIndex.toString();
          final String value = colIndex < row.length && row[colIndex] != null 
              ? row[colIndex]!.value.toString() 
              : '';
          rowData[columnKey] = value;
        }
        
        data.add(rowData);
      }

      return {
        'success': true,
        'fileName': fileName,
        'data': data,
        'columnCount': headers.length,
        'headers': headers,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error parsing Excel file: ${e.toString()}',
      };
    }
  }
}