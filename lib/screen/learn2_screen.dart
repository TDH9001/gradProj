import 'package:flutter/material.dart';

class Learn2Screen extends StatelessWidget {
  const Learn2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
      [
        Image(image: AssetImage('assets/images/img2.png'),),
        SizedBox(height: 10,),
        Text("Create Table " ,
          style:TextStyle(
            fontSize: 18 ,
            color: Colors.black ,
            fontWeight: FontWeight.w400 ,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(" Create your own lecture schedule by choosing the subject and choosing the day and time of the lecture, and based on that, your schedule is built." ,
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