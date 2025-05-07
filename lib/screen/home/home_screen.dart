import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/feed_Items.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/screen/feed_test_screen.dart';
import 'package:grad_proj/screen/about_screen/acadimic_career_screen.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: AuthProvider.instance,
        child: (Scaffold(
            appBar: AppBar(
              title: Text(
                'PLACEHOLDER FOR NAME',
                style: TextStyle(fontSize: 15),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.view_list),
                  tooltip: "Test All Feed Items",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FeedTestScreen()),
                    );
                  },
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AcademicCareerScreen(),
                      ),
                    );
                  },
                  child: Text('Test Academic Career Screen'),
                ),
                GetUsersStream(),
              ],
            ))));
  }
}

class GetUsersStream extends StatelessWidget {
  const GetUsersStream({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthProvider>(context);
    if (_auth.user == null) {
      return CircularProgressIndicator();
    }
    return StreamBuilder<List<FeedItems>>(
      stream: DBService().getUserFeed(_auth.user!.uid),
      builder: (context, _snapshot) {
        var data = _snapshot.data;

        if (_snapshot.connectionState == ConnectionState.waiting ||
            _snapshot.connectionState == ConnectionState.none) {
          return Center(child: CircularProgressIndicator());
        }
        if (_snapshot.hasError) {
          return Center(
              child: Text(
                  "Error: ${_snapshot.error} \n please update your data and the data field mising"));
        }
        print(data);
        return ListView.builder(
            itemCount: data!.length,
            itemBuilder: (context, index) {
              if (data.isEmpty) {
                return Center(child: Text("No data"));
              } else {
                return data[index].present(context: context);
              }
            });
      },
    );
  }
}
