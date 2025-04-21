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
import 'package:grad_proj/features/chats/chat_data_screen.dart';
import 'package:grad_proj/features/splash/splash_screen.dart';
import 'package:grad_proj/services/cloud_Storage_Service.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import '../../providers/theme_provider.dart';
import '../../theme/dark_theme_colors.dart';
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
  late AuthProvider _auth;
  GlobalKey<FormState> GK = GlobalKey<FormState>();
  String textTosend = "";
  final ScrollController _LVC = ScrollController();
  List<String> admins;
  final TextEditingController txt = TextEditingController();
  late String memberName;
  final record = AudioRecorder();
  bool isRecording = false;
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
  //late Future<List<String>> chatMembersFuture;

  @override
  void initState() {
    super.initState();
    // chatMembersFuture = DBService.instance.getMembersOfChat(widget.chatID);
    widget._auth = context.read<AuthProvider>();

    //  _audioPlayer = AudioPlayer();
    // Call the method during initialization
  }

  void startRecord(AudioRecorder rec) async {
    var location = await getApplicationDocumentsDirectory();
    String fileName = Uuid().v4();
    if (await rec.hasPermission()) {
      await rec.start(RecordConfig(), path: location.path + fileName + '.m4a');
      setState(() {
        widget.isRecording = true;
      });
      print("recordStarted ");
    }
  }

  Future<String?> stopRecord(AudioRecorder rec) async {
    String? finalPath = await rec.stop();
    setState(() {
      widget.isRecording = false;
    });
    print("record stopped");
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
    print(MediaService.instance.getHeight());
    print(MediaQuery.sizeOf(context).height);
    _width = MediaService.instance.getWidth();
    //widget._auth = context.read<AuthProvider>();

    if (AuthProvider.instance.user == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    widget.memberName = AuthProvider.instance.user!.email!;
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
      widget._auth = Provider.of<AuthProvider>(context);
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

          // print(widget.admins);
          // print(widget._auth.user!.uid);
          //reversing the list
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
                        widget._auth.user!.uid == bubbles[index].senderID
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                    children: [
                      bubbles[index].type == "text"
                          ? _MessageBubble(
                              message: ChatdataOfCurrentChat.messageContent
                                  .toString(),
                              isOurs: widget._auth.user!.uid ==
                                  bubbles[index].senderID,
                              ts: bubbles[index].timestamp,
                              senderName: bubbles[index].senderName,
                            )
                          : bubbles[index].type == "image"
                              ? _imageMessageBubble(
                                  FileAdress: ChatdataOfCurrentChat
                                      .messageContent
                                      .toString(),
                                  isOurs: widget._auth.user!.uid ==
                                      bubbles[index].senderID,
                                  ts: bubbles[index].timestamp,
                                  senderName: bubbles[index].senderName,
                                )
                              : VoiceBubble(
                                  AudioAdress: ChatdataOfCurrentChat
                                      .messageContent
                                      .toString(),
                                  isOurs: widget._auth.user!.uid ==
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

  Widget _MessageBubble(
      {required String message,
      required bool isOurs,
      required Timestamp ts,
      required String senderName}) {
    var _numMap = {
      1: "jan ",
      2: "feb",
      3: "mar",
      4: 'apr',
      5: "may",
      6: "jun",
      7: "jul",
      8: "aug",
      9: "sep",
      10: "oct",
      11: "nov",
      12: "dec"
    };
    var _weekmap = {
      6: "saturday",
      7: 'sunday',
      1: "monday",
      2: "tuesday",
      3: "wednesday",
      4: "thursday",
      5: "friday"
    };
    List<Color> colorScheme = isOurs
        ? [Color(0xFFA3BFE0), Color(0xFF769BC6)]
        : [Color(0xFF769BC6), Color(0xFFA3BFE0)];
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              colors: colorScheme,
              stops: [0.40, 0.70],
              begin: isOurs ? Alignment.bottomLeft : Alignment.bottomRight,
              end: isOurs ? Alignment.topRight : Alignment.topLeft)),
      padding: EdgeInsets.symmetric(horizontal: 15),
      // height:
      //     _height * 0.13 + ((message.length * 3.5 + senderName.length) / 10),
      width: _width * 0.80,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment:
            isOurs ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(senderName),
          SizedBox(
            height: 5,
          ),
          Text(message),
          // SizedBox(
          //   height: 15,
          // ),
          Text(
            "${_weekmap[ts.toDate().weekday]} ${_numMap[ts.toDate().month]} ${ts.toDate().day} , ${ts.toDate().hour % 12}: ${ts.toDate().minute % 60} ${ts.toDate().hour < 12 ? "pm" : "am"}        ",
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }

  Widget _imageMessageBubble(
      {required FileAdress,
      required bool isOurs,
      required Timestamp ts,
      required String senderName}) {
    var _numMap = {
      1: "jan ",
      2: "feb",
      3: "mar",
      4: 'apr',
      5: "may",
      6: "jun",
      7: "jul",
      8: "aug",
      9: "sep",
      10: "oct",
      11: "nov",
      12: "dec"
    };
    var _weekmap = {
      6: "saturday",
      7: 'sunday',
      1: "monday",
      2: "tuesday",
      3: "wednesday",
      4: "thursday",
      5: "friday"
    };
    List<Color> colorScheme = isOurs
        ? [Color(0xFFA3BFE0), Color(0xFF769BC6)]
        : [
            Color(0xFFA3BFE0),
            Color(0xFF769BC6),
          ];
    return GestureDetector(
      onTap: () => showDialog(
          context: context,
          builder: (_) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Image(image: NetworkImage(FileAdress)))),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
                colors: colorScheme,
                stops: [0.40, 0.70],
                begin: isOurs ? Alignment.bottomLeft : Alignment.bottomRight,
                end: isOurs ? Alignment.topRight : Alignment.topLeft)),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment:
              isOurs ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(senderName),
            SizedBox(
              height: 9,
            ),
            Container(
              height: _height * 0.45,
              width: _width * 0.6,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage(FileAdress), fit: BoxFit.fill)),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "${_weekmap[ts.toDate().weekday]} ${_numMap[ts.toDate().month]} ${ts.toDate().day} , ${ts.toDate().hour % 12}: ${ts.toDate().minute % 60} ${ts.toDate().hour < 12 ? "pm" : "am"}        ",
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  Widget MessageField(BuildContext _context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    return Container(
      // height: _height * 0.1,
      width: _width,
      decoration: BoxDecoration(
          color:  isDarkMode? DarkThemeColors.background : Colors.grey[200],
          borderRadius: BorderRadius.circular(22)),
      margin: EdgeInsets.symmetric(
          horizontal: _width * 0.02, vertical: _height * 0.02),
      child: Form(
          key: widget.GK,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: widget.admins.contains(widget._auth.user!.uid)
                ? [
                    _messageTextField(widget.txt),
                    _sendMessageButton(_context, widget.txt),
                    _imageMessageButton()
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
                ? (widget.isRecording ? Icons.stop : Icons.mic)
                : Icons.send,
            color: LightTheme.primary),
        onPressed: () async {
          if (widget.txt.text.isEmpty) {
            if (!widget.isRecording) {
              startRecord(widget.record);
            } else {
              String? VoiceUrl = await stopRecord(widget.record);
              DBService.instance.addMessageInChat(
                  chatId: widget.chatID,
                  messageData: Message(
                      senderID: widget._auth.user!.uid,
                      messageContent: VoiceUrl!,
                      timestamp: Timestamp.now(),
                      type: "voice",
                      //TODO: here after making databse > make it so here it sends the current user data in DB
                      senderName: widget.memberName));
            }
          } else if (widget.GK.currentState!.validate() &&
              widget.txt.text.isNotEmpty) {
            // txt.text.trim();
            DBService.instance.addMessageInChat(
                chatId: widget.chatID,
                messageData: Message(
                    senderID: widget._auth.user!.uid,
                    messageContent: txt.text.trim(),
                    timestamp: Timestamp.now(),
                    type: "text",
                    //TODO: here after making databse > make it so here it sends the current user data in DB
                    senderName: widget.memberName));
          }
          txt.text = "";
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Widget _imageMessageButton() {
    return SizedBox(
        height: _height * 0.07,
        width: _width * 0.09,
        child: IconButton(
            onPressed: () async {
              var _image = await MediaService.instance.getImageFromLibrary();
              if (_image != null) {
                var _resilt = await CloudStorageService.instance.uploadChatFile(
                    uid: widget._auth.user!.uid, fileData: _image);
                var _imageurl = await _resilt!.ref.getDownloadURL();
                await DBService.instance.addMessageInChat(
                    chatId: widget.chatID,
                    messageData: Message(
                        senderID: widget._auth.user!.uid,
                        messageContent: _imageurl,
                        timestamp: Timestamp.now(),
                        type: "image",
                        //TODO: here after making databse > make it so here it sends the current user data in DB
                        senderName: widget.memberName));
              }
              FocusScope.of(context).unfocus();
            },
            icon: Icon(Icons.camera_alt)));
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

class VoiceBubble extends StatefulWidget {
  final String AudioAdress;
  final bool isOurs;
  final Timestamp ts;
  final String senderName;

  VoiceBubble({
    required this.AudioAdress,
    required this.isOurs,
    required this.ts,
    required this.senderName,
  });

  @override
  _VoiceMessageBubbleState createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceBubble> {
  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  bool Playing = false;
  late AudioPlayer _audioPlayer;
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool _isAudioLoaded = false;

  final _numMap = {
    1: "jan",
    2: "feb",
    3: "mar",
    4: 'apr',
    5: "may",
    6: "jun",
    7: "jul",
    8: "aug",
    9: "sep",
    10: "oct",
    11: "nov",
    12: "dec"
  };
  final _weekmap = {
    6: "saturday",
    7: 'sunday',
    1: "monday",
    2: "tuesday",
    3: "wednesday",
    4: "thursday",
    5: "friday"
  };

  Future<void> _loadAudio() async {
    if (!_isAudioLoaded) {
      try {
        await _audioPlayer.setSourceUrl(widget.AudioAdress);
        Duration? d = await _audioPlayer.getDuration();
        if (d != null) {
          setState(() {
            _duration = d;
            _isAudioLoaded = true;
          });
        }
      } catch (e) {
        print("Error loading audio: $e");
      }
    }
  }

  void _togglePlayPause() async {
    if (!_isAudioLoaded) await _loadAudio();

    if (Playing) {
      MediaService.instance.pauseAudio(_audioPlayer);
    } else {
      if (_position > Duration.zero) {
        MediaService.instance.resumeAudio(_audioPlayer);
      } else {
        MediaService.instance.playAudio(_audioPlayer, widget.AudioAdress);
      }
    }
    setState(() {
      Playing = !Playing;
    });
  }

  @override
  dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  initState() {
    _audioPlayer = AudioPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _audioPlayer.onPlayerComplete.listen((D) {
      setState(() {
        _position = Duration.zero;
        Playing = !Playing;
      });
      MediaService.instance.pauseAudio(_audioPlayer);
    });
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });
    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });
    List<Color> colorScheme = widget.isOurs
        ? [Color(0xFFA3BFE0), Color(0xFF769BC6)]
        : [
            Color(0xFFA3BFE0),
            Color(0xFF769BC6),
          ];

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              colors: colorScheme,
              stops: [0.40, 0.70],
              begin:
                  widget.isOurs ? Alignment.bottomLeft : Alignment.bottomRight,
              end: widget.isOurs ? Alignment.topRight : Alignment.topLeft)),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment:
            widget.isOurs ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(widget.senderName),
          Row(
            children: [
              IconButton(
                splashColor: Playing ? LightTheme.primary : Colors.red,
                onPressed: () {
                  _togglePlayPause();
                },
                icon: Icon(
                  Playing ? Icons.pause : Icons.play_arrow,
                ),
              ),
              Column(
                children: [
                  Slider(
                    value: _position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      try {
                        await _audioPlayer
                            .seek(Duration(seconds: value.toInt()));

                        setState(() {});
                      } catch (e) {
                        print(e);
                      }
                    },
                    min: 0,
                    max: _duration.inSeconds.toDouble() > 0.0
                        ? _duration.inSeconds.toDouble()
                        : 1.0,
                    activeColor: LightTheme.primary,
                    inactiveColor: LightTheme.secondary,
                  ),
                  Text("${_position.toString()} / ${_duration.toString()}")
                ],
              )
            ],
          ),
          // SizedBox(
          //   height: 6,
          // ),
          Text(
            "${_weekmap[widget.ts.toDate().weekday]} ${_numMap[widget.ts.toDate().month]} ${widget.ts.toDate().day} , ${widget.ts.toDate().hour % 12}: ${widget.ts.toDate().minute % 60} ${widget.ts.toDate().hour < 12 ? "pm" : "am"}        ",
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
