import 'package:flutter/material.dart';
import 'package:grad_proj/screen/auth/login_screen.dart';
import 'package:grad_proj/screen/profiles/CompleteProfile.dart';
import 'package:grad_proj/models/contact.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/widgets/Header_Text.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:provider/provider.dart';
import '../../services/navigation_Service.dart';
import '../../providers/auth_provider.dart';

class ProfileScreenUi extends StatefulWidget {
  ProfileScreenUi(
      {super.key,
      required this.height,
      required this.length,
      required this.Controller});
  final double length;
  final double height;
  final TextEditingController Controller;

  @override
  State<ProfileScreenUi> createState() => _ProfileScreenUiState();
}

class _ProfileScreenUiState extends State<ProfileScreenUi> {
  @override
  Widget build(BuildContext _context) {
    var _auth = Provider.of<AuthProvider>(_context);
    if (_auth.user == null) {
      navigationService.instance.navigateToReplacement(LoginScreen.id);
    }
    return StreamBuilder<contact>(
        stream: DBService.instance.getUserData(_auth.user!.uid),
        builder: (_context, _snapshot) {
          if (_snapshot.connectionState == ConnectionState.waiting ||
              _snapshot.connectionState == ConnectionState.none) {
            return Center(child: CircularProgressIndicator());
          }
          if (_snapshot.hasError) {
            return Center(
                child: Text(
                    "Error: ${_snapshot.error} \n please update your data and the data field mising"));
          }
          var userData = _snapshot.data;
          bool isComp;

          if (userData!.isComplete == false) {
            isComp = false;
          } else {
            isComp = true;
          }

          return isComp
              ? ListView(
                  children: [
                    TextHeader(
                        height: widget.height * 0.12,
                        largeText: "Profile Screen",
                        littleText: "We hope you are enjoying our app"),
                    SizedBox(
                      height: widget.height * 0.04,
                    ),
                    TextFormField(
                      enabled: false,
                      initialValue: _snapshot.data!.FirstName,
                      style: TextStyle(color: Colors.black54),
                      decoration: InputDecoration(
                          labelText: "FirstName",
                          labelStyle: TextStyle(color: Colors.black54)),
                    ),
                    SizedBox(
                      height: widget.height * 0.04,
                    ),
                    TextFormField(
                      enabled: false,
                      initialValue: _snapshot.data!.LastName,
                      decoration: InputDecoration(
                        labelText: "Last Name",
                      ),
                    ),
                    SizedBox(
                      height: widget.height * 0.04,
                    ),
                    TextFormField(
                      enabled: false,
                      initialValue: _auth.user!.email,
                      decoration: InputDecoration(
                        labelText: "Email",
                      ),
                    ),
                    SizedBox(
                      height: widget.height * 0.04,
                    ),
                    TextFormField(
                      enabled: false,
                      initialValue: _snapshot.data!.phoneNumber,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                      ),
                    ),
                    SizedBox(
                      height: widget.height * 0.04,
                    ),
                    TextFormField(
                      enabled: false,
                      initialValue: _snapshot.data!.Year.toString(),
                      decoration: InputDecoration(
                        labelText: "Academec Year",
                      ),
                    ),
                    SizedBox(
                      height: widget.height * 0.04,
                      child: Text(
                        "courses",
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                    ),
                    SizedBox(
                        height: widget.height * 0.15,
                        width: widget.length,
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemCount: _snapshot.data!.Classes.length,
                            itemBuilder: (_context, index) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    _snapshot.data!.Classes[index],
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black54),
                                  ),
                                ),
                              );
                            })),
                    SizedBox(
                      height: widget.height * 0.04,
                    ),
                    PrimaryButton(
                        buttontext: "LOGOUT",
                        func: () async {
                          _auth.signOut();
                          navigationService.instance
                              .navigateToReplacement(LoginScreen.id);
                        }),
                    SizedBox(
                      height: widget.height * 0.04,
                    ),
                    PrimaryButton(
                        buttontext: "Edit Data",
                        func: () {
                          navigationService.instance
                              .navigateTo(CompleteProfile.id);
                        }),
                  ],
                )
              : ListView(
                  children: [
                    TextHeader(
                        height: widget.height * 0.30,
                        largeText: "please update your profile",
                        littleText: "your Profile is currently not completed"),
                    PrimaryButton(
                        buttontext: "LOGOUT",
                        func: () {
                          _auth.signOut();
                          navigationService.instance
                              .navigateToReplacement(LoginScreen.id);
                        }),
                    SizedBox(
                      height: widget.height * 0.04,
                    ),
                    PrimaryButton(
                        buttontext: "complete Profile Data",
                        func: () {
                          navigationService.instance
                              .navigateTo(CompleteProfile.id);
                        }),
                  ],
                );
        });
  }
}
