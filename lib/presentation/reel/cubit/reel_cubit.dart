import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/data/models/user_model.dart';
import 'package:instagram_clone_app/data/repository/user_services/user_repository.dart';
import 'package:video_player/video_player.dart';

import 'reel_state.dart';

class ReelCubit extends Cubit<ReelState> {
  ReelCubit(this._userRepository) : super(ReelInitial());

  static ReelCubit get(context) => BlocProvider.of(context);
  final UserRepository _userRepository;
  List<VideoPlayerController> controllers = [];
  List<UserModel> userDataList = [];

  Future<void> LoadReels() async {
    try {
      emit(ReelLoading());
      final allReel = await _userRepository.getAllReels();

      if (allReel.isNotEmpty) {
        for (int i = 0; i < allReel.length; i++) {
          final userData = await fetchUserData(allReel[i].uId);
          if (userData != null) {
            userDataList.add(userData);
          } else {
           print("No existing user");
          }

          controllers.add(VideoPlayerController.networkUrl(
              Uri.parse(allReel[i].mediaUrl.toString())));
          await controllers[i].initialize();
        }

        emit(ReelLoaded(allReel, controllers, userDataList));
      } else {
        emit(ReelError("Reels are empty."));
      }
    } catch (e) {
      emit(ReelError("${e.toString()}"));
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


  Future<void> likeReel(String postId)async{
    try{
      await _userRepository.likePost(postId);
    }catch(e){
      throw Exception("Error inside likeReel Cubit");
    }
  }

  @override
  Future<void> close() {
    for (var controller in controllers) {
      controller.dispose();
    }
    return super.close();
  }
}
