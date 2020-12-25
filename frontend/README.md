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

## Android Release
From the command line:

Run `flutter build appbundle` (Running flutter build defaults to a release build.)
The release bundle for your app is created at `./build/app/outputs/bundle/release/app.aab`.
