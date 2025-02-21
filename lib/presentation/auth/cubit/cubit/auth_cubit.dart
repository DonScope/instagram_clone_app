import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/core/helpers/cache_helper.dart';
import 'package:instagram_clone_app/core/helpers/navigation_helper.dart';
import 'package:instagram_clone_app/data/repository/auth/auth_repository.dart';
import 'package:instagram_clone_app/presentation/auth/ui/login_screen.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(AuthInitial());
  final AuthRepository _authRepository;

  static AuthCubit get(context) => BlocProvider.of(context);

  Future<void> signUpEmailPassword(
      {required String email,
      required String password,
      required String displayName}) async {
    try {
      emit(RegisterLoading());
      await _authRepository.registerWithEmailPassword(
          email: email, password: password, displayName: displayName);
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      emit(RegisterError(e.message.toString()));
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }

  Future<void> signInEmailPassword({required email, required password}) async {
    emit(LoginLoading());
    try {
      User? user = await _authRepository.loginWithEmailPassword(
          email: email, password: password);
      if (user != null) {
        emit(LoginSuccess());
        log("User ID: ${CacheHelper.getData(key: "uId")}");
      }
    } on FirebaseAuthException catch (e) {
      emit(LoginError(e.message.toString()));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  Future<void> logOut(context) async {
    emit(LogoutLoading());
    try {
      await _authRepository.logout().then(
        (value) {
          NavigationHelper.goOffAll(context, LoginScreen());
        },
      );

      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutError(e.toString()));
    }
  }
}
