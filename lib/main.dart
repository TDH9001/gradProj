import 'package:flutter/material.dart';

void main() {
  runApp(homePage());
}

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Column(
        children: [
          MaterialButton(
            onPressed: () {},
            child: Text("damaging attack"),
            color: Colors.green,
          ),
        ],
      ),
    ));
  }
}
