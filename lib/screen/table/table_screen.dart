import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/screen/chats/chat_data_screen.dart';
import 'package:grad_proj/screen/table/tableform_screen.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/widgets/customTextField.dart';
import 'package:grad_proj/widgets/dropdown_select_widget.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:grad_proj/widgets/updated_scedule_item.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';

import '../../UI/colors.dart';

class TableScreen extends StatefulWidget {
  TableScreen({super.key});
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
  final GlobalKey<FormState> validateSceduleItemForPersonalUse =
      GlobalKey<FormState>();

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  Future<ScheduleItemClass?> createSceduleItem(int itemType) => showDialog<
          ScheduleItemClass?>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
                "add a ${itemType == 1 ? "permanat" : itemType == 2 ? "temporary" : "personal"} scedule"),
            content: Form(
              key: widget.validateSceduleItemForPersonalUse,
              child: Column(
                children: [
                  DropdownSelect(
                    data: widget.daysList,
                    cont: widget.dayController,
                    maxSelections: 1,
                    isSearchable: false,
                  ),
                  CustomTextField(
                      hintText: "location",
                      controller: widget.locationController),
                  CustomTextField(
                      hintText: "scedule Name", controller: widget.sceduleName),
                  CustomTextField(
                      hintText: "Start time", controller: widget.startTime),
                  CustomTextField(
                      hintText: "end time", controller: widget.endTime),
                  PrimaryButton(
                      buttontext: "add the items",
                      func: () async {
                        if (widget
                            .validateSceduleItemForPersonalUse.currentState!
                            .validate()) {
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
                            DateTime? pickedDate = await showOmniDateTimePicker(
                                title: Text("Temporary scedule's end date"),
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
                                  .byName(widget
                                      .dayController.selectedItems[0].value
                                      .toString()
                                      .trim())
                                  .index,
                              location: widget.locationController.text.trim(),
                              name: widget.sceduleName.text.trim(),
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

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedCourse;
  DateTime? selectedDay;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  final List<Map<String, dynamic>> tableData = [];
  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDay) {
      setState(() {
        selectedDay = picked;
      });
    }
  }

  Future<void> pickStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != startTime) {
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> pickEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != endTime) {
      setState(() {
        endTime = picked;
      });
    }
  }

  void addCourse() {
    if (selectedCourse != null &&
        selectedDay != null &&
        startTime != null &&
        endTime != null) {
      setState(() {
        tableData.add({
          "course": selectedCourse!,
          "day": selectedDay!,
          "start_time": startTime!,
          "end_time": endTime!,
        });
        selectedCourse = null;
        selectedDay = null;
        startTime = null;
        endTime = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select all fields before adding a course."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF7F9FC),
        body: ChangeNotifierProvider.value(
            value: AuthProvider.instance,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Spacer(
                        flex: 1,
                      ),
                      Text(
                        "Add permanant scedule item ",
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(
                        flex: 3,
                      ),
                      IconButton(
                          onPressed: () async {
                            final ScheduleItemClass? data =
                                await createSceduleItem(3)!;
                            DBService.instance.addSceduleItem(
                                AuthProvider.instance.user!.uid,
                                "not relavant",
                                data!);
                          },
                          icon: Icon(
                            Icons.add_alert_sharp,
                          )),
                      Spacer(
                        flex: 2,
                      )
                    ],
                  ),
                ),
                StreamBuilder<List<ScheduleItemClass>>(
                    stream: DBService.instance
                        .getUserPersonalScedule("UyyMJiz3qnTfjus9dAoiNO7epKM2"),
                    builder: (context, _snapshot) {
                      if (_snapshot.connectionState ==
                              ConnectionState.waiting ||
                          _snapshot.connectionState == ConnectionState.none) {
                        return SliverToBoxAdapter(
                          child: Center(
                              child: Image(
                                  image:
                                      AssetImage('assets/images/splash.png'))),
                        );
                      }
                      if (_snapshot.hasError) {
                        return SliverToBoxAdapter(
                          child: Center(
                              child: Text(
                                  "Error: ${_snapshot.error} \n please update your data and the data field mising")),
                        );
                      }
                      return SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                        return updatedSceduleItem(_snapshot.data![index]);
                      }, childCount: _snapshot.data!.length));
                    }),
                StreamBuilder<List<ScheduleItemClass>>(
                    stream: DBService.instance.getUserPermanatScedules(
                        AuthProvider.instance.user!.uid),
                    builder: (context, _snapshot) {
                      if (_snapshot.connectionState ==
                              ConnectionState.waiting ||
                          _snapshot.connectionState == ConnectionState.none) {
                        return SliverToBoxAdapter(
                          child: Center(
                              child: Image(
                                  image:
                                      AssetImage('assets/images/splash.png'))),
                        );
                      }
                      if (_snapshot.hasError) {
                        return SliverToBoxAdapter(
                          child: Center(
                              child: Text(
                                  "Error: ${_snapshot.error} \n please update your data and the data field mising")),
                        );
                      }
                      return SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                        return updatedSceduleItem(_snapshot.data![index]);
                      }, childCount: _snapshot.data!.length));
                    }),
                StreamBuilder<List<ScheduleItemClass>>(
                    stream: DBService.instance.getUserTemporaryScedules(
                        AuthProvider.instance.user!.uid),
                    builder: (context, _snapshot) {
                      if (_snapshot.connectionState ==
                              ConnectionState.waiting ||
                          _snapshot.connectionState == ConnectionState.none) {
                        return SliverToBoxAdapter(
                          child: Center(
                              child: Image(
                                  image:
                                      AssetImage('assets/images/splash.png'))),
                        );
                      }
                      if (_snapshot.hasError) {
                        return Center(
                            child: Text(
                                "Error: ${_snapshot.error} \n please update your data and the data field mising"));
                      }
                      return SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                        return updatedSceduleItem(_snapshot.data![index]);
                      }, childCount: _snapshot.data!.length));
                    }),
              ],
            ))
        //  Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: SingleChildScrollView(
        //     child: Column(
        //       children: [
        //         const SizedBox(height: 15),
        //         const Text(
        //           "Fill in the details to create your schedule",
        //           style: TextStyle(fontSize: 16),
        //         ),
        //         const SizedBox(height: 30),
        //         TextField(
        //           onChanged: (value) {
        //             setState(() {
        //               selectedCourse = value;
        //             });
        //           },
        //           decoration: InputDecoration(
        //             labelText: "Enter Course Name",
        //             border: OutlineInputBorder(
        //               borderRadius: BorderRadius.circular(8),
        //             ),
        //           ),
        //         ),
        //         const SizedBox(height: 16),
        //         InkWell(
        //           onTap: pickDate,
        //           child: Container(
        //             padding:
        //                 const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        //             decoration: BoxDecoration(
        //               border: Border.all(color: Colors.grey),
        //               borderRadius: BorderRadius.circular(8),
        //             ),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 Text(
        //                   selectedDay == null
        //                       ? "Select Day"
        //                       : "${selectedDay!.day}/${selectedDay!.month}/${selectedDay!.year}",
        //                   style: const TextStyle(fontSize: 16),
        //                 ),
        //                 const Icon(Icons.calendar_today, color: Colors.grey),
        //               ],
        //             ),
        //           ),
        //         ),
        //         const SizedBox(height: 16),
        //         InkWell(
        //           onTap: pickStartTime,
        //           child: Container(
        //             padding:
        //                 const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        //             decoration: BoxDecoration(
        //               border: Border.all(color: Colors.grey),
        //               borderRadius: BorderRadius.circular(8),
        //             ),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 Text(
        //                   startTime == null
        //                       ? "Select Start Time"
        //                       : startTime!.format(context),
        //                   style: const TextStyle(fontSize: 16),
        //                 ),
        //                 const Icon(Icons.access_time, color: Colors.grey),
        //               ],
        //             ),
        //           ),
        //         ),
        //         const SizedBox(height: 16),
        //         InkWell(
        //           onTap: pickEndTime,
        //           child: Container(
        //             padding:
        //                 const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        //             decoration: BoxDecoration(
        //               border: Border.all(color: Colors.grey),
        //               borderRadius: BorderRadius.circular(8),
        //             ),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 Text(
        //                   endTime == null
        //                       ? "Select End Time"
        //                       : endTime!.format(context),
        //                   style: const TextStyle(fontSize: 16),
        //                 ),
        //                 const Icon(Icons.access_time, color: Colors.grey),
        //               ],
        //             ),
        //           ),
        //         ),
        //         const SizedBox(height: 24),
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             ElevatedButton(
        //               style: ElevatedButton.styleFrom(
        //                 backgroundColor: ColorsApp.primary,
        //               ),
        //               onPressed: () {
        //                 Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                     builder: (context) => TableformScreen(),
        //                   ),
        //                 );
        //               },
        //               child: const Text(
        //                 'Create Table',
        //                 style: TextStyle(
        //                   fontSize: 15,
        //                   fontWeight: FontWeight.bold,
        //                   color: Colors.white,
        //                 ),
        //               ),
        //             ),
        //             const SizedBox(width: 35),
        //             ElevatedButton(
        //               style: ElevatedButton.styleFrom(
        //                 backgroundColor: ColorsApp.primary,
        //               ),
        //               onPressed: addCourse,
        //               child: const Text(
        //                 'Add Course',
        //                 style: TextStyle(
        //                   fontSize: 15,
        //                   fontWeight: FontWeight.bold,
        //                   color: Colors.white,
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //         showSceduleData(),
        //         const SizedBox(height: 40),
        //         SizedBox(
        //           height: MediaQuery.of(context).size.height * 0.4,
        //           child: ListView.builder(
        //             itemCount: tableData.length,
        //             itemBuilder: (context, index) {
        //               final course = tableData[index];
        //               return Card(
        //                 margin: const EdgeInsets.symmetric(vertical: 8),
        //                 child: ListTile(
        //                   leading: CircleAvatar(
        //                     backgroundColor: ColorsApp.primary,
        //                     child: Text(
        //                       course['course']![0],
        //                       style: const TextStyle(color: Colors.white),
        //                     ),
        //                   ),
        //                   title: Text("${course['course']}"),
        //                   subtitle: Text(
        //                       "Day: ${course['day']!.day}/${course['day']!.month}/${course['day']!.year}\nTime: ${course['start_time']!.format(context)} - ${course['end_time']!.format(context)}"),
        //                 ),
        //               );
        //             },
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}

