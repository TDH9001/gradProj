import 'dart:ffi';
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

    var _auth = Provider.of<AuthProvider>(_context);

    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: StreamBuilder<contact>(
          //steam builder getss a stream > rebuilds when the data chanegs
          //data fo stream is stored in _snapshot
          stream: DBService.instance.getUserData(_auth.user!.uid),
          builder: (_context, _snapshot) {
            var userData = _snapshot.data;
            fn.text = userData!.FirstName;
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  children: [
                    TextHeader(
                      height: _DeviceHeight * 0.12,
                      largeText: "Hi there 'userUsername'",
                      littleText: "We hope you are enjoying our app",
                    ),
                    SizedBox(
                      height: _DeviceHeight * 0.04,
                    ),
                    TextFormField(
                      controller: fn,
                      style: TextStyle(color: Colors.black54),
                      decoration: InputDecoration(
                          labelText: "First Name",
                          labelStyle: TextStyle(color: Colors.blueAccent)),
                    ),
                    SizedBox(
                      height: _DeviceHeight * 0.04,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Last Name",
                      ),
                    ),
                    SizedBox(
                      height: _DeviceHeight * 0.04,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Email",
                      ),
                    ),
                    SizedBox(
                      height: _DeviceHeight * 0.04,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                      ),
                    ),
                    SizedBox(
                      height: _DeviceHeight * 0.04,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Academec Year",
                      ),
                    ),
                    SizedBox(
                      height: _DeviceHeight * 0.15,
                      width: _DeviceWidth,
                      child: ListView(
                        children: [
                          Text("class 1 "),
                          Text("class 2"),
                          Text("class 3"),
                          Text("ETC")
                        ],
                      ),
                    ),
                    SizedBox(
                      height: _DeviceHeight * 0.04,
                    ),
                    PrimaryButton(
                        buttontext: "LOGOUT",
                        func: () {
                          List<String> data = ["math101", "math102", "shit111"];
                          DBService.instance.addUserClasesAndYear(
                              classes: data,
                              year: 3453443,
                              userId: _auth.user!.uid);
                        }),
                    SizedBox(
                      height: _DeviceHeight * 0.04,
                    ),
                    PrimaryButton(buttontext: "Edit Data", func: () {}),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
//
