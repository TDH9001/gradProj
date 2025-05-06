import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/screen/chats/chat_data_screen.dart';
import 'package:grad_proj/screen/table/Course_disaplay_Lists.dart';
import 'package:grad_proj/screen/table/tableform_screen.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/Scedule_creation_service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:grad_proj/widgets/customTextField.dart';
import 'package:grad_proj/widgets/dropdown_select_widget.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:grad_proj/widgets/updated_scedule_item.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../theme/dark_theme_colors.dart';

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
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final _auth = Provider.of<AuthProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    return Scaffold(
        backgroundColor: isDarkMode ? DarkThemeColors.background : Color(0xFFF7F9FC),
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
                                await SceduleCreationService.instance
                                    .createSceduleItem(
                                        chatID: "Personal",
                                        itemType: 3,
                                        cont: context);
                            if (data != null) {
                              DBService.instance.addSceduleItem(
                                  _auth.user!.uid, "not relavant", data!);
                            } else {
                              SnackBarService.instance.showsSnackBarError(
                                  text:
                                      "error adding scedule, please try again");
                            }
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
                UserPerosnalSceduleList(),
                CoursesPermanatSceduleList(),
                CourseTemporarySceduleList(),
                //located on the file called "Course_disaplay_Lists"
              ],
            )));
  }
}
