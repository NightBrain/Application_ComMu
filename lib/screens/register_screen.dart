import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _genderController = TextEditingController(); // Controller for Gender
  final _imageUrlController =
      TextEditingController(); // Controller for Image URL

  String _selectedSex = 'male';
  bool _isPasswordVisible = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  // Helper method to show success snackbar (from MyHistoryScreen)
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  // Helper method to show error dialog (from MyHistoryScreen)
  void _showErrorDialog(String title, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: title,
      desc: message,
      btnOkText: 'OK',
      btnOkOnPress: () {},
      btnOkColor: Colors.red[600],
      buttonsTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.red[600],
      ),
      descTextStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: true,
      autoHide: Duration(seconds: 4),
    ).show();
  }

  // Helper method to check for empty fields (from MyHistoryScreen)
  List<String> _getEmptyFields() {
    List<String> emptyFields = [];

    if (_emailController.text.isEmpty) {
      emptyFields.add('Email');
    }
    if (_passwordController.text.isEmpty) {
      emptyFields.add('Password');
    }
    if (_nameController.text.isEmpty) {
      emptyFields.add('Name');
    }
    if (_surnameController.text.isEmpty) {
      emptyFields.add('Surname');
    }
    return emptyFields;
  }

  // Function to handle email/password registration and save to Firestore
  Future<void> _registerWithEmailAndPassword() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      bool success = await authProvider.registerUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
        gender: _selectedSex == 'male' ? 'Male' : 'Female',
        imageURL: _imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text.trim(),
      );

      if (success) {
        // Show success dialog
        await AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: 'สำเร็จ!',
          desc: 'ลงทะเบียนสำเร็จ! คุณสามารถเข้าสู่ระบบได้แล้ว',
          btnOkOnPress: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ).show();
      } else {
        String errorMessage = authProvider.errorMessage ?? 'ไม่สามารถลงทะเบียนได้';
        if (errorMessage.contains('Google')) {
          errorMessage += '\n\nหากปัญหายังคงอยู่ กรุณาตรวจสอบ:\n• การเชื่อมต่ออินเทอร์เน็ต\n• การตั้งค่า Google Sign-in ใน Firebase Console\n• SHA-1 fingerprint configuration';
        }
        _showErrorDialog('เกิดข้อผิดพลาด!', errorMessage);
      }
    } catch (e) {
      print(e);
      _showErrorDialog('เกิดข้อผิดพลาด!', 'เกิดข้อผิดพลาดที่ไม่คาดคิด');
    }
  }

  // Final submit handler, integrating validation and Firebase logic
  void _submitForm() async {
    List<String> emptyFields = _getEmptyFields();
    if (emptyFields.isNotEmpty) {
      String fieldsText = emptyFields.join(', ');
      String message = 'กรุณากรอกข้อมูลต่อไปนี้: $fieldsText';
      _showErrorDialog('ข้อมูลไม่ครบถ้วน!', message);
      return;
    }

    if (_formKey.currentState!.validate()) {
      await _registerWithEmailAndPassword();
    } else {
      _showErrorDialog(
        'ข้อมูลไม่ถูกต้อง!',
        'กรุณาตรวจสอบข้อมูลในฟอร์ม',
      );
    }
  }

  // Function to handle Google Sign-in (retained from previous version)
  Future<void> _signInWithGoogle() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool success = await authProvider.signInWithGoogle();

      if (success) {
        await AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: 'สำเร็จ!',
          desc: 'เข้าสู่ระบบด้วย Google สำเร็จ!',
          btnOkOnPress: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ).show();
      } else {
        _showErrorDialog(
          'เกิดข้อผิดพลาด!',
          authProvider.errorMessage ?? 'ไม่สามารถเข้าสู่ระบบด้วย Google ได้',
        );
      }
    } catch (e) {
      _showErrorDialog(
        'เกิดข้อผิดพลาด!',
        'เกิดข้อผิดพลาดที่ไม่คาดคิดในการเข้าสู่ระบบด้วย Google',
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _genderController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "ลงทะเบียน",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Name and Surname Fields
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _nameController,
                              label: 'ชื่อ',
                              icon: Icons.person_rounded,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกชื่อ';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: _surnameController,
                              label: 'นามสกุล',
                              icon: Icons.person_outline_rounded,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกนามสกุล';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Email Field
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอก email';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'กรุณากรอก email ที่ถูกต้อง';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      // Password Field
                      _buildTextField(
                        controller: _passwordController,
                        label: 'รหัสผ่าน',
                        icon: Icons.lock_rounded,
                        obscureText: !_isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกรหัสผ่าน';
                          }
                          if (value.length < 6) {
                            return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      // Confirm Password Field
                      _buildTextField(
                        controller: _confirmPasswordController,
                        label: 'ยืนยันรหัสผ่าน',
                        icon: Icons.lock_rounded,
                        obscureText:
                            !_isPasswordVisible, // Re-using password visibility
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณายืนยันรหัสผ่าน';
                          } else if (value != _passwordController.text) {
                            return 'รหัสผ่านไม่ตรงกัน';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),

                      // Sex Selection
                      Text(
                        'เพศ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildGenderOption(
                              'male',
                              'ชาย',
                              Icons.male_rounded,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildGenderOption(
                              'female',
                              'หญิง',
                              Icons.female_rounded,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Image URL Field
                      _buildTextField(
                        controller: _imageUrlController,
                        label: 'URL รูปโปรไฟล์ (ไม่บังคับ)',
                        icon: Icons.image_rounded,
                        keyboardType: TextInputType.url,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (!RegExp(
                              r'^https?:\/\/.+',
                              caseSensitive: false,
                            ).hasMatch(value)) {
                              return 'กรุณากรอก URL ที่ถูกต้อง';
                            }
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),

                      // Image Preview
                      if (_imageUrlController.text.isNotEmpty)
                        _buildImagePreview(),
                      SizedBox(height: 32),

                      // Register Button
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue[600]!, Colors.blue[700]!],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'ลงทะเบียน',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // "or" divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[300])),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'หรือ',
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
                          onPressed: _signInWithGoogle,
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
                                'ลงทะเบียนด้วย Google',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Bottom navigation text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "มีบัญชีอยู่แล้ว? ",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'เข้าสู่ระบบ',
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
            ],
          ),
        ),
      ),
    );
  }

  // Helper widgets from MyHistoryScreen
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
        onChanged: (value) {
          if (controller == _imageUrlController) {
            setState(() {});
          }
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue[600], size: 20),
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          errorStyle: TextStyle(
            color: Colors.red[600],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderOption(String value, String label, IconData icon) {
    bool isSelected = _selectedSex == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSex = value;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue[300]! : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue[600] : Colors.grey[600],
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.blue[600] : Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.preview_rounded,
                    color: Colors.blue[600],
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'ตัวอย่างรูปภาพ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                child: Image.network(
                  _imageUrlController.text,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.blue[600],
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[100],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image_rounded,
                            size: 40,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'ไม่สามารถโหลดรูปภาพได้',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'กรุณาตรวจสอบ URL',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 