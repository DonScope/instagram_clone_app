import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/core/helpers/cache_helper.dart';
import 'package:instagram_clone_app/data/models/post_model.dart';
import 'package:instagram_clone_app/data/models/user_model.dart';
import 'package:instagram_clone_app/data/repository/user_services/user_repository.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._userRepository) : super(HomeInitial());
  static HomeCubit get(context) => BlocProvider.of(context);
  final UserRepository _userRepository;
  List<UserModel> userDataList = [];
  final getCurrentUserId = CacheHelper.getData(key: "uId");
  Future<void> getAllPosts() async {
    try {
      emit(PostsLoading());
      Map<String, UserModel> userDataMap = {};

      final allPosts = await _userRepository.getAllPosts();
      final filteredPosts = allPosts
          .where((post) => !post.mediaUrl.endsWith("_tiny.mp4"))
          .toList();
      if (filteredPosts.isNotEmpty) {
        for (int i = 0; i < filteredPosts.length; i++) {
          final userData =
              await _userRepository.fetchUserData(filteredPosts[i].uId);
          if (userData != null) {
            userDataMap[filteredPosts[i].uId] = userData;
          }
        }
      }
      filteredPosts.shuffle(Random());
      userDataList =
          filteredPosts.map((post) => userDataMap[post.uId]!).toList();
      emit(PostsLoaded(posts: filteredPosts));
    } catch (e) {
      emit(PostsError());
    }
  }

  Future<void> likePost(String postId) async {
    try {
      final currentUserId = getCurrentUserId;
      final currentState = state;

      // Optimistic update
      if (currentState is PostsLoaded) {
        final updatedPosts = currentState.posts.map((post) {
          if (post.id == postId) {
            final newLikedBy = List<String>.from(post.liked_by);
            if (newLikedBy.contains(currentUserId)) {
              newLikedBy.remove(currentUserId);
            } else {
              newLikedBy.add(currentUserId);
            }
            return post.copyWith(liked_by: newLikedBy);
          }
          return post;
        }).toList();

        emit(PostsLoaded(posts: updatedPosts));
      }

      // Actual API call
      await _userRepository.likePost(postId);

      // Refresh from server to ensure consistency
    } catch (e) {
      // Revert on error
      if (state is PostsLoaded) {
        emit(PostsLoaded(posts: (state as PostsLoaded).posts));
      }
      throw Exception("Like error: $e");
    }
  }
}
