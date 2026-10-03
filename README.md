# ConnectMe — Modern Community & Social Mobile Application

> **Share. Discover. Connect.**

A production-ready Flutter mobile application architected with **Clean Architecture**, **Cubit (BLoC)**, **GetIt Dependency Injection**, and **Firebase Backend Services**. Designed and styled after the **Social App — Free UI Kit (Community Figma)** design system.

---

## 📱 Visual Previews

| Screen | Preview | Screen | Preview |
|---|---|---|---|
| **Welcome / Onboarding** | ![Welcome](docs/screenshots/welcome.png) | **Sign In (Login)** | ![Sign In](docs/screenshots/login.png) |
| **Sign Up** | ![Sign Up](docs/screenshots/signup.png) | **Forgot Password** | ![Forgot Password](docs/screenshots/forgot_password.png) |
| **Community Feed** | ![Home Feed](docs/screenshots/home.png) | **Biometric Gate** | ![Biometric](docs/screenshots/biometric.png) |
| **Member Profile** | ![Profile](docs/screenshots/profile.png) | **Device Information** | ![Device Info](docs/screenshots/device_info.png) |
| **Community Map** | ![Map](docs/screenshots/map.png) | **App Distribution** | ![Distribution](docs/screenshots/distribution.png) |

---

## 🚀 Key Features

* **Authentication Flow**:
  * Email & password registration with validation (uppercase first letter for names, email formatting, minimum 6-character passwords).
  * Secure sign-in with password visibility toggle.
  * In-place password reset link dispatch.
  * Persistent authentication state checking upon startup.
  * User-friendly Firebase error mapping (no raw technical exceptions displayed to users).
* **Community Feed**:
  * Real-time Firestore stream with automatic updates.
  * Stories / Creators horizontal reel with custom gradient borders.
  * Rich post cards with user avatars, post imagery, location tags, and formatted timestamps.
  * Post reactions: Like/unlike with immediate count updates, comment counts, and sharing.
  * Modal bottom sheet for creating and publishing posts.
* **Community Profile & Biometric Gate**:
  * **Biometric Authentication Gate**: Accessing the Profile screen is protected by device biometrics (`local_auth` fingerprint or face authentication).
  * Direct profile photo upload to Firebase Storage with instant Firestore persistence.
  * User statistics (Posts, Followers, Following).
  * Photo grid and saved collections tabs.
  * Edit profile metadata (Full Name, Bio, Location).
* **Device Hardware Metadata**:
  * Native hardware model, manufacturer, and operating system inspection via `device_info_plus`.
* **Interactive Community Map**:
  * Interactive map surface with 4+ community member markers.
  * Custom interactive marker info-window cards displaying member avatars, roles, and biographies.

---

## 🛠 Tech Stack

| Layer / Capability | Package / Technology |
|---|---|
| **Framework** | Flutter 3.x / Dart 3.x (Material 3) |
| **State Management** | `flutter_bloc: ^9.1.1` |
| **Dependency Injection** | `get_it: ^8.0.3` |
| **Backend & Cloud** | Firebase (`firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`) |
| **Biometrics** | `local_auth: ^2.3.0` |
| **Device Hardware** | `device_info_plus: ^11.5.0` |
| **Media & Storage** | `image_picker: ^1.1.2`, `cached_network_image: ^3.4.1` |
| **UI & Typography** | `google_fonts: ^8.2.1`, `flutter_screenutil: ^5.9.3`, `flutter_svg: ^2.3.0` |
| **Utilities** | `equatable: ^2.1.0`, `timeago: ^3.7.0` |
| **Testing** | `flutter_test`, `mockito: ^5.7.0` |

---

## 🏛 Clean Architecture & Structure

The codebase strictly adheres to Clean Architecture separation of concerns:

```
Presentation (BLoC / Cubit, Screens, Widgets)
    │
    ▼
Domain (Entities, Use Cases, Repository Contracts)
    │
    ▼
Data (Models, DataSources, Repository Implementations)
    │
    ▼
Services (Firebase, Biometrics, Device Info, Storage)
```

### Directory Tree

