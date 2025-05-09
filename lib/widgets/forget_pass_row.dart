import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../screen/auth/resetpassword_screen.dart';

class ForgetPassRow extends StatelessWidget {
   ForgetPassRow({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
         Text(
         'Login.forgot'.tr(),
          style: TextStyle(color: Colors.white70),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResetpasswordScreen(),
              ),
            );
          },
          child: Text(
            'Login.reset_button'.tr(),
            style: TextStyle(
              color:  isDarkMode ? Color(0xff769BC6) : Color(0xff2E5077),
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor:isDarkMode ? Color(0xff769BC6) :Color(0xff2E5077),
            ),
          ),
        ),
      ],
    );
  }
}
