import 'package:flutter/material.dart';

class LoginformScreen extends StatefulWidget {
  const LoginformScreen({super.key});
  //this code was refactored into
  //the "universalTextFormField" widget
  //where the widget became a form field taht can be used where ever we please
  //instead of relying on a certain screen

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
            //commented for inv
            buildInputform('Email', false),
            buildInputform('Password', true),
          ],
        ),
      ],
    );
  }

  Padding buildInputform(String lable, bool password) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: TextFormField(
        obscureText: password ? isObscure : false,
        decoration: InputDecoration(
            labelText: lable,
            labelStyle: const TextStyle(color: Colors.black),
            focusedBorder: const UnderlineInputBorder(
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
                        ? const Icon(
                            Icons.visibility_off,
                            color: Colors.black,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: Colors.black,
                          ),
                  )
                : null),
      ),
    );
  }
}
