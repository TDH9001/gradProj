import 'package:flutter/material.dart';
import 'package:grad_proj/models/contact.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/screen/chats/chat_data_screen.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/Scedule_creation_service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:grad_proj/widgets/selectable_scedule_item.dart';
import 'package:grad_proj/widgets/updated_scedule_item.dart';

class TemporaryChatSceleList extends StatelessWidget {
  const TemporaryChatSceleList({
    super.key,
    required this.widget,
  });

  final ChatDataScreen widget;

  @override
  Widget build(BuildContext context) {
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
              child:  Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff769BC6), Color(0xffa6c4dd)],
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
                  leading: const Icon(Icons.table_chart, color: Color(0xff2E5077)),
                  // elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),

                  ),
                  title: const Text(
                    "Temporary scedule items",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,color: Colors.white
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
                          style: TextStyle(fontSize: 16,color: Colors.white),
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
                                    AuthProvider.instance.user!.uid,
                                    widget.cahtId,
                                    data);
                              } else {
                                SnackBarService.instance.buildContext = context;
                                SnackBarService.instance.showsSnackBarError(
                                    text:
                                        "Error adding scedule, please try again");
                              }
                            },
                            icon: Icon(
                              Icons.add_alert_sharp,color: Color(0xff2E5077),
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
                            child: SelectableScheduleItem(
                              cont: context,
                              scheduleItem: _snapshot.data![index],
                            ),
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
                    colors: [Color(0xff769BC6), Color(0xffa6c4dd)],
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
                  leading: Icon(Icons.table_view_outlined, color: Color(0xff2E5077) ),
                  // elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    "Permanat Scedule Items",
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
                          colors: [Color(0xff769BC6), Color(0xffa6c4dd)],
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
                    Row(
                      children: [
                        Spacer(
                          flex: 1,
                        ),
                        Text(
                          "Add permanant scedule item ",
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
                                    AuthProvider.instance.user!.uid,
                                    widget.cahtId,
                                    data);
                              } else {
                                SnackBarService.instance.buildContext = context;
                                SnackBarService.instance.showsSnackBarError(
                                    text:
                                        "Error adding scedule, please try again");
                              }
                              // DBService.instance.addSceduleItem(
                              //     AuthProvider.instance.user!.uid,
                              //     widget.cahtId,
                              //     data!);
                            },
                            icon: Icon(
                              Icons.add_alert_sharp,color: Color(0xff2E5077),
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
                          child: SelectableScheduleItem(
                            cont: context,
                            scheduleItem: _snapshot.data![index],
                          ),
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
  const ChatMembersList({
    super.key,
    required this.widget,
    required this.deviceHeight,
  });

  final ChatDataScreen widget;
  final double deviceHeight;

  @override
  Widget build(BuildContext context) {
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
                    colors: [Color(0xff769BC6), Color(0xffa6c4dd)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  //color: Color(0xff769BC6),
                  // gradient: LinearGradient(
                  //   colors: [Colors.blue.shade50, Colors.white],
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  // ),
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
                  leading: const Icon(Icons.library_books_sharp,
                      color: Color(0xff2E5077)),
                  // elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Row(
                    children: [
                      Text(
                        "Course members",
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
                          final member = _snapshot.data![index];
                          return Card(
                            color: Colors.transparent,
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xff2E5077),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ExpansionTile(
                                leading: Icon(Icons.person, color: Colors.white),
                                iconColor: Colors.white,
                                collapsedIconColor: Colors.white70,
                                title: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    member.firstName,
                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                ),
                                childrenPadding: EdgeInsets.only(left: 24, bottom: 12, right: 12),
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.badge, color: Colors.white70, size: 16),
                                      SizedBox(width: 8),
                                      Text("Last Name: ${member.lastName}", style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.phone, color: Colors.white70, size: 16),
                                      SizedBox(width: 8),
                                      Text("Phone: ${member.phoneNumber}", style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  // Row(
                                  //   children: [
                                  //     Icon(Icons.email, color: Colors.white70, size: 16),
                                  //     SizedBox(width: 8),
                                  //     Text("Email: ${member.email}", style: TextStyle(color: Colors.white)),
                                  //   ],
                                  // ),
                                   SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.badge, color: Colors.white70, size: 16),
                                      SizedBox(width: 8),
                                      Text("SeatNumber: ${member.seatNumber}", style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ],
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
