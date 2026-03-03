import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return ios;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAc7gnoeslIWlDNU--MmRayT7HacTTbHTQ',
    appId: '1:507832408176:android:4cbe6cab1891dc04ed7cb5',
    messagingSenderId: '507832408176',
    projectId: 'careerpilot-l4kg9',
    databaseURL: 'https://careerpilot-l4kg9-default-rtdb.firebaseio.com',
    storageBucket: 'careerpilot-l4kg9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: '1:YOUR_APP_ID:ios:YOUR_IOS_APP_ID',
    messagingSenderId: '507832408176',
    projectId: 'careerpilot-l4kg9',
    databaseURL: 'https://careerpilot-l4kg9-default-rtdb.firebaseio.com',
    storageBucket: 'careerpilot-l4kg9.firebasestorage.app',
    iosBundleId: 'com.skillswap.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDFKhV0Gc8xKiE0eEWp7EBGw8advILcKWs',
    appId: '1:507832408176:web:75fc52d68240a883ed7cb5',
    messagingSenderId: '507832408176',
    projectId: 'careerpilot-l4kg9',
    databaseURL: 'https://careerpilot-l4kg9-default-rtdb.firebaseio.com',
    storageBucket: 'careerpilot-l4kg9.firebasestorage.app',
    authDomain: 'careerpilot-l4kg9.firebaseapp.com',
  );
}
