import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/data/models/post_model.dart';
import 'package:instagram_clone_app/data/repository/user_services/user_repository.dart';
import 'package:meta/meta.dart';

part 'reel_state.dart';

class ReelCubit extends Cubit<ReelState> {
  ReelCubit(this._userRepository) : super(ReelInitial());
  final UserRepository _userRepository;
  static ReelCubit get(context) => BlocProvider.of(context);
  Future<void> getReels() async {
    try {
      emit(ReelsGetLoading());
      final reels = await _userRepository.getReels();

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
