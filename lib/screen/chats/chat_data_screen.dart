import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/constants.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/caht_data_widgets/ChatDataScreenWidgets.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/caht_data_widgets/add_user_QR_tab.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/caht_data_widgets/chat_avalibility_tab.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/caht_data_widgets/chat_files_sent.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/caht_data_widgets/chat_images_sent.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/caht_data_widgets/chat_video_sent.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/caht_data_widgets/chat_spreadsheets_manager.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:provider/provider.dart';

import '../theme/light_theme.dart';

class ChatDataScreen extends StatefulWidget {
  ChatDataScreen(
      {super.key,
      required this.cahtId,
      required this.adminList,
      required this.leaders,
      required this.chatAccesability});
  static String id = "ChatDataScreen";
  final String cahtId;
  final List<String> adminList;
  final List<String> leaders;
  final String chatAccesability;

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
          ChatMembersList(
            widget: widget,
            deviceHeight: deviceHeight,
            chatId: widget.cahtId,
            admins: widget.adminList,
            leaders: widget.leaders,
          ),
          SliverToBoxAdapter(
            child: AddUserQrTab(
              chatID: widget.cahtId,
            ),
          ),
          ChatSpreadSheetsSlider(
            widget: widget,
          ),
          widget.adminList.contains(
                      HiveUserContactCashingService.getUserContactData().id) ||
                  HiveUserContactCashingService.getUserContactData().id.length <
                      10
              ? ChatAvalibilitySlider(
                  chatId: widget.cahtId,
                  chatAccesability: widget.chatAccesability,
                )
              : SliverToBoxAdapter(child: SizedBox()),
          PermanatChatScedulesList(widget: widget),
          TemporaryChatSceleList(widget: widget),
          ChatImagesSent(cahtId: widget.cahtId),
          ChatFilesSent(cahtId: widget.cahtId),
          ChatVideosSent(cahtId: widget.cahtId),
        ],
      ),
    );
  }
}
