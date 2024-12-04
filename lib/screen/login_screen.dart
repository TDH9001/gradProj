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
          value: AuthProvider.instance, // HEREEEEEE

          child: Builder(builder: (BuildContext _context) {
            _auth = Provider.of<AuthProvider>(_context);
            // print(_auth.user);
            return ListView(
              children: [
                SizedBox(height: _DeviceHeight! * 0.17),
                TextHeader(
                  height: _DeviceHeight! * .2, //_DeviceHeight! * 24,
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
                                  if (_auth.user?.email == null) {
                                    PrintSnackBarFail(
                                        context, "No email available");
                                  } else {
                                    PrintSnackBarSucces(context,
                                        "welcome, ${_auth.user?.email}");
                                  }
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


  //by addign this > isntead of being provided a new var > i only need the one here
   //now everytime the authprovider calls > it will re-render the shole UI and provide it's
          //context to the provider > taht should provide the Firebase with the data it needs
          //so now each time i need an authProvider > it will heck all the aprents searchign for one untill
          //one can provide it
          //here the builder si provided the provideor from the ChangeNotifier above it
          
            //made an instance of > ChangeNotifierProvider > set the value to an isntance of my provider
            //made ti take a builder taht will build my UI
                        //ALL OF THAT > was to return the firebase user data

