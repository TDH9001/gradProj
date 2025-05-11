import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class ThemeButtonLogin extends StatelessWidget {
  const ThemeButtonLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    return Container(
        decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: PopupMenuButton<ThemeModeType>(
    icon: Icon(
    isDarkMode ? Icons.dark_mode : Icons.light_mode,
    color: Colors.white,
    ),
    tooltip: 'ThemeButtonLogin.title'.tr(),
    onSelected: (mode) {
        themeProvider.setTheme(mode);
    },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ThemeModeType.light,
          child: Row(
            children:  [
              Icon(Icons.light_mode, color: Color(0xff769BC6)),
              SizedBox(width: 8),
              Text('ThemeButtonLogin.light'.tr(),),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeModeType.dark,
          child: Row(
            children:  [
              Icon(Icons.dark_mode, color: Color(0xff2E5077)),
              SizedBox(width: 8),
              Text('ThemeButtonLogin.dark'.tr(),),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeModeType.system,
          child: Row(
            children:  [
              Icon(Icons.settings, color: Colors.grey),
              SizedBox(width: 8),
              Text('ThemeButtonLogin.system'.tr(),),
            ],
          ),
        ),
      ],
    ),
    );
  }
}


