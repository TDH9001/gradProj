import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/Chats.dart';
import 'package:grad_proj/services/media_service.dart';

class ChatsScreenSearchBar extends StatefulWidget {
  ChatsScreenSearchBar({super.key, required this.txt});
  final TextEditingController txt;
  static List<ChatSnipits> chatSearch = [];

  @override
  State<ChatsScreenSearchBar> createState() => _ChatsScreenSearchBarState();
}

class _ChatsScreenSearchBarState extends State<ChatsScreenSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: MediaService.instance.getHeight() * 0.06,
        child: TextFormField(
          onChanged: (str) {
            if (mounted) {
              setState(() {
                widget.txt.text = str;
              });
            }
          },
          controller: widget.txt,
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
        ));
  }
}
