
import 'package:flutter/material.dart';

class Learn1Screen extends StatelessWidget {
  const Learn1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
     // mainAxisAlignment: MainAxisAlignment.center,
      children:
      [
        Image(image: AssetImage('assets/images/img1.png'),),
        //SizedBox(height: 10,),
        Center(
          child: Text("SciConnect" ,
            style:TextStyle(
              fontSize: 18 ,
              color: Colors.black ,
              fontWeight: FontWeight.w400 ,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Text(" a centralized academic management app designed for students at the Faculty of Science, Ain Shams University. It simplifies schedule organization, course-related communication, and access to essential resources. The app also offers collaborative spaces for graduation projects, helping students and professors stay organized and updated in real time using Flutter and Firebase technology." ,
            style: TextStyle(
              fontSize: 12 ,
              color: Colors.black,
            ),
              textAlign: TextAlign.center,
            ),
          ),
        ),



      ],
    );
  }
}
