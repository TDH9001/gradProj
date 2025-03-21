import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';

import '../theme/light_theme.dart';

class SnackBarService {
  // to use aon a certain page > at the top  > add the following
  //    SnackBarService.instance.buildContext = context;
//to the list of vars > so when a func summosn ti > the context is auto provided
  late BuildContext _buildContext;

  static SnackBarService instance = SnackBarService();

  SnackBarService() {}
  set buildContext(BuildContext _context) {
    _buildContext = _context;
  }

  void showsSnackBarError({required String text}) {
    ScaffoldMessenger.of(_buildContext).showSnackBar(SnackBar(
        content: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2)));
  }

  void showsSnackBarSucces({required String text}) {
    ScaffoldMessenger.of(_buildContext).showSnackBar(SnackBar(
        content: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: LightTheme.primary,
        duration: Duration(seconds: 2)));
  }
}