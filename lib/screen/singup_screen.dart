import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grad_proj/constants.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/widgets/Header_Text.dart';
import 'package:grad_proj/widgets/UniversalTextFormField.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:grad_proj/widgets/NavigatorTextButton.dart';
import 'login_screen.dart';
import '../services/DB-service.dart';
// import '../services/media_service.dart';

class SingupScreen extends StatefulWidget {
  SingupScreen({super.key});

  static String id = "SingupScreen";

  double? _DeviceWidth;

  double? _DeviceHeight;

  @override
  State<SingupScreen> createState() => _SingupScreenState();
}

class _SingupScreenState extends State<SingupScreen> {
  bool _isObscure = true;
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _LastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _passWord = TextEditingController();
  final TextEditingController _confirmPassWord = TextEditingController();
  @override
  Widget build(BuildContext context) {
    widget._DeviceHeight = MediaQuery.of(context).size.height;
    widget._DeviceWidth = MediaQuery.of(context).size.width;
    File? _imageFileExample;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(11),
        child: Align(
          alignment: Alignment.center,
          child: ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Center(
                  child: TextHeader(
                    height: widget._DeviceHeight! * 0.1,
                    largeText: "Create a new account",
                    littleText: "  we are pleased to have you",
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  Universaltextformfield(
                      label: 'First Name',
                      Password: false,
                      controller: _firstName),
                  Universaltextformfield(
                      label: 'Last Name',
                      Password: false,
                      controller: _LastName),
                  Universaltextformfield(
                      label: 'Email', Password: false, controller: _email),
                  Universaltextformfield(
                      label: 'Phone Number',
                      Password: false,
                      controller: _phoneNumber),
                  Universaltextformfield(
                      label: 'Password', Password: true, controller: _passWord),
                  Universaltextformfield(
                      label: 'Confirm Password',
                      Password: true,
                      controller: _confirmPassWord),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              PrimaryButton(
                buttontext: "Create the account",
                func: () async {
                  String fn = _firstName.text.trim();
                  String ln = _LastName.text.trim();
                  String em = _email.text.trim();
                  String pn = _phoneNumber.text.trim();
                  String pw = _passWord.text.trim();
                  String cpw = _confirmPassWord.text.trim();
                  DBService.instance.createUserInDB(
                      cont: context,
                      userId: "012012",
                      firstName: fn,
                      lastname: ln,
                      email: em,
                      phoneNumber: pn,
                      password: pw);
                  // PrintSnackBarSucces(context, "SUCCCC");
                  // _imageFileExample =
                  //     await MediaService.instance.getImageFromLibrary();

                  // if (_formKey.currentState!.validate()) {
                  //   _auth.loginUserWithEmailAndPassword(_email, _password);
                  //   if (_auth.user?.email == null) {
                  //     PrintSnackBarFail(context, "No email available");
                  //   } else {
                  //     PrintSnackBarSucces(context, "welcome, ${_auth.user?.email}");
                  //   }
                  // }
                },
              ),
              Navigatortextbutton(
                  text: 'Already have an account ?', location: LoginScreen.id),
            ],
          ),
        ),
      ),
    );
  }
}
