import 'package:flutter/material.dart';
import 'package:grad_proj/screen/navbar_screen.dart';
import 'package:grad_proj/screen/orgappbar.dart';

class Level3Screen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Level3Screen({super.key});

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
            Text("Level 3 for computer science",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            Text('first term'),
            SizedBox(height: 20,),
            Text('math302'),
            SizedBox(height: 20,),
            Text('second term'),
            SizedBox(height: 20,),
            Text('math302'),
            SizedBox(height: 20,),
          ],
        ),
        ),
    ],
      ),
    );
  }
}
