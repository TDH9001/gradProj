// import 'package:file_picker/file_picker.dart';
// import 'package:syncfusion_flutter_xlsio/xlsio.dart';

// class ExcelService {
//   static Future<List<Map<String, dynamic>>> readExcel() async {
//     final FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['xlsx', 'xls'],
//     );

//     if (result == null) return [];

//     try {
//       final PlatformFile file = result.files.first;
//       final List<int> bytes = file.bytes!;

//       // CORRECTED: Initialize workbook directly from bytes
//       final Workbook workbook = Workbook.fromBytes(bytes);

//       if (workbook.worksheets.count == 0) {
//         workbook.dispose();
//         return [];
//       }

//       final Worksheet sheet = workbook.worksheets[0];
//       List<Map<String, dynamic>> data = [];

//       final int lastRow = sheet.getLastRow();
//       final int lastCol = sheet.getLastColumn();

//       for (int row = 2; row <= lastRow; row++) {
//         Map<String, dynamic> entry = {};
//         for (int col = 1; col <= lastCol; col++) {
//           final String header = sheet.getRangeByIndex(1, col).text ?? 'Column$col';
//           final dynamic value = sheet.getRangeByIndex(row, col).value;
//           entry[header] = value;
//         }
//         data.add(entry);
//       }

//       workbook.dispose();
//       return data;
//     } catch (e) {
//       print("Excel read error: $e");
//       return [];
//     }
//   }
// }