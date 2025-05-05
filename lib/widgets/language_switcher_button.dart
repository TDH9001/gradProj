import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageSwitcherButton extends StatelessWidget {
  const LanguageSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
                Text(
                  'login_language_button'.tr(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.language, color: Color(0xff2E5077)),
                  title:  Text('login_language_english'.tr(), style: TextStyle(fontSize: 18)),
                  onTap: () {
                    context.setLocale(const Locale('en'));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language, color: Color(0xff769BC6)),
                  title:Text('login_language_arabic'.tr(), style: TextStyle(fontSize: 18)),
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
      child: Container(
        padding: const EdgeInsets.all(10),
        child: const Icon(
          Icons.language,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
