import 'package:haftaa/user/base-user.dart';

class Authenticatable {
  Future<BaseUser> register(String username, String password, String email) {}
  Future<bool> login(String username, String password) {}
  Future<bool> resetPassword(String email) {}
  Future<BaseUser> updateProfile(BaseUser user){}
}
