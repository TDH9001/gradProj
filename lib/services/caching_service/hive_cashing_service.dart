import 'package:grad_proj/models/contact.dart';
import 'package:grad_proj/services/caching_service/cashing_service_hive_keys.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

abstract class HiveCashingService {
  static late Box _userContactData;

  static Future<void> initHive() async {
    await Hive.initFlutter();
    _userContactData =
        await Hive.openBox(CashingServiceHiveKeys.userContactData);
  }

  static Future<void> resetUserContactData() async {
    await _userContactData.delete('userData');
  }

  static Future<void> updateUserContactData(Map<String, dynamic> data) async {
    await _userContactData.put(CashingServiceHiveKeys.userContactData, data);
  }

  static Future<Contact> getUserContactData() async {
    var data = _userContactData.get(CashingServiceHiveKeys.userContactData);
    if (data.isNotEmpty && data != null) {
      return Contact.fromJson(id: '', snap: data);
    } else {
      return Contact(
          id: "",
          seatNumber: "0",
          firstName: "",
          lastName: "",
          classes: [],
          year: 0,
          isComplete: false,
          phoneNumber: "");
    }
    //the ID should always be provided by the AuthProvider > if the user is signed in
  }

  //TODO: add (updateUserdata) to the (getUserContactDAta) function in DBservice
}
