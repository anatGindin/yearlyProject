# Localization

The Hamal Transport App supports multiple languages (English and Hebrew at the moment) using the standard Flutter `l10n` library.

## Configuration

Localization settings are defined in:
1.  [l10n.yaml](../../Frontend/hamal_transport_app/l10n.yaml): Specifies the location of ARB files and the generation settings.
2.  [lib/l10n/](../../Frontend/hamal_transport_app/lib/l10n/): Directory containing the translation files.
    -   [app_en.arb](../../Frontend/hamal_transport_app/lib/l10n/app_en.arb): English translations.
    -   [app_he.arb](../../Frontend/hamal_transport_app/lib/l10n/app_he.arb): Hebrew translations.

## Defining New Strings

1.  Open [lib/l10n/app_en.arb](../../Frontend/hamal_transport_app/lib/l10n/app_en.arb).
2.  Add a new key-value pair and an optional description:
    ```json
    "myNewKey": "Hello World",
    "@myNewKey": {
      "description": "A greeting message"
    }
    ```
3.  Add the same key with the translated value to all the other `.arb` files.

## Generating Translation Code

Flutter automatically generates localization code when the app is built or when `flutter pub get` is run (if `generate: true` is set in `pubspec.yaml`).

To manually trigger generation, run:
```bash
flutter gen-l10n
```
This generates [app_localizations.dart](../../Frontend/hamal_transport_app/lib/l10n/app_localizations.dart) and its related files.

## Usage in Code

To use a localized string in a widget:

1.  Import the localization class:
    ```dart
    import 'package:hamal_transport_app/l10n/app_localizations.dart';
    ```
2.  Access the string via the context:
    ```dart
    final l10n = AppLocalizations.of(context)!;
    return Text(l10n.myNewKey);
    ```

For view models or logic outside of the build method, you may need to pass the `AppLocalizations` instance explicitly.
