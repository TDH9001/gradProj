import "dart:developer" as dev;
import "dart:io";

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:grad_proj/services/DB-service.dart";
import "package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart";
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

  Future<void> signOut() async {
    await _auth.signOut();
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
    } on Exception catch (e) {
      if (e is FirebaseAuthException) {
        SnackBarService.instance
            .showsSnackBarError(text: "PasswordRest failed ${e.message}");
      }
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
      await instance.user!.reload();
      bool isVerified = instance.user!.emailVerified;
      if (isVerified) {
        SnackBarService.instance
            .showsSnackBarSucces(text: "Welcome ${user?.email}");
        navigationService.instance.navigateToReplacement("HomeScreen");
      } else {
        SnackBarService.instance.showsSnackBarError(
            text:
                "plase validate your email , using the link sent to your inbox");
        await signOut();
      }
      //  SnackBarService.instance
      //     .showsSnackBarSucces(text: "Welcome ${user?.email}");
      //  navigationService.instance.navigateToReplacement("HomeScreen");
    } on Exception catch (e) {
      if (e is SocketException) {
        print(e);
      }
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
      if (instance.user != null) {
        await instance.user!.sendEmailVerification();
        SnackBarService.instance.showsSnackBarSucces(
            text: "Validation email sent to ${instance.user!.email}");

        await Future.delayed(Duration(seconds: 1));
        await signOut();
      }
    } on Exception catch (e) {
      if (e is FirebaseAuthException) {
        try {
          if (e.code == "ERROR_EMAIL_ALREADY_IN_USE" ||
              e.code == "email-already-in-use") {
            await signOut();

            UserCredential result = await _auth.signInWithEmailAndPassword(
              email: email,
              password: password,
            );
            instance.user = result.user;

            if (instance.user != null && !instance.user!.emailVerified) {
              final credential = EmailAuthProvider.credential(
                  email: email, password: password);
              await instance.user!.reauthenticateWithCredential(credential);
              //my research says this is a must to eliviate the 'requires-recent-login'error
              //forcing fireabse too treat it as a new user and not hesitate in sending  validation mails
              await result.user!.sendEmailVerification();
              dev.log(
                  "${user?.email}"); // did this as smetimes firebase refuses to send mails to accounts that have been deleted
              SnackBarService.instance.showsSnackBarSucces(
                text: "Verification email re-sent to ${user?.email}",
              );
            } else {
              SnackBarService.instance.showsSnackBarError(
                  text: "email is used , try and reset the password");
            }
            await Future.delayed(Duration(seconds: 1));
            await signOut();
          }
        } on Exception catch (e) {
          dev.log(e.toString());
        }
      }
      if (e is SocketException) {
        print(e);
        navigationService.instance.goBack();
        SnackBarService.instance
            .showsSnackBarError(text: "error connecting to server");
      }
      status = AuthStatus.ERROR;
      instance.user = null;

      navigationService.instance.goBack();
      //  SnackBarService.instance.showsSnackBarError(text: "Error authenticating");
    }
    notifyListeners();
  }
}
