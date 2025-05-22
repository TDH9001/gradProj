import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:grad_proj/widgets/customTextField.dart';
import 'package:grad_proj/widgets/dropdown_select_widget.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class SceduleCreationService {
  static SceduleCreationService instance = SceduleCreationService();
  final GlobalKey<FormState> validatescheduleItem = GlobalKey();
  final MultiSelectController<String> dayController =
      MultiSelectController<String>();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController sceduleName = TextEditingController();
  final TextEditingController startTime = TextEditingController();
  final TextEditingController endTime = TextEditingController();
  final TextEditingController endDate = TextEditingController();
 final  List<DropdownItem<String>> daysList = [
    DropdownItem(label: 'ScheduleCreationService.saturday'.tr(), value: "saturday"),
    DropdownItem(label: 'ScheduleCreationService.sunday'.tr(), value: "sunday"),
    DropdownItem(label: 'ScheduleCreationService.monday'.tr(), value: "monday"),
    DropdownItem(label: 'ScheduleCreationService.tuesday'.tr(), value: "tuesday"),
    DropdownItem(label: 'ScheduleCreationService.wednesday'.tr(), value: "wednesday"),
    DropdownItem(label: 'ScheduleCreationService.thursday'.tr(), value: "thursday"),
    DropdownItem(label: 'ScheduleCreationService.friday'.tr(), value: "friday"),
  ];

  void ClearFields() {
    daysList.clear();
    locationController.clear();
    sceduleName.clear();
    startTime.clear();
    endTime.clear();
    endDate.clear();
  }

  Future<ScheduleItemClass?> createSceduleItem(
          {required int itemType,
          required BuildContext cont,
          required String chatID}) =>
      showDialog<ScheduleItemClass?>(
          context: cont,
          builder: (context) => SingleChildScrollView(
                child: AlertDialog(
                  title: Text(
                    //  "Add a ${itemType == 1 ? "permanent" : itemType == 2 ? "temporary" : "personal"} schedule",style: TextStyle(fontSize: 16),),

                    'ScheduleCreationService.add_schedule'.tr(
                      namedArgs: {
                        "type": 'ScheduleCreationService.${itemType == 1 ? "permanent" : itemType == 2 ? "temporary" : "personal"}'.tr()
                      },
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                  content: Form(
                    key: validatescheduleItem,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownSelect(
                          data: daysList,
                          cont: dayController,
                          maxSelections: 1,
                          isSearchable: false,
                        ),
                        SizedBox(height: 15,),
                        CustomTextField(
                            hintText: 'ScheduleCreationService.schedule_name'.tr(),controller: sceduleName),
                        SizedBox(height: 15,),
                        CustomTextField(
                            hintText:'ScheduleCreationService.location'.tr(),
                            controller: locationController),
                        SizedBox(height: 15,),
                        CustomTextField(
                            hintText: 'ScheduleCreationService.start_time'.tr(), controller: startTime),
                        SizedBox(height: 15,),
                        CustomTextField(
                          hintText: 'ScheduleCreationService.end_time'.tr(),
                          controller: endTime,
                          startTimeController: startTime,
                        ),
                        itemType == 2
                            ? CustomTextField(
                                hintText: 'ScheduleCreationService.end_date'.tr(), controller: endDate)
                            : SizedBox(
                                height: 15,
                              ),
                        PrimaryButton(
                            buttontext: 'ScheduleCreationService.add_the_items_button'.tr(),
                            func: () async {
                              if (validatescheduleItem.currentState!
                                  .validate()) {
                                DateTime endDateData = DateTime.now();
                                List<String> startTimeList =
                                    startTime.text.split(" ");
                                String startTimeFinished =
                                    startTimeList[0].replaceAll(':', "");
                                int startTimeInt = int.parse(startTimeFinished);
                                if (startTimeList[1].contains("PM")) {
                                  startTimeInt += 1200;
                                }
                                print(startTimeList);
                                print(startTimeInt);

                                List<String> endTimeList =
                                    endTime.text.split(" ");
                                String endTimeFinished =
                                    endTimeList[0].replaceAll(':', "");
                                int endTimeInt = int.parse(endTimeFinished);
                                if (endTimeList[1].contains("PM")) {
                                  endTimeInt += 1200;
                                }
                                print(endTimeList);
                                print(endTimeInt);
                                if (itemType == 2) {
                                  endDateData =
                                      DateTime.parse(endDate.text.trim());
                                  //print(DateTime.parse(endDate.text.trim()));
                                }

                                Navigator.of(cont).pop(ScheduleItemClass(
                                    creatorId: AuthProvider.instance.user!.uid,
                                    creatorName:
                                        "${HiveUserContactCashingService.getUserContactData().firstName} ${HiveUserContactCashingService.getUserContactData().lastName}",
                                    day: days.values
                                        .byName(dayController
                                            .selectedItems[0].value
                                            .toString()
                                            .trim())
                                        .index,
                                    location: locationController.text.trim(),
                                    name: "$chatID: ${sceduleName.text.trim()}",
                                    startTime: startTimeInt,
                                    type: itemType,
                                    endTime: endTimeInt,
                                    endDate: itemType == 2
                                        ? Timestamp.fromDate(endDateData)
                                        : null));
                                SnackBarService.instance.buildContext = cont;
                                SnackBarService.instance.showsSnackBarSucces(
                                    text:'ScheduleCreationService.successfully'.tr());
                                ClearFields();
                              }
                            })
                      ],
                    ),
                  ),
                ),
              ));
}
