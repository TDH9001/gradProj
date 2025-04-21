import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grad_proj/constants.dart';
import 'package:grad_proj/refactored/loginform_screen.dart';
import 'package:grad_proj/widgets/Header_Text.dart';
import 'package:grad_proj/refactored/singupform_screen.dart';
import 'package:grad_proj/widgets/NavigatorTextButton.dart';
import 'package:grad_proj/widgets/UniversalTextFormField.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:grad_proj/features/auth/resetpassword_screen.dart';
import 'package:grad_proj/features/auth/singup_screen.dart';
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Image(image: AssetImage('assets/images/login.jpeg')),
                    const Text(
                      'SciConnect',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: t1,
                      hintText: 'Email',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: t2,
                      hintText: 'Password',
                      isPassword: true,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                              color: Color(0xff769BC6),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xff769BC6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
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
                            },
                            buttontext: 'Login',
                          ),
                    const SizedBox(height: 40),
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
                              color: Color(0xff769BC6),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xff769BC6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
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
