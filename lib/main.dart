import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // ต้อง import ก่อนใช้
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart'; // import หน้า Login

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized');
  } catch (e) {
    print('❌ Firebase init failed: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
      ],
      child: MaterialApp(
        title: 'Loading Screen Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: LoadingScreen(),
        debugShowCheckedModeBanner: false,
      ),
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
    try {
      setState(() => _loadingText = 'กำลังเชื่อมต่อ Firebase...');
      // จำลองข้อผิดพลาด
      //throw Exception('Mock connection failed!');
      await Firebase.initializeApp(); // ✅ เชื่อม Firebase จริง

      setState(() => _loadingText = 'เชื่อมต่อสำเร็จ กำลังโหลด...');
      await Future.delayed(Duration(milliseconds: 600));

      // เปลี่ยนหน้าไป LoginScreen
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    } catch (e) {
      // กรณีเกิดข้อผิดพลาด
      setState(
        () => _loadingText = '❌ ไม่สามารถเชื่อมต่อ Firebase\n${e.toString()}',
      );
    }
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
