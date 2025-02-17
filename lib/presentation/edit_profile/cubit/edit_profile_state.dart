part of 'edit_profile_cubit.dart';

@immutable
sealed class EditProfileState {}

final class EditProfileInitial extends EditProfileState {}

final class EditProfileLoading extends EditProfileState {}

final class EditProfileSuccess extends EditProfileState {
  final UserModel userData;

  EditProfileSuccess(this.userData);
}

final class EditProfileError extends EditProfileState {
  final String error;

  EditProfileError(this.error);
}

final class ProfilePictureLoading extends EditProfileState {}

final class ProfilePictureSucess extends EditProfileState {
  ProfilePictureSucess();
}

final class ProfilePictureError extends EditProfileState {
  final String error;

  ProfilePictureError(this.error);
}

final class UserFetchLoading extends EditProfileState {
  UserFetchLoading();
}

final class UserFetchSuccess extends EditProfileState {
  final UserModel userData;

  UserFetchSuccess(this.userData);
}

final class UserFetchError extends EditProfileState {
  final String error;

  UserFetchError(this.error);
}
