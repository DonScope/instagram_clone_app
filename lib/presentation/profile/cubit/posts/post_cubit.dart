import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/data/models/post_model.dart';
import 'package:instagram_clone_app/data/repository/user_services/user_repository.dart';
import 'package:meta/meta.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit(this._userRepository) : super(PostsInitial());
  final UserRepository _userRepository;
  static PostCubit get(context) => BlocProvider.of(context);
  Future<void> uploadPost({required dynamic mediaFile, String? caption}) async {
    try {
      emit(PostsLoading());
      await _userRepository.uploadPost(mediaFile: mediaFile, caption: caption);
      emit(PostSuccess());
    } catch (e) {
      emit(PostError(error: e.toString()));
      throw Exception("Failed to uploadPost in cubit: $e");
    }
  }

  Future<void> getPosts() async {
    try {
      emit(PostGetLoading());
      final posts = await _userRepository.getPosts();
      log("POST REQUEST");

      emit(PostGetSuccess(posts: posts));
    } catch (e) {
      print("Cubit Error: $e"); 
      emit(PostGetError(error: e.toString()));
    }
  }
}
