import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../features/auth/singup_screen.dart';

class SignupTextRow extends StatelessWidget {
  const SignupTextRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "app_reset_pass_tex".tr(),
          style: const TextStyle(color: Colors.white70),
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
          child: Text(
            'app_creat_acc'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
