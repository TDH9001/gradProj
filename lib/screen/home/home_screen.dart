import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/feed_Items.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/screen/feed_test_screen.dart';
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
             // backgroundColor: Color(0xFF1C1C1C),
              title: Center(
                child: Text(
                  'HomeScreen.title'.tr(),
                  style: TextStyle(fontSize: 15),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.view_list),
                  tooltip: 'HomeScreen.important'.tr(),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FeedTestScreen()),
                    );
                  },
                ),
              ],
            ),
            body: GetUsersStream())));
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
        if (_snapshot.connectionState == ConnectionState.waiting ||
            _snapshot.connectionState == ConnectionState.none) {
          return Center(child: CircularProgressIndicator());
        }
        if (_snapshot.hasError) {
          return Center(
              child: Text(
                  "Error: ${_snapshot.error} \n please update your data and the data field mising"));
        }
        // print(data);
        var items = _snapshot.data;
        var data = items?.reversed.toList();

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
