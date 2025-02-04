import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone_app/core/helpers/cache_helper.dart';
import 'package:instagram_clone_app/data/models/post_model.dart';
import 'package:instagram_clone_app/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class UserService {
  final SupabaseClient _client = Supabase.instance.client;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var uId = CacheHelper.getData(key: "uId");
  // ################################ Profile Picture And Data ##########################################
  Future<String> uploadProfilePicture(
      {required String userId, required File imageFile}) async {
    try {
      final filePath =
          'profile_pictures/$userId/${DateTime.now().millisecondsSinceEpoch}';

      await _client.storage
          .from('profile-pictures')
          .upload(filePath, imageFile)
          .catchError((e) {
        throw Exception('Error in Supabase uploadProfilePicture: $e');
      });

      final imageUrl =
          _client.storage.from('profile-pictures').getPublicUrl(filePath);
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profilePicUrl': imageUrl,
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
      return null;
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

  // ################################ POSTS SECTION ##########################################

  Future<String> uploadMediaToSupabase({required File mediaFile}) async {
    try {
      final filePath =
          '${DateTime.now().millisecondsSinceEpoch}_${mediaFile.path.split('/').last}';
      await _client.storage.from("media-uploads").upload(filePath, mediaFile);

      final publicUrl =
          _client.storage.from('media-uploads').getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      throw Exception("Media upload failed: ${e.toString()}");
    }
  }

  Future<void> insertPostToFireStore(PostModel post) async {
    try {
      await _firestore
          .collection('users')
          .doc(uId)
          .collection('uploads')
          .doc(Uuid().v4().toString())
          .set(post.toJson());
    } catch (e) {
      throw Exception("Database insertion failed: ${e.toString()}");
    }
  }

  Future<List<PostModel>> getPostsFromFireStore() async {
    try {
      QuerySnapshot response = await _firestore
          .collection('users')
          .doc(uId)
          .collection('uploads')
          .orderBy("created_at", descending: false)
          .get();

      final posts = response.docs.map((doc) {
        return PostModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return posts;
    } catch (e) {
      throw Exception("Failed to fetch posts: $e");
    }
  }

  Future<List<PostModel>> getReelsFromFireStore() async {
    try {
      QuerySnapshot response = await _firestore
          .collection('users')
          .doc(uId)
          .collection('uploads')
          .where('type', isEqualTo: 'reels')
          .get();

      final reels = response.docs.map((doc) {
        return PostModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return reels;
    } catch (e) {
      throw Exception("Failed to fetch posts: $e");
    }
  }

  Future<void> likePost(String postId) async {
    final postRef =
        FirebaseFirestore.instance.collection('uploads').doc(postId);

    await postRef.update({
      'likes_count': FieldValue.increment(1),
    });
  }
}
