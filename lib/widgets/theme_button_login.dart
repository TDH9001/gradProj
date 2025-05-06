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
    tooltip: 'Theme',
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
              Text('light mode',),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeModeType.dark,
          child: Row(
            children:  [
              Icon(Icons.dark_mode, color: Color(0xFF323232)),
              SizedBox(width: 8),
              Text('dark mode')
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeModeType.system,
          child: Row(
            children:  [
              Icon(Icons.settings, color: Colors.grey),
              SizedBox(width: 8),
              Text('system'),
            ],
          ),
        ),
      ],
    ),
    );
  }
}


