import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class Validators {
  // Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Regex for email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null; // No error
  }

  // Validate if email exists
  static Future<String?> validateEmailExists(String email,
      {String? currentUserEmail}) async {
    if (currentUserEmail != null && email == currentUserEmail) {
      return null; // No error if the email hasn't changed
    }

    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return 'Email already exists';
    }

    return null; // No error
  }

  // Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null; // No error
  }

  // Validate username
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters long';
    }
    return null; // No error
  }

  static Future<String?> validateUsernameExists(String userName,
      {String? currentUsername}) async {
    if (currentUsername != null && userName == currentUsername) {
      return null; // No error if the email hasn't changed
    }

    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore
        .collection('users')
        .where('userName', isEqualTo: userName)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return 'Username already exists';
    }
    log(querySnapshot.docs.toString());
    return null; // No error
  }

  // Validate phone number
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    // Regex for phone number validation
    final phoneRegex = RegExp(r'^\+[0-9\s-]{11,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null; // No error
  }
}
