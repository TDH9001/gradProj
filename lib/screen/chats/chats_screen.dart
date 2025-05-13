import 'dart:developer' as devtools;

import 'package:flutter/material.dart';
import 'package:grad_proj/models/Chats.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/widgets/dialogs/add_chat_dialog.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../screen/chats/Chat_page.dart';
import '../theme/dark_theme_colors.dart';

class RecentChats extends StatefulWidget {
  RecentChats({super.key});
  static String id = "RecentChats";
  String searchText = "";

  final TextEditingController chatsTextController = TextEditingController();

  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ChatsScreenSearchBar(
              //   txt: widget.chatsTextController,
              // ),
              RecentChatsreturn(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddChatDialog(context),
        child: const Icon(Icons.add_comment_outlined),
        tooltip: 'Add New Chat',
      ),
    );
  }
}

class RecentChatsreturn extends StatefulWidget {
  RecentChatsreturn({super.key});
  String searchText = "";

  @override
  State<RecentChatsreturn> createState() => _RecentChatsreturnState();
}

class _RecentChatsreturnState extends State<RecentChatsreturn> {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    if (_auth.user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        Container(
            width: double.infinity,
            height: MediaService.instance.getHeight() * 0.06,
            child: TextFormField(
              onChanged: (str) {
                widget.searchText = str;
                // dev.log(ChatsScreenSearchBar.chatSearch = str);
                setState(() {});
              },
              //   controller: widget.txt,
              keyboardType: TextInputType.text,
              autocorrect: false,
              decoration: InputDecoration(
                //label: Text("Search"),
                icon: Icon(Icons.search),
                labelText: "Search for courses",
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            )),
        StreamBuilder<List<ChatSnipits>>(
          stream: DBService.instance.getUserChats(
              AuthProvider.instance.user!.uid.toString(),
              widget.searchText), //_auth.user!.uid),
          builder: (context, _snapshot) {
            var data = _snapshot.data;
            devtools.log(widget.searchText);

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
                ? Container(
                    height: MediaService.instance.getHeight() * 0.75,
                    child: ListView.builder(
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isDarkMode
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).primaryColor,
                              child: Image(
                                  image: AssetImage("assets/images/chat.png")),
                            ),
                            tileColor: isDarkMode
                                ? DarkThemeColors.background
                                : Colors.white,
                            onTap: () {
                              navigationService.instance.navigateToRoute(
                                  MaterialPageRoute(builder: (_context) {
                                return ChatPage(
                                  chatID: data[index].chatId,
                                  admins: data[index].adminId,
                                  chatAccesability:
                                      data[index].chatAccesability,
                                  leaders: data[index].leaders,
                                );
                              }));
                              DBService.instance.resetUnseenCount(
                                  _auth.user!.uid, data[index].chatId);
                            },
                            title: Text(data[index].chatId),
                            subtitle: data[index].type == MessageType.image.name
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Image attachment"),
                                      Icon(
                                        Icons.image,
                                        size: 16, // Adjusted icon size
                                        color: Color(0xff7AB2D3),
                                      ),
                                    ],
                                  )
                                : data[index].type == MessageType.voice.name
                                    ? Row(
                                        children: [
                                          Text("Voice attachment"),
                                          Icon(
                                            Icons.music_note,
                                            color: Color(0xff7AB2D3),
                                          ),
                                        ],
                                      )
                                    : data[index].type == MessageType.video.name
                                        ? Row(
                                            children: [
                                              Text("Video attachment"),
                                              Icon(
                                                Icons.ondemand_video_outlined,
                                                color: Color(0xff7AB2D3),
                                              )
                                            ],
                                          )
                                        : data[index].type ==
                                                MessageType.file.name
                                            ? Row(
                                                children: [
                                                  Text("File attachment"),
                                                  Icon(
                                                    Icons.file_present_outlined,
                                                    color: Color(0xff7AB2D3),
                                                  )
                                                ],
                                              )
                                            : Text(
                                                data[index].lastMessage,
                                                maxLines: 1,
                                              ),
                          );
                        }),
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
          },
        ),
      ],
    );
  }
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
            : SizedBox()
      ],
    );
  }
}
