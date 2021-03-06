// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCtmcjxgbQvTXWH6yLSkzD0cV5Gbc_7J30',
    appId: '1:531502953778:web:14be4832ce3c416644532b',
    messagingSenderId: '531502953778',
    projectId: 'shareridealpha',
    authDomain: 'shareridealpha.firebaseapp.com',
    databaseURL: 'https://shareridealpha-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'shareridealpha.appspot.com',
    measurementId: 'G-BXZT5CXNBJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDWXI9gjfdLIDm0j-C61Yx6IMbhPJnk4u4',
    appId: '1:531502953778:android:5bb8352aa49e614c44532b',
    messagingSenderId: '531502953778',
    projectId: 'shareridealpha',
    databaseURL: 'https://shareridealpha-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'shareridealpha.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDuIB5w8s3_kWqzHLOpJmAXQR_9haUl_60',
    appId: '1:531502953778:ios:7fe64374dd13e16544532b',
    messagingSenderId: '531502953778',
    projectId: 'shareridealpha',
    databaseURL: 'https://shareridealpha-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'shareridealpha.appspot.com',
    androidClientId: '531502953778-ndhlrj6fk7fe60bmv0ua0obn916req7t.apps.googleusercontent.com',
    iosClientId: '531502953778-tmvkhrgcqb7kt071lc81ejk75rmo3okk.apps.googleusercontent.com',
    iosBundleId: 'com.example.userApp',
  );
}
