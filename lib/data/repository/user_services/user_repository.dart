import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
    String docId = Uuid().v4().toString();

    final mediaUrl =
        await _userService.uploadMediaToSupabase(mediaFile: mediaFile);

    String? thumbnailUrl = await MediaHelper.generateThumbnail(
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
        liked_by: []);

    await _userService.insertPostToFireStore(post, docId);
  }

  Future<void> storyUpload({
    required File mediaFile,
    String? caption,
    required bool isVideo,
  }) async {
    String docId = Uuid().v4().toString();
    final mediaUrl = await _userService.uploadStory(mediaFile: mediaFile);
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
  }

  Future<List<StoryModel>> getAllStories() async {
    try {
      final allStories = await _userService.getAllStories();

      return allStories;
    } catch (e) {
      throw Exception("Error getAllStories inside user repo. $e");
    }
  }

  Future<List<PostModel>> getPosts() async {
    try {
      final response = await _userService.getPostsFromFireStore();
      return response;
    } catch (e) {
      throw Exception("Failed to fetch getPosts inside repository: $e");
    }
  }

  Future<List<PostModel>> getReels() async {
    try {
      final response = await _userService.getReelsFromFireStore();
      return response;
    } catch (e) {
      throw Exception("Failed to fetch getReels inside repository: $e");
    }
  }

  Future<List<PostModel>> getAllReels() async {
    try {
      final response = await _userService.getAllReelsFromFireStore();
      return response;
    } catch (e) {
      throw Exception("Failed to fetch getAllReels inside repository: $e");
    }
  }

  Future<List<PostModel>> getAllPosts() async {
    try {
      final response = await _userService.getAllPostsFromFireStore();
      return response;
    } catch (e) {
      throw Exception("Failed to fetch getAllPosts inside repository: $e");
    }
  }

  Future<void> likePost(String postId) async {
    try {
      final response = await _userService.likePost(postId);
      return response;
    } catch (e) {
      throw Exception("Failed to fetch likePost inside repository: $e");
    }
  }
}
