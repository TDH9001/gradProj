import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton({super.key, required this.buttontext, required this.func});
  final String buttontext;
  VoidCallback func;
  //PrimaryButton({required this.buttontext});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: Color(0xff7AB2D3)),
      child: MaterialButton(
        height: MediaQuery.of(context).size.height * 0.08,
        minWidth: double.infinity,
        onPressed: func,
        child: Text(
          buttontext,
          style: const TextStyle(
              color: Colors.white, fontSize: 35, fontWeight: FontWeight.w400),
        ),
      ),
    ); //saaaaaaaaaaaaaaaaa
  }
}
