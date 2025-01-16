import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Update user profile (e.g., name, email, etc.)
  Future<void> updateUser(String name, String email, String profilePicUrl, String bio) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Update Firestore document
        await _firestore.collection('users').doc(user.uid).update({
          'name': name,
          'email': email,
          'profilePicUrl': profilePicUrl,
          'bio': bio,
        });

        // Also update the user's email in Firebase Auth if necessary
        await user.verifyBeforeUpdateEmail(email);
      }
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  // Delete user account
  Future<void> deleteUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Delete the user's data in Firestore
        await _firestore.collection('users').doc(user.uid).delete();

        // Delete the user from Firebase Auth
        await user.delete();
      }
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  // Fetch user profile data
  Future<Map<String, dynamic>?> fetchUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Get the user document from Firestore
        DocumentSnapshot snapshot = await _firestore.collection('users').doc(user.uid).get();
        return snapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }
}
