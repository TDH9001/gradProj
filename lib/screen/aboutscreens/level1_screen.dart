import 'package:flutter/material.dart';
import 'package:grad_proj/screen/navbar_screen.dart';
import 'package:grad_proj/screen/orgappbar.dart';

class Level1Screen extends StatelessWidget {
  final Map<String, List<String>> courses =
  {
    'First Tirm':['SAFS101', ' HUM101','math101' , ' PHYS101' , 'CHEM101' , 'CHEM103' , 'STAT101'],
    'Second Tirm':['ENG102','INCO102' , ' MATH102' , 'MATH104' , 'COMP102' , 'COMP104', 'COMP106'],
  };
  final scaffoldKey = GlobalKey<ScaffoldState>();
   Level1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: Orgappbar(scaffoldKey: scaffoldKey),
      drawer: NavbarScreen(),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Column(
            children: [
              Text(
                "Level 1 for Computer Science",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Courses in First Term:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ...courses['First Term']!.map((course) => Text(course)).toList(),
              SizedBox(height: 20),
              Text(
                'Courses in Second Term:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ...courses['Second Term']!.map((course) => Text(course)).toList(),
            ],
          ),
        ],
      ),
    );
  }
}