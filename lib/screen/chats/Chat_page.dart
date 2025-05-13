import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_proj/screen/chats/chat_data_screen.dart';
import 'package:grad_proj/screen/chats/caht_cubit/caht_cubit.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/chat_page_message_field.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/message_list_view_chat_lsit.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import '../../UI/text_style.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../theme/light_theme.dart';

class ChatPage extends StatefulWidget {
  ChatPage(
      {super.key,
      required this.chatID,
      required this.admins,
      required this.leaders,
      required this.chatAccesability});
  final String id = "ChatPage";
  final List<String> leaders;
  final String chatAccesability;
  String chatID;
  GlobalKey<FormState> GK = GlobalKey<FormState>();
  String textTosend = "";
  final ScrollController _LVC = ScrollController();
  List<String> admins;
  //final TextEditingController txt = TextEditingController();
  //final record = AudioRecorder();
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
      child: BlocProvider(
        create: (context) => ChatCubit(),
        child: Scaffold(
          //resizeToAvoidBottomInset: false,
          appBar: AppbarGestureDetector(widget: widget),
          body: ChangeNotifierProvider<AuthProvider>.value(
              value: AuthProvider.instance, child: _chatPageUI()),
        ),
      ),
    );
  }

  Widget _chatPageUI() {
    return Builder(builder: (context) {
      return Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          MessageListViewChatList(
            admins: widget.admins,
            LVC: widget._LVC,
            chatID: widget.chatID,
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: MessageField(
                chatAccesability: widget.chatAccesability,
                leaders: widget.leaders,
                GK: widget.GK,
                chatID: widget.chatID,
                admins: widget.admins,
                isRecording: isRecording,
                //  txt: CahtCubit.get(context).txt // widget.txt,
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
              chatAccesability: widget.chatAccesability,
              leaders: widget.leaders,
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => navigationService.instance.goBack(),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}
