import 'package:flutter/material.dart';
import '../UI/colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;

  CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    //required this.onChanged,
    required this.controller,
  });
  bool isObscure = true;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    void initstate() {
      super.initState();
      widget.isObscure = widget.isPassword;
    }

    return TextFormField(
      obscureText: widget.isObscure,

      controller: widget.controller,
      //obscureText: widget.hintText == "Password" ? true : false,
      autocorrect: false,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 10.0, 20.0, 10.0),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60),
            borderSide: const BorderSide(color: ColorsApp.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60),
            borderSide: const BorderSide(color: ColorsApp.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60),
            borderSide: const BorderSide(
              color: ColorsApp.primary,
            ),
          ),
          //contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: widget.isPassword
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
        if (widget.hintText == "Email" || widget.hintText == "email") {
          if (data == null || data.trim().isEmpty) {
            return "empty field";
          } else if (!data.trim().contains("@")) {
            return "the email must contain an '@' symbol";
          } else if (data.trim().indexOf("@") != data.trim().lastIndexOf("@")) {
            return "you can only contain one instance of '@' in your email";
          } else if (!emailRegex.hasMatch(data.trim())) {
            return "Invalid email format, it should be similar to 'test@example.com'";
          } else {
            return null;
          }
          // Valid email
        } else if (widget.hintText == "Password" ||
            widget.hintText == "Confirm Password") {
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
        } else if (widget.hintText == "First Name" ||
            widget.hintText == "Last Name") {
          if (data == null || data.trim().isEmpty) {
            return "empty field";
          } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(data)) {
            return 'Name can only contain letters and spaces.';
          } else if (data.length < 2) {
            return 'Name must be at least 2 characters long.';
          } else if (data.length > 50) {
            return 'Name must not exceed 50 characters.';
          }
        } else if (widget.hintText == "Phone Number") {
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
        } else if (widget.hintText == "Academic Year") {
          if (data == null || data.trim().isEmpty) {
            return 'Phone number cannot be empty.';
          }
          if (!RegExp(r'^\d+$').hasMatch(data)) {
            return 'Year number must contain digits.';
          }
          if (data.trim().length > 1) {
            return 'year must contain only digits.';
          }
        } //username , phone , etc
      },
    );
  }
}
