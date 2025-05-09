import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/providers/theme_provider.dart';

import 'package:grad_proj/screen/about_screen/question_screen.dart';
import 'package:grad_proj/screen/chats/chat_data_screen.dart';
import 'package:grad_proj/screen/onboarding_screen/onboarding_screen.dart';
import 'package:grad_proj/screen/profiles/CompleteProfile.dart';
import 'package:grad_proj/screen/profiles/Profile_screen.dart';
import 'package:grad_proj/screen/auth/resetpassword_screen.dart';
import 'package:grad_proj/screen/auth/singup_screen.dart';
import 'package:grad_proj/screen/chats/chats_screen.dart';
import 'package:grad_proj/screen/setting_screen/setting.dart';
import 'package:grad_proj/services/hive_caching_service/hive_caht_data_caching_service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';

import 'package:grad_proj/widgets/bottom_navegation_bar_screen.dart';
import 'package:grad_proj/screen/splash/determine.dart';
import 'package:grad_proj/screen/splash/no_internet_page.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:grad_proj/screen/auth/login_screen.dart';
import 'package:grad_proj/screen/splash/splash_screen.dart';
import '../providers/auth_provider.dart';
import '../services/navigation_Service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  HiveUserContactCashingService.initHive();
  HiveCahtMessaegsCachingService.initHive();
  runApp(
      EasyLocalization(
          supportedLocales: [Locale('en'), Locale('ar')],
          path: 'assets/translate',
          fallbackLocale: Locale('en'),
          startLocale: Locale('en'),
      child: MultiProvider(providers: [
    ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
    ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
  ], child: homePage())));
}

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    var _auth = Provider.of<AuthProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      navigatorKey: navigationService.instance.navKey, //added the nav service
      title: "Sci.Connect",
      themeMode: themeProvider.getEffectiveThemeMode(),
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
      ),

      darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Color(0xFF1C1C1C)
          //Color(0xFF2E3B55),
          ),
      // brightness: Brightness.dark,
      // primaryColor: DarkThemeColors.primary,
      // scaffoldBackgroundColor: Color(0xFF1C1C1C),
      // //Color(0xFF2E3B55),

      // theme: themeProvider.lightTheme,
      // darkTheme: themeProvider.darkTheme,

      //darkTheme: ThemeData.dark(),
      //FIXME: fix the isseus with levels in the ABOUT screens
      //FIXME: make a model for the table
      //FIXME: implement the table screen and its stuff

      //TODO: add logic for user to be added to thier classes after finishing
      //TODO: add local storage to store user current data
      //TODO: make chat be stored localy > then allow acces of images , files
      //TODO: make caht be loaded from DB then from cloud
      //TODO: handle files being added to the chat > probably needs storage
      //TODO: make the audi be laoded froma  file and solve the network crisis

      routes: {
        //  ChatDataScreen.id: (context) => ChatDataScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        Determine.id: (context) => Determine(),
        "OnboardingScreen": (context) => OnboardingScreen(),
        "login": (context) => LoginScreen(),
        "resetPassScreen": (context) => ResetpasswordScreen(),
        "SingupScreen": (context) => SingupScreen(),
        //home has been replaced by BottomNavegationBarScreen
        "HomeScreen": (context) => BottomNavegationBarScreen(),
        "ProfileScreen": (context) => ProfileScreen(),
        "CompleteProfile": (context) => CompleteProfile(),
        "RecentChats": (context) => RecentChats(),
        "AboutScreen": (context) => QuestionScreen(),
        "Setting": (context) => Setting(),
        "noInternet": (context) => noInternet(),
      },
      //make it splash later
      initialRoute: SplashScreen.id,
      debugShowCheckedModeBanner: false,
    );
  }
}

//stopped at 5
