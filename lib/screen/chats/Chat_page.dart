import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/chats/chat_data_screen.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/chat_page_message_field.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/message_list_view_chat_lsit.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import '../../providers/theme_provider.dart';
import '../../UI/text_style.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../theme/light_theme.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key, required this.chatID, required this.admins});
  final String id = "ChatPage";
  String chatID;
  GlobalKey<FormState> GK = GlobalKey<FormState>();
  String textTosend = "";
  final ScrollController _LVC = ScrollController();
  List<String> admins;
  final TextEditingController txt = TextEditingController();
  //final record = AudioRecorder();
  late AudioPlayer audioPlayer = AudioPlayer();
  // PlatformDispatcher.

  @override
  State<ChatPage> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  double _height = 0;
  double _width = 0;
  bool isRecording = false;
  //late Future<List<String>> chatMembersFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _height = MediaService.instance.getHeight();
    _width = MediaService.instance.getWidth();
    //widget._auth = context.read<AuthProvider>();

    if (AuthProvider.instance.user == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    //  widget.memberName = AuthProvider.instance.user!.email!;
    //   widget.currID = widget._auth.user!.uid;
//thsi cahnge notifier may be redundant
    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        appBar: AppbarGestureDetector(widget: widget),
        body: ChangeNotifierProvider<AuthProvider>.value(
            value: AuthProvider.instance, child: _chatPageUI()),
      ),
    );
  }

  Widget _chatPageUI() {
    return Builder(builder: (context) {
      return Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          MessageListViewChatList(
            LVC: widget._LVC,
            chatID: widget.chatID,
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: MessageField(
                GK: widget.GK,
                chatID: widget.chatID,
                admins: widget.admins,
                isRecording: isRecording,
                txt: widget.txt,
              )),
        ],
      );
    });
  }
}

class AppbarGestureDetector extends StatelessWidget
    implements PreferredSizeWidget {
  const AppbarGestureDetector({
    super.key,
    required this.widget,
  });

  final ChatPage widget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        {
          navigationService.instance
              .navigateToRoute(MaterialPageRoute(builder: (context) {
            return ChatDataScreen(
              adminList: widget.admins,
              cahtId: widget.chatID,
            );
          }));
        }
      },
      child: AppBar(
        backgroundColor: LightTheme.primary,
        title: Text(widget.chatID, style: TextStyles.appBarText),
        centerTitle: true,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}
