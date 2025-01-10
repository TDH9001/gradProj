import 'package:flutter/material.dart';

import '../UI/colors.dart';
import '../UI/text_style.dart';

class Orgappbar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;
  final Widget? leading;

  Orgappbar({
    required this.scaffoldKey,
    Key? key,
    this.title = 'SciConnect',
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorsApp.primary,
      title: Center (
        child: Text(
          title,
          style: TextStyles.appBarText,
        ),
      ),
      leading: leading,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: const AssetImage('assets/images/science.png'),
            radius: 20,
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
