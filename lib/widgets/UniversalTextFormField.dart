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
