import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register new user
  Future<UserCredential?> registerUser({
    required String email,
    required String password,
    required String name,
    required String surname,
    required String gender,
    String? imageURL,
  }) async {
    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user model
      UserModel userModel = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        surname: surname,
        email: email,
        gender: gender,
        imageURL: imageURL,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save user data to Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการลงทะเบียน: $e');
    }
  }

  // Login user
  Future<UserCredential?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการเข้าสู่ระบบ: $e');
    }
  }

  // Logout user
  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการออกจากระบบ: $e');
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการดึงข้อมูลผู้ใช้: $e');
    }
  }

  // Update user data
  Future<void> updateUserData(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .update(userModel.toMap());
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการอัปเดตข้อมูลผู้ใช้: $e');
    }
  }

  // Check if email exists
  Future<bool> checkEmailExists(String email) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      return query.docs.isNotEmpty;
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการตรวจสอบอีเมล: $e');
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'รหัสผ่านอ่อนเกินไป กรุณาใช้รหัสผ่านที่แข็งแกร่งกว่า';
      case 'email-already-in-use':
        return 'อีเมลนี้ถูกใช้งานแล้ว กรุณาใช้อีเมลอื่น';
      case 'user-not-found':
        return 'ไม่พบผู้ใช้นี้ กรุณาตรวจสอบอีเมลและรหัสผ่าน';
      case 'wrong-password':
        return 'รหัสผ่านไม่ถูกต้อง กรุณาตรวจสอบรหัสผ่าน';
      case 'invalid-email':
        return 'รูปแบบอีเมลไม่ถูกต้อง';
      case 'user-disabled':
        return 'บัญชีผู้ใช้นี้ถูกปิดใช้งาน';
      case 'too-many-requests':
        return 'มีการพยายามเข้าสู่ระบบมากเกินไป กรุณาลองใหม่ภายหลัง';
      case 'operation-not-allowed':
        return 'การดำเนินการนี้ไม่ได้รับอนุญาต';
      default:
        return 'เกิดข้อผิดพลาด: ${e.message}';
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการรีเซ็ตรหัสผ่าน: $e');
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('การเข้าสู่ระบบด้วย Google ถูกยกเลิก');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Check if user data already exists in Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      // If user doesn't exist, create new user data
      if (!userDoc.exists) {
        // Split display name into first and last name
        List<String> nameParts = googleUser.displayName?.split(' ') ?? ['', ''];
        String firstName = nameParts.isNotEmpty ? nameParts.first : '';
        String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

        UserModel userModel = UserModel(
          uid: userCredential.user!.uid,
          name: firstName,
          surname: lastName,
          email: googleUser.email,
          gender: '', // Google doesn't provide gender
          imageURL: googleUser.photoUrl,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Save user data to Firestore
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userModel.toMap());
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      // Handle specific Google Sign-in errors
      String errorMessage = 'เกิดข้อผิดพลาดในการเข้าสู่ระบบด้วย Google';
      
      if (e.toString().contains('sign_in_failed')) {
        errorMessage = 'ไม่สามารถเข้าสู่ระบบด้วย Google ได้ กรุณาตรวจสอบการตั้งค่า Google Sign-in ใน Firebase Console';
      } else if (e.toString().contains('network_error')) {
        errorMessage = 'เกิดข้อผิดพลาดเครือข่าย กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต';
      } else if (e.toString().contains('developer_error')) {
        errorMessage = 'เกิดข้อผิดพลาดในการตั้งค่า Google Sign-in กรุณาตรวจสอบ SHA-1 fingerprint และ Google Services configuration';
      } else {
        errorMessage = 'เกิดข้อผิดพลาดที่ไม่คาดคิด: $e';
      }
      
      throw Exception(errorMessage);
    }
  }
} 