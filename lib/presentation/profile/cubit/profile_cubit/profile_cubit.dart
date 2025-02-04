import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/core/helpers/cache_helper.dart';
import 'package:instagram_clone_app/data/models/user_model.dart';
import 'package:instagram_clone_app/data/repository/user_services/user_repository.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._userRepository) : super(ProfileInitial());
  final UserRepository _userRepository;
  static ProfileCubit get(context) => BlocProvider.of(context);

  final userId = CacheHelper.getData(key: "uId");

    Future<void> fetchUserData() async {
    try {
      emit(ProfileLoading());
      final userData = await _userRepository.fetchUserData(userId);

      if (userData == null) {
        throw Exception("User data not found");
      }


      emit(ProfileFetchSuccess(userData));
      log("//////////////////////////////////USER DATA FETCH///////////////////////////");
    } catch (e) {
      emit(ProfileFetchError(e.toString()));
    }
  }

}