```
lib/
├── main.dart                          # App bootstrapping, orientation lock, theme
├── injection.dart                     # GetIt dependency injection container
├── firebase_options.dart              # Firebase platform configurations
│
├── core/
│   ├── app_router/app_router.dart     # Named route enum definitions
│   ├── constants/
│   │   ├── app_colors.dart            # Figma Social App UI Kit color palette
│   │   ├── app_sizes.dart             # 4pt grid system & sizing constants
│   │   └── app_strings.dart           # Centralized localized copy & error messages
│   ├── errors/
│   │   ├── exceptions.dart            # Data-layer exceptions
│   │   └── failures.dart              # Domain-layer Failure sealed classes
│   ├── extensions/string_extensions.dart # Reusable form validators & string helpers
│   ├── helpers/firebase_error_mapper.dart # Technical error code translation
│   ├── routes/route_generator.dart    # Centralized MaterialPageRoute factory
│   ├── theme/app_theme.dart           # Material 3 ThemeData definition
│   ├── utils/either.dart              # Functional Either (Left/Right) type
│   └── widgets/                       # Reusable UI widgets (Buttons, TextFields, Overlays)
│
├── data/
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart # Firebase Auth integration
│   │   ├── user_remote_datasource.dart # Firestore user document operations
│   │   ├── post_data_source.dart      # Abstract datasource contract
│   │   ├── firestore_post_datasource.dart # Firestore feed datasource
│   │   ├── local_post_datasource.dart # Offline / fallback seed datasource
│   │   └── post_datasource_factory.dart # [Factory Pattern] Datasource selector
│   ├── models/
│   │   ├── user_model.dart            # [Builder Pattern] UserBuilder & UserModel
│   │   └── post_model.dart            # Post serialization model
│   └── repositories/
│       ├── auth_repository_impl.dart  # Concrete AuthRepository
│       ├── profile_repository_impl.dart # Concrete ProfileRepository
│       └── post_repository_impl.dart  # Concrete PostRepository
│
├── domain/
│   ├── entities/
│   │   ├── user_entity.dart           # Pure Dart User entity
│   │   └── post.dart                  # Pure Dart Post entity
│   ├── repositories/                  # Domain contracts (Auth, Profile, Post)
│   └── usecases/                      # Single-responsibility use cases
│
├── presentation/
│   ├── blocs/
│   │   ├── auth/                      # AuthCubit & AuthState
│   │   ├── profile/                   # ProfileCubit & ProfileState
│   │   └── post/                      # PostCubit & PostState
│   ├── common_widgets/
│   │   ├── full_size_button_unclicked.dart # Figma gradient pill button
│   │   ├── full_size_button_cliked.dart   # Secondary pill button
│   │   ├── text_form_field_widget.dart    # Figma pill input with password toggle
│   │   ├── post_card.dart                 # Social feed post card
│   │   └── member_marker.dart             # Community map marker
│   └── screens/
│       ├── splash/splash_screen.dart          # Figma onboarding splash
│       ├── login/login_screen.dart            # Figma sign in screen
│       ├── sign_up/sign_up_screen.dart        # Figma sign up screen
│       ├── forgot_password/forgot_password_screen.dart
│       ├── home/home_screen.dart              # Feed & notched navigation bar
│       ├── profile/profile_screen.dart        # Member profile & photo upload
│       ├── profile/edit_profile_screen.dart   # Profile metadata editor
│       ├── settings/settings_screen.dart      # Security & app preferences
│       └── map/map_screen.dart                # Interactive community map
│
└── services/
    ├── auth_service.dart              # FirebaseAuth wrapper
    ├── firestore_service.dart         # [Singleton Pattern] Shared Firestore instance
    ├── storage_service.dart           # Firebase Storage upload operations
    ├── biometric_service.dart         # Device biometric authentication
    └── device_info_service.dart       # Platform hardware inspection
```

---

## 🎨 Design Patterns Implemented

### 1. Singleton Pattern
* **Class**: `FirestoreService` (`lib/services/firestore_service.dart`)
* **Purpose**: Guarantees exactly one shared Firestore connection across the entire application lifecycle.
* **Problem Solved**: Prevents duplicate Firestore client allocations, ensures consistent read/write transactions, and standardizes collection access for all repositories.

