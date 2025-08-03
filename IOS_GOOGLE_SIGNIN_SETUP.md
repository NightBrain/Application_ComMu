# 🍎 iOS Google Sign-in Setup Guide

## ❌ ปัญหาที่เกิดขึ้น
```
iOS กด Google Sign-in แล้วเด้งออก
```

## ✅ วิธีแก้ไข

### 📱 ขั้นตอนที่ 1: ตั้งค่า Info.plist

#### 1.1 เพิ่ม URL Scheme
ไฟล์: `ios/Runner/Info.plist`

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.xxxxxxxxxxxxxxxxxxxxxxxxxxx</string>
        </array>
    </dict>
</array>
```

#### 1.2 เพิ่ม GIDClientID
```xml
<key>GIDClientID</key>
<string>xxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com</string>
```

---

### 🔧 ขั้นตอนที่ 2: ตรวจสอบ GoogleService-Info.plist

ไฟล์: `ios/Runner/GoogleService-Info.plist`

ตรวจสอบว่ามีข้อมูลถูกต้อง:
- ✅ **CLIENT_ID**: `xxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com`
- ✅ **REVERSED_CLIENT_ID**: `com.googleusercontent.apps.xxxxxxxxxxxxxxxxxxxxxxxxx`
- ✅ **BUNDLE_ID**: `com.example.xxxxxxxxxxxx`

---

### 🌐 ขั้นตอนที่ 3: Firebase Console

#### 3.1 เพิ่ม iOS App
1. เปิด [Firebase Console](https://console.firebase.google.com/)
2. เลือกโปรเจค `xxxxxxxxxxx`
3. ไปที่ **Project Settings** → **General**
4. คลิก **Add app** → **iOS**
5. ใส่ **Bundle ID**: `com.example.xxxxxxxxxxx`
6. ดาวน์โหลด `GoogleService-Info.plist`
7. วางใน `ios/Runner/`

#### 3.2 เปิด Google Sign-in
1. ไปที่ **Authentication** → **Sign-in method**
2. เปิด **Google** provider
3. ใส่ **Project support email**

---

### 🍎 ขั้นตอนที่ 4: Xcode Configuration

#### 4.1 เปิด Xcode
```bash
open ios/Runner.xcworkspace
```

#### 4.2 ตรวจสอบ Bundle Identifier
1. เลือก **Runner** project
2. เลือก **Runner** target
3. ตรวจสอบ **Bundle Identifier**: `com.example.xxxxxxxxxxxxxx`

#### 4.3 ตรวจสอบ Signing
1. เลือก **Signing & Capabilities**
2. ตรวจสอบ **Team** และ **Bundle Identifier**

---

### 🔄 ขั้นตอนที่ 5: Clean และ Rebuild

```bash
# Clean project
flutter clean

# Get dependencies
flutter pub get

# Install iOS pods
cd ios && pod install && cd ..

# Run on iOS
flutter run -d B4B26300-51BA-4EE2-8F7A-E47BF0FCC0EE
```

---

## 📋 ข้อมูลสำคัญ

| ข้อมูล | ค่า |
|--------|-----|
| **Bundle ID** | `com.example.xxxxxxxxxxx` |
| **CLIENT_ID** | `xxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com` |
| **REVERSED_CLIENT_ID** | `xxxxxxxxxxxxxxxxxxxxxxxxxxxxx.com.googleusercontent.apps` |
| **Firebase Project** | `xxxxxxxxxxx` |

---

## 🧪 การทดสอบ

1. **รันแอปบน iOS Simulator**
2. **ไปหน้า Login หรือ Register**
3. **กดปุ่ม "Sign in with Google"**
4. **ควรจะเปิด Safari และเลือก Google account**
5. **กลับมาที่แอปและ login สำเร็จ**

---

## ⚠️ หมายเหตุสำคัญ

- **iOS Simulator**: ต้องมี Google account ที่ login ไว้
- **Safari**: Google Sign-in จะเปิด Safari
- **Bundle ID**: ต้องตรงกับ Firebase Console
- **URL Scheme**: ต้องตรงกับ REVERSED_CLIENT_ID

---

## 🆘 หากยังมีปัญหา

1. **ตรวจสอบ Bundle ID** ตรงกับ Firebase Console
2. **ตรวจสอบ URL Scheme** ใน Info.plist
3. **ตรวจสอบ GoogleService-Info.plist** อยู่ในตำแหน่งถูกต้อง
4. **ลองใช้ Google account อื่น**
5. **Restart iOS Simulator**

---

## 📞 ติดต่อ

หากยังมีปัญหา กรุณาแจ้ง:
- Error message ที่แสดง
- ขั้นตอนที่ทำไปแล้ว
- ข้อมูล iOS Simulator ที่ใช้ 