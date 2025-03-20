import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/widgets/customTextField.dart';
import 'package:grad_proj/widgets/dropdown_select_widget.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class SceduleCreationService {
  static SceduleCreationService instance = SceduleCreationService();
  final GlobalKey<FormState> validateSceduleItem = GlobalKey();
  final MultiSelectController<String> dayController =
      MultiSelectController<String>();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController sceduleName = TextEditingController();
  final TextEditingController startTime = TextEditingController();
  final TextEditingController endTime = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  final List<DropdownItem<String>> daysList = [
    DropdownItem(label: "saturday", value: "saturday"),
    DropdownItem(label: "sunday", value: "sunday"),
    DropdownItem(label: "monday", value: "monday"),
    DropdownItem(label: "tuesday", value: "tuesday"),
    DropdownItem(label: "wednesday", value: "wednesday"),
    DropdownItem(label: "thursday", value: "thursday"),
    DropdownItem(label: "friday", value: "friday"),
  ];

  Future<ScheduleItemClass?> createSceduleItem(
          {required int itemType, required BuildContext cont}) =>
      showDialog<ScheduleItemClass?>(
          context: cont,
          builder: (context) => AlertDialog(
                title: Text(
                    "add a ${itemType == 1 ? "permanat" : itemType == 2 ? "temporary" : "personal"} scedule"),
                content: Form(
                  key: validateSceduleItem,
                  child: Column(
                    children: [
                      DropdownSelect(
                        data: daysList,
                        cont: dayController,
                        maxSelections: 1,
                        isSearchable: false,
                      ),
                      CustomTextField(
                          hintText: "location", controller: locationController),
                      CustomTextField(
                          hintText: "scedule Name", controller: sceduleName),
                      CustomTextField(
                          hintText: "Start time", controller: startTime),
                      CustomTextField(
                          hintText: "end time", controller: endTime),
                      PrimaryButton(
                          buttontext: "add the items",
                          func: () async {
                            if (validateSceduleItem.currentState!.validate()) {
                              //need to validate the fields and the timeStuf
                              TimeOfDay? startTime = await showTimePicker(
                                helpText: "start time",
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              TimeOfDay? EndTime = await showTimePicker(
                                helpText: "start time",
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              DateTime? endDate;
                              if (itemType == 2) {
                                DateTime? pickedDate =
                                    await showOmniDateTimePicker(
                                        title: Text(
                                            "Temporary scedule's end date"),
                                        context: context);

                                if (pickedDate != null) {
                                  endDate =
                                      pickedDate; // Only assign if user selects a date
                                }
                              }
                              Timestamp? endDateTimestamp = endDate != null
                                  ? Timestamp.fromDate(endDate)
                                  : null;
                              Navigator.of(context).pop(ScheduleItemClass(
                                  creatorId: AuthProvider.instance.user!.uid,
                                  creatorName: "User name ",
                                  day: days.values
                                      .byName(dayController
                                          .selectedItems[0].value
                                          .toString()
                                          .trim())
                                      .index,
                                  location: locationController.text.trim(),
                                  name: sceduleName.text.trim(),
                                  startTime: int.parse(
                                      // ${startTime!.hour > 12 ? "pm" : "am"}
                                      "${startTime!.hour % 12}${startTime!.minute}"),
                                  type: itemType,
                                  endTime: int.parse(
                                      //${EndTime!.hour > 12 ? "pm" : "am"}
                                      "${EndTime!.hour % 12}${EndTime!.minute} "),
                                  endDate: endDateTimestamp
                                  // Timestamp.fromDate(
                                  //     endDate ?? DateTime.now()
                                  ));
                            }
                          })
                    ],
                  ),
                ),
              ));
}
