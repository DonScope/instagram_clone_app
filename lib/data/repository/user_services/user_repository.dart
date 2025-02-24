import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:instagram_clone_app/core/helpers/cache_helper.dart';
import 'package:instagram_clone_app/core/helpers/generate_thumbnail_helper.dart';
import 'package:instagram_clone_app/core/web_services/user_service.dart';
import 'package:instagram_clone_app/data/models/post_model.dart';
import 'package:instagram_clone_app/data/models/story_model.dart';
import 'package:instagram_clone_app/data/models/user_model.dart';
import 'package:uuid/uuid.dart';

class UserRepository {
  final UserService _userService;

  UserRepository(userService) : _userService = userService;

  Future uploadProfilePicture(String userId, File imageFile) async {
    try {
      return await _userService.uploadProfilePicture(
          userId: userId, imageFile: imageFile);
    } catch (e) {
      throw Exception("Failed to uploadProfilePicture inside repository: $e");
    }
  }

  Future fetchUserData(String userId) async {
    try {
      return await _userService.fetchUserData(userId);
    } catch (e) {
      throw Exception("Failed to fetchUserData inside repository: $e");
    }
  }

  Future<List<UserModel>> fetchAllUsers() async {
    try {
      return await _userService.fetchAllUsers();
    } catch (e) {
      throw Exception("Failed to fetchAllUsers inside repository: $e");
    }
  }

  Future<void> updateUserData(String userId, UserModel userData) async {
    try {
      await _userService.updateUserData(userId, userData);
    } catch (e) {
      throw Exception("Failed to updateUserData inside repository: $e");
    }
  }

  Future<void> uploadPost({
    required File mediaFile,
    String? caption,
    required String type,
  }) async {
    final String docId = Uuid().v4().toString();

    try {
      final String mediaUrl =
          await _userService.uploadMediaToSupabase(mediaFile: mediaFile);

      final String? thumbnailUrl = await MediaHelper.generateThumbnail(
        mediaFile,
        (thumbnailFile) =>
            _userService.uploadMediaToSupabase(mediaFile: thumbnailFile),
      );

      final post = PostModel(
        mediaUrl: mediaUrl,
        caption: caption,
        id: docId,
        uId: CacheHelper.getData(key: "uId"),
        thumbnailUrl: thumbnailUrl,
        createdAt: Timestamp.now(),
        type: type,
        liked_by: [],
      );

      await _userService.insertPostToFireStore(post, docId);
    } catch (e) {
      throw Exception("Failed to upload post inside repository: $e");
    }
  }

  Future<void> storyUpload({
    required File mediaFile,
    String? caption,
    required bool isVideo,
  }) async {
    final String docId = Uuid().v4().toString();
    try {
      final String mediaUrl =
          await _userService.uploadStory(mediaFile: mediaFile);
      final story = StoryModel(
        id: docId,
        uId: CacheHelper.getData(key: "uId"),
        isVideo: isVideo,
        caption: caption,
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(Duration(hours: 24)),
        mediaUrl: mediaUrl,
      );

      await _userService.insertStory(story, docId);
    } catch (e) {
      throw Exception("Failed to upload story inside repository: $e");
    }
  }

  Future<List<StoryModel>> getAllStories() async {
    try {
      final List<StoryModel> allStories = await _userService.getAllStories();
      return allStories;
    } catch (e) {
      throw Exception("Error getAllStories inside user repo: $e");
    }
  }

  Future<List<PostModel>> getPosts({String? userId}) async {
    try {
      final List<PostModel> response =
          await _userService.getPostsFromFireStore(userId: userId);
      return response;
    } catch (e) {
      throw Exception("Failed to fetch posts inside repository: $e");
    }
  }

  Future<List<PostModel>> getReels({String? userId}) async {
    try {
      final List<PostModel> response =
          await _userService.getReelsFromFireStore(userId: userId);
      return response;
    } catch (e) {
      throw Exception("Failed to fetch reels inside repository: $e");
    }
  }

  Future<List<PostModel>> getAllReels() async {
    try {
      final List<PostModel> response =
          await _userService.getAllReelsFromFireStore();
      return response;
    } catch (e) {
      throw Exception("Failed to fetch all reels inside repository: $e");
    }
  }

  Future<List<PostModel>> getAllPosts() async {
    try {
      final List<PostModel> response =
          await _userService.getAllPostsFromFireStore();
      return response;
    } catch (e) {
      throw Exception("Failed to fetch all posts inside repository: $e");
    }
  }

  Future<void> likePost(String postId) async {
    try {
      await _userService.likePost(postId);
    } catch (e) {
      throw Exception("Failed to like post inside repository: $e");
    }
  }

  Future<void> toggleFollow({required String targetUserId}) async {
    try {
      await _userService.toggleFollow(targetUserId: targetUserId);
    } catch (e) {
      throw Exception("Failed to toggle follow inside repository: $e");
    }
  }
}
