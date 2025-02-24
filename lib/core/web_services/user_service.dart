import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone_app/core/helpers/cache_helper.dart';
import 'package:instagram_clone_app/data/models/post_model.dart';
import 'package:instagram_clone_app/data/models/story_model.dart';
import 'package:instagram_clone_app/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseClient _client = Supabase.instance.client;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // A getter to always retrieve the current user ID from cache.
  String get currentUserId {
    final id = CacheHelper.getData(key: "uId");
    if (id == null) {
      throw Exception("User is not logged in. uId is null.");
    }
    return id;
  }

  // ################################ Profile Picture And Data ##########################################
  Future<String> uploadProfilePicture({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final filePath =
          'profile_pictures/$userId/${DateTime.now().millisecondsSinceEpoch}';

      // Upload image file to Supabase storage.
      await _client.storage
          .from('profile-pictures')
          .upload(filePath, imageFile);

      final imageUrl =
          _client.storage.from('profile-pictures').getPublicUrl(filePath);

      // Update Firestore user document with new profile picture URL.
      await _firestore.collection('users').doc(userId).update({
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
      final docSnapshot = await _firestore.collection('users').doc(userId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          return UserModel.fromJson(data);
        } else {
          throw Exception("User data is null.");
        }
      }
      return null;
    } catch (e) {
      throw Exception("Failed to fetch user data from Firestore: $e");
    }
  }

  Future<List<UserModel>> fetchAllUsers() async {
    try {
      final String currentId = currentUserId;
      // Exclude a specific user and the current user.
      final List<String> excluded = ["3XpMQLS79aQBrRrkrvX8mjuhhrv2", currentId];

      final QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereNotIn: excluded)
          .get();

      final List<UserModel> users = querySnapshot.docs
          .map((doc) =>
              UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return users;
    } catch (e) {
      throw Exception("Failed to fetch users from Firestore: $e");
    }
  }

  Future<void> updateUserData(String userId, UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update(user.toJsonForUpdate());
    } catch (e) {
      throw Exception("Failed to update user profile: $e");
    }
  }

  // ################################ PROFILE POSTS SECTION ##########################################

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

  Future<void> insertPostToFireStore(PostModel post, String docId) async {
    try {
      // Use currentUserId getter for consistency.
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('uploads')
          .doc(docId)
          .set(post.toJson());

      await _firestore.collection('allUploads').doc(docId).set(post.toJson());
    } catch (e) {
      throw Exception("Database insertion failed: ${e.toString()}");
    }
  }

  Future<List<PostModel>> getPostsFromFireStore({String? userId}) async {
    try {
          final String id = userId ?? currentUserId;
      final QuerySnapshot response = await _firestore
          .collection('users')
          .doc(id)
          .collection('uploads')
          .orderBy("created_at", descending: false)
          .get();

      final List<PostModel> posts = response.docs.map((doc) {
        return PostModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return posts;
    } catch (e) {
      throw Exception("Failed to fetch posts: $e");
    }
  }

Future<void> toggleFollow({required String targetUserId}) async {
  try {
    final currentUserRef = _firestore.collection('users').doc(currentUserId);
    final targetUserRef = _firestore.collection('users').doc(targetUserId);

    // Retrieve current state
    final targetSnapshot = await targetUserRef.get();
    final currentSnapshot = await currentUserRef.get();

    final List targetFollowers = targetSnapshot.data()?['followers'] ?? [];
    final List currentFollowing = currentSnapshot.data()?['following'] ?? [];

    final bool isFollowing = targetFollowers.contains(currentUserId);

    if (isFollowing) {
      // Unfollow: Remove current user from target's followers and target from current user's following
      await targetUserRef.update({
        'followers': FieldValue.arrayRemove([currentUserId])
      });
      await currentUserRef.update({
        'following': FieldValue.arrayRemove([targetUserId])
      });
    } else {
      // Follow: Add current user to target's followers and target to current user's following
      await targetUserRef.update({
        'followers': FieldValue.arrayUnion([currentUserId])
      });
      await currentUserRef.update({
        'following': FieldValue.arrayUnion([targetUserId])
      });
    }
  } catch (e) {
    throw Exception("Failed to toggle follow: $e");
  }
}

 

  /////////////////////////////////// REEL'S SCREEN SECTION /////////////////////////////////////

  Future<List<PostModel>> getReelsFromFireStore({String? userId}) async {
    try {
          final String id = userId ?? currentUserId;
      final QuerySnapshot response = await _firestore
          .collection('users')
          .doc(id)
          .collection('uploads')
          .where('type', isEqualTo: 'reels')
          .get();

      final List<PostModel> reels = response.docs.map((doc) {
        return PostModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return reels;
    } catch (e) {
      throw Exception("Failed to fetch reels: $e");
    }
  }

  Future<List<PostModel>> getAllReelsFromFireStore() async {
    try {
      final QuerySnapshot response = await _firestore
          .collection('allUploads')
          .where('type', isEqualTo: 'reels')
          .get();

      final List<PostModel> allReels = response.docs.map((doc) {
        return PostModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return allReels;
    } catch (e) {
      throw Exception("Failed to fetch all reels: $e");
    }
  }

  Future<void> likePost(String postId) async {
    try {
   final postRef = _firestore.collection("allUploads").doc(postId);
    final snapshot = await postRef.get();
    List likedBy = snapshot.data()?['liked_by'] ?? [];
      if (likedBy.contains(currentUserId)) {
        await postRef.update({
          'liked_by': FieldValue.arrayRemove([currentUserId]),
        });
      } else {
        await postRef.update({
          'liked_by': FieldValue.arrayUnion([currentUserId]),
        });
      }
    } catch (e) {
      throw Exception("Failed to like/unlike post: $e");
    }
  }
  


  /////////////////////////////////// STORY SECTION /////////////////////////////////////

  Future<String> uploadStory({required File mediaFile}) async {
    try {
      final filePath =
          '${DateTime.now().millisecondsSinceEpoch}_${mediaFile.path.split('/').last}';
      await _client.storage.from("story-uploads").upload(filePath, mediaFile);

      final publicUrl =
          _client.storage.from('story-uploads').getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      throw Exception("Story upload failed: ${e.toString()}");
    }
  }

  Future<void> insertStory(StoryModel story, String docId) async {
    try {
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('uploads')
          .doc(docId)
          .set(story.toJson());

      await _firestore
          .collection('storyUploads')
          .doc(docId)
          .set(story.toJson());
    } catch (e) {
      throw Exception("Database insertion failed: ${e.toString()}");
    }
  }

  Future<List<StoryModel>> getAllStories() async {
    try {
      final QuerySnapshot response = await _firestore
          .collection('storyUploads')
          .where('isVideo', isEqualTo: false)
          .get();

      final List<StoryModel> allStories = response.docs.map((doc) {
        return StoryModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return allStories;
    } catch (e) {
      throw Exception("Failed to fetch stories: $e");
    }
  }

  /////////////////////////////////// HOME SCREEN SECTION /////////////////////////////////////

  Future<List<PostModel>> getAllPostsFromFireStore() async {
    try {
      final QuerySnapshot response = await _firestore
          .collection('allUploads')
          .where('type', isEqualTo: 'post')
          .get();

      final List<PostModel> allPosts = response.docs.map((doc) {
        return PostModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return allPosts;
    } catch (e) {
      throw Exception("Failed to fetch posts: $e");
    }
  }

  String sanitizeFileName(String fileName) {
    return fileName
        .replaceAll(RegExp(r'[^\w\s.-]'), '')
        .replaceAll(' ', '_')
        .toLowerCase();
  }
}




 
