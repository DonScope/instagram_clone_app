
import '../../../core/web_services/auth_service.dart';

class AuthRepository {
  final AuthService _authWebService;

  AuthRepository(this._authWebService);

  Future loginWithEmailPassword({required String email, required String password}) async {
    return await _authWebService.loginWithEmailPassword(email: email, password: password);
  }
  Future registerWithEmailPassword({required String email, required String password, required String displayName}) async {
    return await _authWebService.registerWithEmailPassword(email: email, password: password, displayName: displayName);
  }
  Future<void> logout() async {
    return await _authWebService.logout();
  }
}