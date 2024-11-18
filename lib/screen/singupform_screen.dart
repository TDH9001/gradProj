import 'package:flutter/material.dart';

class SingupformScreen extends StatefulWidget {
  const SingupformScreen({super.key});

  @override
  State<SingupformScreen> createState() => _SingupformScreenState();
}

class _SingupformScreenState extends State<SingupformScreen> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            buildInputForm('First Name', false),
            buildInputForm('Last Name', false),
            buildInputForm('Email', false),
            buildInputForm('Phone Number', false),
            buildInputForm('Password', true),
            buildInputForm('Confirm Password', true),
          ],
        ),
      ],
    );
  }

  Padding buildInputForm(String hint, bool password) {
    return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 5,
        ),
        child: TextFormField(
          obscureText: password ? _isObscure : false,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.black),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            suffixIcon: password
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: _isObscure
                        ? Icon(Icons.visibility_off, color: Colors.black)
                        : Icon(
                            Icons.visibility,
                            color: Colors.black,
                          ),
                  )
                : null,
          ),
        ));
  }
}
