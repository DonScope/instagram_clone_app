
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/core/web_services/auth_service.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authService) : super(AuthInitial());
  final AuthService authService;

  static AuthCubit get(context) => BlocProvider.of(context);

  Future<void> signUpEmailPassword(
      {required String email, required String password}) async {
    emit(AuthLoading());

    authService
        .registerWithEmailPassword(email: email, password: password)
        .then((user) {

      emit(AuthSuccess());
    }).catchError((e) {
      emit(AuthError(e.toString()));
    });
  }

  Future<void> signInEmailPassword({required email, required password}) async {
    emit(AuthLoading());
    try {
      User? user = await authService.loginWithEmailPassword(
          email: email, password: password);
      if (user != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthError('Error'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logOut() async {
    emit(AuthLoading());
    try {
      await authService.logout();
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
