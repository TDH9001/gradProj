import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/Chats.dart';
import 'package:grad_proj/screen/auth/login_screen.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../screen/chats/Chat_page.dart';
import 'package:grad_proj/widgets/dialogs/add_chat_dialog.dart'; 

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
          
          if (data == null || data.isEmpty) { // Handle null or empty data
            return Center(
              child: Text(
                "No recent chats.",
                style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
              ),
            );
          }

          return ListView.builder(
                  itemCount: data.length, // Use data.length directly
                  itemBuilder: (context, index) {
                    final chatSnipit = data[index]; // More descriptive variable name
                    return ListTile(
                        tileColor: isDarkMode ? Colors.black54 : Colors.white,
                        onTap: () {
                          navigationService.instance.navigateToRoute( // Use correct class name
                              MaterialPageRoute(builder: (_context) {
                            return ChatPage(
                              chatID: chatSnipit.chatId,
                              admins: chatSnipit.adminId,
                            );
                          }));
                          DBService.instance.resetUnseenCount(
                              _auth.user!.uid, chatSnipit.chatId);
                        },
                        leading: CircleAvatar( // Added a leading avatar for better UI
                          backgroundColor: isDarkMode ? Theme.of(context).colorScheme.secondary : Theme.of(context).primaryColor,
                          child: Text(
                            chatSnipit.chatId.isNotEmpty ? chatSnipit.chatId[0].toUpperCase() : "?",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(chatSnipit.chatId), // Use chatSnipit
                        subtitle: Column( // Use column for better layout of subtitle and time
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (chatSnipit.lastMessage.isNotEmpty) // Check if last message exists
                              Text(
                                chatSnipit.lastMessage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (chatSnipit.type == "image")
                              Row(
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
                            else if (chatSnipit.type == "voice")
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Voice "),
                                    Icon(
                                      Icons.mic, // Changed to mic icon
                                      size: 16, // Adjusted icon size
                                      color: Color(0xff7AB2D3),
                                    ),
                                  ],
                                )
                            // Consider adding a default case or handling other types if necessary
                            else if (chatSnipit.lastMessage.isEmpty && chatSnipit.type != "text") // If no last message and not a special type
                                Text(
                                  "Chat started",
                                  style: TextStyle(fontStyle: FontStyle.italic, color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                                ),
                          ],
                        ),
                        trailing: Column( // Use Column for time and unseen count
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (chatSnipit.timestamp != null)
                              Text(
                                timeago.format(chatSnipit.timestamp!.toDate()),
                                style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.grey[400] : Colors.grey[700]),
                              ),
                            if (chatSnipit.unseenCount > 0)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  chatSnipit.unseenCount.toString(),
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                    );
                  },
                );
        });
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
