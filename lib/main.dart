import 'package:flutter/material.dart';
import 'login.dart'; // import หน้า Login

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loading Screen Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoadingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _isLoading = true;
  String _loadingText = 'กำลังโหลด...';

  @override
  void initState() {
    super.initState();
    _startLoadingProcess();
  }

  // ฟังก์ชันจำลองการโหลดข้อมูล
  Future<void> _startLoadingProcess() async {
    await Future.delayed(Duration(milliseconds: 800));
    setState(() => _loadingText = 'กำลังตรวจสอบการเชื่อมต่อ...');
    await Future.delayed(Duration(milliseconds: 800));
    setState(() => _loadingText = 'กำลังโหลดการตั้งค่า...');
    await Future.delayed(Duration(milliseconds: 800));
    setState(() => _loadingText = 'กำลังเตรียมระบบ...');
    await Future.delayed(Duration(milliseconds: 800));
    setState(() => _loadingText = 'เสร็จสิ้น!');
    await Future.delayed(Duration(milliseconds: 500));

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // โลโก้ใหญ่ขึ้นและไม่มีพื้นหลัง
            Image.asset(
              'images/logo.png',
              width: 200, // ปรับขนาดโลโก้ใหญ่ขึ้น
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.image, size: 100, color: Colors.blue);
              },
            ),

            SizedBox(height: 40),

            // ข้อความโหลด
            Text(
              _loadingText,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 20),

            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
