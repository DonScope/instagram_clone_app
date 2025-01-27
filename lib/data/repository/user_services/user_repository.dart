import 'dart:io';

import 'package:instagram_clone_app/core/helpers/cache_helper.dart';
import 'package:instagram_clone_app/core/web_services/user_service.dart';
import 'package:instagram_clone_app/data/models/post_model.dart';
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

  Future<void> uploadPost({required dynamic file, String? caption}) async {
    final mediaUrl = await _userService.uploadMediaToSupabase(imageFile: file);

    final post = PostModel(
        id: const Uuid().v4(),
        uId: CacheHelper.getData(key: "uId"),
        mediaUrl: mediaUrl,
        caption: caption,
        createdAt: DateTime.now());
    await _userService.insertPostToDatabase(post);
  }
}
