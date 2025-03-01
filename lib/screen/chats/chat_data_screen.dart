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
    var _auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: ColorsApp.primary,
              //expandedHeight: 120.0,
              flexibleSpace: FlexibleSpaceBar(
                title:
                    Center(child: Text(widget.cahtId, style: TextStyles.text)),
              ),
            ),
            SliverList(
              // the permanat one
              delegate:
                  SliverChildBuilderDelegate(childCount: 1, (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: updatedSceduleItem(scll),
                );
              }),
            ),
            StreamBuilder<List<ScheduleItemClass>>(
                stream:
                    DBService.instance.getPermanantSceduleItems(widget.cahtId),
                builder: (context, _snapshot) {
                  if (_snapshot.connectionState == ConnectionState.waiting ||
                      _snapshot.connectionState == ConnectionState.none) {
                    return SliverToBoxAdapter(
                        child: Center(
                      child:
                          Image(image: AssetImage('assets/images/splash.png')),
                    ));
                  }
                  if (_snapshot.hasError) {
                    return SliverToBoxAdapter(
                        child: Center(
                      child: Text(
                          "Error: ${_snapshot.error} \n please update your data and the data field mising"),
                    ));
                  }
                  // if (!_snapshot.hasData ||
                  //     _snapshot.data == null ||
                  //     _snapshot.data!.isEmpty) {
                  //   return const SliverToBoxAdapter(
                  //     child: Center(child: Text("No schedules found")),
                  //   );
                  // }

                  // var data = _snapshot.data;
                  return SliverList(
                    // the temporary one
                    delegate: SliverChildBuilderDelegate(
                        childCount: _snapshot.data!.length, (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: updatedSceduleItem(_snapshot.data![index]),
                      );
                    }),
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
                      child:
                          Image(image: AssetImage('assets/images/splash.png')),
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
                  return SliverList(
                    // the temporary one
                    delegate: SliverChildBuilderDelegate(
                        childCount: _snapshot.data!.length, (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: updatedSceduleItem(_snapshot.data![index]),
                      );
                    }),
                  );
                }),

            // body: Center(
            //   child: PrimaryButton(
            //       buttontext: "LOGOUT",
            //       func: () {
            //         _auth.signOut();
            //         navigationService.instance.navigateToReplacement(LoginScreen.id);
            //       }),
            // ),
          ],
        ),
      ),
    );
  }
}

Widget updatedSceduleItem(ScheduleItemClass scl) {
//  final ScheduleItemClass scl;

  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Container(
      decoration: BoxDecoration(
        color: scl.type == 1 ? const Color(0xff769BC6) : Colors.redAccent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scl.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  scl.location,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Text(
                  scl.creatorName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "${scl.startTime} - ${scl.endTime}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "${days.values[scl.day].name}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                scl.endDate != null
                    ? Text(
                        "${timeago.format(scl.endDate!.toDate())}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
