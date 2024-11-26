import 'package:flutter/material.dart';

class ResetformScreen extends StatelessWidget {
  const ResetformScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding (
      padding: EdgeInsets.only(top: 20),
      child: TextFormField(
        decoration: InputDecoration(
            hintText: 'Email',
            hintStyle: TextStyle(color: Colors.black),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black))),
      ),
    );
  }
}
