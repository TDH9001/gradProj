import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../screen/auth/singup_screen.dart';

class HaveAccRow extends StatelessWidget {
  const HaveAccRow({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.white70),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SingupScreen(),
              ),
            );
          },
          child:  Text(
            'Sign up',
            style: TextStyle(
              color: isDarkMode ? Color(0xff769BC6) : Color(0xff2E5077),
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: isDarkMode ? Color(0xff769BC6) : Color(0xff2E5077),
            ),
          ),
        ),
      ],
    );
  }
}
