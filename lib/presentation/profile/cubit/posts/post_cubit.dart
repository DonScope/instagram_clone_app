import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/data/repository/user_services/user_repository.dart';
import 'package:meta/meta.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit(this._userRepository) : super(PostsInitial());
  final UserRepository _userRepository;
  static PostCubit get(context) => BlocProvider.of(context);

  Future<void> uploadPost({required dynamic file, String? caption}) async {
    try {
      emit(PostsLoading());
      await _userRepository.uploadPost(file: file, caption: caption);
      emit(PostSuccess());
    } catch (e) {
      emit(PostError(error: e.toString()));
      throw Exception("Failed to uploadPost in cubit: $e");
    }
  }
}
