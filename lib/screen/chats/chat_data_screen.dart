import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/UI/colors.dart';
import 'package:grad_proj/constants.dart';
import 'package:grad_proj/models/contact.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/widgets/category_card.dart';
import 'package:grad_proj/widgets/custom_card.dart';
import 'package:grad_proj/widgets/updated_scedule_item.dart';
import 'package:grad_proj/widgets/sceduleitem.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';

class ChatDataScreen extends StatefulWidget {
  ChatDataScreen({super.key, required this.cahtId, required this.adminList});
  static String id = "ChatDataScreen";
  final String cahtId;
  final List<String> adminList;

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
                        title: const Text(
                          "Course members",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
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
                        leading:
                            const Icon(Icons.book, color: Color(0xff769BC6)),
                        // elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: const Text(
                          "Permanat scedule items",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        children: [
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
        ],
      ),
    );
  }
}
