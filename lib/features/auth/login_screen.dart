import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/widgets/forget_password_row.dart';
import 'package:grad_proj/widgets/signup_text_row.dart';
import 'package:provider/provider.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:grad_proj/features/auth/resetpassword_screen.dart';
import 'package:grad_proj/features/auth/singup_screen.dart';
import '../../providers/auth_provider.dart';
import '../../services/snackbar_service.dart';

import '../../widgets/customtextfield.dart';
import '../../widgets/language_switcher_button.dart';
import '../theme/light_theme.dart';

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
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthProvider _auth = AuthProvider();

  @override
  Widget build(BuildContext context) {
    _DeviceHeight = MediaQuery.of(context).size.height;
    _DeviceWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LightTheme.backgroundGradient,
          ),
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
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.topRight,
                        child: LanguageSwitcherButton(),
                      ),
                      const SizedBox(height: 20),
                      Image.asset('assets/images/login.jpeg'),
                      Text(
                        'name_of_app'.tr(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'app_login'.tr(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: t1,
                        hintText: 'hint_email'.tr(),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: t2,
                        hintText: 'hint_pass'.tr(),
                        isPassword: true,
                      ),
                      const SizedBox(height: 40),
                      ForgetPasswordRow(),
                      const SizedBox(height: 30),
                      _auth.status == AuthStatus.Authenticating
                          ? const CircularProgressIndicator()
                          : PrimaryButton(
                        func: () {
                          _email = t1.text.trim();
                          _password = t2.text.trim();
                          if (_formKey.currentState!.validate()) {
                            _auth.loginUserWithEmailAndPassword(
                                _email, _password);
                          }
                        },
                        buttontext: 'app_login_but'.tr(),
                      ),
                      const SizedBox(height: 40),
                    SignupTextRow (),
                      const SizedBox(height: 24),
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