### 2. Factory Pattern
* **Class**: `PostDataSourceFactory` (`lib/data/datasources/post_datasource_factory.dart`)
* **Purpose**: Determines whether `FirestorePostDataSource` or `LocalPostDataSource` is instantiated at runtime.
* **Problem Solved**: Decouples `PostRepositoryImpl` from the concrete data source implementation. Enables seamless transitions between live cloud data and local seed/offline caches.

### 3. Builder Pattern
* **Class**: `UserBuilder` (`lib/data/models/user_model.dart`)
* **Purpose**: Constructs a `UserModel` step by step, assigning only fields provided during specific user lifecycle events.
* **Problem Solved**: Prevents invalid constructors with dozens of nullable parameters. Allows setting only `id`, `fullName`, and `email` during initial registration, while deferring `bio`, `profileImageUrl`, `location`, `deviceModel`, and `osVersion` to profile setup.

---

## 🔒 Security Rules

### Cloud Firestore (`firestore.rules`)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isAuthenticated() { return request.auth != null; }
    function isOwner(userId) { return isAuthenticated() && request.auth.uid == userId; }

    match /users/{userId} {
      allow read: if isAuthenticated();
      allow create, update: if isOwner(userId);
      allow delete: if false;
    }

    match /posts/{postId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() && request.resource.data.authorId == request.auth.uid;
      allow update: if isAuthenticated() && (resource.data.authorId == request.auth.uid || request.resource.data.diff(resource.data).affectedKeys().hasOnly(['likes']));
      allow delete: if isAuthenticated() && resource.data.authorId == request.auth.uid;
    }
  }
}
```

### Firebase Storage (`storage.rules`)
* Profile images: `profile_images/{userId}.jpg` max 5MB, author only.
* Post pictures: `post_images/{postId}.jpg` max 10MB, authenticated authors.

---

## 📋 Device Permissions (`AndroidManifest.xml`)

| Permission | Purpose |
|---|---|
| `android.permission.INTERNET` | Communication with Firebase Auth, Firestore, and Storage |
| `android.permission.CAMERA` | Taking profile photos directly using device camera |
| `android.permission.READ_MEDIA_IMAGES` | Selecting profile and post images from gallery |
| `android.permission.USE_BIOMETRIC` | Biometric fingerprint & face authentication for profile gate |
| `android.permission.USE_FINGERPRINT` | Fingerprint authentication fallback for older Android devices |

---

## 📦 Getting Started & Release Build

### 1. Prerequisites
* Flutter SDK (3.12+ recommended)
* Android SDK (API 34, Min SDK 23)

### 2. Running Locally
```bash
# Install dependencies
flutter pub get

# Run on connected device / emulator
flutter run
```

### 3. Running Test Suite
```bash
flutter test test/unit
```
All **17 unit tests** run and pass:
* `validators_test.dart` (Email, password, name formatting, confirmation)
* `user_model_test.dart` (Serialization & UserBuilder pattern)
* `failures_test.dart` (Failure sealed classes & Equatable equality)
* `post_model_test.dart` (Post serialization & like checking)
* `factory_test.dart` (PostDataSourceFactory runtime selection)

### 4. Code Quality & Formatting
```bash
dart format .
flutter analyze
```
Result: **No issues found!**

### 5. Building Release APK
```bash
flutter build apk --release
# Generated output located at: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🚀 Firebase App Distribution Guide

To distribute the ConnectMe release APK to testing groups:

1. **Build the production release APK**:
   ```bash
   flutter build apk --release
   ```
2. **Navigate to Firebase Console**:
   * Open [Firebase Console](https://console.firebase.google.com).
   * Go to **Release & Monitor** → **App Distribution**.
3. **Upload Binary**:
   * Drag and drop `build/app/outputs/flutter-apk/app-release.apk`.
4. **Assign Testers**:
   * Enter test group email addresses (minimum 2 required):
     * `tester1@example.com`
     * `tester2@example.com`
5. **Add Release Notes**:
   ```
   ConnectMe v1.0.0 (Release Candidate)
   - Complete Figma Social App UI Kit implementation
   - Firebase Authentication & persistent session
   - Biometric profile gate
   - Firebase Storage profile photo upload
   - Community post feed & reactions
   - Interactive Community Map
   ```
6. **Distribute**: Click **Distribute to 2 testers**. Testers receive an email invitation to install via the Firebase App Tester app.

---

## 📄 License
This project is open-source under the [MIT License](LICENSE).
