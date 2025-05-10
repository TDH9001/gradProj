import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/widgets/custom_card.dart';
import 'package:grad_proj/widgets/orgappbar.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../theme/dark_theme_colors.dart';
import '../theme/light_theme.dart';

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
    final bool isDarkMode = themeProvider.isDarkMode;
    return Scaffold(
      appBar: Orgappbar(
        scaffoldKey: scaffoldKey,
        title: 'Setting.title'.tr(),
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
            title: 'Setting.theme'.tr(),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile<ThemeModeType>(
                        title:  Text('Setting.light'.tr()),
                        value: ThemeModeType.light,
                        groupValue: themeProvider.themeMode,
                        onChanged: (value) {
                          themeProvider.setTheme(value!);
                          Navigator.pop(context);
                        },
                      ),
                      RadioListTile<ThemeModeType>(
                        title:  Text('Setting.dark'.tr()),
                        value: ThemeModeType.dark,
                        groupValue: themeProvider.themeMode,
                        onChanged: (value) {
                          themeProvider.setTheme(value!);
                          Navigator.pop(context);
                        },
                      ),
                      RadioListTile<ThemeModeType>(
                        title:  Text('Setting.system'.tr()),
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
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: isDarkMode ? DarkThemeColors.arrowColor: LightTheme.secondary,),
          ),
          CustomCard(
            icon: Icons.language,
            title:'Setting.language'.tr(),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title:  Text('Setting.english'.tr()),
                        onTap: () {
                          context.setLocale(const Locale('en'));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title:  Text('Setting.arabic'.tr()),
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
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: isDarkMode ? DarkThemeColors.arrowColor: LightTheme.secondary,),
          ),

        ],
      ),
    );
  }
}
