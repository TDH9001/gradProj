import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/Chats.dart';
import 'package:grad_proj/screen/auth/login_screen.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../screen/chats/Chat_page.dart';

class RecentChats extends StatelessWidget {
  RecentChats({super.key});
  static String id = "RecentChats";

  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: _RecentChats(),
      ),
    );
  }
}

Widget _RecentChats() {
  return Builder(builder: (_context) {
    var _auth = Provider.of<AuthProvider>(_context);
    if (_auth.user == null) {
      navigationService.instance.navigateToReplacement(LoginScreen.id);
    }
    //all it does ios go up the widget tree > searching for the CHANGENOTI... and taking it's data
    return StreamBuilder<List<ChatSnipits>>(
        stream: DBService.instance.getUserChats(_auth.user!.uid),
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

          return data!.length != 0
              ? ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        tileColor: Colors.white,
                        onTap: () {
                          navigationService.instance.navigateToRoute(
                              MaterialPageRoute(builder: (_context) {
                            return ChatPage(chatID: data[index].Chatid);
                          }));
                        },
                        title: Text(data[index].Chatid),
                        subtitle: Text(data[index].LastMessage),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                                image: AssetImage("assets/images/science.png")),
                          ),
                        ),
                        trailing: Container(
                            width: 100,
                            child: ChatScreenTrailingiwdget(
                                data[index].timestamp)));
                  },
                )
              : Center(
                  child: Text(
                  "WOW, such emptyness",
                  style: TextStyle(fontSize: 30),
                ));
        });
  });
}

Widget ChatScreenTrailingiwdget(Timestamp s) {
  return ListView(
    children: [
      Text(
        timeago.format(s.toDate()),
        style: TextStyle(fontSize: 15),
      ),
      SizedBox(
        height: 12,
      ),
      Container(
        height: 18,
        width: 18,
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(300)),
      )
    ],
  );
}
