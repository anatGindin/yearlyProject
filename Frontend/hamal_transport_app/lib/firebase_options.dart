import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

const _databaseUrl = String.fromEnvironment(
  'DATABASE_URL',
  defaultValue:
      'https://hamal-transportation-app-default-rtdb.europe-west1.firebasedatabase.app',
);

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
    apiKey: 'AIzaSyB8GHxG3O-_--3hLUDyig3Z6fk0-0NTRZU',
    appId: '1:646186446544:android:646a6049c297fb213178d5',
    messagingSenderId: '646186446544',
    projectId: 'hamal-transportation-app',
    databaseURL: _databaseUrl,
    storageBucket: 'hamal-transportation-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCGTNXKiTXNMonjtq8p5Q5wWGgIA6tZRps',
    appId: '1:646186446544:ios:0f8c28626a0af2d93178d5',
    messagingSenderId: '646186446544',
    projectId: 'hamal-transportation-app',
    databaseURL: _databaseUrl,
    storageBucket: 'hamal-transportation-app.firebasestorage.app',
    iosBundleId: 'com.example.hamalTransportApp',
  );

  // TODO: configure firebase.json for iOS
}
