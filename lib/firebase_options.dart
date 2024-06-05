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
    apiKey: 'AIzaSyAsYD6Pz2jjLzQsvbEaMelXJNvlZtxnFCc',
    appId: '1:769880525135:web:27987785eea9f7e6e45d3a',
    messagingSenderId: '769880525135',
    projectId: 'noteshouse-72',
    authDomain: 'noteshouse-72.firebaseapp.com',
    storageBucket: 'noteshouse-72.appspot.com',
    measurementId: 'G-4S5ZVBX3S1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBBKxU3xtyWb-_lBdDIGxJp4sgEQbEB7DE',
    appId: '1:769880525135:android:fbf204c4a3f4d364e45d3a',
    messagingSenderId: '769880525135',
    projectId: 'noteshouse-72',
    storageBucket: 'noteshouse-72.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAp8K3PvwauLkSA29wWJc1h1KLSN9G-5dw',
    appId: '1:769880525135:ios:63ea6ca6651eabdbe45d3a',
    messagingSenderId: '769880525135',
    projectId: 'noteshouse-72',
    storageBucket: 'noteshouse-72.appspot.com',
    iosBundleId: 'arpit.rangi.notesHouse',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAp8K3PvwauLkSA29wWJc1h1KLSN9G-5dw',
    appId: '1:769880525135:ios:f13cce1a541668ece45d3a',
    messagingSenderId: '769880525135',
    projectId: 'noteshouse-72',
    storageBucket: 'noteshouse-72.appspot.com',
    iosBundleId: 'arpit.rangi.notesHouse.RunnerTests',
  );
}
