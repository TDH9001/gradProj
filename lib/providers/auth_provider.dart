import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:grad_proj/constants.dart";

enum AuthStatus {
  NotAuthenticated,
  Authenticating,
  Authenticated,
  UserNotFound,
  ERROR,
}

//when Authprovider si called > then it will tell all listener in app > SOMETHING HAPPEND
//and allt he app will know as the whole app si inside of a reciver
//and as we made the UI int he login page a listining context > it will be notified
//changeing the _auth value there informing it of the chanegs


class AuthProvider extends ChangeNotifier {

  User? user;

  AuthStatus status = AuthStatus.NotAuthenticated;

  FirebaseAuth _auth = FirebaseAuth.instance;

  static AuthProvider instance = AuthProvider();
  
  AuthProvider() {
    _auth = FirebaseAuth.instance;
  }

  void loginUserWithEmailAndPassword(String _email, String _password) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      UserCredential _result = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      user = _result.user!;
      status = AuthStatus.Authenticated;
      //navigate to homepage
    } catch (e) {
      status = AuthStatus.ERROR;
      //snackbar an error
    }
    notifyListeners();
  }

  void RegisterUser(
      {required BuildContext cont,
      required String userId,
      required String firstName,
      required String lastname,
      required String email,
      required String phoneNumber,
      required String password}) {
    Future<void> onSuccess(String userId) async {
      status = AuthStatus.Authenticating;
      notifyListeners();
      try {
        UserCredential _result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        user = _result.user;
        status = AuthStatus.Authenticated;
        await onSuccess(user!.uid);
        Navigator.pop(cont);
        //update the last seen variable
        //add the user to the database
        PrintSnackBarSucces(cont, "welcome ${user!.email}");

        //should amke it navigate to homepage > not yet made
      } catch (e) {
        status = AuthStatus.ERROR;
        user = null;
        PrintSnackBarFail(cont, "error in regestry");

        print(e);
      }
      notifyListeners();
    }
  }
}