// Widget showSceduleData() {
//   return ChangeNotifierProvider.value(
//       value: AuthProvider.instance,
//       child: Column(
//         children: [
//           StreamBuilder<List<ScheduleItemClass>>(
//               stream: DBService.instance
//                   .getUserPermanatScedules(AuthProvider.instance.user!.uid),
//               builder: (context, _snapshot) {
//                 if (_snapshot.connectionState == ConnectionState.waiting ||
//                     _snapshot.connectionState == ConnectionState.none) {
//                   return Center(
//                       child:
//                           Image(image: AssetImage('assets/images/splash.png')));
//                 }
//                 if (_snapshot.hasError) {
//                   return Center(
//                       child: Text(
//                           "Error: ${_snapshot.error} \n please update your data and the data field mising"));
//                 }
//                 return SizedBox(
//                   height: 150,
//                   child: ListView.builder(
//                       itemCount: _snapshot.data!.length,
//                       itemBuilder: (Context, index) {
//                         print(_snapshot.data!.length);
//                         return updatedSceduleItem(_snapshot.data![index]);
//                       }),
//                 );
//               }),
//           StreamBuilder<List<ScheduleItemClass>>(
//               stream: DBService.instance
//                   .getUserTemporaryScedules(AuthProvider.instance.user!.uid),
//               builder: (context, _snapshot) {
//                 if (_snapshot.connectionState == ConnectionState.waiting ||
//                     _snapshot.connectionState == ConnectionState.none) {
//                   return Center(
//                       child:
//                           Image(image: AssetImage('assets/images/splash.png')));
//                 }
//                 if (_snapshot.hasError) {
//                   return Center(
//                       child: Text(
//                           "Error: ${_snapshot.error} \n please update your data and the data field mising"));
//                 }
//                 return SizedBox(
//                   height: 150,
//                   child: ListView.builder(
//                       itemCount: _snapshot.data!.length,
//                       itemBuilder: (Context, index) {
//                         return updatedSceduleItem(_snapshot.data![index]);
//                       }),
//                 );
//               }),
//           StreamBuilder<List<ScheduleItemClass>>(
//               stream: DBService.instance
//                   .getUserPersonalScedule("UyyMJiz3qnTfjus9dAoiNO7epKM2"),
//               builder: (context, _snapshot) {
//                 if (_snapshot.connectionState == ConnectionState.waiting ||
//                     _snapshot.connectionState == ConnectionState.none) {
//                   return Center(
//                       child:
//                           Image(image: AssetImage('assets/images/splash.png')));
//                 }
//                 if (_snapshot.hasError) {
//                   return Center(
//                       child: Text(
//                           "Error: ${_snapshot.error} \n please update your data and the data field mising"));
//                 }
//                 return SizedBox(
//                   height: 150,
//                   child: ListView.builder(
//                       itemCount: _snapshot.data!.length,
//                       itemBuilder: (Context, index) {
//                         Row(
//                           children: [
//                             Spacer(
//                               flex: 1,
//                             ),
//                             Text(
//                               "Add permanant scedule item ",
//                               style: TextStyle(fontSize: 20),
//                             ),
//                             Spacer(
//                               flex: 3,
//                             ),
//                             IconButton(
//                                 onPressed: () async {
//                                   final ScheduleItemClass? data =
//                                       await createSceduleItem(2)!;
//                                   DBService.instance.addSceduleItem(
//                                       AuthProvider.instance.user!.uid,
//                                       "not relavant",
//                                       data!);
//                                 },
//                                 icon: Icon(
//                                   Icons.add_alert_sharp,
//                                 )),
//                             Spacer(
//                               flex: 2,
//                             )
//                           ],
//                         );
//                         print(_snapshot.data!.length);
//                         return updatedSceduleItem(_snapshot.data![index]);
//                       }),
//                 );
//               })
//         ],
//       ));
// }
