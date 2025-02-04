import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:instagram_clone_app/core/web_services/user_service.dart';
import 'package:instagram_clone_app/data/models/post_model.dart';
import 'package:instagram_clone_app/data/models/user_model.dart';

class UserRepository {
  final UserService _userService;
  List<String> videoExtensions = [
    ".mp4",
    ".mov",
    ".avi",
    ".mkv",
    ".flv",
    ".wmv",
    ".webm"
  ];
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

  Future<void> uploadPost({
    required File mediaFile,
    String? caption,
    required String type,
  }) async {
    final mediaUrl =
        await _userService.uploadMediaToSupabase(mediaFile: mediaFile);
    String? thumbnailUrl;

    if (videoExtensions.any((ext) => mediaFile.path.endsWith(ext))) {
      final Uint8List? thumbnailData = await VideoThumbnail.thumbnailData(
        video: mediaFile.path,
        imageFormat: ImageFormat.JPEG,
       maxHeight: 256, 
    quality: 75,  
      );

      if (thumbnailData != null) {
        final tempDir = await getTemporaryDirectory();
        final thumbnailFile = File('${tempDir.path}/thumbnail.jpg');
        await thumbnailFile.writeAsBytes(thumbnailData);

        thumbnailUrl =
            await _userService.uploadMediaToSupabase(mediaFile: thumbnailFile);
      }
    }
    final post = PostModel(
      mediaUrl: mediaUrl,
      caption: caption,
      thumbnailUrl: thumbnailUrl,
      createdAt: Timestamp.now(),
      type: type,
    );

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

  Future<List<PostModel>> getReels() async {
    try {
      final response = await _userService.getReelsFromFireStore();
      return response;
    } catch (e) {
      throw Exception("Failed to fetch posts inside repo: $e");
    }
  }
}
