import 'dart:ffi';
import 'package:grad_proj/screen/chats_and_profile/profile_screen_ui.dart';
import 'package:grad_proj/models/contact.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/widgets/Header_Text.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import '../providers/auth_provider.dart';
import '../services/DB-service.dart';
import '../services/snackbar_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static String id = "ProfileScreen";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext _context) {
    final double _DeviceHeight = MediaQuery.of(_context).size.height;
    final double _DeviceWidth = MediaQuery.of(_context).size.width;
    SnackBarService.instance.buildContext = _context;
    TextEditingController fn = TextEditingController();

    

    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(12),
          child: ProfileScreenUi(
            height: _DeviceHeight,
            Controller: fn,
            length: _DeviceWidth,
          ),
        ),
      ),
    );
  }
}
//
