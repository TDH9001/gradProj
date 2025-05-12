// import 'package:flutter/material.dart';
// import 'package:grad_proj/services/media_service.dart';
// import 'dart:developer' as dev;

// class ChatsScreenSearchBar extends StatefulWidget {
//   ChatsScreenSearchBar({super.key, required this.txt});
//   static String chatSearch = "";

//   @override
//   State<ChatsScreenSearchBar> createState() => _ChatsScreenSearchBarState();
// }

// class _ChatsScreenSearchBarState extends State<ChatsScreenSearchBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         width: double.infinity,
//         height: MediaService.instance.getHeight() * 0.06,
//         child: TextFormField(
//           onChanged: (str) {
//             ChatsScreenSearchBar.chatSearch = str;
//             // dev.log(ChatsScreenSearchBar.chatSearch = str);
//             //   setState(() {});
//           },
//           controller: widget.txt,
//           keyboardType: TextInputType.text,
//           autocorrect: false,
//           decoration: InputDecoration(
//             //label: Text("Search"),
//             icon: Icon(Icons.search),
//             labelText: "Search for courses",
//             focusedBorder: const UnderlineInputBorder(
//               borderSide: BorderSide(color: Colors.black),
//             ),
//           ),
//         ));
//   }
// }
