part of 'profile_reel_cubit.dart';

@immutable
sealed class ProfileReelState {}

final class ReelInitial extends ProfileReelState {}

class ReelsUploadLoading extends ProfileReelState {}
class ReelsUploadSuccess extends ProfileReelState {}
class ReelsUploadError extends ProfileReelState {}

class ReelsGetLoading extends ProfileReelState {}

class ReelsGetSuccess extends ProfileReelState {
  final List<PostModel> reels;
  ReelsGetSuccess({required this.reels});
}

class ReelsGetError extends ProfileReelState {
  final String error;
  ReelsGetError({required this.error});
}