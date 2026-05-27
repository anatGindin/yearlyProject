import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBdD9f4nqqJgyz5EZvrk_-HOtUPk1Uz-y8',
    appId: '1:889931214736:android:b5de0ce00e7dc737d4cd15',
    messagingSenderId: '889931214736',
    projectId: 'transportaion-app-e31cb',
    // The URL should be the same as the URL in Backend\firebase_config.py
    databaseURL:
        'https://transportaion-app-e31cb-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'transportaion-app-e31cb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCtOsVbhY95Zlu6X3VRYI5hzhKSx4ujtcU',
    appId: '1:889931214736:ios:f6ab131f7d494f9bd4cd15',
    messagingSenderId: '889931214736',
    projectId: 'transportaion-app-e31cb',
    // The URL should be the same as the URL in Backend\firebase_config.py
    databaseURL:
        'https://transportaion-app-e31cb-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'transportaion-app-e31cb.firebasestorage.app',
    iosBundleId: 'com.example.hamalTransportApp',
  );
}
