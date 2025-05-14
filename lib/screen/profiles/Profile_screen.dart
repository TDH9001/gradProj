import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/widgets/orgappbar.dart';
import 'package:grad_proj/screen/profiles/profile_screen_ui.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../providers/auth_provider.dart';
import '../../services/snackbar_service.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});
  static String id = "ProfileScreen";
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext _context) {
    final double _DeviceHeight = MediaService.instance.getHeight();
    final double _DeviceWidth = MediaService.instance.getWidth();
    SnackBarService.instance.buildContext = _context;
    TextEditingController fn = TextEditingController();

    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Scaffold(
        appBar: Orgappbar(
          scaffoldKey: scaffoldKey,
          title: "Profile",
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back, color: Colors.white),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
        ),
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
