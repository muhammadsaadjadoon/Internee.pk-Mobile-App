# Internee Portal — Flutter mobile app

Course discovery app based on the publicly visible Internee.pk learning catalog (snapshot: 27 September 2026). The catalog is bundled locally; it does **not** call an undocumented private API. Course cards open an embedded view of the official learning site. Firebase Authentication handles email/password sign up, sign in, password reset and sign out. Firestore stores each user's saved courses and independent practice quiz scores. Firebase accounts created here are **not** Internee.pk accounts; enrollment, official video access, quizzes, purchases and certificates happen through their own platform.

## Features

- Course discovery from a locally bundled snapshot of the public Internee.pk learning catalog (29 courses)
- Course cards open an embedded view of the official learning site
- Independent practice quizzes organized by subject category, with scores synced to Firestore
- Saved courses as personal bookmarks
- Email/password sign up, sign in, password reset, and sign out
- Responsive mobile interface

## Tech Stack

- Flutter and Dart (Material)
- Firebase Authentication — email/password accounts
- Cloud Firestore — saved courses and quiz scores
- webview_flutter — embedded LMS view
- url_launcher — external links

## Setup

1. Install Flutter stable and Android Studio or Xcode. From this directory run `flutter create --platforms=android,ios .` to generate standard native runner files (this delivery is a lean source project). Then `flutter pub get`.
2. Create your own Firebase project. Enable **Authentication → Sign-in method → Email/Password** and create a **Cloud Firestore** database.
3. Install FlutterFire CLI (`dart pub global activate flutterfire_cli`), then run `flutterfire configure --platforms=android,ios` from this directory. It generates `lib/firebase_options.dart` and registers app identifiers. Do not reuse credentials from another Firebase project.
4. In `lib/main.dart`, replace the `Firebase.initializeApp()` call with `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` and add `import 'firebase_options.dart';` after configuration. Android/iOS initialization can also work with native config alone, but generated options are recommended.
5. Publish the provided `firestore.rules` in Firebase console or with Firebase CLI. Run `flutter run`.

### Updating an existing configured app

Keep your own `android/` directory, `lib/firebase_options.dart`, `android/app/google-services.json`, existing app ID, and Firebase project. Replace `lib/main.dart`, `lib/catalog.dart`, add `lib/learning.dart` and `lib/portal.dart`, add `webview_flutter: ^4.10.0` to your `pubspec.yaml`, and publish the updated Firestore rules. If your existing `main.dart` already imports `firebase_options.dart` and passes `DefaultFirebaseOptions.currentPlatform` to `Firebase.initializeApp`, preserve those two lines. Then run `flutter pub get`, `dart format lib`, `flutter analyze`, and `flutter run`.

Do not overwrite a working, configured Android folder with this source package. This archive is intentionally source only.

### If Android stays on the Flutter splash screen

The app starts by calling `Firebase.initializeApp()`. If the native Firebase app isn't configured, it cannot reach the sign-in screen. Check the Android application ID in `android/app/build.gradle.kts` (or `build.gradle`) and register that **exact** ID in your Firebase project. Run `flutterfire configure --platforms=android,ios` in this app directory. Then add the generated `firebase_options.dart` import and `DefaultFirebaseOptions.currentPlatform` initialization as in step 4. Run `flutter clean`, `flutter pub get`, and `flutter run`. A failed initialization now shows the exception on screen instead of leaving the launch splash visible.

If you need web too, run `flutter create --platforms=web .`, rerun `flutterfire configure --platforms=android,ios,web`, and use the generated Firebase options as above.

## Scope and limitations

- The catalog includes 29 publicly listed courses with broad categories. Some metadata is unavailable publicly, so the app intentionally omits invented lesson counts, prices, LMS progress, and media.
- Selected curriculum previews for HTML, NextJS and Go are partial, sourced from publicly visible pages. The full and current curriculum is on the official LMS.
- The embedded LMS view displays the official site's public pages and any content the site itself permits after its separate sign-in. No video URL is extracted or bypassed. Some LMS pages or videos may require the external browser, which is available from the top-right button.
- Quizzes are clearly labeled **independent practice**, organized by subject category, and authored for this app. Scores sync to Firestore and are not official LMS quiz scores or certificates. No official progress is claimed.
- Saved courses are personal bookmarks, not enrollment.
- Branding uses a typographic wordmark and green palette inspired by the public website; no logo asset was copied or falsely represented as an official licensed asset. Check brand permission before publishing as an official app.
- Catalog data is a dated snapshot and must be maintained when the official site changes.
- No Flutter SDK was available in the creation environment, so compilation and device testing must be run after installing Flutter.

Public source pages used for catalog and partial lesson previews: https://learn.internee.pk/home/courses , https://www.learn.internee.pk/home/course/html/60 , https://www.learn.internee.pk/home/course/nextjs-full-course/37 , https://learn.internee.pk/home/course/n-a/48 .
