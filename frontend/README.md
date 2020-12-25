# creditask

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Generating launcher icons for Android and iOS
1. Make sshure `flutter_icons` in `pubspec.yml` configuration is correct.
2. Run `flutter pub run flutter_launcher_icons:main`
3. Done.

## Release

### Android
From the command line:

1. Run `flutter build appbundle` (Running flutter build defaults to a release build.)
The release bundle for your app is created at `./build/app/outputs/bundle/release/app.aab`.
2. go to `https://play.google.com/console` => `Creditask` and create a new release for a track  (Testing/Production)

### iOS

1. Run `flutter build ios`
2. In Xcode, open `Runner.xcworkspace` in your app’s ios folder.
3. Select `Product` > `Scheme` > `Runner`.
4. Select `Product` > `Destination` > `Any iOS Device`.
5. Select `Runner` in the Xcode project navigator, then select the `Runner` target in the settings view sidebar.
6. In the Identity section, update the Version to the user-facing version number you wish to publish.
7. In the Identity section, update the Build identifier to a unique build number used to track this build on App Store Connect. Each upload requires a unique build number.
8. Select `Product` > `Archive` to produce a build archive.
