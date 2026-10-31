# MegaMetal Spring Selection App

I started this project during my summer internship at Mega Metal in Kayseri. I am an Electrical-Electronics Engineering student at Abdullah Gül University.

During my internship, I saw that choosing the correct dancer spring could be difficult for machine operators. I wanted to make a simple app that could help with this task. The operator enters the wire count and the diameter of one wire. The app then calculates the winding tension and shows the spring number for the NIEHOFF D632 machine.

I first worked on the calculation with Python and made a basic screen with Kivy. Later, I made the mobile version with Flutter and Dart.

## Screenshots

<p>
  <img src="docs/screenshots/machine-selection.png" alt="Machine selection screen" width="280" />
  <img src="docs/screenshots/spring-result.png" alt="Calculation result showing Spring No. 2" width="280" />
</p>

These screenshots are from the app running in the iPhone Simulator.

## What the app does

The app has two machine options:

| Machine | Result |
| --- | --- |
| NIEHOFF D632 | Wire cross-section, winding tension, spring number and spring size |
| SAMP | Wire cross-section and winding tension |

The app works without an internet connection. Its screens are in Turkish because I prepared it for the operators at the factory.

The main features are:

- A machine selection screen and a short use guide.
- Two input fields: wire count and single-wire diameter in mm.
- Support for both a comma and a point, such as `0,30` and `0.30`.
- Messages for empty or incorrect values.
- A large, coloured result card.
- A clear button to start a new calculation.
- A back button to return to machine selection.

## How I developed the project

I began by learning basic Python topics, such as variables, conditions and functions. I used these topics to write the calculation in `calculator.py`. I kept this file separate from the screen code so that I could test the calculation more easily.

Then I used Kivy to make the first version of the screen. This version helped me connect the input fields and the calculation button to the Python function.

After that, I moved to Flutter and Dart for the mobile version. I added the machine selection page, input checks, result cards and the Mega Metal logo. The Flutter app does its own calculations in Dart. It does not need the Python program to run.

I ran the mobile app in the iOS Simulator. The project also includes Android files, but I have not finished checking it on an Android device.

## Calculation

I used the calculation method from the machine card:

```text
Raw cross-section = wire count × single-wire diameter² × 3.14 / 4
Cross-section     = floor(raw cross-section × 100) / 100
Winding tension   = cross-section × coefficient
```

Cross-section means the total area of the wires, in mm². Before calculating the tension, the program keeps two decimal places and removes the extra digits. For example, `1.5543` becomes `1.55`.

The program uses the table below to choose a coefficient. It takes the largest reference value that is equal to or smaller than the calculated cross-section. If the result is below `0.09 mm²`, it uses the first row.

| Reference cross-section (mm²) | Coefficient (N/mm²) |
| ---: | ---: |
| 0.09 | 50 |
| 0.14 | 40 |
| 0.35 | 40 |
| 0.80 | 30 |
| 1.50 | 25 |
| 2.50 | 20 |
| 4.00 | 20 |
| 6.00 | 16 |

For NIEHOFF D632, I used these spring ranges:

| Winding tension | Spring number | Spring size |
| --- | --- | --- |
| 4 ≤ F < 10 N | 1 | Ø0.8 × Ø8.80 × 55.5 mm |
| 10 ≤ F < 80 N | 2 | Ø1.25 × Ø13.70 × 65.2 mm |
| 80 ≤ F ≤ 100 N | 3 | Ø1.60 × Ø12.7 × 68.0 mm |

If the tension is below 4 N or above 100 N, the app does not suggest a spring. It asks the user to contact the responsible engineer. These rules are for this project and should not be used for every machine.

### Example

For 22 wires with a single-wire diameter of 0.30 mm:

```text
Cross-section:      1.55 mm²
Coefficient:        25 N/mm²
Winding tension:    38.75 N
Spring number:      2
```

SAMP gives the same cross-section and tension for these inputs, but it does not give a spring number.

## Run the mobile app

You need Flutter with Dart 3.9 or later. For iOS, you also need a Mac and Xcode. For Android, you need the Android SDK.

Open a terminal in the main project folder and run:

```bash
cd mobile
flutter pub get
flutter devices
flutter run
```

If there is more than one device, choose one with `flutter run -d <device-id>`.

## Run the Python version

You can check the Python calculation with Python 3.10 or later. This test does not need Kivy:

```bash
python3 -m unittest -v
```

To open the first screen version, you also need Kivy. Use a Python version that works with your Kivy version. For example, you can set up Python 3.12 like this:

```bash
python3.12 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
python app.py
```

On Windows, use `.venv\Scripts\activate` to activate the environment.

## Tests

I used tests to check the example above and some possible input problems.

The four Python tests check the example, spring limits, a result outside the spring range and an incorrect input. The three Flutter tests check the D632 example, the SAMP result and the machine selection screen.

To run the Flutter tests:

```bash
cd mobile
flutter pub get
flutter test
```

These tests check the software. They do not show how much scrap the app could reduce in the factory.

## Main files

| File or folder | What it contains |
| --- | --- |
| `calculator.py` | Python calculation |
| `app.py` | First screen version made with Kivy |
| `test_calculator.py` | Python tests |
| `requirements.txt` | Python package needed for the screen |
| `mobile/lib/main.dart` | Flutter screens and Dart calculation |
| `mobile/test/` | Flutter tests |
| `mobile/assets/` | Logo and app icon images |
| `docs/screenshots/` | Screenshots from the iPhone Simulator |

## What I learned

This project helped me understand how a problem in production can become a small software project. I practised using formulas in code, checking user inputs, writing tests and making a simple mobile screen. I also learned why a clear result is important for the person using the app.

In a future version, I would like to add a calculation history, more machines and QR code input. The current app selects a spring from the given rules. It does not calculate spring life or control the machine.

## About this project

**Selhan Coşkun**  
Electrical-Electronics Engineering, Abdullah Gül University

This repository contains the app from my Mega Metal summer internship. The daily activity form, final report and Kaizen presentations are kept separately. The Mega Metal name and logo belong to the company. This is my student project, not an official company app.
