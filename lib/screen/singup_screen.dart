import 'package:flutter/material.dart';
import 'package:grad_proj/screen/singupform_screen.dart';

import 'login_screen.dart';

class  SingupScreen extends StatelessWidget {
  const  SingupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Create Account' ,
                  style: TextStyle(
                      fontSize: 20 ,
                      fontWeight: FontWeight.bold ,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text('Already have an account ?' ,
                      style: TextStyle(
                          fontSize: 15 ,
                          fontWeight: FontWeight.bold ,
                          color: Colors.black),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>  LoginScreen()
                        ));
                      },
                      child: Text('Login' ,
                        style: TextStyle(
                            fontSize: 15 ,
                            fontWeight: FontWeight.bold ,
                            color: Colors.black,
                            decoration: TextDecoration.underline
                        ),
                        ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(padding: EdgeInsets.all(8.0)
                  ,child: SingupformScreen(),),
            ],
          ),
        ],
      ),
    );
  }
}
