import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageLoginButton extends StatelessWidget {
  const LanguageLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.language, color: Color(0xFF1F2937)),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("choose_language".tr(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text("English"),
                  onTap: () {
                    context.setLocale(const Locale('en'));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text("العربية"),
                  onTap: () {
                    context.setLocale(const Locale('ar'));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

