# Commurur - Flutter Authentication App

แอปพลิเคชัน Flutter ที่มีระบบลงทะเบียนและเข้าสู่ระบบ เชื่อมต่อกับ Firebase Authentication และ Cloud Firestore

## ฟีเจอร์

- ✅ ระบบลงทะเบียนผู้ใช้ (Register)
- ✅ ระบบเข้าสู่ระบบ (Login)
- ✅ ระบบออกจากระบบ (Logout)
- ✅ รีเซ็ตรหัสผ่าน (Password Reset)
- ✅ จัดเก็บข้อมูลผู้ใช้ใน Cloud Firestore
- ✅ อัปโหลดรูปโปรไฟล์
- ✅ UI ที่สวยงามและใช้งานง่าย
- ✅ การตรวจสอบความถูกต้องของข้อมูล (Validation)
- ✅ การจัดการสถานะด้วย Provider

## ข้อมูลที่เก็บในการลงทะเบียน

- ชื่อ (Name)
- นามสกุล (Surname)
- อีเมล (Email)
- รหัสผ่าน (Password)
- ยืนยันรหัสผ่าน (Confirm Password)
- เพศ (Gender)
- รูปโปรไฟล์ (Profile Image)

## การติดตั้ง

### 1. ข้อกำหนดเบื้องต้น

- Flutter SDK (เวอร์ชันล่าสุด)
- Dart SDK
- Android Studio หรือ VS Code
- Firebase Account

### 2. ติดตั้ง Dependencies

```bash
flutter pub get
```

### 3. ตั้งค่า Firebase

#### 3.1 สร้างโปรเจค Firebase

1. ไปที่ [Firebase Console](https://console.firebase.google.com/)
2. สร้างโปรเจคใหม่ชื่อ "commurur-app"
3. เปิดใช้งาน Authentication และ Cloud Firestore

#### 3.2 เปิดใช้งาน Authentication

1. ไปที่ Authentication > Sign-in method
2. เปิดใช้งาน Email/Password

#### 3.3 ตั้งค่า Cloud Firestore

1. ไปที่ Firestore Database
2. สร้างฐานข้อมูลในโหมด test
3. ตั้งค่า Security Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

#### 3.4 อัปเดต Firebase Configuration

1. ไปที่ Project Settings
2. เพิ่มแอป Android/iOS/Web
3. ดาวน์โหลดไฟล์ `google-services.json` (Android) หรือ `GoogleService-Info.plist` (iOS)
4. วางไฟล์ในโฟลเดอร์ที่เหมาะสม:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

#### 3.5 อัปเดต Firebase Options

แก้ไขไฟล์ `lib/firebase_options.dart` ด้วยข้อมูลจริงจาก Firebase Console:

### 4. รันแอปพลิเคชัน

```bash
flutter run
```

## โครงสร้างโปรเจค

```
lib/
├── main.dart                 # Entry point ของแอป
├── firebase_options.dart     # Firebase configuration
├── models/
│   └── user_model.dart       # โมเดลข้อมูลผู้ใช้
├── providers/
│   └── auth_provider.dart    # Provider สำหรับจัดการ Authentication
├── services/
│   └── auth_service.dart     # Service สำหรับ Firebase Auth
├── screens/
│   ├── wrapper_screen.dart   # หน้าตรวจสอบสถานะการเข้าสู่ระบบ
│   ├── login_screen.dart     # หน้าเข้าสู่ระบบ
│   ├── register_screen.dart  # หน้าลงทะเบียน
│   └── home_screen.dart      # หน้าหลัก
└── widgets/
    ├── custom_button.dart    # Custom Button Widget
    └── custom_text_field.dart # Custom Text Field Widget
```

## การใช้งาน

### 1. ลงทะเบียนผู้ใช้ใหม่

1. เปิดแอปพลิเคชัน
2. กดปุ่ม "ลงทะเบียน"
3. กรอกข้อมูลที่จำเป็น
4. เลือกรูปโปรไฟล์ (ไม่บังคับ)
5. กดปุ่ม "ลงทะเบียน"

### 2. เข้าสู่ระบบ

1. กรอกอีเมลและรหัสผ่าน
2. กดปุ่ม "เข้าสู่ระบบ"

### 3. รีเซ็ตรหัสผ่าน

1. ในหน้าเข้าสู่ระบบ กดปุ่ม "ลืมรหัสผ่าน?"
2. กรอกอีเมล
3. ตรวจสอบกล่องจดหมายสำหรับลิงก์รีเซ็ตรหัสผ่าน

### 4. ออกจากระบบ

1. ในหน้าหลัก กดปุ่ม "ออกจากระบบ"
2. ยืนยันการออกจากระบบ

## การตรวจสอบความถูกต้องของข้อมูล

- **อีเมล**: ต้องเป็นรูปแบบอีเมลที่ถูกต้อง
- **รหัสผ่าน**: ต้องมีอย่างน้อย 6 ตัวอักษร
- **ยืนยันรหัสผ่าน**: ต้องตรงกับรหัสผ่าน
- **ชื่อและนามสกุล**: ต้องไม่เป็นค่าว่าง

## การจัดการข้อผิดพลาด

แอปพลิเคชันมีการจัดการข้อผิดพลาดที่ครอบคลุม:

- ข้อผิดพลาดการเชื่อมต่อ
- ข้อผิดพลาดการตรวจสอบความถูกต้อง
- ข้อผิดพลาดจาก Firebase
- ข้อผิดพลาดการอัปโหลดรูปภาพ

## การพัฒนาต่อ

### ฟีเจอร์ที่สามารถเพิ่มได้

- [ ] การแก้ไขโปรไฟล์
- [ ] การอัปโหลดรูปภาพไปยัง Firebase Storage
- [ ] การแจ้งเตือน (Push Notifications)
- [ ] การเข้าสู่ระบบด้วย Google/Facebook
- [ ] การจัดการข้อมูลผู้ใช้แบบ Offline
- [ ] การเข้ารหัสรูปภาพ
- [ ] การตรวจสอบความแข็งแกร่งของรหัสผ่าน

### การปรับปรุง UI/UX

- [ ] Dark Mode
- [ ] การเปลี่ยนธีม
- [ ] การเพิ่ม Animation
- [ ] การปรับปรุง Responsive Design

## การแก้ไขปัญหา

### ปัญหาที่พบบ่อย

1. **Firebase ไม่เชื่อมต่อ**
   - ตรวจสอบ Firebase configuration
   - ตรวจสอบการตั้งค่า Security Rules

2. **รูปภาพไม่แสดง**
   - ตรวจสอบการอนุญาตการเข้าถึงแกลเลอรี่
   - ตรวจสอบการตั้งค่า Camera permissions

3. **แอป Crash**
   - ตรวจสอบ Console logs
   - ตรวจสอบ Firebase Console

## License

MIT License

## ผู้พัฒนา

สร้างด้วย ❤️ โดย Flutter และ Firebase
