import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grad_proj/constants.dart';
import 'package:grad_proj/refactored/loginform_screen.dart';
import 'package:grad_proj/widgets/Header_Text.dart';
import 'package:grad_proj/refactored/singupform_screen.dart';
import 'package:grad_proj/widgets/NavigatorTextButton.dart';
import 'package:grad_proj/widgets/UniversalTextFormField.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:grad_proj/screen/resetpassword_screen.dart';
import 'package:grad_proj/screen/singup_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/snackbar_service.dart';
import '../services/navigation_Service.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ChangeNotifierProvider<AuthProvider>.value(
          value: AuthProvider.instance,
          child: Builder(builder: (_context) {
            _auth = Provider.of<AuthProvider>(_context);
            SnackBarService.instance.buildContext = context;

            return ListView(
              children: [
                SizedBox(height: _DeviceHeight! * 0.17),
                TextHeader(
                  height: _DeviceHeight! * .2,
                  largeText: "Welcome Student!",
                  littleText: "please login to your app",
                ),
                Form(
                  key: _formKey,
                  onChanged: () {
                    _formKey.currentState?.save();
                  },
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
                      _auth.status == AuthStatus.Authenticating
                          ? const Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator())
                          : PrimaryButton(
                              buttontext: 'Login',
                              func: () {
                                _password = t2.text.trim();
                                _email = t1.text.trim();
                                if (_formKey.currentState!.validate()) {
                                  _auth.loginUserWithEmailAndPassword(
                                      _email, _password);
                                }
                              },
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
            );
          }),
        ),
      ),
    ));
  }
}
