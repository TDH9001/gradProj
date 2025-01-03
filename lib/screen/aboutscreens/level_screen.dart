import 'package:flutter/material.dart';
// import 'package:grad_proj/screen/navbar_screen.dart';
import 'package:grad_proj/screen/orgappbar.dart';
import 'component.dart';
import 'level1_screen.dart';
// import 'level2_screen.dart';
// import 'level3_screen.dart';
// import 'level4_screen.dart';

class LevelScreen extends StatefulWidget {
   LevelScreen({super.key,});
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
      // drawer: NavbarScreen(),
      body: Padding(padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Level', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                SizedBox(height: 20,),
                aboutButtonScreen(
                   text: 'Level 1 ',
                   onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Level1Screen()));
                       },
                    ),
            SizedBox(height: 20,),
                aboutButtonScreen(
              text: 'Level 2 ',
              onPressed: (){
             //   Navigator.push(context, MaterialPageRoute(builder: (context) => Level2Screen()));
              },
            ),
                SizedBox(height: 20,),
                aboutButtonScreen(
                  text: 'Level 3 ',
                  onPressed: (){
               //     Navigator.push(context, MaterialPageRoute(builder: (context) => Level3Screen()));
                  },
                ),
                SizedBox(height: 20,),
                aboutButtonScreen(
                  text: 'Level 4 ',
                  onPressed: (){
                 //   Navigator.push(context, MaterialPageRoute(builder: (context) => Level4Screen()));
                  },
                ),
                ],
                ),
        ],
          ),
      ),
    );
  }
}
