import 'package:flutter/material.dart';

class Orgappbar extends StatelessWidget implements PreferredSizeWidget
{
  final GlobalKey<ScaffoldState> scaffoldKey;

  const Orgappbar({required this.scaffoldKey, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff7AB2D3),
      title: Text("SciConnect"),
      leading: InkWell(
        onTap: ()
        {
          scaffoldKey.currentState?.openDrawer();
        },
        child: Icon(Icons.menu),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/science.png'),
          radius: 20,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}


