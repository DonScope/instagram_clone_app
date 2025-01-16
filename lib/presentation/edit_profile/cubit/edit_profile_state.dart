part of 'edit_profile_cubit.dart';

@immutable
sealed class EditProfileState {}

final class EditProfileInitial extends EditProfileState {}

final class EditProfileLoading extends EditProfileState {}

final class EditProfileSuccess extends EditProfileState {

  EditProfileSuccess();
}

final class EditProfileError extends EditProfileState {
  final String error;

  EditProfileError(this.error);
}