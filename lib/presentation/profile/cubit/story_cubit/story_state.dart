part of 'story_cubit.dart';

@immutable
sealed class StoryState {}

final class StoryInitial extends StoryState {}

class StoryUploadLoading extends StoryState {}

class StoryUploadSuccess extends StoryState {}

class StoryUploadError extends StoryState {
    final String error;
  StoryUploadError({required this.error});
}



class StoryGetLoading extends StoryState {}

class StoryGetSuccess extends StoryState {
  // final List<StoryModel> stories;
    final Map<UserModel, List<StoryModel>> stories;
  // final List<UserModel> users;
  // final Map<String, List<StoryModel>> groupedStories;
  StoryGetSuccess( {required this.stories});
}

class StoryGetError extends StoryState {
    final String error;
  StoryGetError({required this.error});
}

