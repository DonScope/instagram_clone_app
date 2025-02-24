import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/data/models/post_model.dart';
import 'package:instagram_clone_app/data/repository/user_services/user_repository.dart';
import 'package:meta/meta.dart';

part 'profile_reel_state.dart';

class ProfileReelCubit extends Cubit<ProfileReelState> {
  ProfileReelCubit(this._userRepository) : super(ReelInitial());
  final UserRepository _userRepository;
  static ProfileReelCubit get(context) => BlocProvider.of(context);
  
  Future<void> getReels({String? userId}) async {
    try {
      emit(ReelsGetLoading());
      final reels = await _userRepository.getReels(userId: userId);

      emit(ReelsGetSuccess(reels: reels));
    } catch (e) {
      print("Cubit Error: $e");
      emit(ReelsGetError(error: e.toString()));
    }
  }

  void getReelsLoading() {
    emit(ReelsGetLoading());
  }
}
