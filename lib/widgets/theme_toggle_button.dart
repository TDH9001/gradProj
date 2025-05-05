import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/theme/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

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
        tooltip: 'Change Theme',
        onSelected: (mode) {
          themeProvider.setTheme(mode);
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: ThemeModeType.light,
            child: Row(
              children: const [
                Icon(Icons.light_mode, color: Color(0xff769BC6)),
                SizedBox(width: 8),
                Text('Light Theme'),
              ],
            ),
          ),
          PopupMenuItem(
            value: ThemeModeType.dark,
            child: Row(
              children: const [
                Icon(Icons.dark_mode, color: Color(0xFF323232)),
                SizedBox(width: 8),
                Text('Dark Theme'),
              ],
            ),
          ),
          PopupMenuItem(
            value: ThemeModeType.system,
            child: Row(
              children: const [
                Icon(Icons.settings, color: Colors.grey),
                SizedBox(width: 8),
                Text('System Default'),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
