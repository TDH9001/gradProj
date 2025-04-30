import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:appbar_dropdown/appbar_dropdown.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/Chats.dart';
import 'package:grad_proj/models/contact.dart';
import 'package:grad_proj/models/message.dart';
import 'package:grad_proj/screen/chats/chat_data_screen.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/image_chat_bubble.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/image_message_button.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/message_field_bubble.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/voice_chat_bubble.dart';
import 'package:grad_proj/screen/splash/splash_screen.dart';
import 'package:grad_proj/services/caching_service/hive_cashing_service.dart';
import 'package:grad_proj/services/cloud_Storage_Service.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import '../../theme/light_theme.dart';
import '../../UI/text_style.dart';
import '../../services/DB-service.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key, required this.chatID, required this.admins});
  final String id = "ChatPage";
  String chatID;
  //late AuthProvider _auth;
  GlobalKey<FormState> GK = GlobalKey<FormState>();
  String textTosend = "";
  final ScrollController _LVC = ScrollController();
  List<String> admins;
  final TextEditingController txt = TextEditingController();
  final record = AudioRecorder();
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

    // chatMembersFuture = DBService.instance.getMembersOfChat(widget.chatID);

    //  _audioPlayer = AudioPlayer();
    // Call the method during initialization
  }

  void startRecord(AudioRecorder rec) async {
    var location = await getApplicationDocumentsDirectory();
    String fileName = Uuid().v4();
    if (await rec.hasPermission()) {
      await rec.start(RecordConfig(), path: location.path + fileName + '.m4a');
      setState(() {
        isRecording = true;
      });
    }
  }

  Future<String?> stopRecord(AudioRecorder rec) async {
    String? finalPath = await rec.stop();
    setState(() {
      isRecording = false;
    });
    if (finalPath != null) {
      var _result = await CloudStorageService.instance.uploadVoice(
          uid: AuthProvider.instance.user!.uid, fileData: File(finalPath));
      return await _result!.ref.getDownloadURL();
    } else {
      SnackBarService.instance
          .showsSnackBarError(text: "could not uplaod the file");
    }
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
          _messageLsitView(),
          Align(
              child: MessageField(context), alignment: Alignment.bottomCenter),
        ],
      );
    });
  }

  Widget _messageLsitView() {
    return Container(
      height: _height * 0.815,
      child: StreamBuilder<ChatData>(
        stream: DBService.instance.getChat(this.widget.chatID),
        builder: (_context, _snapshot) {
          var _data = _snapshot.data;

          //used to tell the builder to start from the end
          if (_snapshot.connectionState == ConnectionState.waiting ||
              _snapshot.connectionState == ConnectionState.none) {
            return Center(
                child: Image(image: AssetImage('assets/images/splash.png')));
          }
          if (_snapshot.hasError) {
            return Center(
                child: Text(
                    "Error: ${_snapshot.error} \n please update your data and the data field mising"));
          }
          //FIXME: possibly not working after a large enough amount of data is sent
          List bubbles = _data!.messages.reversed.toList();
          return ListView.builder(
            itemCount: _snapshot.data!.messages.length, controller: widget._LVC,
            physics: BouncingScrollPhysics(), reverse: true,
            scrollDirection: Axis.vertical,
            // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            itemBuilder: (_Context, index) {
              var ChatdataOfCurrentChat = bubbles[index];

              return Padding(
                  padding: EdgeInsets.only(
                    top: 3,
                    bottom: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment:
                        HiveCashingService.getUserContactData().id ==
                                bubbles[index].senderID
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                    children: [
                      bubbles[index].type == "text"
                          ? chatMessageBubble(
                              message: ChatdataOfCurrentChat.messageContent
                                  .toString(),
                              isOurs:
                                  HiveCashingService.getUserContactData().id ==
                                      bubbles[index].senderID,
                              ts: bubbles[index].timestamp,
                              senderName: bubbles[index].senderName,
                            )
                          : bubbles[index].type == "image"
                              ? ImageMessageBubble(
                                  FileAdress: ChatdataOfCurrentChat
                                      .messageContent
                                      .toString(),
                                  isOurs:
                                      HiveCashingService.getUserContactData()
                                              .id ==
                                          bubbles[index].senderID,
                                  ts: bubbles[index].timestamp,
                                  senderName: bubbles[index].senderName,
                                )
                              : VoiceBubble(
                                  AudioAdress: ChatdataOfCurrentChat
                                      .messageContent
                                      .toString(),
                                  isOurs:
                                      HiveCashingService.getUserContactData()
                                              .id ==
                                          bubbles[index].senderID,
                                  ts: bubbles[index].timestamp,
                                  senderName: bubbles[index].senderName,
                                ),
                    ],
                  ));
            },
          );
        },
      ),
    );
  }

  Widget MessageField(BuildContext _context) {
    print(widget.admins);
    print(HiveCashingService.getUserContactData().id.trim());
    return Container(
      // height: _height * 0.1,
      width: _width,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(22)),
      margin: EdgeInsets.symmetric(
          horizontal: _width * 0.02, vertical: _height * 0.02),
      child: Form(
          key: widget.GK,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: widget.admins
                    .contains(HiveCashingService.getUserContactData().id.trim())
                ? [
                    _messageTextField(widget.txt),
                    _sendMessageButton(_context, widget.txt),
                    ImageMessageButton(
                      chatID: widget.chatID,
                    )
                  ]
                : [
                    Text("only admins can contribute to this chat"),
                  ],
          )),
    );
  }

  Widget _messageTextField(final TextEditingController txt) {
    return SizedBox(
      width: _width * 0.5,
      child: TextFormField(
        controller: txt,
        onTap: () {
          txt.text += " ";
        },
        validator: (data) {
          if (data == null || data.trim().isEmpty) {
            return "The message cannot be empty";
          }
          return null;
        },
        cursorColor: Colors.black,
        autocorrect: false,
        decoration: InputDecoration(
            border: InputBorder.none, hintText: "type Massage ... "),
      ),
    );
  }

  Widget _sendMessageButton(
    BuildContext context,
    TextEditingController txt,
  ) {
    return SizedBox(
      // height: _height * 0.1,
      width: _width * 0.09,
      child: IconButton(
        icon: Icon(
            widget.txt.text.isEmpty
                ? (isRecording ? Icons.stop : Icons.mic)
                : Icons.send,
            color: LightTheme.primary),
        onPressed: () async {
          if (widget.txt.text.isEmpty) {
            if (isRecording) {
              startRecord(widget.record);
            } else {
              String? VoiceUrl = await stopRecord(widget.record);
              DBService.instance.addMessageInChat(
                  chatId: widget.chatID,
                  messageData: Message(
                      senderID: HiveCashingService.getUserContactData().id,
                      messageContent: VoiceUrl!,
                      timestamp: Timestamp.now(),
                      type: "voice",
                      //TODO: here after making databse > make it so here it sends the current user data in DB
                      senderName:
                          "${HiveCashingService.getUserContactData().firstName} ${HiveCashingService.getUserContactData().lastName}"));
            }
          } else if (widget.GK.currentState!.validate() &&
              widget.txt.text.isNotEmpty) {
            // txt.text.trim();
            DBService.instance.addMessageInChat(
                chatId: widget.chatID,
                messageData: Message(
                    senderID: HiveCashingService.getUserContactData().id,
                    messageContent: txt.text.trim(),
                    timestamp: Timestamp.now(),
                    type: "text",
                    //TODO: here after making databse > make it so here it sends the current user data in DB
                    senderName:
                        "${HiveCashingService.getUserContactData().firstName} ${HiveCashingService.getUserContactData().lastName}"));
          }
          txt.text = "";
          FocusScope.of(context).unfocus();
        },
      ),
    );
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
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);
}
