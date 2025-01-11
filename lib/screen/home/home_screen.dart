import 'package:flutter/material.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/screen/auth/login_screen.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var _auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Center(
        child: PrimaryButton(
            buttontext: "LOGOUT",
            func: () {
              _auth.signOut();
              navigationService.instance.navigateToReplacement(LoginScreen.id);
            }),
      ),
    );
  }
}
