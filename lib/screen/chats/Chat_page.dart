import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/Chats.dart';
import 'package:grad_proj/models/message.dart';
import 'package:grad_proj/services/cloud_Storage_Service.dart';
import 'package:grad_proj/services/media_service.dart';
import '../../services/DB-service.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  ChatPage({
    super.key,
    required this.chatID,
  });
  final String id = "ChatPage";
  String chatID;
  late AuthProvider _auth;
  GlobalKey<FormState> GK = GlobalKey<FormState>();
  String textTosend = "";
  final ScrollController _LVC = ScrollController();

  @override
  State<ChatPage> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  double _height = 0;
  double _width = 0;
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff7AB2D3),
        title: Text(widget.chatID),
      ),
      body: ChangeNotifierProvider<AuthProvider>.value(
          value: AuthProvider.instance, child: _chatPageUI()),
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
      height: _height * 0.75,
      child: StreamBuilder<ChatData>(
        stream: DBService.instance.getChat(this.widget.chatID),
        builder: (_context, _snapshot) {
          var _data = _snapshot.data;

          //used to tell the builder to start from the end
          if (_snapshot.connectionState == ConnectionState.waiting ||
              _snapshot.connectionState == ConnectionState.none) {
            return Center(child: CircularProgressIndicator());
          }
          if (_snapshot.hasError) {
            return Center(
                child: Text(
                    "Error: ${_snapshot.error} \n please update your data and the data field mising"));
          }
          //FIXME: possibly not working after a large enough amount of data is sent
          Timer(
            Duration(milliseconds: 50),
            () {
              widget._LVC.jumpTo(
                widget._LVC.position.maxScrollExtent * 2,
              ); //giving it a larger expented scrool amount
            },
          );

          return ListView.builder(
            itemCount: _snapshot.data!.messages.length, controller: widget._LVC,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            itemBuilder: (_Context, index) {
              var ChatdataOfCurrentChat = _data!.messages[index];

              return Padding(
                  padding: EdgeInsets.only(
                    top: 3,
                    bottom: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment:
                        widget._auth.user!.uid == _data.messages[index].senderID
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                    children: [
                      _data.messages[index].type == "text"
                          ? _MessageBubble(
                              message: ChatdataOfCurrentChat.messageContent
                                  .toString(),
                              isOurs: widget._auth.user!.uid ==
                                  _data.messages[index].senderID,
                              ts: _data.messages[index].timestamp,
                              senderName: _data.messages[index].senderName,
                            )
                          : _FileMessageBubble(
                              FileAdress: ChatdataOfCurrentChat.messageContent
                                  .toString(),
                              isOurs: widget._auth.user!.uid ==
                                  _data.messages[index].senderID,
                              ts: _data.messages[index].timestamp,
                              senderName: _data.messages[index].senderName,
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
    List<Color> colorScheme = isOurs
        ? [Colors.blue, Color.fromARGB(170, 143, 8, 227)]
        : [Color.fromARGB(197, 5, 140, 57), Color.fromARGB(170, 216, 30, 204)];
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
            height: 9,
          ),
          Text(message),
          SizedBox(
            height: 15,
          ),
          Text(
            timeago.format(ts.toDate()),
            style: TextStyle(color: Colors.black45),
          )
        ],
      ),
    );
  }

  Widget _FileMessageBubble(
      {required FileAdress,
      required bool isOurs,
      required Timestamp ts,
      required String senderName}) {
    List<Color> colorScheme = isOurs
        ? [Colors.blue, Color.fromARGB(170, 143, 8, 227)]
        : [Color.fromARGB(197, 5, 140, 57), Color.fromARGB(170, 216, 30, 204)];
    return Container(
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
            timeago.format(ts.toDate()),
            style: TextStyle(color: Colors.black45),
          )
        ],
      ),
    );
  }

  Widget MessageField(BuildContext _context) {
    TextEditingController txt = TextEditingController();
    return Container(
      height: _height * 0.1,
      width: _width,
      decoration: BoxDecoration(
          color: Color.fromARGB(43, 43, 43, 1),
          borderRadius: BorderRadius.circular(22)),
      margin: EdgeInsets.symmetric(
          horizontal: _width * 0.02, vertical: _height * 0.02),
      child: Form(
          key: widget.GK,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _messageTextField(txt),
              _sendMessageButton(_context, txt),
              _imageMessageButton()
            ],
          )),
    );
  }

  Widget _messageTextField(TextEditingController txt) {
    return SizedBox(
      width: _width * 0.5,
      child: TextFormField(
        controller: txt,
        validator: (data) {
          if (data == null) {
            return "empty field";
          }
        },
        cursorColor: Colors.black,
        autocorrect: false,
        decoration:
            InputDecoration(border: InputBorder.none, hintText: "type please"),
      ),
    );
  }

  Widget _sendMessageButton(
    BuildContext context,
    TextEditingController txt,
  ) {
    return Container(
      height: _height * 0.1,
      width: _width * 0.09,
      child: IconButton(
        icon: Icon(Icons.send),
        onPressed: () async {
          if (widget.GK.currentState!.validate()) {
            // txt.text.trim();
            DBService.instance.addMessageInChat(
                chatId: widget.chatID,
                messageData: Message(
                    senderID: widget._auth.user!.uid,
                    messageContent: txt.text.trim(),
                    timestamp: Timestamp.now(),
                    type: "text",
                    //TODO: here after making databse > make it so here it sends the current user data in DB
                    senderName: widget._auth.user!.email ?? "how is it null"));
          }
          txt.text = "";
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Widget _imageMessageButton() {
    return Container(
        height: _height * 0.1,
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
                        senderName:
                            widget._auth.user!.email ?? "how is it null"));
              }
              FocusScope.of(context).unfocus();
            },
            icon: Icon(Icons.camera_enhance)));
  }
}
