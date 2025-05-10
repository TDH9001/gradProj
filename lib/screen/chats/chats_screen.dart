import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/Chats.dart';
import 'package:grad_proj/screen/auth/login_screen.dart';
import 'package:grad_proj/widgets/dialogs/add_chat_dialog.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../screen/chats/Chat_page.dart';
import '../theme/dark_theme_colors.dart';

class RecentChats extends StatelessWidget {
  RecentChats({super.key});
  static String id = "RecentChats";

  void _showAddChatDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return const AddChatDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: _RecentChats(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddChatDialog(context),
        child: const Icon(Icons.add_comment_outlined),
        tooltip: 'Add New Chat',
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
      return const Center(
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
          return const Center(child: CircularProgressIndicator());
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
                    leading: CircleAvatar(
                      backgroundColor: isDarkMode
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).primaryColor,
                      child: Image(image: AssetImage("assets/images/chat.png")),
                    ),
                    tileColor:
                        isDarkMode ? DarkThemeColors.background : Colors.white,
                    onTap: () {
                      navigationService.instance.navigateToRoute(
                          MaterialPageRoute(builder: (_context) {
                        return ChatPage(
                          chatID: data[index].chatId,
                          admins: data[index].adminId,
                          chatAccesability: data[index].chatAccesability,
                          leaders: data[index].leaders,
                        );
                      }));
                      DBService.instance.resetUnseenCount(
                          _auth.user!.uid, data[index].chatId);
                    },
                    title: Text(data[index].chatId),
                    subtitle: data[index].type == "image"
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Image "),
                              Icon(
                                Icons.image,
                                size: 16, // Adjusted icon size
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
                            : Text(
                                data[index].lastMessage,
                                maxLines: 2,
                              ),
                  );
                })
            : Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    "no chats please go to the profile and add courses....",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
        // leading: Container(
        //   width: 50,
        //   height: 50,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(100),
        //     image: DecorationImage(
        //         image: AssetImage("assets/images/chat.png")),
        //   ),
        // ),
        // trailing: Container(
        //     width: 100,
        //     child: ChatScreenTrailingiwdget(
        //         data[index].timestamp,
        //         data[index].unseenCount >= 1,
        //         data[index].unseenCount))
      },
    );
  });
}

class ChatScreenTrailingiwdget extends StatelessWidget {
  final ChatSnipits chat;
  final bool isDarkMode;
  const ChatScreenTrailingiwdget(
      {super.key, required this.chat, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          timeago.format(chat.timestamp!.toDate()),
          style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
        ),
        chat.unseenCount != 0
            ? Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: Color(0xff7AB2D3),
                    borderRadius: BorderRadius.circular(500)),
                child: Center(
                  child: Text(
                    chat.unseenCount.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            : Container(
                height: 0,
                width: 0,
              )
      ],
    );
  }
}
