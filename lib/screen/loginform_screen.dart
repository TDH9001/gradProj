import 'package:flutter/material.dart';

class LoginformScreen extends StatefulWidget {
  const LoginformScreen({super.key});

  @override
  State<LoginformScreen> createState() => _LoginformScreenState();
}

class _LoginformScreenState extends State<LoginformScreen> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            buildInputform('Email', false),
            buildInputform('Password', true),
          ],
        ),
      ],
    );
  }

  Padding buildInputform(String lable, bool password) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: TextFormField(
        obscureText: password ? isObscure : false,
        decoration: InputDecoration(
            labelText: lable,
            labelStyle: TextStyle(color: Colors.black),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            suffixIcon: password
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    icon: isObscure
                        ? Icon(
                            Icons.visibility_off,
                            color: Colors.black,
                          )
                        : Icon(
                            Icons.visibility,
                            color: Colors.black,
                          ),
                  )
                : null),
      ),

    );
  }
}
