import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/message.dart';
import 'package:grad_proj/services/DB-service.dart';

class ChatPopupMenuBuilderButons {
  static Widget popupMenuBuilder(
      CustomPopupMenuController cst, String ChatId, Message message) {
    return Container(
      // height: MediaService.instance.getHeight() * 0.05,
      color: Colors.blueGrey,
      child: Wrap(
        direction: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      DBService.instance.deleteMessageFromChat(ChatId, message);
                      cst.hideMenu();
                    }),
                Text("delete"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () {
                      cst.hideMenu();
                    }),
                Text("copy text")
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                IconButton(
                    icon: Icon(Icons.star_border_purple500_outlined),
                    onPressed: () {
                      cst.hideMenu();
                    }),
                Text("favourite")
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                IconButton(
                    icon: Icon(Icons.push_pin_outlined),
                    onPressed: () {
                      cst.hideMenu();
                    }),
                Text("pin feed")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
