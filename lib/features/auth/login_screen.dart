import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grad_proj/constants.dart';
import 'package:grad_proj/refactored/loginform_screen.dart';
import 'package:grad_proj/widgets/Header_Text.dart';
import 'package:grad_proj/refactored/singupform_screen.dart';
import 'package:grad_proj/widgets/NavigatorTextButton.dart';
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
                onChanged: () {_formKey.currentState?.save();},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Image(image: AssetImage('assets/images/login.jpeg')),
                    Text('name_of_app'.tr(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1F2937),),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.topLeft,
                      child:  Text(
                        'app_login'.tr(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1F2937),),),
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(controller: t1, hintText: 'hint_email'.tr(),),
                    const SizedBox(height: 16),
                    CustomTextField(controller: t2, hintText: 'hint_pass'.tr(), isPassword: true,),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                         Text("app_forget_pass ".tr(), style: TextStyle(color: Color(0xFF6B7280)),),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ResetpasswordScreen(),),);
                          },
                          child:  Text(
                            'app_reset_pass '.tr(),
                            style: TextStyle(color: Color(0xff769BC6), fontWeight: FontWeight.w600, decoration: TextDecoration.underline, decorationColor: Color(0xff769BC6),
                            ),),),
                      ],
                    ),
                    SizedBox(height: 30),
                    _auth.status == AuthStatus.Authenticating ? const Align(alignment: Alignment.center,child: CircularProgressIndicator())
                        : PrimaryButton(
                            func: () {
                              _password = t2.text.trim();
                              _email = t1.text.trim();
                              if (_formKey.currentState!.validate()) {
                                _auth.loginUserWithEmailAndPassword(
                                    _email, _password);
                              }
                            },
                            buttontext: 'app_login_but'.tr(),
                          ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text("app_reset_pass_tex".tr(), style: TextStyle(color: Color(0xFF6B7280)),),
                        TextButton(
                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SingupScreen(),),);
                          },
                          child:  Text('app_creat_acc'.tr(), style: TextStyle(color: Color(0xff769BC6), fontWeight: FontWeight.w600, decoration: TextDecoration.underline, decorationColor: Color(0xff769BC6),
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
