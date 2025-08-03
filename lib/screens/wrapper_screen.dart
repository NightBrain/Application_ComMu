import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class WrapperScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // ถ้า user login อยู่แล้ว ให้ไปหน้า Home
        if (authProvider.isAuthenticated && authProvider.userData != null) {
          return HomePage();
        }
        
        // ถ้ายังไม่ได้ login ให้ไปหน้า Login
        return LoginScreen();
      },
    );
  }
} 