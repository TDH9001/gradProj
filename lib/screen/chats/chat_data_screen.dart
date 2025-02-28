import 'package:flutter/material.dart';
import 'package:grad_proj/UI/colors.dart';
import 'package:grad_proj/constants.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/widgets/category_card.dart';
import 'package:grad_proj/widgets/custom_card.dart';
import 'package:grad_proj/widgets/sceduleitem.dart';
import 'package:provider/provider.dart';

class ChatDataScreen extends StatefulWidget {
  ChatDataScreen({super.key});
  static String id = "ChatDataScreen";

  @override
  State<ChatDataScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ChatDataScreen> {
  @override
  Widget build(BuildContext context) {
    var _auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: ColorsApp.primary,
              //expandedHeight: 120.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Center(child: Text("chatName", style: TextStyles.text)),
              ),
            ),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate(childCount: 1, (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: CustomCard(
                    icon: Icons.abc,
                    onTap: () {},
                    title: "",
                  ),
                );
              }),
            ),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate(childCount: 1, (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Sceduleitem(
                    title: "lab is",
                    subtitle: "time is",
                    thirdText: "where?",
                  ),
                );
              }),
            ),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate(childCount: 1, (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Sceduleitem(
                    title: "lab is",
                    subtitle: "time is",
                    thirdText: "where?",
                  ),
                );
              }),

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
