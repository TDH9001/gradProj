import 'package:flutter/material.dart';
import 'package:grad_proj/widgets/UniversalTextFormField.dart';

class SingupformScreen extends StatefulWidget {
  const SingupformScreen({super.key});
  static String id = "";

  @override
  State<SingupformScreen> createState() => _SingupformScreenState();
}

class _SingupformScreenState extends State<SingupformScreen> {
  bool _isObscure = true;
  final TextEditingController t2 = TextEditingController();
  final TextEditingController t1 = TextEditingController();
  final TextEditingController t3 = TextEditingController();
  final TextEditingController t4 = TextEditingController();
  final TextEditingController t5 = TextEditingController();
  final TextEditingController t6 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Universaltextformfield(
            label: 'First Name', Password: false, controller: t1),
        Universaltextformfield(
            label: 'Last Name', Password: false, controller: t2),
        Universaltextformfield(label: 'Email', Password: false, controller: t3),
        Universaltextformfield(
            label: 'Phone Number', Password: false, controller: t4),
        Universaltextformfield(
            label: 'Password', Password: true, controller: t5),
        Universaltextformfield(
            label: 'Confirm Password', Password: true, controller: t6),
        // buildInputForm('First Name', false),
        // buildInputForm('Last Name', false),
        // buildInputForm('Email', false),
        // buildInputForm('Phone Number', false),
        // buildInputForm('Password', true),
        // buildInputForm('Confirm Password', true),
      ],
    );
  }

  // Padding buildInputForm(String hint, bool password) {
  //   return Padding(
  //       padding: EdgeInsets.symmetric(
  //         vertical: 5,
  //       ),
  //       child: TextFormField(
  //         obscureText: password ? _isObscure : false,
  //         decoration: InputDecoration(
  //           hintText: hint,
  //           hintStyle: TextStyle(color: Colors.black),
  //           focusedBorder: UnderlineInputBorder(
  //               borderSide: BorderSide(color: Colors.black)),
  //           suffixIcon: password
  //               ? IconButton(
  //                   onPressed: () {
  //                     setState(() {
  //                       _isObscure = !_isObscure;
  //                     });
  //                   },
  //                   icon: _isObscure
  //                       ? Icon(Icons.visibility_off, color: Colors.black)
  //                       : Icon(
  //                           Icons.visibility,
  //                           color: Colors.black,
  //                         ),
  //                 )
  //               : null,
  //         ),
  //       ));
  // }
}
