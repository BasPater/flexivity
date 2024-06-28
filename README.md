# flexivity-frontend

[![coverage report](https://gitlab.fdmci.hva.nl/se-specialization-2023-2/projects-tse2/404_namenotfound/step-counter-frontend/badges/main/coverage.svg)](https://gitlab.fdmci.hva.nl/se-specialization-2023-2/projects-tse2/404_namenotfound/step-counter-frontend/-/commits/main)
[![Latest Release](https://gitlab.fdmci.hva.nl/se-specialization-2023-2/projects-tse2/404_namenotfound/step-counter-frontend/-/badges/release.svg)](https://gitlab.fdmci.hva.nl/se-specialization-2023-2/projects-tse2/404_namenotfound/step-counter-frontend/-/releases)

## Installation instructions
On gitlab go to Deploy>Releases and select the most recent release. Once there, download the file ending in .apk. You can then navigate to this file on your Android device in your file manager of choice. Tap on the file and you will be given a prompt. Follow the instructions in the prompt and the App will be installed on your device.

## Developer instructions
### Flutter SDK
When opening the project, make sure the Flutter SDK is installed. If this is yet to be the case, [please follow the official installation guide](https://docs.flutter.dev/get-started/install).

### Dependencies
To install the project dependencies run the following command:
```bash
flutter pub get
```

### Running tests
To run the unit tests in the project, first run the following command to generate the mocks:
```bash
dart run build_runner build
```

You can then run the tests using:
```
flutter test
```