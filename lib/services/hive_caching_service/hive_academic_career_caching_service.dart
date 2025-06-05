import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:grad_proj/models/Semester_logs_models/academic_career.dart';
import 'cashing_service_hive_keys.dart';

class HiveAcademicCareerCachingService {
  static late Box _academicCareerBox;

  static Future<void> initHive() async {
     await Hive.initFlutter(); 

    _academicCareerBox = await Hive.openBox(CashingServiceHiveKeys.academicCareerData);
  }

  static Future<void> saveAcademicCareer(AcademicCareer career) async {
    final key = CashingServiceHiveKeys.academicCareerData; 
    await _academicCareerBox.put(key, career.toJson());
  }

  static AcademicCareer? getAcademicCareer() {
    final key = CashingServiceHiveKeys.academicCareerData; 
    final data = _academicCareerBox.get(key);
    if (data != null && data is Map) {
      try {
        return AcademicCareer.fromJson(Map<String, dynamic>.from(data));
      } catch (e) {
        print("Error deserializing AcademicCareer from Hive: $e");
        return null;
      }
    }
    return null;
  }

  static Future<void> deleteAcademicCareer() async {
    final key = CashingServiceHiveKeys.academicCareerData;
  }

}