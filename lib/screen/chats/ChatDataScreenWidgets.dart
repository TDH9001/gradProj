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
                  leading: const Icon(Icons.book, color: Color(0xff769BC6)),
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

    return StreamBuilder<List<contact>>(
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
                  leading: const Icon(Icons.book, color: Color(0xff769BC6)),
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
        });
  }
}
