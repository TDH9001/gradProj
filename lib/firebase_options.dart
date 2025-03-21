// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBDjvhakL-iw5_fxPtTTkpVKcMBLrlMKZo',
    appId: '1:1095379499506:web:91ab1af17759ef3977d36b',
    messagingSenderId: '1095379499506',
    projectId: 'gradproj-89f8a',
    authDomain: 'gradproj-89f8a.firebaseapp.com',
    storageBucket: 'gradproj-89f8a.firebasestorage.app',
    measurementId: 'G-TDR44KDTPJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfFeg2zhvx_H13lDx52xoUl50KZ2RgsLs',
    appId: '1:1095379499506:android:e83accf2d760d89d77d36b',
    messagingSenderId: '1095379499506',
    projectId: 'gradproj-89f8a',
    storageBucket: 'gradproj-89f8a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAY6yFQuCzJWyfVBJK9Tk_H_20Kpy22csg',
    appId: '1:1095379499506:ios:8b3a376fc1ad694077d36b',
    messagingSenderId: '1095379499506',
    projectId: 'gradproj-89f8a',
    storageBucket: 'gradproj-89f8a.firebasestorage.app',
    iosBundleId: 'com.example.gradProj',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAY6yFQuCzJWyfVBJK9Tk_H_20Kpy22csg',
    appId: '1:1095379499506:ios:8b3a376fc1ad694077d36b',
    messagingSenderId: '1095379499506',
    projectId: 'gradproj-89f8a',
    storageBucket: 'gradproj-89f8a.firebasestorage.app',
    iosBundleId: 'com.example.gradProj',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBDjvhakL-iw5_fxPtTTkpVKcMBLrlMKZo',
    appId: '1:1095379499506:web:7b92de5bb0e8640e77d36b',
    messagingSenderId: '1095379499506',
    projectId: 'gradproj-89f8a',
    authDomain: 'gradproj-89f8a.firebaseapp.com',
    storageBucket: 'gradproj-89f8a.firebasestorage.app',
    measurementId: 'G-EQ0SSLG8ZW',
  );

}