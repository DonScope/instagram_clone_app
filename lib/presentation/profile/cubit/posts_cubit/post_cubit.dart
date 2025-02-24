import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/data/models/post_model.dart';
import 'package:instagram_clone_app/data/repository/user_services/user_repository.dart';
import 'package:meta/meta.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit(this._userRepository) : super(PostsInitial());
  final UserRepository _userRepository;
  static PostCubit get(context) => BlocProvider.of(context);
  int postLength = 0;
  Future<void> uploadPost(
      {required dynamic mediaFile,
      String? caption,
      required String type}) async {
    try {
      emit(PostUploadLoading());

      await _userRepository.uploadPost(
          mediaFile: mediaFile, caption: caption, type: type);
      emit(PostUploadSuccess());
    } catch (e) {
      emit(PostUploadError(error: e.toString()));
      throw Exception("Failed to uploadPost in cubit: $e");
    }
  }

  Future<void> getPosts({String? userId}) async {
    try {
      emit(PostGetLoading());
      final posts = await _userRepository.getPosts(userId: userId);
      postLength = posts.length;
      log("Post REQUEST");

      emit(PostGetSuccess(posts: posts));
      log(posts.length.toString());
    } catch (e) {
      print("Cubit Error: $e");
      emit(PostGetError(error: e.toString()));
    }
  }

  


}
