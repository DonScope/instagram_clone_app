import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/data/repository/user_services/user_repository.dart';
import 'package:meta/meta.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(this._userRepository) : super(EditProfileInitial());
  final UserRepository _userRepository;
  static EditProfileCubit get(context) => BlocProvider.of(context);

  Future<void> updateUser(
      {required String name,
      required String email,
      required String profilePicUrl,
      required String bio}) async {
    try {
      emit(EditProfileLoading());
      await _userRepository.updateUser(name, email, profilePicUrl, bio);
      emit(EditProfileSuccess()); 
    } catch (e) {
      emit(EditProfileError(e.toString()));
    }
  }

  Future<void> deleteUser() async {
    try {
      emit(EditProfileLoading());
      await _userRepository.deleteUser();
      emit(EditProfileSuccess());
    } catch (e) {
      emit(EditProfileError(e.toString()));
    }
  }
}
