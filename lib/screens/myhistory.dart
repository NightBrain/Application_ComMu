import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'wrapper_screen.dart';

class MyHistoryScreen extends StatefulWidget {
  @override
  _MyHistoryScreenState createState() => _MyHistoryScreenState();
}

class _MyHistoryScreenState extends State<MyHistoryScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String _selectedSex = 'male';
  bool _isPasswordVisible = false;
  bool _isLoading = false;
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
    
    // โหลดข้อมูลผู้ใช้เมื่อเริ่มต้น
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.userData != null) {
      final user = authProvider.userData!;
      setState(() {
        _emailController.text = user.email;
        _nameController.text = user.name;
        _surnameController.text = user.surname;
        _selectedSex = user.gender.toLowerCase();
        _imageUrlController.text = user.imageURL ?? '';
      });
    }
  }

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

  void _showErrorDialog(String title, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: title,
      desc: message,
      btnOkText: 'OK',
      btnOkOnPress: () {
        print("Error dialog closed");
      },
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

  void _showLogoutDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'ออกจากระบบ',
      desc: 'คุณต้องการออกจากระบบหรือไม่?',
      btnOkText: 'ออกจากระบบ',
      btnCancelText: 'ยกเลิก',
      btnOkOnPress: () async {
        await Provider.of<AuthProvider>(context, listen: false).logoutUser();
        // Navigate กลับไปหน้า Login หลังจาก logout
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => WrapperScreen()),
            (route) => false,
          );
        }
      },
      btnCancelOnPress: () {},
      btnOkColor: Colors.red[600],
      btnCancelColor: Colors.grey[400],
      buttonsTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.orange[600],
      ),
      descTextStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: true,
    ).show();
  }

  List<String> _getEmptyFields() {
    List<String> emptyFields = [];

    if (_emailController.text.isEmpty) {
      emptyFields.add('Email');
    }
    if (_nameController.text.isEmpty) {
      emptyFields.add('First Name');
    }
    if (_surnameController.text.isEmpty) {
      emptyFields.add('Last Name');
    }

    return emptyFields;
  }

  Future<void> _updateProfile() async {
    // Check if required data is available first
    List<String> emptyFields = _getEmptyFields();

    if (emptyFields.isNotEmpty) {
      // Show warning for empty fields
      String fieldsText = emptyFields.join(', ');
      String message = 'Please fill in the following fields: $fieldsText';

      _showErrorDialog('Incomplete Information!', message);
      return;
    }

    // Check form validation
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        
        // สร้าง UserModel ใหม่จากข้อมูลที่แก้ไข
        final updatedUser = authProvider.userData!.copyWith(
          email: _emailController.text.trim(),
          name: _nameController.text.trim(),
          surname: _surnameController.text.trim(),
          gender: _selectedSex == 'male' ? 'Male' : 'Female',
          imageURL: _imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text.trim(),
        );

        // อัปเดตข้อมูลใน Firebase
        bool success = await authProvider.updateUserData(updatedUser);

        if (success) {
          _showSuccessSnackBar('อัปเดตข้อมูลสำเร็จ!');
          
          // แสดง dialog ยืนยันการอัปเดต
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: 'สำเร็จ!',
            desc: 'อัปเดตข้อมูลโปรไฟล์สำเร็จ',
            btnOkText: 'ดูข้อมูล',
            btnCancelText: 'ปิด',
            btnOkOnPress: () {
              _showUpdatedProfile();
            },
            btnCancelOnPress: () {},
            btnOkColor: Colors.blue[600],
            btnCancelColor: Colors.grey[400],
            buttonsTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            titleTextStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            descTextStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
            dismissOnTouchOutside: true,
            dismissOnBackKeyPress: false,
          ).show();
        } else {
          _showErrorDialog(
            'เกิดข้อผิดพลาด!',
            authProvider.errorMessage ?? 'ไม่สามารถอัปเดตข้อมูลได้',
          );
        }
      } catch (e) {
        _showErrorDialog(
          'เกิดข้อผิดพลาด!',
          'ไม่สามารถอัปเดตข้อมูลได้: ${e.toString()}',
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      _showErrorDialog(
        'ข้อมูลไม่ถูกต้อง!',
        'กรุณาตรวจสอบข้อมูลที่กรอกให้ถูกต้อง',
      );
    }
  }

  void _showUpdatedProfile() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.userData!;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      title: 'ข้อมูลโปรไฟล์',
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoItem('Email', user.email),
              _buildInfoItem('ชื่อ', user.name),
              _buildInfoItem('นามสกุล', user.surname),
              _buildInfoItem('เพศ', user.gender),
              _buildInfoItem(
                'รูปโปรไฟล์',
                user.imageURL ?? 'ไม่ระบุ',
              ),
              _buildInfoItem('User ID', user.uid),
              _buildInfoItem(
                'วันที่สร้าง',
                '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}',
              ),
            ],
          ),
        ),
      ),
      btnOkText: 'ตกลง',
      btnOkOnPress: () {
        print("Profile details OK button pressed");
      },
      btnOkColor: Colors.blue[600],
      buttonsTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: false,
    ).show();
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[800], fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "แก้ไขโปรไฟล์",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.blue[600]),
                  SizedBox(height: 16),
                  Text(
                    'กำลังโหลดข้อมูล...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return FadeTransition(
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
                          // Profile Image Preview
                          if (authProvider.userData?.imageURL != null)
                            Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: Center(
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage(
                                    authProvider.userData!.imageURL!,
                                  ),
                                  onBackgroundImageError: (exception, stackTrace) {
                                    // Handle error
                                  },
                                ),
                              ),
                            ),

                          // Email Field (Read-only)
                          _buildTextField(
                            controller: _emailController,
                            label: 'Email',
                            icon: Icons.email_rounded,
                            keyboardType: TextInputType.emailAddress,
                            enabled: false, // ไม่ให้แก้ไข email
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),

                          // Gender Selection
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

                          // Name Field
                          _buildTextField(
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
                          SizedBox(height: 20),

                          // Surname Field
                          _buildTextField(
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

                          // Update Button
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
                              onPressed: _isLoading ? null : _updateProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _isLoading
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'กำลังอัปเดต...',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      'อัปเดตโปรไฟล์',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    bool enabled = true,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey[100],
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
        enabled: enabled,
        validator: validator,
        style: TextStyle(
          fontSize: 16, 
          color: enabled ? Colors.grey[800] : Colors.grey[600],
        ),
        onChanged: (value) {
          // Trigger rebuild to show/hide image preview
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
              color: enabled ? Colors.blue[50] : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon, 
              color: enabled ? Colors.blue[600] : Colors.grey[500], 
              size: 20
            ),
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey[100],
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