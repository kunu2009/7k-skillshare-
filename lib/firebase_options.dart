import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'dart:io' show Platform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (Platform.isAndroid) {
      return android;
    }
    if (Platform.isIOS) {
      return ios;
    }
    if (Platform.isWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: '1:YOUR_APP_ID:android:YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'skillswap-firebase-project',
    databaseURL: 'https://skillswap-firebase-project.firebaseio.com',
    storageBucket: 'skillswap-firebase-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: '1:YOUR_APP_ID:ios:YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'skillswap-firebase-project',
    databaseURL: 'https://skillswap-firebase-project.firebaseio.com',
    storageBucket: 'skillswap-firebase-project.appspot.com',
    iosBundleId: 'com.skillswap.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: '1:YOUR_APP_ID:web:YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'skillswap-firebase-project',
    databaseURL: 'https://skillswap-firebase-project.firebaseio.com',
    storageBucket: 'skillswap-firebase-project.appspot.com',
    authDomain: 'skillswap-firebase-project.firebaseapp.com',
  );
}
