import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:grad_proj/models/Semester_logs_models/academic_career.dart';
import 'package:grad_proj/models/Semester_logs_models/semester_model.dart';
import 'package:grad_proj/models/Semester_logs_models/course_model.dart';
import 'package:grad_proj/utils/grade_utils.dart';

class PdfParsingService {
  Future<File?> pickPdfFile() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pickedFile != null && pickedFile.files.single.path != null) {
      return File(pickedFile.files.single.path!);
    }
    return null;
  }

  Future<String?> extractTextFromFile(File pdfFile) async {
    try {
      List<int> fileBytes = await pdfFile.readAsBytes();
      PdfDocument document = PdfDocument(inputBytes: fileBytes);
      String text = PdfTextExtractor(document).extractText();
      document.dispose();
      return text;
    } catch (e) {
      print("Error extracting text from PDF: $e");
      return null;
    }
  }

  Future<AcademicCareer?> parseTextToAcademicCareer(String pdfText) async {
    print("--- Extracted PDF Text (Raw) ---");
    print(pdfText);
    print("--- End of Raw PDF Text ---");
    
    String seatNumber = "PDF_SeatNo_Placeholder";
    List<SemesterModel> semesters = [];
    RegExp seatNumberRegExp = RegExp(r"رقم الجلوس:\s*(\d+)");
    Match? seatNumberMatch = seatNumberRegExp.firstMatch(pdfText);
    if (seatNumberMatch != null && seatNumberMatch.groupCount >= 1) {
      seatNumber = seatNumberMatch.group(1)!;
      print("Found Seat Number: $seatNumber");
    } else {
      print("Seat Number not found in PDF.");
    }

    return null;
  }
}