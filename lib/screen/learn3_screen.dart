import 'package:flutter/material.dart';

class Learn3Screen extends StatelessWidget {
  const Learn3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
      [
        Image(image: AssetImage('assets/images/img.png'),),
        SizedBox(height: 20,),
        Text("sarah medhaat" ,
          style:TextStyle(
            fontSize: 20 ,
            color: Colors.black ,
            fontWeight: FontWeight.w400 ,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('uhugyguggygyg' ,
            style: TextStyle(
              fontSize: 16 ,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),



      ],
    );
  }
}

