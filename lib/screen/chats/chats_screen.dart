import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/Chats.dart';
import 'package:grad_proj/screen/auth/login_screen.dart';
import 'package:grad_proj/theme/dark_theme_colors.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
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
    final _auth = Provider.of<AuthProvider>(_context);
    final themeProvider = Provider.of<ThemeProvider>(_context);
    final isDarkMode = themeProvider.isDarkMode;

    if (_auth.user == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return StreamBuilder<List<ChatSnipits>>(
        stream: DBService.instance.getUserChats(
            AuthProvider.instance.user!.uid.toString()), //_auth.user!.uid),
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
                        tileColor:  isDarkMode ? DarkThemeColors.background: Colors.white,
                        onTap: () {
                          navigationService.instance.navigateToRoute(
                              MaterialPageRoute(builder: (_context) {
                            return ChatPage(
                              chatID: data[index].chatId,
                              admins: data[index].adminId,
                            );
                          }));
                          DBService.instance.resetUnseenCount(
                              _auth.user!.uid, data[index].chatId);
                        },
                        title: Text(data[index].chatId),
                        subtitle: data[index].type == "image"
                            ? Row(
                                children: [
                                  Text("image attachment"),
                                  Icon(
                                    Icons.image,
                                    color: Color(0xff7AB2D3),
                                  ),
                                ],
                              )
                            : data[index].type == "voice"
                                ? Row(
                                    children: [
                                      Text("Voice attachment"),
                                      Icon(
                                        Icons.music_note,
                                        color: Color(0xff7AB2D3),
                                      ),
                                    ],
                                  )
                                : Text(data[index].lastMessage),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                                image: AssetImage("assets/images/chat.png")),
                          ),
                        ),
                        trailing: Container(
                            width: 100,
                            child: ChatScreenTrailingiwdget(
                                data[index].timestamp,
                                data[index].unseenCount >= 1,
                                data[index].unseenCount)));
                  },
                )
              : Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "no chats please go to the profile and add courses....",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
        });
  });
}

Widget ChatScreenTrailingiwdget(Timestamp s, bool isUnseen, int unseenCount) {
//  await getMembersOfChat("math 105");
  return Column(
    children: [
      Text(
        timeago.format(s.toDate()),
        style: TextStyle(fontSize: 12),
      ),
      SizedBox(
        height: 8,
      ),
      isUnseen
          ? Container(
              height: 18,
              width: 25,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(360)),
              child: Center(
                child: Text(
                  unseenCount.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            )
          : SizedBox()
    ],
  );
}
