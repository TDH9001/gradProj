import 'package:flutter/material.dart';
import 'package:grad_proj/screen/navbar_screen.dart';
import 'package:grad_proj/screen/orgappbar.dart';

class Level2Screen extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
   Level2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: Orgappbar(scaffoldKey: scaffoldKey),
      drawer: NavbarScreen(),
      body: ListView(
        children:[ Padding(padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Level 2",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            Text('comp201'),
           ],
        ),
        ),
      ],
      ),
    );
  }
}
