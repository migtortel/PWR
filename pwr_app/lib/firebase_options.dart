// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyCFC3rkBHJbH7cm2xqOdz2ACqd79yK0x5M',
    appId: '1:343859319893:web:844da2a3e0f7730ebd30dc',
    messagingSenderId: '343859319893',
    projectId: 'pwrappdb',
    authDomain: 'pwrappdb.firebaseapp.com',
    storageBucket: 'pwrappdb.firebasestorage.app',
    measurementId: 'G-CEDYK7RGSG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZBdMC5Y2R0U9ORVl6kmIxX-r10Kvom88',
    appId: '1:343859319893:android:e97a55f0aaac9cffbd30dc',
    messagingSenderId: '343859319893',
    projectId: 'pwrappdb',
    storageBucket: 'pwrappdb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDogawzqBDV-FYKPF8FxzwqvryLRis9c7o',
    appId: '1:343859319893:ios:582c6dae91aeb62bbd30dc',
    messagingSenderId: '343859319893',
    projectId: 'pwrappdb',
    storageBucket: 'pwrappdb.firebasestorage.app',
    iosBundleId: 'com.example.pwrApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDogawzqBDV-FYKPF8FxzwqvryLRis9c7o',
    appId: '1:343859319893:ios:582c6dae91aeb62bbd30dc',
    messagingSenderId: '343859319893',
    projectId: 'pwrappdb',
    storageBucket: 'pwrappdb.firebasestorage.app',
    iosBundleId: 'com.example.pwrApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCFC3rkBHJbH7cm2xqOdz2ACqd79yK0x5M',
    appId: '1:343859319893:web:b0216f4aa89c2003bd30dc',
    messagingSenderId: '343859319893',
    projectId: 'pwrappdb',
    authDomain: 'pwrappdb.firebaseapp.com',
    storageBucket: 'pwrappdb.firebasestorage.app',
    measurementId: 'G-5T6JJJF2FY',
  );
}
