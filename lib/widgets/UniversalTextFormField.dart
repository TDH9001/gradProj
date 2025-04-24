import 'package:flutter/material.dart';

class Universaltextformfield extends StatefulWidget {
  Universaltextformfield(
      {super.key,
      required this.label,
      required this.Password,
      required this.controller,
      this.keaboardType = TextInputType.text});
//
  final String label;
  final bool Password;
  final TextEditingController controller;
  final TextInputType keaboardType;

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
        keyboardType: widget.keaboardType,
        autocorrect: false,
        cursorColor: Colors.white,
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
        validator: (data) {
          final emailRegex = RegExp(r'^[\w.-]+@[a-zA-Z\d.-]+\.[a-zA-Z]{2,}$');
          if (widget.label == "Email" || widget.label == "email") {
            if (data == null || data.trim().isEmpty) {
              return "empty field";
            } else if (!data.trim().contains("@")) {
              return "the email must contain an '@' symbol";
            } else if (data.trim().indexOf("@") !=
                data.trim().lastIndexOf("@")) {
              return "you can only contain one instance of '@' in your email";
            } else if (!emailRegex.hasMatch(data.trim())) {
              return "Invalid email format, it should be similar to 'test@example.com'";
            } else {
              return null;
            }
            // Valid email
          } else if (widget.label == "Password" ||
              widget.label == "Confirm Password") {
            if (data == null || data.trim().isEmpty) {
              return "Password cannot be empty.";
            }
            if (data.trim().length < 8) {
              return "Password must be at least 8 characters long.";
            }
            final upperCase = RegExp(r'[A-Z]');
            final lowerCase = RegExp(r'[a-z]');
            final number = RegExp(r'\d');
            final specialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
            if (!upperCase.hasMatch(data.trim())) {
              return "Password must include an uppercase letter.";
            }
            if (!lowerCase.hasMatch(data.trim())) {
              return "Password must include a lowercase letter.";
            }
            if (!number.hasMatch(data.trim())) {
              return "Password must include a number.";
            }
            if (!specialChar.hasMatch(data.trim())) {
              return "Password must include a special character.";
            } else {
              return null;
            } // Valid password
          } else if (widget.label == "First Name" ||
              widget.label == "Last Name") {
            if (data == null || data.trim().isEmpty) {
              return "empty field";
            } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(data)) {
              return 'Name can only contain letters and spaces.';
            } else if (data.length < 2) {
              return 'Name must be at least 2 characters long.';
            } else if (data.length > 50) {
              return 'Name must not exceed 50 characters.';
            }
          } else if (widget.label == "Phone Number") {
            if (data == null || data.trim().isEmpty) {
              return 'Phone number cannot be empty.';
            }
            // Check if the input contains only digits
            if (!RegExp(r'^\d+$').hasMatch(data)) {
              return 'Phone number must contain only digits.';
            }
            // Optional: Enforce length constraints
            if (data.length != 11) {
              return 'Phone number must be exactly 11 digits long.';
            }
            return null; // Valid input
          } else if (widget.label == "Academic Year") {
            if (data == null || data.trim().isEmpty) {
              return 'Phone number cannot be empty.';
            }
            if (!RegExp(r'^\d+$').hasMatch(data)) {
              return 'Year number must contain digits.';
            }
            if (data.trim().length > 1) {
              return 'year must contain only digits.';
            }
          } else if (widget.label == "Seat Number") {
            if (data == null || data.trim().isEmpty) {
              return 'Phone number cannot be empty.';
            }
            if (!RegExp(r'^\d+$').hasMatch(data)) {
              return 'Year number must contain digits.';
            }
          } //username , phone , etc
        },
      ),
    );
  }
}
