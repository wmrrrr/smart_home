import 'package:smart_home/data/models/user_model.dart';

abstract interface class AuthRepository {
  Future<void> register(final UserModel user);
  Future<UserModel?> login(final String email, final String password);
  Future<UserModel?> getCurrentUser();
  Future<void> updateUser(final UserModel user);
  Future<void> logout();
  Future<bool> isLoggedIn();
}
