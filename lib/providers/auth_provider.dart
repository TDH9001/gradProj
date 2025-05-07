import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:grad_proj/constants.dart";
import "package:grad_proj/models/contact.dart";
import "package:grad_proj/services/DB-service.dart";
import "package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart";
import "package:grad_proj/widgets/bottom_navegation_bar_screen.dart";
import "package:grad_proj/screen/splash/splash_screen.dart";
import "package:grad_proj/services/navigation_Service.dart";
import '../services/snackbar_service.dart';

//when Authprovider si called > then it will tell all listener in app > SOMETHING HAPPEND
//and allt he app will know as the whole app si inside of a reciver
//and as we made the UI int he login page a listining context > it will be notified
//changeing the _auth value there informing it of the chanegs

enum AuthStatus {
  NotAuthenticated,
  Authenticating,
  Authenticated,
  UserNotFound,
  ERROR,
}

class AuthProvider extends ChangeNotifier {
  User? user;

  AuthStatus status = AuthStatus.NotAuthenticated;

  FirebaseAuth _auth = FirebaseAuth.instance;

  static AuthProvider instance = AuthProvider();

  AuthProvider() {
    //constructor to give init value on startup/use
    _auth = FirebaseAuth.instance;
    _isAuthenticated();
  }

  void _autiLogin() {
    navigationService.instance.navigateToReplacement(SplashScreen.id);
  }

  void signOut() async {
    _auth.signOut();
    user = null;
    await HiveUserContactCashingService.resetUserContactData();
  }

//firebase has it's own login-indecators > very usefll
  void _isAuthenticated() async {
    user = await _auth.currentUser;
    if (user != null) {
      notifyListeners();
      //  _autiLogin();
    }
  }

  void sendResetPassword({required String email}) async {
    notifyListeners();
    try {
      await _auth.sendPasswordResetEmail(email: email);
      SnackBarService.instance
          .showsSnackBarSucces(text: "password Rest Email sent to your inbox");
    } on FirebaseAuthException catch (e) {
      SnackBarService.instance
          .showsSnackBarError(text: "PasswordRest failed ${e.message}");
    }
  }

//provider Functions
  void loginUserWithEmailAndPassword(String _email, String _password) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      UserCredential _result = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      instance.user = _result.user!;
      //update last seen time
      status = AuthStatus.Authenticated;
      HiveUserContactCashingService.updateUserContactData(
          (await DBService.instance.getUserData(_result.user!.uid).first)
              .toJson());
      SnackBarService.instance
          .showsSnackBarSucces(text: "Welcome ${user?.email}");
      navigationService.instance.navigateToReplacement("HomeScreen");
    } catch (e) {
      status = AuthStatus.ERROR;
      instance.user = null;
      SnackBarService.instance.showsSnackBarError(text: "Error authenticating");
    }
    notifyListeners();
  }

  void RegesterUser(
      {required String firstName,
      required String lastname,
      required String email,
      required String phoneNumber,
      required String password,
      required Future<void> Function(String _uid)? onSucces}) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      UserCredential _result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      instance.user = _result.user;
      status = AuthStatus.Authenticated;
      await onSucces!(instance.user!.uid.toString());
      SnackBarService.instance
          .showsSnackBarSucces(text: "Welcome ${instance.user?.email}");
    } catch (e) {
      status = AuthStatus.ERROR;
      instance.user = null;

      navigationService.instance.goBack();
      SnackBarService.instance.showsSnackBarError(text: "Error authenticating");
    }
    notifyListeners();
  }
}
