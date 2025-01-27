import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone_app/data/models/post_model.dart';
import 'package:instagram_clone_app/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseClient _client = Supabase.instance.client;
  Future<String> uploadProfilePicture(
      {required String userId, required File imageFile}) async {
    try {
      final filePath =
          'profile_pictures/$userId/${DateTime.now().millisecondsSinceEpoch}';

      // Attempt to upload the file
      await _client.storage
          .from('profile-pictures')
          .upload(filePath, imageFile)
          .catchError((e) {
        log('Error in Supabase uploadProfilePicture: $e');
        throw Exception('Failed to upload profile picture: $e');
      });

      // If the response is successful, get the public URL of the uploaded file
      final imageUrl =
          _client.storage.from('profile-pictures').getPublicUrl(filePath);
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profilePictureUrl': imageUrl,
      });

      return imageUrl;
    } catch (e) {
      log('Error in uploadProfilePicture: $e');
      throw Exception('Failed to upload profile picture: $e');
    }
  }

  Future<UserModel?> fetchUserData(String userId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          return UserModel.fromJson(data);
        } else {
          throw Exception("User not found");
        }
      }
      return null; // Return null if the document does not exist
    } catch (e) {
      throw Exception("Failed to fetch user data from Firestore: $e");
    }
  }

  Future<void> updateUserData(String userId, UserModel user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(user.toJsonForUpdate());
    } catch (e) {
      throw Exception("Failed to update user profile: $e");
    }
  }

  Future<String> uploadMediaToSupabase({required dynamic imageFile}) async {
    try {
      final filePath = 'media_${DateTime.now().millisecondsSinceEpoch}';

      await _client.storage.from("posts").upload(filePath, imageFile);

      final publicUrl = _client.storage.from('media').getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      throw Exception("Media upload failed: ${e.toString()}");
    }
  }

  Future<void> insertPostToDatabase(PostModel post) async {
    try {
      await _client.from('posts').insert(post.toJson());
    } catch (e) {
      throw Exception("Database insertion failed: ${e.toString()}");
    }
  }
}
