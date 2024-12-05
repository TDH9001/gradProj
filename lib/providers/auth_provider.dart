import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:grad_proj/constants.dart";
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
  }
//provider Functions
  void loginUserWithEmailAndPassword(String _email, String _password) async {
    //tells the app we are currently working on signing in the user
    //notifies all rpovider that are intrested int he process of status
    //does the code
    //eventualy navigates
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      UserCredential _result = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      user = _result.user!;
      //update last seen time
      status = AuthStatus.Authenticated;
      SnackBarService.instance
          .showsSnackBarSucces(text: "Welcome ${user?.email}");
      //navigate to homepage
    } catch (e) {
      status = AuthStatus.ERROR;
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
      user = _result.user;
      status = AuthStatus.Authenticated;
      await onSucces!(user!.uid.toString());
      //comment to update the alst seen time
      navigationService.instance.goBack();
      SnackBarService.instance
          .showsSnackBarSucces(text: "Welcome ${user?.email}");
      // a naviagator to hope page > not yet made
    } catch (e) {
      print(e);
      status = AuthStatus.ERROR;
      user = null;
      SnackBarService.instance.showsSnackBarError(text: "Error authenticating");
      navigationService.instance.goBack();
    }
    notifyListeners();
  }

  // void RegisterUser(
  //     {required BuildContext cont,
  //     required String userId,
  //     required String firstName,
  //     required String lastname,
  //     required String email,
  //     required String phoneNumber,
  //     required String password}) {
  //   Future<void> onSuccess(String userId) async {
  //     status = AuthStatus.Authenticating;
  //     notifyListeners();
  //     try {
  //       UserCredential _result = await _auth.createUserWithEmailAndPassword(
  //           email: email, password: password);
  //       user = _result.user;
  //       status = AuthStatus.Authenticated;
  //       await onSuccess(user!.uid);
  //       Navigator.pop(cont);
  //       //update the last seen variable
  //       //add the user to the database
  //       PrintSnackBarSucces(cont, "welcome ${user!.email}");

  //       //should amke it navigate to homepage > not yet made
  //     } catch (e) {
  //       status = AuthStatus.ERROR;
  //       user = null;
  //       PrintSnackBarFail(cont, "error in regestry");

  //       print(e);
  //     }
  //     notifyListeners();
  //   }
  // }
}
