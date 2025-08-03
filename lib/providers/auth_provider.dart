import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _currentUser;
  UserModel? _userData;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get currentUser => _currentUser;
  UserModel? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  // Initialize auth provider
  void initialize() {
    _currentUser = _authService.currentUser;
    if (_currentUser != null) {
      _loadUserData();
    }
    _authService.authStateChanges.listen((User? user) {
      _currentUser = user;
      if (user != null) {
        _loadUserData();
      } else {
        _userData = null;
      }
      notifyListeners();
    });
  }

  // Load user data from Firestore
  Future<void> _loadUserData() async {
    if (_currentUser != null) {
      try {
        _userData = await _authService.getUserData(_currentUser!.uid);
        notifyListeners();
      } catch (e) {
        _errorMessage = e.toString();
        notifyListeners();
      }
    }
  }

  // Register user
  Future<bool> registerUser({
    required String email,
    required String password,
    required String name,
    required String surname,
    required String gender,
    String? imageURL,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Validate password strength
      if (password.length < 6) {
        _setError('รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร');
        return false;
      }

      // Validate email format
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        _setError('รูปแบบอีเมลไม่ถูกต้อง');
        return false;
      }

      // Check if email already exists
      bool emailExists = await _authService.checkEmailExists(email);
      if (emailExists) {
        _setError('อีเมลนี้ถูกใช้งานแล้ว');
        return false;
      }

      // Register user
      await _authService.registerUser(
        email: email,
        password: password,
        name: name,
        surname: surname,
        gender: gender,
        imageURL: imageURL,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Login user
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.loginUser(
        email: email,
        password: password,
      );

      _setLoading(false);
      notifyListeners(); // เพิ่ม notifyListeners เพื่อให้ WrapperScreen rebuild
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Logout user
  Future<void> logoutUser() async {
    _setLoading(true);
    try {
      await _authService.logoutUser();
      _currentUser = null;
      _userData = null;
      notifyListeners(); // เพิ่ม notifyListeners เพื่อให้ WrapperScreen rebuild
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Update user data
  Future<bool> updateUserData(UserModel userModel) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.updateUserData(userModel);
      _userData = userModel;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.signInWithGoogle();
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _clearError();
  }
} 