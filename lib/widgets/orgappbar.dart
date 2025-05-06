import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../UI/text_style.dart';
import '../providers/theme_provider.dart';
import '../screen/theme/dark_theme_colors.dart';
import '../screen/theme/light_theme.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    return AppBar(
      backgroundColor: isDarkMode ?DarkThemeColors.primary: LightTheme.primary,
      //Color(0xFF2E5077)
      title: Center (
        child: Text(
          title,
          style: TextStyles.appBarText.copyWith(
            color:Colors.white,
          ),
        ),
      ),
      leading: leading,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: isDarkMode ? DarkThemeColors.backgroundImage: LightTheme.backgroundImage,
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
