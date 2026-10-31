# MegaMetal Flutter Application

The Flutter/Dart implementation of the dancer-spring selection and winding-tension calculator. See the [main project README](../README.md) for the project background, screenshots, calculation rules and the earlier Python/Kivy prototype.

## Run

From this directory, using a Flutter SDK with Dart 3.9 or later:

```bash
flutter pub get
flutter devices
flutter run
```

## Test

```bash
flutter test
```

The main application is in [`lib/main.dart`](lib/main.dart). Calculation tests are in [`test/calculation_test.dart`](test/calculation_test.dart), and the machine-selection screen test is in [`test/widget_test.dart`](test/widget_test.dart).

NIEHOFF D632 mode calculates winding tension and recommends a spring. SAMP mode calculates winding tension without selecting a spring. Both modes work offline.
