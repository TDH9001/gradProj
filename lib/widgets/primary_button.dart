import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.buttontext});
  final String buttontext;
   //PrimaryButton({required this.buttontext});

  @override
  Widget build(BuildContext context) {
    return Container
      (
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.08,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),color: Color(0xff7AB2D3)),
      child: Text(buttontext,style: TextStyle(color: Colors.white,fontSize: 20),),



    );
  }
}
