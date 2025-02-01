import 'dart:io';

import 'package:instagram_clone_app/core/web_services/user_service.dart';
import 'package:instagram_clone_app/data/models/post_model.dart';
import 'package:instagram_clone_app/data/models/user_model.dart';

class UserRepository {
  final UserService _userService;

  UserRepository(userService) : _userService = userService;
  Future uploadProfilePicture(String userId, File imageFile) async {
    try {
      return await _userService.uploadProfilePicture(
          userId: userId, imageFile: imageFile);
    } catch (e) {
      throw Exception("Failed to update profile picture in Firebase: $e");
    }
  }

  Future fetchUserData(String userId) async {
    try {
      return await _userService.fetchUserData(userId);
    } catch (e) {
      throw Exception("Failed to fetch user data: $e");
    }
  }

  Future<void> updateUserData(String userId, UserModel userData) async {
    try {
      await _userService.updateUserData(userId, userData);
    } catch (e) {
      throw Exception("Failed to update user data: $e");
    }
  }

  Future<void> uploadPost({required File mediaFile, String? caption}) async {
    final mediaUrl =
        await _userService.uploadMediaToSupabase(mediaFile: mediaFile);

    final post = PostModel(
        mediaUrl: mediaUrl, caption: caption, createdAt: DateTime.now());
    await _userService.insertPostToFireStore(post);
  }

  Future<List<PostModel>> getPosts() async {
    try {
      final response = await _userService.getPostsFromFireStore();
      return response;
    } catch (e) {
      throw Exception("Failed to fetch posts inside repo: $e");
    }
  }
}
