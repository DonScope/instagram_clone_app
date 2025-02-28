import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/core/helpers/cache_helper.dart';
import 'package:instagram_clone_app/data/repository/user_services/user_repository.dart';
import 'package:meta/meta.dart';

import '../../../data/models/user_model.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(this._userRepository) : super(EditProfileInitial());
  final UserRepository _userRepository;
  static EditProfileCubit get(context) => BlocProvider.of(context);
  final userId = CacheHelper.getData(key: "uId");

  Future<void> fetchUserData() async {
    try {
      emit(UserFetchLoading());
      final userData = await _userRepository.fetchUserData(userId);

      if (userData == null) {
        throw Exception("User data not found");
      }

      emit(UserFetchSuccess(userData));
    } catch (e) {
      emit(UserFetchError(e.toString()));
    }
  }

  Future<void> uploadProfilePicture(File imageFile) async {
    try {
      emit(ProfilePictureLoading());

      await _userRepository.uploadProfilePicture(userId, imageFile);
      emit(ProfilePictureSucess());
    } catch (e) {
      emit(ProfilePictureError(e.toString()));
    }
  }

Future<void> updateUserData(UserModel userData) async {
  try {
    emit(EditProfileLoading());
       log("entered update user data loading");
    await _userRepository.updateUserData(userId, userData);
    final updatedUserData = await _userRepository.fetchUserData(userId);
    emit(EditProfileSuccess(updatedUserData));
    log("entered update user data");
  } catch (e) {
    emit(EditProfileError(e.toString()));
  }
}
}
