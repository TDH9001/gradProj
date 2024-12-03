import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

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
    _auth = FirebaseAuth.instance;
  }
  //when Authprovider si called > then it will tell alllistener in app > SOMETHING AHPPEND
  //and as we made the UI int he login page a listining context > it will be notified
  //changeing the _auth value there informing it of the chanegs
  void loginUserWithEmailAndPassword(String _email, String _password) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      UserCredential _result = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      user = _result.user!;
      status = AuthStatus.Authenticated;
      print("suucly loggedin");
      //navigate to homepage
    } catch (e) {
      status = AuthStatus.ERROR;
      print("login ERROR");
      //snackbar an error
    }
    notifyListeners();
  }
}
