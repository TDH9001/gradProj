import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/screen/auth/login_screen.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:grad_proj/widgets/sceduleitem.dart';
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
          child: ListView(
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
                        type: 2,
                        endTime: 1,
                        endDate: Timestamp.now());
                    DBService.instance.addSceduleItem(
                        "52stEYElBRO21mDdf85KdAaSg1E3", "math 105", scl);
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
                        type: 2,
                        endTime: 1,
                        endDate: Timestamp.now());
                    DBService.instance.removeSceduleItem(
                        scl, "52stEYElBRO21mDdf85KdAaSg1E3", "math 105");
                  })
            ],
          )),
    );
  }
}
