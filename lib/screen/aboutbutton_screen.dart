import 'package:flutter/material.dart';

class AboutbuttonScreen extends StatelessWidget {
  final String text;
  final VoidCallback onpressed;
  AboutbuttonScreen({super.key, required this.text, required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (){},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Color(0xff7AB2D3),
        ),
        child:  Text(
          text,
          style:  TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        )
    );
  }
}
