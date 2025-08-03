# 🚀 Project Setup Guide

## 📋 Prerequisites

### ✅ Required Software
- [x] Flutter SDK (latest stable)
- [x] Android Studio with Android SDK
- [x] Xcode (for iOS development)
- [x] Git
- [x] VS Code (recommended)

### 🔧 Required Accounts
- [x] Firebase Console account
- [x] Google Cloud Console account
- [x] Google account (for testing)

---

## 🛠️ Initial Setup

### 1. Clone Repository
```bash
git clone <repository-url>
cd commurur
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Setup Firebase Configuration

#### Android
1. ดาวน์โหลด `google-services.json` จาก Firebase Console
2. วางใน `android/app/`
3. **⚠️ ไฟล์นี้จะถูก ignore โดย git (มีข้อมูล sensitive)**

#### iOS
1. ดาวน์โหลด `GoogleService-Info.plist` จาก Firebase Console
2. วางใน `ios/Runner/`
3. **⚠️ ไฟล์นี้จะถูก ignore โดย git (มีข้อมูล sensitive)**

---

## 🔐 Firebase Configuration

### 1. Firebase Console Setup
1. เปิด [Firebase Console](https://console.firebase.google.com/)
2. สร้างโปรเจคใหม่หรือเลือกโปรเจคที่มีอยู่
3. เพิ่ม Android และ iOS apps

### 2. Authentication Setup
1. ไปที่ **Authentication** → **Sign-in method**
2. เปิดใช้งาน **Email/Password**
3. เปิดใช้งาน **Google**

### 3. Firestore Setup
1. ไปที่ **Firestore Database**
2. สร้าง database ใน test mode
3. ตั้งค่า security rules

---

## 📱 Platform Configuration

### Android Setup
```bash
# Check Android setup
flutter doctor

# Start Android emulator
flutter emulators --launch Medium_Phone_API_35
```

### iOS Setup
```bash
# Check iOS setup
flutter doctor

# Install iOS pods
cd ios && pod install && cd ..
```

---

## 🚀 Running the App

### Development Mode
```bash
# Run on Android
flutter run -d emulator-5554

# Run on iOS
flutter run -d B4B26300-51BA-4EE2-8F7A-E47BF0FCC0EE

# Run on both platforms
./run_both_platforms.sh
```

### Production Build
```bash
# Android APK
flutter build apk --release

# iOS Archive
flutter build ios --release
```

---

## 📁 Project Structure

```
commurur/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/                   # Data models
│   ├── providers/                # State management
│   ├── screens/                  # UI screens
│   ├── services/                 # Business logic
│   └── widgets/                  # Reusable widgets
├── android/                      # Android configuration
├── ios/                          # iOS configuration
├── images/                       # App assets
├── test/                         # Unit tests
├── pubspec.yaml                  # Dependencies
├── .gitignore                    # Git ignore rules
└── README.md                     # Project documentation
```

---

## 🔒 Security & Configuration

### Files Ignored by Git
- `android/app/google-services.json` - Firebase Android config
- `ios/Runner/GoogleService-Info.plist` - Firebase iOS config
- `.env*` - Environment variables
- `build/` - Build outputs
- `.dart_tool/` - Dart tool cache
- `ios/Pods/` - iOS dependencies

### Environment Variables
สร้างไฟล์ `.env` (จะถูก ignore โดย git):
```env
FIREBASE_PROJECT_ID=commurur
GOOGLE_CLIENT_ID=your_client_id
```

---

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

---

## 📦 Dependencies

### Core Dependencies
- `firebase_core` - Firebase initialization
- `firebase_auth` - Authentication
- `cloud_firestore` - Database
- `google_sign_in` - Google Sign-in
- `provider` - State management
- `awesome_dialog` - UI dialogs

### Development Dependencies
- `flutter_test` - Testing framework
- `flutter_lints` - Code linting

---

## 🐛 Troubleshooting

### Common Issues

#### Android Issues
```bash
# Clean Android build
flutter clean
flutter pub get

# Check Android setup
flutter doctor
```

#### iOS Issues
```bash
# Clean iOS build
cd ios && pod install && cd ..

# Check iOS setup
flutter doctor
```

#### Firebase Issues
1. ตรวจสอบ Firebase configuration files
2. ตรวจสอบ Firebase Console settings
3. ตรวจสอบ Google Cloud Console APIs

---

## 📚 Documentation

### Project Documentation
- [RUNNING_GUIDE.md](./RUNNING_GUIDE.md) - How to run the app
- [GOOGLE_SIGNIN_SETUP.md](./GOOGLE_SIGNIN_SETUP.md) - Google Sign-in setup
- [IOS_GOOGLE_SIGNIN_SETUP.md](./IOS_GOOGLE_SIGNIN_SETUP.md) - iOS specific setup

### External Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Google Sign-in Documentation](https://developers.google.com/identity/sign-in)

---

## 🤝 Contributing

### Git Workflow
1. Create feature branch
2. Make changes
3. Run tests
4. Submit pull request

### Code Style
- Follow Flutter conventions
- Use meaningful variable names
- Add comments for complex logic
- Keep functions small and focused

---

## 📞 Support

### Getting Help
1. Check documentation
2. Search existing issues
3. Create new issue with details
4. Contact development team

### Issue Template
```
**Description:**
Brief description of the issue

**Steps to Reproduce:**
1. Step 1
2. Step 2
3. Step 3

**Expected Behavior:**
What should happen

**Actual Behavior:**
What actually happens

**Environment:**
- Flutter version: X.X.X
- Platform: Android/iOS
- Device: Device name

**Additional Information:**
Any other relevant details
``` 