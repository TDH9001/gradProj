import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../features/auth/resetpassword_screen.dart';

class ForgetPasswordRow extends StatelessWidget {
  const ForgetPasswordRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'app_forget_pass'.tr(),
          style: const TextStyle(color: Colors.white70),
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
            'app_reset_pass'.tr(),
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
