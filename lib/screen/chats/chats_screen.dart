import 'dart:developer' as devtools;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/Chats.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/widgets/dialogs/add_chat_dialog.dart';
import 'package:hive_flutter/adapters.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ChatsScreenSearchBar(
            //   txt: widget.chatsTextController,
            // ),
            RecentChatsreturn(),
          ],
        ),
      ),
      floatingActionButton:
          HiveUserContactCashingService.getUserContactData().id.length < 10
              ? null
              : FloatingActionButton(
                  backgroundColor: Color(0xff2E5077),
                  onPressed: () => _showAddChatDialog(context),
                  child: const Icon(Icons.add_comment_outlined, color: Colors.white),
                  tooltip: 'chats.add_new_chat'.tr(),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Column(
      children: [
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: double.infinity,
            height: MediaService.instance.getHeight() * 0.06,
            decoration: BoxDecoration(
              color:isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isDarkMode ? Colors.white60 : Color(0xff769BC6)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: TextFormField(
                onChanged: (str) {
                  widget.searchText = str;
                  setState(() {});
                },
                keyboardType: TextInputType.text,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: 'home.search_for_courses'.tr(),
                  hintStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.grey.shade600),
                  prefixIcon: Icon(Icons.search, color:isDarkMode ? Colors.white60 : Colors.grey.shade700),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        StreamBuilder<List<ChatSnipits>>(
          stream:
              HiveUserContactCashingService.getUserContactData().id.length < 10
                  ? DBService.instance.getAllChatsForAdmin(widget.searchText)
                  : DBService.instance.getUserChats(
                      HiveUserContactCashingService.getUserContactData().id,
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
                              if (HiveUserContactCashingService
                                          .getUserContactData()
                                      .id
                                      .length >
                                  10) {
                                DBService.instance.resetUnseenCount(
                                    HiveUserContactCashingService
                                            .getUserContactData()
                                        .id,
                                    data[index].chatId);
                              }
                            },
                            title: Text(data[index].chatId),
                            subtitle: data[index].type == MessageType.image.name
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('chats.image_attachment'.tr()),
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
                                          Text('chats.voice_attachment'.tr()),
                                          Icon(
                                            Icons.music_note,
                                            color: Color(0xff7AB2D3),
                                          ),
                                        ],
                                      )
                                    : data[index].type == MessageType.video.name
                                        ? Row(
                                            children: [
                                              Text('chats.video_attachment'.tr()),
                                              Icon(
                                                Icons.video_collection_sharp,
                                                color: Color(0xff7AB2D3),
                                              )
                                            ],
                                          )
                                        : data[index].type ==
                                                MessageType.file.name
                                            ? Row(
                                                children: [
                                                  Text('chats.file_attachment'.tr()),
                                                  Icon(
                                                    Icons.file_copy_outlined,
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
                        'chats.no_chats'.tr(),
                        style: TextStyle(fontSize: 16),
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
