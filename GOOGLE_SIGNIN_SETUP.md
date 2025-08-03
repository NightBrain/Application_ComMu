# 🔧 Google Sign-in Setup Guide

## ❌ ปัญหาที่เกิดขึ้น
```
PlatformException(sign_in_failed, com.google.android.gms.common.api.ApiException: 10:, null, null)
```

## ✅ วิธีแก้ไข (ทำตามขั้นตอนนี้)

### 📱 ขั้นตอนที่ 1: เพิ่ม SHA-1 ใน Firebase Console

#### 1.1 เปิด Firebase Console
- ไปที่: https://console.firebase.google.com/
- **เลือกโปรเจค**: `commurur`

#### 1.2 ไปที่ Project Settings
- คลิก **ไอคอนเฟือง** ⚙️ (มุมขวาบน)
- เลือก **Project settings**

#### 1.3 หา Android App
- เลื่อนลงไปหา **Your apps**
- คลิกที่ **Android app** (`com.example.xxxxxxxxxxxxx`)

#### 1.4 เพิ่ม SHA-1
- คลิก **Add fingerprint** 
- **ใส่ SHA-1 นี้**: `XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`
- คลิก **Save**

---

### 🔐 ขั้นตอนที่ 2: เปิด Google Sign-in

#### 2.1 ไปที่ Authentication
- ใน Firebase Console คลิก **Authentication** (เมนูซ้าย)
- คลิกแท็บ **Sign-in method**

#### 2.2 เปิด Google Provider
- คลิกที่ **Google** (ในรายการ providers)
- **เปิด Enable switch** ✅
- ใส่ **Project support email** (email ของคุณ)
- คลิก **Save**

---

### 🌐 ขั้นตอนที่ 3: ตรวจสอบ Google Cloud Console

#### 3.1 เปิด Google Cloud Console
- ไปที่: https://console.cloud.google.com/
- **เลือกโปรเจค**: `xxxxxsxxxx` (หรือโปรเจคที่เชื่อมกับ Firebase)

#### 3.2 เปิด APIs ที่จำเป็น
- คลิก **APIs & Services** → **Library**
- **เปิด APIs เหล่านี้**:

**Google Identity Services API**
- ค้นหา: "Google Identity Services API" หรือ "Identity Services"
- คลิก **Google Identity Services API**
- คลิก **Enable**

**Google Sign-In API** (ถ้ามี)
- ค้นหา: "Google Sign-In API"
- ถ้าเจอ ให้เปิดใช้งานด้วย

**หมายเหตุ**: Google Sign-in ใช้ Google Identity Services API เป็นหลัก

#### 3.3 ตรวจสอบ APIs ที่เปิดใช้งาน
- ไปที่ **APIs & Services** → **Enabled APIs**
- ตรวจสอบว่ามี APIs เหล่านี้:
  - ✅ Google Identity Services API
  - ✅ Google Sign-In API (ถ้ามี)

---

### 🔄 ขั้นตอนที่ 4: รันแอปใหม่

```bash
flutter clean
flutter pub get
flutter run
```

---

## 📋 ข้อมูลสำคัญ

| ข้อมูล | ค่า |
|--------|-----|
| **SHA-1** | `XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX` |
| **Package Name** | `com.example.XXXXXXXXXX` |
| **Firebase Project** | `XXXXXXXXXXX` |

---

## 🧪 การทดสอบ

1. **รันแอป**: `flutter run`
2. **ไปหน้า Login** หรือ **Register**
3. **กดปุ่ม** "Sign in with Google"
4. **เลือก Google account**
5. **ควร login สำเร็จ** ✅

---

## ⚠️ หมายเหตุสำคัญ

- **Emulator**: ต้องมี Google Play Services
- **Internet**: ต้องเชื่อมต่ออินเทอร์เน็ต
- **Google Account**: ต้องมีสิทธิ์เข้าถึงโปรเจค
- **Production**: ต้องใช้ release SHA-1 fingerprint

---

## 🆘 หากยังมีปัญหา

1. **ตรวจสอบ Internet connection**
2. **Restart emulator/device**
3. **ตรวจสอบ Google Play Services**
4. **ลองใช้ Google account อื่น**
5. **ตรวจสอบ APIs ใน Google Cloud Console**:
   - ไปที่ **APIs & Services** → **Enabled APIs**
   - ต้องมี **Google Identity Services API**
6. **ตรวจสอบ Firebase Authentication**:
   - ต้องเปิด **Google provider** แล้ว
   - ต้องมี **SHA-1 fingerprint** แล้ว

---

## 📞 ติดต่อ

หากยังมีปัญหา กรุณาแจ้ง:
- Error message ที่แสดง
- ขั้นตอนที่ทำไปแล้ว
- ข้อมูล device/emulator ที่ใช้ 