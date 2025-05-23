import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grad_proj/widgets/forget_pass_row.dart';
import 'package:grad_proj/widgets/have_acc_row.dart';
import 'package:grad_proj/widgets/language_login_button.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:grad_proj/widgets/theme_button_login.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/snackbar_service.dart';
import '../../widgets/customtextfield.dart';
import '../theme/dark_theme_colors.dart';
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
  TextEditingController t2 = TextEditingController();
  TextEditingController t1 = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthProvider _auth = AuthProvider();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    _DeviceHeight = MediaQuery.of(context).size.height;
    _DeviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            body: Container(
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? DarkThemeColors.backgroundGradient
            : LightTheme.backgroundGradient,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ChangeNotifierProvider<AuthProvider>.value(
            value: AuthProvider.instance,
            child: Builder(builder: (_context) {
              _auth = Provider.of<AuthProvider>(_context);
              if (_auth == null) {
                return CircularProgressIndicator();
              }
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
                    Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          LanguageLoginButton(),
                          SizedBox(width: 8),
                          ThemeButtonLogin(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image(image: AssetImage('assets/images/login.jpeg')),
                    Text(
                      'Login.welcome'.tr(),
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Login.title'.tr(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: t1,
                      hintText: 'Login.email1'.tr(),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: t2,
                      hintText: 'Login.password'.tr(),
                      isPassword: true,
                    ),
                    const SizedBox(height: 40),
                    ForgetPassRow(),
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
                                //   bool isValid = _auth.user!.emailVerified;
                                _auth.loginUserWithEmailAndPassword(
                                    _email, _password);
                              }
                            },
                            buttontext: 'Login.login_button'.tr(),
                          ),
                    const SizedBox(height: 40),
                    HaveAccRow(),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    )));
  }
}
