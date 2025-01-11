import 'package:flutter/material.dart';

import '../UI/colors.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton({super.key, required this.buttontext, required this.func});
  final String buttontext;
  VoidCallback func;
  //PrimaryButton({required this.buttontext});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
    height: 50,
     width: 300,
     child:  ElevatedButton(
      onPressed: func,
      style: ElevatedButton.styleFrom(
        backgroundColor:  ColorsApp.primary,
        // padding: const EdgeInsets.symmetric(vertical: 16),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(8),
        // ),
      ),
      child: Text(
      buttontext,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
     ),
    );
  }
}
