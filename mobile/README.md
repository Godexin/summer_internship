# MegaMetal Mobile App

This folder contains the mobile version of my internship project. I made it with Flutter and Dart after working on the first Python and Kivy version.

The app has two options. NIEHOFF D632 shows the winding tension and a spring number. SAMP shows the winding tension. Both options work without an internet connection.

You can find the project story, calculation tables and screenshots in the [main README](../README.md).

## Run the app

You need Flutter with Dart 3.9 or later. Open a terminal in this folder and run:

```bash
flutter pub get
flutter devices
flutter run
```

## Run the tests

```bash
flutter test
```

## Main files

- [`lib/main.dart`](lib/main.dart): the app screens and calculation code.
- [`test/calculation_test.dart`](test/calculation_test.dart): tests for the D632 and SAMP calculations.
- [`test/widget_test.dart`](test/widget_test.dart): a test for the machine selection screen.
- `assets/`: the logo and app icon images.
