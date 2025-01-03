import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grad_proj/constants.dart';
import 'package:grad_proj/refactored/loginform_screen.dart';
import 'package:grad_proj/widgets/Header_Text.dart';
import 'package:grad_proj/refactored/singupform_screen.dart';
import 'package:grad_proj/widgets/NavigatorTextButton.dart';
import 'package:grad_proj/widgets/UniversalTextFormField.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:grad_proj/screen/auth/resetpassword_screen.dart';
import 'package:grad_proj/screen/auth/singup_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/snackbar_service.dart';
import '../../services/navigation_Service.dart';
import '../../widgets/customtextfield.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  static String id = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double? _DeviceWidth;

  double? _DeviceHeight;

  String _email = "";

  String _password = "";

  TextEditingController t2 = TextEditingController();

  TextEditingController t1 = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AuthProvider _auth = AuthProvider();

  @override
  Widget build(BuildContext context) {
    _DeviceHeight = MediaQuery.of(context).size.height;
    _DeviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ChangeNotifierProvider<AuthProvider>.value(
            value: AuthProvider.instance,
            child: Builder(builder: (_context) {
              _auth = Provider.of<AuthProvider>(_context);
              SnackBarService.instance.buildContext = context;
              return Form(
                key: _formKey,
                onChanged: () {
                  _formKey.currentState?.save();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 80),
                    const Text(
                      'Login to your Account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    CustomTextField(
                      controller: t1,
                      hintText: 'Email',
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: t2,
                      hintText: 'Password',
                      isPassword: true,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 24),
                    _auth.status == AuthStatus.Authenticating
                        ? const Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator())
                        : PrimaryButton(
                            func: () {
                              _password = t2.text.trim();
                              _email = t1.text.trim();
                              if (_formKey.currentState!.validate()) {
                                _auth.loginUserWithEmailAndPassword(
                                    _email, _password);
                              }
                              navigationService.instance
                                  .navigateToReplacement("HomeScreen");
                            },
                            buttontext: 'Login',
                          ),
                    const SizedBox(height: 24),
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Or',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Color(0xFF6B7280)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingupScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: Color(0xff7AB2D3),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Forget password ? ",
                          style: TextStyle(color: Color(0xFF6B7280)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResetpasswordScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Reset password ',
                            style: TextStyle(
                              color: Color(0xff7AB2D3),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
    ));
  }
}
/*
* */
