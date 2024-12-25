import 'package:flutter/material.dart';

import '../UI/text_style.dart';

class Orgappbar extends StatelessWidget implements PreferredSizeWidget
{
  final GlobalKey<ScaffoldState> scaffoldKey;
  String title;

   Orgappbar({required this.scaffoldKey, Key? key, this.title='SciConnect'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff7AB2D3),
      title: Text(title,style: TextStyles.appBarText,),
      // leading: InkWell(
      //   onTap: ()
      //   {
      //     scaffoldKey.currentState?.openDrawer();
      //   },
      //   child: Icon(Icons.menu),
      // ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/science.png'),
            radius: 20,
          ),
        ),
        SizedBox(width: 10,),

      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}


