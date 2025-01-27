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

      // تحقق من وجود البيانات
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
      await _userRepository.updateUserData(userId, userData);
      emit(EditProfileSuccess());
    } catch (e) {
      emit(EditProfileError(e.toString()));
    }
  }
}
