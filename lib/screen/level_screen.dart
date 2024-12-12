import 'package:flutter/material.dart';
import 'package:grad_proj/screen/aboutbutton_screen.dart';
import 'package:grad_proj/screen/navbar_screen.dart';
import 'package:grad_proj/screen/orgappbar.dart';

import 'level1_screen.dart';
import 'level2_screen.dart';
import 'level3_screen.dart';
import 'level4_screen.dart';

class LevelScreen extends StatefulWidget {
  const LevelScreen({super.key});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: Orgappbar(scaffoldKey: scaffoldKey),
      drawer: NavbarScreen(),
      body: Padding(padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Level', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
              SizedBox(height: 20,),
        AboutbuttonScreen(
          text: 'Level 1 ',
          onpressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Level1Screen()));
          },
        ),
          SizedBox(height: 20,),
          AboutbuttonScreen(
            text: 'Level 2 ',
            onpressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Level2Screen()));
            },
          ),
              AboutbuttonScreen(
                text: 'Level 3 ',
                onpressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Level3Screen()));
                },
              ),
              AboutbuttonScreen(
                text: 'Level 4 ',
                onpressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Level4Screen()));
                },
              ),
    ],
    ),
      ),
    );
  }
}
