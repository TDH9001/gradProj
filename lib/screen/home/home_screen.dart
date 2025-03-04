import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/screen/auth/login_screen.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:grad_proj/widgets/sceduleitem.dart';
import 'package:grad_proj/widgets/updated_scedule_item.dart';
import 'package:provider/provider.dart';

import '../../UI/colors.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var _auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              PrimaryButton(
                  buttontext: "addCourse",
                  func: () {
                    ScheduleItemClass scl = ScheduleItemClass(
                        creatorId: "123",
                        creatorName: "tester",
                        day: 1,
                        location: "nowhere",
                        name: "test of type1",
                        startTime: 1,
                        type: 3,
                        endTime: 1,
                        endDate: Timestamp.now());
                    DBService.instance.addSceduleItem(
                        "UyyMJiz3qnTfjus9dAoiNO7epKM2", "math 105", scl);
                  }),
              PrimaryButton(
                  //52stEYElBRO21mDdf85KdAaSg1E3
                  buttontext: "removeCourse",
                  func: () {
                    ScheduleItemClass scl = ScheduleItemClass(
                        creatorId: "123",
                        creatorName: "tester",
                        day: 1,
                        location: "nowhere",
                        name: "test of type1",
                        startTime: 1,
                        type: 3,
                        endTime: 1,
                        endDate: Timestamp.now());
                    DBService.instance.removeSceduleItem(
                        scl, "UyyMJiz3qnTfjus9dAoiNO7epKM2", "math 105");
                  }),
              StreamBuilder<List<ScheduleItemClass>>(
                  stream: DBService.instance
                      .getUserPermanatScedules("UyyMJiz3qnTfjus9dAoiNO7epKM2"),
                  builder: (context, _snapshot) {
                    if (_snapshot.connectionState == ConnectionState.waiting ||
                        _snapshot.connectionState == ConnectionState.none) {
                      return Center(
                          child: Image(
                              image: AssetImage('assets/images/splash.png')));
                    }
                    if (_snapshot.hasError) {
                      return Center(
                          child: Text(
                              "Error: ${_snapshot.error} \n please update your data and the data field mising"));
                    }
                    return SizedBox(
                      height: 150,
                      child: ListView.builder(
                          itemCount: _snapshot.data!.length,
                          itemBuilder: (Context, index) {
                            print(_snapshot.data!.length);
                            return updatedSceduleItem(_snapshot.data![index]);
                          }),
                    );
                  }),
              StreamBuilder<List<ScheduleItemClass>>(
                  stream: DBService.instance
                      .getUserTemporaryScedules("UyyMJiz3qnTfjus9dAoiNO7epKM2"),
                  builder: (context, _snapshot) {
                    if (_snapshot.connectionState == ConnectionState.waiting ||
                        _snapshot.connectionState == ConnectionState.none) {
                      return Center(
                          child: Image(
                              image: AssetImage('assets/images/splash.png')));
                    }
                    if (_snapshot.hasError) {
                      return Center(
                          child: Text(
                              "Error: ${_snapshot.error} \n please update your data and the data field mising"));
                    }
                    return SizedBox(
                      height: 150,
                      child: ListView.builder(
                          itemCount: _snapshot.data!.length,
                          itemBuilder: (Context, index) {
                            return updatedSceduleItem(_snapshot.data![index]);
                          }),
                    );
                  }),
              StreamBuilder<List<ScheduleItemClass>>(
                  stream: DBService.instance
                      .getUserPersonalScedule("UyyMJiz3qnTfjus9dAoiNO7epKM2"),
                  builder: (context, _snapshot) {
                    if (_snapshot.connectionState == ConnectionState.waiting ||
                        _snapshot.connectionState == ConnectionState.none) {
                      return Center(
                          child: Image(
                              image: AssetImage('assets/images/splash.png')));
                    }
                    if (_snapshot.hasError) {
                      return Center(
                          child: Text(
                              "Error: ${_snapshot.error} \n please update your data and the data field mising"));
                    }
                    return SizedBox(
                      height: 150,
                      child: ListView.builder(
                          itemCount: _snapshot.data!.length,
                          itemBuilder: (Context, index) {
                            print(_snapshot.data!.length);
                            return updatedSceduleItem(_snapshot.data![index]);
                          }),
                    );
                  }),
            ],
          )),
    );
  }
}
