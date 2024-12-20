import 'package:flutter/material.dart';

class navigationService {
  static navigationService instance = navigationService();

  late GlobalKey<NavigatorState> navKey;

  navigationService() {
    navKey = GlobalKey<NavigatorState>();
  }
//still using the router
  Future<dynamic> navigateToReplacement(String _routeName) {
    return navKey.currentState!.pushReplacementNamed(_routeName);
    //kills current state > goes to the target
  }

  Future<dynamic> navigateTo(String _routeName) {
    return navKey.currentState!.pushNamed(_routeName);
    //opens new screen without killing Curr page
  }

  Future<dynamic> navigateToRoute(MaterialPageRoute _route) {
    //unknown
    return navKey.currentState!.push(_route);
  }
    // navigationService.instance.navigateToRoute(
    //                           MaterialPageRoute(builder: (_context) {
    //                         return ChatPage(
    //                             chatID: data[index].Chatid,
    //                             senderName: data[index].Sendername);
    //                       }));
    //                     },

  void goBack() {
    return navKey.currentState!.pop();
  }
}
