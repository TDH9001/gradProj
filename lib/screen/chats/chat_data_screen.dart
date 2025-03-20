import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/UI/colors.dart';
import 'package:grad_proj/constants.dart';
import 'package:grad_proj/models/contact.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/Scedule_creation_service.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:grad_proj/widgets/UniversalTextFormField.dart';
import 'package:grad_proj/widgets/category_card.dart';
import 'package:grad_proj/widgets/customTextField.dart';
import 'package:grad_proj/widgets/custom_card.dart';
import 'package:grad_proj/widgets/custom_dropdown.dart';
import 'package:grad_proj/widgets/dropdown_select_widget.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:grad_proj/widgets/updated_scedule_item.dart';
import 'package:grad_proj/widgets/sceduleitem.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';

class ChatDataScreen extends StatefulWidget {
  ChatDataScreen({super.key, required this.cahtId, required this.adminList});
  static String id = "ChatDataScreen";
  final String cahtId;
  final List<String> adminList;
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

  @override
  State<ChatDataScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ChatDataScreen> {
  ScheduleItemClass scll = ScheduleItemClass(
      creatorId: "123",
      creatorName: "tester",
      day: 1,
      location: "nowhere",
      name: "test of type1",
      startTime: 1,
      type: 1,
      endTime: 1,
      endDate: Timestamp.now()
      //  endDate: Timestamp.now()
      );

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.sizeOf(context).height;
    double deviceWidth = MediaQuery.sizeOf(context).width;
    SnackBarService.instance.buildContext = context;

    var _auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: ColorsApp.primary,
            //expandedHeight: 120.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Center(child: Text(widget.cahtId, style: TextStyles.text)),
            ),
          ),
          StreamBuilder<List<contact>>(
              stream: DBService.instance.getChatMembersData(widget.cahtId),
              builder: (context, _snapshot) {
                if (_snapshot.connectionState == ConnectionState.waiting ||
                    _snapshot.connectionState == ConnectionState.none) {
                  return SliverToBoxAdapter(
                      child: Center(
                    child: Image(image: AssetImage('assets/images/splash.png')),
                  ));
                }
                if (_snapshot.hasError) {
                  return SliverToBoxAdapter(
                      child: Center(
                    child: Text(
                        "Error: ${_snapshot.error} \n please update your data and the data field mising"),
                  ));
                }
                return SliverToBoxAdapter(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade50, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        leading:
                            const Icon(Icons.book, color: Color(0xff769BC6)),
                        // elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: Row(
                          children: [
                            Text(
                              "Course members",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        children: [
                          SizedBox(
                            height: deviceHeight / 2,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: _snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Column(
                                    children: [
                                      Text(_snapshot.data![index].FirstName),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
          StreamBuilder<List<ScheduleItemClass>>(
              stream:
                  DBService.instance.getPermanantSceduleItems(widget.cahtId),
              builder: (context, _snapshot) {
                if (_snapshot.connectionState == ConnectionState.waiting ||
                    _snapshot.connectionState == ConnectionState.none) {
                  return SliverToBoxAdapter(
                      child: Center(
                    child: Image(image: AssetImage('assets/images/splash.png')),
                  ));
                }
                if (_snapshot.hasError) {
                  return SliverToBoxAdapter(
                      child: Center(
                    child: Text(
                        "Error: ${_snapshot.error} \n please update your data and the data field mising"),
                  ));
                }
                return SliverToBoxAdapter(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade50, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        leading: Icon(Icons.book, color: Color(0xff769BC6)),
                        // elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: Text(
                          "Permanat scedule items",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue.shade50, Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          Row(
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
                                        await SceduleCreationService.instance
                                            .createSceduleItem(
                                                cont: context, itemType: 1);
                                    DBService.instance.addSceduleItem(
                                        AuthProvider.instance.user!.uid,
                                        widget.cahtId,
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
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child:
                                    updatedSceduleItem(_snapshot.data![index]),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
          StreamBuilder<List<ScheduleItemClass>>(
              stream:
                  DBService.instance.getTemporarySceduleItems(widget.cahtId),
              builder: (context, _snapshot) {
                if (_snapshot.connectionState == ConnectionState.waiting ||
                    _snapshot.connectionState == ConnectionState.none) {
                  return SliverToBoxAdapter(
                      child: Center(
                    child: Image(image: AssetImage('assets/images/splash.png')),
                  ));
                }
                if (_snapshot.hasError) {
                  return SliverToBoxAdapter(
                      child: Center(
                    child: Text(
                        "Error: ${_snapshot.error} \n please update your data and the data field mising"),
                  ));
                }
                // var data = _snapshot.data;
                return SliverToBoxAdapter(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade50, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        leading:
                            const Icon(Icons.book, color: Color(0xff769BC6)),
                        // elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: const Text(
                          "Temporary scedule items",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        children: [
                          Row(
                            children: [
                              Spacer(
                                flex: 1,
                              ),
                              Text(
                                "Add temporary scedule item ",
                                style: TextStyle(fontSize: 20),
                              ),
                              Spacer(
                                flex: 3,
                              ),
                              IconButton(
                                  onPressed: () async {
                                    final ScheduleItemClass? data =
                                        await SceduleCreationService.instance
                                            .createSceduleItem(
                                                itemType: 2, cont: context)!;
                                    DBService.instance.addSceduleItem(
                                        AuthProvider.instance.user!.uid,
                                        widget.cahtId,
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
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _snapshot.data!.length,
                            itemBuilder: (context, index) {
                              if (_snapshot.data![index].endDate!
                                      .toDate()
                                      .compareTo(DateTime.now()) <
                                  1) {
                                DBService.instance.removeSceduleItem(
                                    _snapshot.data![index],
                                    AuthProvider.instance.user!.uid,
                                    widget.cahtId);
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: updatedSceduleItem(
                                      _snapshot.data![index]),
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
