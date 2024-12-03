import 'package:flutter/material.dart';

class Universaltextformfield extends StatefulWidget {
  Universaltextformfield({
    super.key,
    required this.label,
    required this.Password,
    required this.controller,
  });
//
  final String label;
  final bool Password;
  final TextEditingController controller;
  bool isObscure = true;
  @override
  State<Universaltextformfield> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Universaltextformfield> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: TextFormField(
        controller: widget.controller,
        autocorrect: false,
        //undetermidn cursor collor
        cursorColor: Colors.white,
        validator: (data) {
          if (widget.label == "login") {
            if (data == null || data.isEmpty) {
              return "empty field";
            } else if (!data.contains("@")) {
              return "the email msut contain an '@' symbol";
            } else if (data.indexOf("@") != data.lastIndexOf("@")) {
              return "you can only contain one instance of '@' in your email";
            }
          } //else if() {} //and more
        },
        obscureText: widget.Password ? widget.isObscure : false,
        decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: const TextStyle(color: Colors.black),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            suffixIcon: widget.Password
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        widget.isObscure = !widget.isObscure;
                      });
                    },
                    icon: widget.isObscure
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
