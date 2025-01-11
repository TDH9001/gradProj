import 'package:flutter/material.dart';
import 'package:grad_proj/UI/colors.dart';
import 'package:grad_proj/screen/auth/login_screen.dart';
import 'package:grad_proj/screen/profiles/CompleteProfile.dart';
import 'package:grad_proj/models/contact.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/widgets/Header_Text.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
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
  bool visible = false;

  @override
  Widget build(BuildContext _context) {
    var _auth = Provider.of<AuthProvider>(_context);
    if (_auth.user == null) {
      navigationService.instance.navigateToReplacement(LoginScreen.id);
    }
    return StreamBuilder<contact>(
        stream: DBService.instance.getUserData(_auth.user!.uid),
        builder: (_context, _snapshot) {
          // if (_snapshot.connectionState == ConnectionState.waiting ||
          //     _snapshot.connectionState == ConnectionState.none) {
          //   return Center(child: CircularProgressIndicator());
          // }
          if (_snapshot.hasError) {
            return Center(
                child: Text(
                    "Error: ${_snapshot.error} \n please update your data and the data field mising"));
          }
          bool isComp =false;


          if(_snapshot.data != null){
            var userData = _snapshot.data;

            if (userData?.isComplete == false) {
              isComp = false;
            } else {
              isComp = true;
            }

            return isComp
                ? ListView(
              children: [
                SizedBox(
                  height: 35,
                ),
                TextFormField(
                  enabled: false,
                  initialValue: _snapshot.data?.FirstName??"",
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xff7AB2D3),
                        ),
                        borderRadius: BorderRadius.circular(60)),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                TextFormField(
                  enabled: false,
                  initialValue: _auth.user!.email,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xff7AB2D3),
                        ),
                        borderRadius: BorderRadius.circular(60)),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                IntlPhoneField(
                  enabled: false,
                  initialValue: _snapshot.data?.phoneNumber??"",
                  style: TextStyle(color: Colors.black),
                  initialCountryCode: 'EG',
                  showCountryFlag: true,
                  showDropdownIcon: false,
                  onChanged: (phone) {
                    print(phone.completeNumber);
                  },
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Color(0xff769BC6)),
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                TextFormField(
                  enabled: false,
                  initialValue: _snapshot.data?.Year.toString(),
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Academec Year",
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xff769BC6),
                        ),
                        borderRadius: BorderRadius.circular(60)),
                  ),
                ),
                SizedBox(
                  height: 35,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.transparent,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor:Color(0xff769BC6),
                        shadowColor: Color(0xff769BC6),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          visible = !visible;
                        });
                      },
                      child: Text(
                        'Courses Enrolled',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),
                userData!.Classes.isEmpty
                    ? Center(
                  child: Text(
                    'No courses enrolled yet.',
                    style: TextStyle(
                        color: Colors.grey[600], fontSize: 16),
                  ),
                )
                    : Visibility(
                  visible: visible,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: userData.Classes.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                              leading: Icon(Icons.book,
                                  color: Color(0xff769BC6)),
                              title: Text(
                                userData.Classes[index],
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // SizedBox(
                //   height: widget.height * 0.04,
                // ),
                // PrimaryButton(
                //     buttontext: "LOGOUT",
                //     func: () async {
                //       _auth.signOut();
                //       navigationService.instance.navigateTo(LoginScreen.id);
                //     }),
                SizedBox(
                  height: 20,
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
          }

          return SizedBox.shrink();


        });
  }
}
