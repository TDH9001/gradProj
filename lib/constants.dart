import 'dart:ui';
import 'package:flutter/material.dart';

const Color accent = Color(0x7AB2D3);
const Color backGround = Colors.white;
const Color textAndAccent = Colors.black;

void PrintSnackBarSucces(BuildContext context, String S) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 2),
      content:
          Text(S, style: const TextStyle(color: Colors.black, fontSize: 15)),
      backgroundColor: Colors.green,
    ),
  );
}

void PrintSnackBarFail(BuildContext context, String S) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 2),
      content:
          Text(S, style: const TextStyle(color: Colors.black, fontSize: 15)),
      backgroundColor: Colors.red,
    ),
  );
}

//  MediaQuery.of(context).size.height;

class TextStyles {
  static TextStyle text = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static TextStyle subtext = TextStyle(
    fontSize: 15,
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );

  void addProfileImage() {
    print("PUT INT HE REGESTRATION PAGE");
    // try {
    // _imageFileExample = await MediaService.instance
    //     .getImageFromLibrary();
    //   var _result = await CloudStorageService
    //       .instance
    //       .upLoadUserProfileImage(
    //           uid: _uid,
    //           image: _imageFileExample!);
    //   var _imageLink = CloudStorageService
    //       .instance.baseRef
    //       .getDownloadURL();
    //   print(_imageLink);
    // } catch (e) {
    //   SnackBarService.instance
    //       .showsSnackBarError(
    //           text:
    //               "image could nto be uploaded");
    // }
  }
}
