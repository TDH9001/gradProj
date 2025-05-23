import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../screen/theme/dark_theme_colors.dart';
import '../screen/theme/light_theme.dart';
class CustomCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
 final Widget? trailing;
  CustomCard({super.key, required this.icon, required this.title, required this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    return  Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: isDarkMode ? Color(0xFF1A2332) : Colors.white,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode ? [Color(0xFF323232), Color(0xFF323232) ]: [Colors.blue.shade50, Colors.white],
            //[Color(0xFF2E3B55), Color(0xFF2E5077)]
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: Icon(icon, color: isDarkMode ? DarkThemeColors.iconColor  : LightTheme.secondary),
          // Colors.lightBlueAccent  0xFF4A739F
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 12,
              color: isDarkMode ?DarkThemeColors.textcolor : LightTheme.textcolor,
            ),
          ),
          trailing: trailing,
          // trailing: Icon(Icons.arrow_forward_ios, size: 16,
          //   color: isDarkMode ? DarkThemeColors.arrowColor: LightTheme.secondary,
          //
          // ),
          onTap: onTap,
        ),
      ),
    );
  }
}

