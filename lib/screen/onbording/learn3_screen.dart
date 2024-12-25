import 'package:flutter/material.dart';

class Learn3Screen extends StatelessWidget {
  const Learn3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
      [
        Image(image: AssetImage('assets/images/img3.png'),),
        SizedBox(height: 10,),
        Text(" Chatting " ,
          style:TextStyle(
            fontSize: 18 ,
            color: Colors.black ,
            fontWeight: FontWeight.w400 ,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("There will be a chat between the doctor of the subject that was recorded" ,
            style: TextStyle(
              fontSize: 12 ,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),



      ],
    );
  }
}

