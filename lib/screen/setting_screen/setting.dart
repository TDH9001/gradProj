import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/widgets/custom_card.dart';
import 'package:grad_proj/widgets/orgappbar.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  static String id = "Setting";

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: Orgappbar(
        scaffoldKey: scaffoldKey,
        title: "Setting",
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 8),
          CustomCard(
            icon: Icons.brightness_6,
            title: "Theme",
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile<ThemeModeType>(
                        title: const Text("Light"),
                        value: ThemeModeType.light,
                        groupValue: themeProvider.themeMode,
                        onChanged: (value) {
                          themeProvider.setTheme(value!);
                          Navigator.pop(context);
                        },
                      ),
                      RadioListTile<ThemeModeType>(
                        title: const Text("Dark"),
                        value: ThemeModeType.dark,
                        groupValue: themeProvider.themeMode,
                        onChanged: (value) {
                          themeProvider.setTheme(value!);
                          Navigator.pop(context);
                        },
                      ),
                      RadioListTile<ThemeModeType>(
                        title: const Text("System"),
                        value: ThemeModeType.system,
                        groupValue: themeProvider.themeMode,
                        onChanged: (value) {
                          themeProvider.setTheme(value!);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          CustomCard(
            icon: Icons.language,
            title: "Language",
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text("English"),
                        onTap: () {
                          context.setLocale(const Locale('en'));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text("العربية"),
                        onTap: () {
                          context.setLocale(const Locale('ar'));
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),

        ],
      ),
    );
  }
}
