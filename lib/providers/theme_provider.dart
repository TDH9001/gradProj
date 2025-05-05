import 'package:flutter/material.dart';

enum ThemeModeType { light, dark, system }

class ThemeProvider with ChangeNotifier {
  ThemeModeType _themeMode = ThemeModeType.system;

  ThemeModeType get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeModeType.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeModeType.dark;
  }

  void setTheme(ThemeModeType mode) {
    _themeMode = mode;
    notifyListeners();
  }

  ThemeMode getEffectiveThemeMode() {
    if (_themeMode == ThemeModeType.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light;
    }
    return currentThemeMode;
  }

  ThemeMode get currentThemeMode {
    switch (_themeMode) {
      case ThemeModeType.light:
        return ThemeMode.light;
      case ThemeModeType.dark:
        return ThemeMode.dark;
      case ThemeModeType.system:
      default:
        return ThemeMode.system;
    }
  }
}
