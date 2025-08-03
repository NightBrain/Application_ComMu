import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../providers/auth_provider.dart';
import 'register_screen.dart'; // นำเข้าหน้าจอลงทะเบียน
import 'home_screen.dart'; // นำเข้า HomePage

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      bool success = await authProvider.loginUser(
        email: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      if (success && mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 30),
                  SizedBox(width: 10),
                  Text('Success'),
                ],
              ),
              content: Text('Login Successfully'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // ปิด dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: Text('OK', style: TextStyle(color: Colors.green)),
                ),
              ],
            );
          },
        );
      } else if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.error, color: Colors.red, size: 30),
                  SizedBox(width: 10),
                  Text('Error'),
                ],
              ),
              content: Text(authProvider.errorMessage ?? 'Incorrect Username or Password'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // ปิด dialog
                  },
                  child: Text('OK', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.error, color: Colors.red, size: 30),
                SizedBox(width: 10),
                Text('Error'),
              ],
            ),
            content: Text('Please enter correct Username & Password'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // ปิด dialog
                },
                child: Text('OK', style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );
    }
  }

  // Function to handle Google Sign-in
  Future<void> _signInWithGoogle() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool success = await authProvider.signInWithGoogle();

      if (success && mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 30),
                  SizedBox(width: 10),
                  Text('Success'),
                ],
              ),
              content: Text('Google Sign-in Successful!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // ปิด dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: Text('OK', style: TextStyle(color: Colors.green)),
                ),
              ],
            );
          },
        );
      } else if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.error, color: Colors.red, size: 30),
                  SizedBox(width: 10),
                  Text('Google Sign-in Error'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(authProvider.errorMessage ?? 'Google Sign-in failed'),
                  SizedBox(height: 16),
                  Text(
                    'หากปัญหายังคงอยู่ กรุณาตรวจสอบ:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• การเชื่อมต่ออินเทอร์เน็ต'),
                  Text('• การตั้งค่า Google Sign-in ใน Firebase Console'),
                  Text('• SHA-1 fingerprint configuration'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // ปิด dialog
                  },
                  child: Text('OK', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.error, color: Colors.red, size: 30),
                  SizedBox(width: 10),
                  Text('Error'),
                ],
              ),
              content: Text('An unexpected error occurred during Google Sign-in'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // ปิด dialog
                  },
                  child: Text('OK', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Center(
            child: SingleChildScrollView(
              child: Container(
                width: 350,
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'images/logo.png',
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        ),
                      ),
                      Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 30),

                      // Username TextField with validator
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Username';
                          } else if (!_isValidEmail(value)) {
                            return 'Invalid email format';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),

                      // Password TextField with validator
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 25),

                      // Login Button
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: ElevatedButton(
                          onPressed: authProvider.isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: authProvider.isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[300])),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'or',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey[300])),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Google Sign In Button
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            await _signInWithGoogle();
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/google.png',
                                height: 20,
                                width: 20,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'G',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Sign in with @g.cmru.ac.th',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                color: Color(0xFF42A5F5),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Custom painter ที่คุณมี (ถ้าต้องการ)
class HexagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Color(0xFF42A5F5), Color(0xFF1E88E5), Color(0xFF0D47A1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    path.moveTo(centerX - 40, centerY + 20);
    path.lineTo(centerX + 40, centerY);
    path.lineTo(centerX - 40, centerY - 20);
    path.lineTo(centerX - 20, centerY);
    path.close();

    canvas.drawPath(path, paint);

    final wingPath = Path();
    wingPath.moveTo(centerX - 10, centerY);
    wingPath.lineTo(centerX + 20, centerY - 15);
    wingPath.lineTo(centerX + 10, centerY);
    wingPath.close();

    canvas.drawPath(wingPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

double cos(double radians) => math.cos(radians);
double sin(double radians) => math.sin(radians); 