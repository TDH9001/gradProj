import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/navbar_screen.dart';

import 'orgappbar.dart';

class GpaScreen extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
   GpaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: Orgappbar(scaffoldKey: scaffoldKey),
      drawer: NavbarScreen(),


    );
  }
}
