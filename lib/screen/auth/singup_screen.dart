import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grad_proj/services/cloud_Storage_Service.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:grad_proj/widgets/Header_Text.dart';
import 'package:grad_proj/widgets/UniversalTextFormField.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:grad_proj/widgets/NavigatorTextButton.dart';
import '../../widgets/customTextField.dart';
import 'login_screen.dart';
import 'package:provider/provider.dart';
import '../../services/DB-service.dart';
import '../../providers/auth_provider.dart';

class SingupScreen extends StatefulWidget {
  SingupScreen({super.key});

  static String id = "SingupScreen";

  double? _DeviceWidth;

  double? _DeviceHeight;

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

    AuthProvider _auth;

    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            // child: ChangeNotifierProvider<AuthProvider>.value(
            //value: AuthProvider.instance,
            child: Builder(builder: (_context) {
              _auth = Provider.of<AuthProvider>(_context);
              //SnackBarService.instance.buildContext = context;
              return Form(
                key: SingupScreen._formKey,
                // onChanged: () {
                // _formKey.currentState?.save();
                // },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Create a New Account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                      textAlign: TextAlign.center,
                      //littleText: "  we are pleased to have you",
                    ),
                    const SizedBox(height: 32),
                    CustomTextField(
                      hintText: 'First Name',
                      isPassword: false,
                      controller: _firstName,
                      onChanged: (String value) {},
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: 'last Name',
                      isPassword: false,
                      controller: _LastName,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: 'Email',
                      isPassword: false,
                      controller: _email,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: 'Phone Number',
                      isPassword: false,
                      controller: _phoneNumber,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: 'Password',
                      isPassword: true,
                      controller: _passWord,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: ' Confirm Password',
                      isPassword: true,
                      controller: _confirmPassWord,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 24),
                    _auth.status == AuthStatus.Authenticating
                        ? const Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator())
                        : PrimaryButton(
                            buttontext: "Create the account",
                            func: () async {
                              if (SingupScreen._formKey.currentState!
                                  .validate()) {
                                String fn = _firstName.text.trim();
                                String ln = _LastName.text.trim();
                                String em = _email.text.trim();
                                String pn = _phoneNumber.text.trim();
                                String pw = _passWord.text.trim();
                                String cpw = _confirmPassWord.text.trim();
                                _auth.RegesterUser(
                                    firstName: fn,
                                    lastname: ln,
                                    email: em,
                                    phoneNumber: pn,
                                    password: pw,
                                    onSucces: (String _uid) async {
                                      DBService.instance.createUserInDB(
                                          userId: _uid,
                                          firstName: fn,
                                          lastname: ln,
                                          email: em,
                                          phoneNumber: pn,
                                          password: pw);
                                    });
                                navigationService.instance
                                    .navigateTo("HomeScreen");
                              }
                            },
                          ),

                    // ),
                    Navigatortextbutton(
                        text: 'Already have an account ?', location: "pop"),
                    //   buttontext: 'Login',),
                    // const SizedBox(height: 24),
                    // const Row(
                    //   children: [
                    //     Expanded(child: Divider()),
                    //     Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 16),
                    //       child: Text(
                    //         'Or',
                    //         style: TextStyle(
                    //           color: Color(0xFF6B7280),
                    //           fontSize: 14,
                    //         ),
                    //       ),
                    //     ),
                    //     Expanded(child: Divider()),
                    //   ],
                    // ),
                    // const SizedBox(height: 24),
                    // const SizedBox(height: 24),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     const Text(
                    //       "Don't have an account? ",
                    //       style: TextStyle(color: Color(0xFF6B7280)),
                    //     ),
                    //     TextButton(
                    //       onPressed: () {
                    //         // Navigator.push(
                    //         //   context,
                    //         //   MaterialPageRoute(
                    //         //     builder: (context) => const RegisterScreen(),
                    //         //   ),
                    //         // );
                    //       },
                    //       child: const Text(
                    //         'Sign up',
                    //         style: TextStyle(
                    //           color: Color(0xff7AB2D3),
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 24),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     const Text(
                    //       "Forget password ? ",
                    //       style: TextStyle(color: Color(0xFF6B7280)),
                    //     ),
                    //     TextButton(
                    //       onPressed: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => ResetpasswordScreen(),
                    //           ),
                    //         );
                    //       },
                    //       child: const Text(
                    //         'Reset password ',
                    //         style: TextStyle(
                    //           color: Color(0xff7AB2D3),
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
