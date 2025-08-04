# 🚀 Running Guide - Flutter App

## 📱 Available Platforms

### 🤖 Android
- **Emulator**: Medium Phone API 35
- **Device ID**: `emulator-xxxxxx`
- **Status**: ✅ Ready

### 🍎 iOS  
- **Simulator**: iPhone 16 Pro
- **Device ID**: `xxxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`
- **Status**: ✅ Ready

---

## 🎯 How to Run

### Option 1: Run on Single Platform

#### Android Only
```bash
# Start Android emulator
flutter emulators --launch Medium_Phone_API_35

# Wait for emulator to start, then run
flutter run -d emulator-xxxxxxx
```

#### iOS Only
```bash
# Run on iOS Simulator
flutter run -d xxxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

### Option 2: Run on Both Platforms (Recommended)

#### Using Script
```bash
# Make script executable
chmod +x run_both_platforms.sh

# Run both platforms
./run_both_platforms.sh
```

#### Manual Method
```bash
# Terminal 1 - Android
flutter run -d emulator-xxxx

# Terminal 2 - iOS  
flutter run -d xxxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxE
```

---

## 🔧 Setup Commands

### Check Devices
```bash
flutter devices
```

### List Emulators
```bash
flutter emulators
```

### Clean and Rebuild
```bash
flutter clean
flutter pub get
```

---

## 🎮 Hot Reload Commands

เมื่อแอปรันแล้ว:
- **r** - Hot reload 🔥
- **R** - Hot restart 🔄
- **q** - Quit ❌
- **h** - Help 📖

---

## 🐛 Troubleshooting

### Android Issues
```bash
# Restart emulator
flutter emulators --launch Medium_Phone_API_35

# Check Android setup
flutter doctor
```

### iOS Issues
```bash
# Clean iOS build
cd ios && pod install && cd ..

# Check iOS setup  
flutter doctor
```

### General Issues
```bash
# Clean everything
flutter clean
flutter pub get

# Check Flutter setup
flutter doctor
```

---

## 📋 Prerequisites

### ✅ Required Setup
- [x] Flutter SDK installed
- [x] Android Studio with emulator
- [x] Xcode with iOS Simulator
- [x] Firebase configuration
- [x] Google Sign-in setup

### 🔧 Dependencies
- [x] Firebase Core
- [x] Firebase Auth
- [x] Cloud Firestore
- [x] Google Sign-in
- [x] Provider
- [x] Awesome Dialog

---

## 🎯 Testing Features

### 🔐 Authentication
- [ ] Email/Password Login
- [ ] Google Sign-in
- [ ] User Registration
- [ ] Logout

### 📱 UI Components
- [ ] Login Screen
- [ ] Register Screen
- [ ] Home Screen
- [ ] Profile Screen
- [ ] Navigation

### 🔄 State Management
- [ ] Provider setup
- [ ] Auth state management
- [ ] User data persistence

---

## 📞 Support

หากมีปัญหา:
1. ตรวจสอบ `flutter doctor`
2. ดู error messages
3. ลอง clean และ rebuild
4. ตรวจสอบ device connections 
