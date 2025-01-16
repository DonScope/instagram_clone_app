import 'package:instagram_clone_app/core/web_services/user_service.dart';

class UserRepository {
  final UserServices _userServices;

  UserRepository(this._userServices);

  Future updateUser(String name, String email, String profilePicUrl, String bio) async {
    return await _userServices.updateUser(name, email, profilePicUrl, bio);
  }

  Future deleteUser() async {
    return await _userServices.deleteUser();
  }



}