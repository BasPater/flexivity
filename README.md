# Flexivity

Flexivity transforms everyday fitness into a thrilling, shared journey of achievement and fun. By leveraging the power of gamification and social connectivity, Flexivity aims to inspire individuals and groups to elevate their physical activity, fostering healthier lifestyles through friendly competition and communal support.
Through customized step goals, Flexivity ensures that physical activity becomes a part of the user’s daily routine. The app’s engaging interface and reward system encourage consistent participation, which is key to developing long-lasting healthy habits.
By collecting data on users' activities and preferences, Flexivity can offer personalized insights and suggestions, improving the effectiveness of workout routines and enhancing user satisfaction. This tailored approach ensures that each user’s fitness journey is optimized to their specific needs and progress pace.

![Summary 2](https://github.com/BasPater/flexivity/assets/144136215/0c9f8713-02e3-49bf-a4da-55527c943b42)

### Contributors:
- [Bas Peters](https://github.com/BasPater)
- [Tom de Waardt](https://github.com/tomdewaardt)
- [Jack Stuijt](https://github.com/Coillenz)
- [Valentijn Nijhuis]()
- [Robert Visser](https://github.com/LordVis)

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
