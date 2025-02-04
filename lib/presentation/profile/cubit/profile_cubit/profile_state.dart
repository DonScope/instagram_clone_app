part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState{}

final class ProfileFetchSuccess extends ProfileState { 
  final UserModel userModel;

  ProfileFetchSuccess(this.userModel); 
}

final class ProfileFetchError extends ProfileState{
  final String error;

  ProfileFetchError( this.error);
}





