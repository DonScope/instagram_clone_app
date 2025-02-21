part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}
final class PostsLoading extends HomeState {}
final class PostsLoaded extends HomeState {
  final List<PostModel> posts;

  PostsLoaded({required this.posts});
}
final class PostsError extends HomeState {}

final class LikeState extends HomeState {}