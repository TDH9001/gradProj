import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/constants.dart';
import 'package:grad_proj/models/contact.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/screen/chats/ChatDataScreenWidgets.dart';

import 'package:grad_proj/services/snackbar_service.dart';
import 'package:grad_proj/theme/light_theme.dart';

import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';

class ChatDataScreen extends StatefulWidget {
  ChatDataScreen({super.key, required this.cahtId, required this.adminList});
  static String id = "ChatDataScreen";
  final String cahtId;
  final List<String> adminList;
  // final GlobalKey<FormState> validateSceduleItem = GlobalKey();
  // final MultiSelectController<String> dayController =
  //     MultiSelectController<String>();
  // final TextEditingController locationController = TextEditingController();
  // final TextEditingController sceduleName = TextEditingController();
  // final TextEditingController startTime = TextEditingController();
  // final TextEditingController endTime = TextEditingController();
  // final TextEditingController endDate = TextEditingController();
  // final List<DropdownItem<String>> daysList = [
  //   DropdownItem(label: "saturday", value: "saturday"),
  //   DropdownItem(label: "sunday", value: "sunday"),
  //   DropdownItem(label: "monday", value: "monday"),
  //   DropdownItem(label: "tuesday", value: "tuesday"),
  //   DropdownItem(label: "wednesday", value: "wednesday"),
  //   DropdownItem(label: "thursday", value: "thursday"),
  //   DropdownItem(label: "friday", value: "friday"),
  // ];

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
            backgroundColor: LightTheme.primary,
            //expandedHeight: 120.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Center(child: Text(widget.cahtId, style: TextStyles.text)),
            ),
          ),
          ChatMembersList(widget: widget, deviceHeight: deviceHeight),
          PermanatChatScedulesList(widget: widget),
          TemporaryChatSceleList(widget: widget),
        ],
      ),
    );
  }
}
