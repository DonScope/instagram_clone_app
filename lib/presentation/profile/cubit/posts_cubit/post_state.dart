part of 'post_cubit.dart';

@immutable
sealed class PostState {}

final class PostsInitial extends PostState {}

final class PostUploadLoading extends PostState {}

final class PostUploadSuccess extends PostState {}

final class PostUploadError extends PostState {
  final String error;

  PostUploadError({required this.error});
}

class PostGetLoading extends PostState {}

class PostGetSuccess extends PostState {
  final List<PostModel> posts;
  PostGetSuccess({required this.posts});
}

class PostGetError extends PostState {
  final String error;
  PostGetError({required this.error});
}

