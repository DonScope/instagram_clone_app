import 'package:instagram_clone_app/data/models/post_model.dart';
import 'package:instagram_clone_app/data/models/user_model.dart';
import 'package:video_player/video_player.dart';

abstract class ReelState {}

class ReelInitial extends ReelState {}

class ReelLoading extends ReelState {}

class ReelLoaded extends ReelState {
  final List<PostModel> allReels;
  final List<VideoPlayerController> videoController;
  final List<UserModel> userDataList; 
  ReelLoaded(this.allReels, this.videoController, this.userDataList);
}
class ReelError extends ReelState {
  final String error;
  ReelError(this.error);
}
class ReelPlaying extends ReelState {
  final int currentIndex;

  ReelPlaying(this.currentIndex);
}

