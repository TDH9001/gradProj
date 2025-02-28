import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class CustomCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  CustomCard({super.key, required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    return  Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: isDarkMode ? Color(0xff1E1E1E) : Colors.white,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode ? [Color(0xFF2E3B55), Color(0xFF2E5077)] : [Colors.blue.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: Icon(icon, color: isDarkMode ? Colors.lightBlueAccent : Color(0xff769BC6)),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16,
            color: isDarkMode ? Colors.white54: Color(0xff769BC6),

          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

