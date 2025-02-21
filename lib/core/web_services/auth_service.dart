
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone_app/core/helpers/cache_helper.dart';
import '../../data/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final defaultPfpUrl = 'https://icrbvpqtwskkgenybdyk.supabase.co/storage/v1/object/public/profile-pictures//default_profile.png';

  // Register
  Future<User?> registerWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await setUser(
        uId: result.user!.uid,
        name: displayName,
        email: email,
        
      );

      CacheHelper.setData(key: "uId", value: result.user!.uid);
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error during registration: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected Error during registration: $e');
      rethrow;
    }
  }

  // Login
  Future<User?> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      CacheHelper.setData(key: "uId", value: result.user!.uid);

      return result.user;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error during login: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected Error during login: $e');
      rethrow;
    }
  }

  Future<void> setUser({
    required String uId,
    required String name,
    required String email,
    String bio = '',
  }) async {
    try {
      UserModel userModel = UserModel(
        uId: uId,
        name: name,
        email: email,
        profilePicUrl: defaultPfpUrl,
        bio: bio,
      );

      await _firestore.collection('users').doc(uId).set(userModel.toJson());
    } catch (e) {
      print('Error saving user to Firestore: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
      await CacheHelper.deleteData(key: "uId");

    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }
}
