import 'package:flutter/material.dart';

import '../navbar_screen.dart';
import '../orgappbar.dart';

class Level4Screen extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
 Level4Screen({super.key});

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
            Text("Level 4 for computer science",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            Text('first term'),
            SizedBox(height: 20,),
            Text('math401'),
            SizedBox(height: 20,),
            Text('second term'),
            SizedBox(height: 20,),
            Text('math401'),
            SizedBox(height: 20,),
          ],
        ),
        ),
      ],
      ),
    );
  }
}
