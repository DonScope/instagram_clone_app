part of 'post_cubit.dart';

@immutable
sealed class PostState {}

final class PostsInitial extends PostState {}

final class PostsLoading extends PostState {}

final class PostSuccess extends PostState {}

final class PostError extends PostState {
  final String error;

  PostError({required this.error});
}