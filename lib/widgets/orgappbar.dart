import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../UI/text_style.dart';
import '../providers/theme_provider.dart';
import '../screen/theme/dark_theme_colors.dart';
import '../screen/theme/light_theme.dart';

class Orgappbar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;
  final VoidCallback? onBack;

  Orgappbar({
    required this.scaffoldKey,
    Key? key,
    this.title = 'SciConnect',
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;
    final backIcon = IconButton(
      icon: Icon(
        isRTL ? Icons.arrow_forward : Icons.arrow_back,
        color: Colors.white,
      ),
      onPressed: onBack ?? () => Navigator.pop(context),
    );
    final image = Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundColor: isDarkMode
            ? DarkThemeColors.backgroundImage
            : LightTheme.backgroundImage,
        backgroundImage: const AssetImage('assets/images/science.png'),
        radius: 20,
      ),
    );

    return AppBar(
      backgroundColor: isDarkMode
          ? DarkThemeColors.primary
          : LightTheme.primary,
      automaticallyImplyLeading: false,

      title: Center(
        child: Text(
          title,
          style: TextStyles.appBarText.copyWith(
            color: Colors.white,
          ),
        ),
      ),


      leading: isRTL ? image : backIcon,
      actions: [
        if (isRTL) backIcon else image,
        const SizedBox(width: 10),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
