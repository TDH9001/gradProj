import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:grad_proj/widgets/NavigatorTextButton.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/customTextField.dart';
import '../theme/dark_theme_colors.dart';
import '../theme/light_theme.dart';
import 'package:provider/provider.dart';
import '../../services/DB-service.dart';
import '../../providers/auth_provider.dart';

class SingupScreen extends StatefulWidget {
  SingupScreen({super.key});

  static String id = "SingupScreen";

  // double? _DeviceWidth;
  //
  // double? _DeviceHeight;

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    // widget._DeviceHeight = MediaQuery.of(context).size.height;
    // widget._DeviceWidth = MediaQuery.of(context).size.width;
    File? _imageFileExample;
    AuthProvider _auth;

    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: isDarkMode
                ? DarkThemeColors.backgroundGradient
                : LightTheme.backgroundGradient,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Builder(builder: (_context) {
                _auth = Provider.of<AuthProvider>(_context);
                SnackBarService.instance.buildContext = context;
                return Form(
                  key: SingupScreen._formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 60),
                      Text(
                        'Signup.title'.tr(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      CustomTextField(
                        hintText: 'Signup.first_name'.tr(),
                        isPassword: false,
                        controller: _firstName,
                      ),
                      const SizedBox(height: 18),
                      CustomTextField(
                        hintText: 'Signup.last_name'.tr(),
                        isPassword: false,
                        controller: _LastName,
                      ),
                      const SizedBox(height: 18),
                      CustomTextField(
                        hintText: 'Signup.email'.tr(),
                        isPassword: false,
                        controller: _email,
                      ),
                      const SizedBox(height: 18),
                      CustomTextField(
                        hintText: 'Signup.phone_number'.tr(),
                        isPassword: false,
                        controller: _phoneNumber,
                      ),
                      const SizedBox(height: 18),
                      CustomTextField(
                        hintText: 'Signup.password'.tr(),
                        isPassword: true,
                        controller: _passWord,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hintText: 'Signup.confirm_password'.tr(),
                        isPassword: true,
                        controller: _confirmPassWord,
                        compareWithController: _passWord,
                      ),
                      const SizedBox(height: 40),
                      _auth.status == AuthStatus.Authenticating
                          ? const Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator())
                          : PrimaryButton(
                              buttontext: 'Signup.signup_button'.tr(),
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
                                }
                              },
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Signup.already_account'.tr(),
                            style:
                                TextStyle(fontSize: 12, color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                          Navigatortextbutton(
                            text: 'Signup.login_button'.tr(),
                            location: "pop",
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
