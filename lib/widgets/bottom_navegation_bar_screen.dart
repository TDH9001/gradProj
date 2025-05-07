import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/chats/chats_screen.dart';
import 'package:grad_proj/widgets/orgappbar.dart';
import 'package:grad_proj/screen/table/table_screen.dart';
import 'package:provider/provider.dart';
import '../screen/theme/dark_theme_colors.dart';
import '../screen/theme/light_theme.dart';
import '../providers/theme_provider.dart';
import '../screen/home/home_screen.dart';
import '../screen/account/account_screen.dart';

class BottomNavegationBarScreen extends StatefulWidget {
  BottomNavegationBarScreen({super.key});

  static String id = "HomeScreen";

  @override
  State<BottomNavegationBarScreen> createState() =>
      _BottomNavegationBarScreenState();
}

class _BottomNavegationBarScreenState extends State<BottomNavegationBarScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    RecentChats(),
    TableScreen(),
    AccountScreen(),
  ];

  final List<String> appBarTitles = [
    'Home',
    'Chats', // Title for RecentChats()
    'Table', // Title for TableScreen()
    'About',
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      key: scaffoldKey,
      appBar: Orgappbar(
        scaffoldKey: scaffoldKey,
        title: appBarTitles[currentIndex],
        leading: (currentIndex == 2 ||
                currentIndex == 1) // Show back button on Table and Chats screen
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white.withOpacity(0.85): Colors.white),
                onPressed: () {
                  setState(() {
                    currentIndex =
                        0; // Go back to the Home screen or any other screen
                  });
                },
              )
            : null, // No back button for other screens
      ),
      body: screens[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color:Colors.white,
          ),
          Icon(
            Icons.chat,
            size: 30,
            color:Colors.white,
          ),
          Icon(
            Icons.table_view_outlined,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.menu,
            size: 30,
            color: Colors.white,
          ),
        ],
        color: isDarkMode ? DarkThemeColors.primary:  LightTheme.primary,
        //Color(0xFF2E5077)
        backgroundColor:isDarkMode ? Colors.transparent: Colors.white10,
        buttonBackgroundColor: isDarkMode ? DarkThemeColors.buttonBackgroundColor: LightTheme.secondary,
        //Color(0xFF4A739F)  or 0xFF90A9D3
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
