import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/contact.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:grad_proj/screen/chats/chat_data_screen.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/Scedule_creation_service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:grad_proj/widgets/selectable_scedule_item.dart';
import 'package:grad_proj/widgets/updated_scedule_item.dart';
import 'dart:developer' as dev;

import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import '../../../../providers/theme_provider.dart';

class TemporaryChatSceleList extends StatelessWidget {
  const TemporaryChatSceleList({
    super.key,
    required this.widget,
  });

  final ChatDataScreen widget;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    return StreamBuilder<List<ScheduleItemClass>>(
        stream: DBService.instance.getTemporarySceduleItems(widget.cahtId),
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
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [Color(0xff2E5077), Color(0xFF2E3B55)]
                        : [Color(0xff769BC6), Color(0xffa6c4dd)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ExpansionTile(
                  initiallyExpanded: false,
                  leading: Icon(Icons.table_chart,
                      color:
                          isDarkMode ? Color(0xFF4A739F) : Color(0xff2E5077)),
                  // elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    'ChatDataScreen.temporary_schedule_items'.tr(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                  children: [
                    if (widget.adminList.contains(
                            HiveUserContactCashingService.getUserContactData()
                                .id) ||
                        widget.leaders.contains(
                            HiveUserContactCashingService.getUserContactData()
                                .id) ||
                        HiveUserContactCashingService.getUserContactData()
                                .id
                                .length <
                            10)
                      Row(
                        children: [
                          Spacer(
                            flex: 1,
                          ),
                          Text(
                            'ChatDataScreen.add_temporary_schedule_item'.tr(),
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Spacer(
                            flex: 3,
                          ),
                          IconButton(
                              onPressed: () async {
                                final ScheduleItemClass? data =
                                    await SceduleCreationService.instance
                                        .createSceduleItem(
                                            chatID: widget.cahtId,
                                            itemType: 2,
                                            cont: context);
                                if (data != null) {
                                  DBService.instance.addSceduleItem(
                                      HiveUserContactCashingService
                                              .getUserContactData()
                                          .id,
                                      widget.cahtId,
                                      data);
                                } else {
                                  SnackBarService.instance.buildContext =
                                      context;
                                  SnackBarService.instance.showsSnackBarError(
                                      text: 'ChatDataScreen.error2'.tr());
                                }
                              },
                              icon: Icon(
                                Icons.add_alert_sharp,
                                color: Color.fromARGB(255, 178, 180, 182),
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
                              HiveUserContactCashingService.getUserContactData()
                                  .id,
                              widget.cahtId);
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: (widget.adminList.contains(
                                        HiveUserContactCashingService
                                                .getUserContactData()
                                            .id) ||
                                    HiveUserContactCashingService
                                                .getUserContactData()
                                            .id
                                            .length <
                                        10)
                                ? SelectableScheduleItem(
                                    cont: context,
                                    scheduleItem: _snapshot.data![index],
                                  )
                                : updatedSceduleItem(_snapshot.data![index]),
                            //  SelectableScheduleItem(
                            //   cont: context,
                            //   scheduleItem: _snapshot.data![index],
                            // )
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class PermanatChatScedulesList extends StatelessWidget {
  const PermanatChatScedulesList({
    super.key,
    required this.widget,
  });

  final ChatDataScreen widget;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    return StreamBuilder<List<ScheduleItemClass>>(
        stream: DBService.instance.getPermanantSceduleItems(widget.cahtId),
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
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [Color(0xff2E5077), Color(0xFF2E3B55)]
                        : [Color(0xff769BC6), Color(0xffa6c4dd)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ExpansionTile(
                  initiallyExpanded: false,
                  leading: Icon(Icons.table_view_outlined,
                      color: isDarkMode
                          ? Color.fromARGB(255, 92, 133, 177)
                          : Color(0xff2E5077)),
                  // elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    'ChatDataScreen.permanent_schedule_items'.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDarkMode
                              ? [Color(0xff2E5077), Color(0xFF2E3B55)]
                              : [Color(0xff769BC6), Color(0xffa6c4dd)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                    if (widget.adminList.contains(
                            HiveUserContactCashingService.getUserContactData()
                                .id) ||
                        widget.leaders.contains(
                            HiveUserContactCashingService.getUserContactData()
                                .id) ||
                        HiveUserContactCashingService.getUserContactData()
                                .id
                                .length <
                            10)
                      Row(
                        children: [
                          Spacer(
                            flex: 1,
                          ),
                          Text(
                            'ChatDataScreen.add_permanent_schedule_item'.tr(),
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Spacer(
                            flex: 3,
                          ),
                          IconButton(
                              onPressed: () async {
                                final ScheduleItemClass? data =
                                    await SceduleCreationService.instance
                                        .createSceduleItem(
                                            chatID: widget.cahtId,
                                            cont: context,
                                            itemType: 1);
                                if (data != null &&
                                    data.startTime > 0 &&
                                    data.endTime > 0) {
                                  DBService.instance.addSceduleItem(
                                      HiveUserContactCashingService
                                              .getUserContactData()
                                          .id,
                                      widget.cahtId,
                                      data);
                                } else {
                                  SnackBarService.instance.buildContext =
                                      context;
                                  SnackBarService.instance.showsSnackBarError(
                                      text: 'ChatDataScreen.error'.tr());
                                }
                              },
                              icon: Icon(
                                Icons.add_alert_sharp,
                                color: Color.fromARGB(255, 178, 180, 182),
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
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: (widget.adminList.contains(
                                      HiveUserContactCashingService
                                              .getUserContactData()
                                          .id) ||
                                  HiveUserContactCashingService
                                              .getUserContactData()
                                          .id
                                          .length <
                                      10)
                              ? SelectableScheduleItem(
                                  cont: context,
                                  scheduleItem: _snapshot.data![index],
                                )
                              : updatedSceduleItem(_snapshot.data![index]),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class ChatMembersList extends StatelessWidget {
  const ChatMembersList(
      {super.key,
      required this.widget,
      required this.deviceHeight,
      required this.admins,
      required this.leaders,
      required this.chatId});

  final ChatDataScreen widget;
  final double deviceHeight;
  final String chatId;
  final List<String> admins;
  final List<String> leaders;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    SnackBarService.instance.buildContext = context;

    return StreamBuilder<List<Contact>>(
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
                  "Error: ${_snapshot.error} \n please update your data and the data field missing"),
            ));
          }
          return SliverToBoxAdapter(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [Color(0xff2E5077), Color(0xFF2E3B55)]
                        : [Color(0xff769BC6), Color(0xffa6c4dd)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  leading: Icon(Icons.library_books_sharp,
                      color:
                          isDarkMode ? Color(0xFF4A739F) : Color(0xff2E5077)),
                  // elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Row(
                    children: [
                      Text(
                        'ChatDataScreen.course_members'.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
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
                          dev.log(_snapshot.data!.toString());
                          Contact member = _snapshot.data![index];
                          return Card(
                            color: Colors.transparent,
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Color(0xFF2E3B55)
                                    : Color(0xff2E5077),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ExpansionTile(
                                leading:
                                    Icon(Icons.person, color: Colors.white),
                                iconColor: Colors.white,
                                collapsedIconColor: Colors.white70,
                                title: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "${member.firstName} ${member.lastName}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                                childrenPadding: EdgeInsets.only(
                                    left: 24, bottom: 12, right: 12),
                                children: admins.contains(
                                            HiveUserContactCashingService
                                                    .getUserContactData()
                                                .id
                                                .trim()) ||
                                        HiveUserContactCashingService
                                                    .getUserContactData()
                                                .id
                                                .trim()
                                                .length <
                                            10
                                    ? [
                                        Row(
                                          children: [
                                            Icon(Icons.badge,
                                                color: Colors.white70,
                                                size: 16),
                                            SizedBox(width: 8),
                                            Text(
                                                //"Last Name: ${member.lastName}",
                                                "${"ChatDataScreen.last_name:".tr()} ${member.lastName}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(Icons.phone,
                                                color: Colors.white70,
                                                size: 16),
                                            SizedBox(width: 8),
                                            Text(
                                                //"Phone: ${member.phoneNumber}",
                                                "${"ChatDataScreen.phone_number:".tr()} ${member.phoneNumber}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Icon(Icons.badge,
                                                color: Colors.white70,
                                                size: 16),
                                            SizedBox(width: 8),
                                            Text(
                                                // "SeatNumber: ${member.seatNumber}",
                                                "${"ChatDataScreen.seat_number:".tr()} ${member.seatNumber}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Icon(Icons.email_outlined,
                                                color: Colors.white70,
                                                size: 16),
                                            SizedBox(width: 8),
                                            Text(
                                                //"Email: ${member.email}",
                                                "${"ChatDataScreen.email:".tr()} ${member.email}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        // Row(
                                        //   children: [
                                        //     Icon(Icons.leaderboard,
                                        //         color: Colors.white70,
                                        //         size: 16),
                                        //     SizedBox(width: 8),
                                        //     Text("${"ChatDataScreen.seat_number:".tr()} ${member.seatNumber}",
                                        //         style: TextStyle(
                                        //             color: Colors.white)),
                                        //   ],
                                        // ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        admins.contains(
                                                    HiveUserContactCashingService
                                                            .getUserContactData()
                                                        .id
                                                        .trim()) ||
                                                HiveUserContactCashingService
                                                            .getUserContactData()
                                                        .id
                                                        .trim()
                                                        .length <
                                                    10
                                            ? Column(
                                                children: [
                                                  SizedBox(
                                                    height: 40,
                                                    child: PrimaryButton(
                                                        buttontext: !widget
                                                                .adminList
                                                                .contains(member.id
                                                                    .trim())
                                                            ? 'ChatDataScreen.make_admin'
                                                                .tr()
                                                            : 'ChatDataScreen.already_an_admin'
                                                                .tr(),
                                                        func: () => !widget
                                                                .adminList
                                                                .contains(member
                                                                    .id
                                                                    .trim())
                                                            ? DBService.instance
                                                                .makeAdmin(
                                                                    member.id.trim(),
                                                                    widget.cahtId)
                                                            : {}),
                                                  ),
                                                  SizedBox(height: 12),
                                                  SizedBox(
                                                    height: 40,
                                                    child: PrimaryButton(
                                                        buttontext: !widget.leaders.contains(member.id.trim())
                                                            ? 'ChatDataScreen.make_leader'
                                                                .tr()
                                                            : 'ChatDataScreen.remove_leader'
                                                                .tr(),
                                                        func: () => !widget.leaders
                                                                .contains(member.id
                                                                    .trim())
                                                            ? DBService.instance
                                                                .makeUserChatLeader(
                                                                    chatId,
                                                                    member.id
                                                                        .trim())
                                                            : {
                                                                DBService
                                                                    .instance
                                                                    .removeLeaderFromChat(
                                                                        chatId,
                                                                        member
                                                                            .id
                                                                            .trim())
                                                              }),
                                                  ),
                                                ],
                                              )
                                            : SizedBox(),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        if (HiveUserContactCashingService
                                                        .getUserContactData()
                                                    .id
                                                    .trim()
                                                    .length <
                                                10 &&
                                            admins.contains(member.id.trim()))
                                          Row(
                                            children: [
                                              PrimaryButton(
                                                buttontext:
                                                    'ChatDataScreen.remove_the_admin'
                                                        .tr(),
                                                func: () => DBService.instance
                                                    .removeAdminFromChat(
                                                  chatId,
                                                  member.id.trim(),
                                                ),
                                              )
                                            ],
                                          )
                                      ]
                                    : [],
                              ),
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
        });
  }
}
