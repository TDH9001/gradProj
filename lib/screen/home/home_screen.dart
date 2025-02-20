import 'package:flutter/material.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/screen/auth/login_screen.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/navigation_Service.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:grad_proj/widgets/sceduleitem.dart';
import 'package:provider/provider.dart';

import '../../UI/colors.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers:<Widget> [
            SliverAppBar(
              //expandedHeight: 120.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text("chat"),
              ),
              backgroundColor: Color(0xff769BC6),
        ),
        SliverList(delegate: SliverChildBuilderDelegate(
          childCount: 1 ,
            (context, index) {
              return Padding(padding:
              const EdgeInsets.only(bottom: 20),
                child: Sceduleitem(
                  title: "User Name",
                  subtitle: "phone number",
                  thirdText: "the second",
                ),
              );
            }
        ),
        ),
          SliverList(delegate: SliverChildBuilderDelegate(
              childCount: 1 ,
                  (context, index) {
                return Padding(padding:
                const EdgeInsets.only(bottom: 20),
                  child: Sceduleitem(
                    title: "lab is",
                    subtitle: "time is",
                    thirdText: "where?",
                  ),
                );
              }
          ),
          ),
            SliverList(delegate: SliverChildBuilderDelegate(
                childCount: 1 ,
                    (context, index) {
                  return Padding(padding:
                  const EdgeInsets.only(bottom: 20),
                    child: Sceduleitem(
                      title: "lab is",
                      subtitle: "time is",
                      thirdText: "where?",
                    ),
                  );
                }
            ),





        // body: Center(
        //   child: PrimaryButton(
        //       buttontext: "LOGOUT",
        //       func: () {
        //         _auth.signOut();
        //         navigationService.instance.navigateToReplacement(LoginScreen.id);
        //       }),
        // ),
        ),
        ],
            ),
      ),
    );
  }
}
