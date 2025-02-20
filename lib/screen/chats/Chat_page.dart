import 'dart:async';
import 'dart:io';

import 'package:appbar_dropdown/appbar_dropdown.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/Chats.dart';
import 'package:grad_proj/models/contact.dart';
import 'package:grad_proj/models/message.dart';
import 'package:grad_proj/screen/splash/splash_screen.dart';
import 'package:grad_proj/services/cloud_Storage_Service.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import '../../UI/colors.dart';
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

  @override
  State<ChatPage> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  double _height = 0;
  double _width = 0;
  late Future<List<String>> chatMembersFuture;

  @override
  void initState() {
    super.initState();
    chatMembersFuture = DBService.instance.getMembersOfChat(widget.chatID);
    widget._auth = context.read<AuthProvider>();
    //  widget.audioPlayer = AudioPlayer();
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
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
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
        appBar: AppBar(
          flexibleSpace: widget.admins.contains(AuthProvider.instance.user!.uid)
              ? FutureBuilder<List<String>>(
                  future: chatMembersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      List<String> hobbies = snapshot.data!;
                    }

                    List<String> ddt = snapshot.data!;

                    return StreamBuilder<List<contact>>(
                        stream: DBService.instance
                            .getMembersDataOfChat(ddt, widget.chatID),
                        builder: (_context, _snapshot) {
                          var _data = _snapshot.data;

                          //used to tell the builder to start from the end
                          if (_snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              _snapshot.connectionState ==
                                  ConnectionState.none) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (_snapshot.hasError) {
                            return Center(
                                child: Text(
                                    "Error: ${_snapshot.error} \n please update your data and the data field mising"));
                          }
                          for (int i = 0; i < snapshot.data!.length; i++) {
                            if (widget._auth.user!.uid ==
                                _snapshot.data![i].Id) {
                              widget.memberName =
                                  " ${_snapshot.data![i].FirstName} ${_snapshot.data![i].LastName}";
                            }
                          }
                          //jsut a place holder for the output methoud
                          return AppbarDropdown(
                            dropdownAppBarColor: ColorsApp.primary,
                            items: [
                              for (int i = 0; i < _snapshot.data!.length; i++)
                                [
                                  //returns a list where > [0] = the name and phone number
                                  //the [1]is the user ID in database to be give to make admin
                                  "${_snapshot.data![i].FirstName + " " + _snapshot.data![i].LastName + "     " + _snapshot.data![i].phoneNumber}",
                                  _snapshot.data![i].Id
                                ]
                            ],
                            title: (user) {
                              if (widget.admins.contains(user[1])) {
                                return user[0] +
                                    "\n already an admin \n does nothing when the button is pressed";
                              } else {
                                return user[0].toString() +
                                    "\nclick to make a group admin";
                              }
                            },
                            onClick: (user) {
                              try {
                                DBService.instance
                                    .makeAdmin(user[1], widget.chatID);
                              } catch (e) {
                                SnackBarService.instance.showsSnackBarError(
                                    text:
                                        'an error occured while making $user an admin \n please try again');
                                navigationService.instance.goBack();
                              }
                            },
                          );
                        });
                  })
              : SizedBox(),
          backgroundColor: ColorsApp.primary,
          title:
              Center(child: Text(widget.chatID, style: TextStyles.appBarText)),
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back, color: Colors.white),
          //   onPressed: () {
          //     //Navigator.pop(_context);
          //   },
          // ),
        ),
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

  Widget _messageTextField(TextEditingController txt) {
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
            color: ColorsApp.primary),
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

class VoiceBubble extends StatefulWidget {
  final String AudioAdress;
  final bool isOurs;
  final Timestamp ts;
  final String senderName;
  final AudioPlayer audioPlayer = AudioPlayer();

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
  bool Playing = false;
  Duration _duration = const Duration();
  Duration _position = const Duration();
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

  @override
  Widget build(BuildContext context) {
    dispose() {
      widget.audioPlayer.dispose();
    }

    List<Color> colorScheme = widget.isOurs
        ? [Color(0xFFA3BFE0), Color(0xFF769BC6)]
        : [
            Color(0xFFA3BFE0),
            Color(0xFF769BC6),
          ];
    widget.audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });
    widget.audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        setState(() => _position = _duration);
      });
    });

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
          SizedBox(height: 9),

          // Only the button will update when clicked
          Row(
            children: [
              IconButton(
                splashColor: Playing ? ColorsApp.primary : Colors.red,
                onPressed: () {
                  if (Playing) {
                    MediaService.instance.pauseAudio(widget.audioPlayer);
                    Playing = !Playing;
                    setState(() {});
                  } else {
                    MediaService.instance
                        .playAudio(widget.audioPlayer, widget.AudioAdress);
                    Playing = !Playing;
                    setState(() {});
                  }
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
                      await widget.audioPlayer
                          .seek(Duration(seconds: value.toInt()));
                      setState(() {});
                    },
                    min: 0,
                    max: _duration.inSeconds.toDouble(),
                    activeColor: ColorsApp.primary,
                    inactiveColor: ColorsApp.secondary,
                  ),
                  Text(_duration.toString())
                ],
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "${_weekmap[widget.ts.toDate().weekday]} ${_numMap[widget.ts.toDate().month]} ${widget.ts.toDate().day} , ${widget.ts.toDate().hour % 12}: ${widget.ts.toDate().minute % 60} ${widget.ts.toDate().hour < 12 ? "pm" : "am"}        ",
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
