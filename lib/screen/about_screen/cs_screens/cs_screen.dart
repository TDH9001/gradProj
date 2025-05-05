import 'package:flutter/material.dart';
import 'package:grad_proj/widgets/cs_listview.dart';
import 'package:grad_proj/widgets/orgappbar.dart';

class CsScreen extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
   CsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Orgappbar(scaffoldKey: scaffoldKey, title: 'Computer Science',
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(padding: const EdgeInsets.all(16.0), child: CsListview(),),

    );
  }
}
