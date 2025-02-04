part of 'reel_cubit.dart';

@immutable
sealed class ReelState {}

final class ReelInitial extends ReelState {}

class ReelsUploadLoading extends ReelState {}
class ReelsUploadSuccess extends ReelState {}
class ReelsUploadError extends ReelState {}

class ReelsGetLoading extends ReelState {}

class ReelsGetSuccess extends ReelState {
  final List<PostModel> reels;
  ReelsGetSuccess({required this.reels});
}

class ReelsGetError extends ReelState {
  final String error;
  ReelsGetError({required this.error});
}