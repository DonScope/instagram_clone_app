import 'package:firebase_auth/firebase_auth.dart';
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register
  Future<User?> registerWithEmailPassword({required String email, required String password}) async{ 
    try { 
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      return result.user;
    } catch (e) {
      print('Register Error: $e');
      return null;
    }
  }

  // Login
   Future<User?> loginWithEmailPassword({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      return result.user;
    } catch (e) {
      print('Login Error: $e');
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}