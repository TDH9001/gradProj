import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/Chats.dart';
import '../../services/DB-service.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key, required this.chatID, required this.senderName});
  final String id = "ChatPage";
  String chatID;
  String senderName;
  late AuthProvider _auth;

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
        height: _height * 0.85,
        child: StreamBuilder<ChatData>(
            stream: DBService.instance.getChat(this.widget.chatID),
            builder: (_context, _snapshot) {
              var _data = _snapshot.data;

              if (_snapshot.connectionState == ConnectionState.waiting ||
                  _snapshot.connectionState == ConnectionState.none) {
                return Center(child: CircularProgressIndicator());
              }
              if (_snapshot.hasError) {
                return Center(
                    child: Text(
                        "Error: ${_snapshot.error} \n please update your data and the data field mising"));
              }

              return ListView.builder(
                itemCount: _snapshot.data!.messages.length,
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
                        mainAxisAlignment: widget._auth.user!.uid ==
                                _data.messages[index].senderID
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          _MessageBubble(
                              ChatdataOfCurrentChat.messageContent.toString(),
                              widget._auth.user!.uid ==
                                  _data.messages[index].senderID,
                              _data.messages[index].timestamp,
                              _data.messages[index].senderName),
                        ],
                      ));
                },
              );
            }));
  }

  Widget _MessageBubble(
      String message, bool isOurs, Timestamp ts, String senderName) {
    List<Color> colorScheme = isOurs
        ? [Colors.blue, Color.fromARGB(42, 117, 188, 99)]
        : [Color.fromARGB(69, 69, 69, 1), Color.fromARGB(43, 43, 43, 1)];
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              colors: colorScheme,
              stops: [0.30, 0.70],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight)),
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: _height * 0.15,
      width: _width * 0.80,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment:
            isOurs ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(senderName),
          Text(message),
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
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          _messageTextField(txt),
          _sendMessageButton(_context),
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
          if (data == null || data.trim().isEmpty) {
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

  Widget _sendMessageButton(BuildContext context) {
    return Container(
      height: _height * 0.05,
      width: _width * 0.05,
      child: IconButton(
        icon: Icon(Icons.send),
        onPressed: () {},
      ),
    );
  }

  Widget _imageMessageButton() {
    return Container(
        height: _height * 0.05,
        width: _width * 0.05,
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.camera_enhance),
        ));
  }
}
