import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grad_proj/constants.dart';
import 'package:grad_proj/refactored/loginform_screen.dart';
import 'package:grad_proj/widgets/Header_Text.dart';
import 'package:grad_proj/widgets/singupform_screen.dart';
import 'package:grad_proj/widgets/NavigatorTextButton.dart';
import 'package:grad_proj/widgets/UniversalTextFormField.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:grad_proj/screen/resetpassword_screen.dart';
import 'package:grad_proj/screen/singup_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  static String id = "login";
  double? _DeviceWidth;
  double? _DeviceHeight;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController t2 = TextEditingController();
  final TextEditingController t1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _DeviceHeight = MediaQuery.of(context).size.height;
    _DeviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text(
        //     "welcome to the login screen",
        //     style: TextStyle(fontSize: 22, color: textAndAccent),
        //   ),
        // ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: [
              SizedBox(height: _DeviceHeight! * 0.17),
              TextHeader(
                height: _DeviceHeight! * .2, //_DeviceHeight! * 24,
                largeText: "Welcome Student!",
                littleText: "please login to your app",
              ),

              // error was located here >LoginformScreen() has a list view but was not given a size
              // added a temporary sizebox

              Form(
                key: _formKey,
                onChanged: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Universaltextformfield(
                      label: "Email",
                      Password: false,
                      controller: t1,
                    ),
                    Universaltextformfield(
                      label: "Password",
                      Password: true,
                      controller: t2,
                    ),
                    PrimaryButton(
                      buttontext: 'Login',
                      func: () {},
                    ),
                    //cahnged from big button to this
                    Navigatortextbutton(
                      text: "reset Password ?",
                      location: ResetpasswordScreen.id,
                    ),
                    Navigatortextbutton(
                      text: "sign up",
                      location: SingupScreen.id,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
