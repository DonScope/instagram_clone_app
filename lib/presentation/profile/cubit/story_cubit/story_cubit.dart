import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/core/helpers/cache_helper.dart';
import 'package:instagram_clone_app/data/models/story_model.dart';
import 'package:instagram_clone_app/data/models/user_model.dart';
import 'package:instagram_clone_app/data/repository/user_services/user_repository.dart';
import 'package:meta/meta.dart';

part 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  StoryCubit(this._userRepository) : super(StoryInitial());
  final UserRepository _userRepository;
  static StoryCubit get(context) => BlocProvider.of(context);
  Future<void> uploadStory(
      {required dynamic mediaFile,
      String? caption,
      required bool isVideo}) async {
    try {
      emit(StoryUploadLoading());
      log("INSIDE STORY UPLOAD");
      await _userRepository
          .storyUpload(mediaFile: mediaFile, isVideo: isVideo)
          .then((onValue) {
        getAllStories();
      });
      log(CacheHelper.getData(key: "uId"));
      log("INSIDE STORY UPLOAD SUCCESS");

      emit(StoryUploadSuccess());
    } catch (e) {
      emit(StoryUploadError(error: e.toString()));
    }
  }

  Map<UserModel, List<StoryModel>> userStoriesMap = {};
  Future<void> getAllStories() async {
    try {
      emit(StoryGetLoading());
      final stories = await _userRepository.getAllStories();
      userStoriesMap.clear();

      for (var story in stories) {
        final userData = await fetchUserData(story.uId);
        if (userData != null) {
          if (userStoriesMap.containsKey(userData)) {
            userStoriesMap[userData]!.add(story);
          } else {
            userStoriesMap[userData] = [story];
          }
        } else {
          print("User doesn't exist.");
        }
      }

      emit(StoryGetSuccess(stories: userStoriesMap));
    } catch (e) {
      throw Exception("Error in getAllStories inside cubit: $e");
    }
  }

  Future<UserModel?> fetchUserData(String userId) async {
    try {
      final userData = await _userRepository.fetchUserData(userId);
      return userData;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }
}
