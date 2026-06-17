import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home/data/models/user_model.dart';
import 'package:smart_home/data/repositories/auth_repository.dart';

class LocalAuthRepository implements AuthRepository {
  static const _usersKey = 'sh_users';
  static const _currentEmailKey = 'sh_current_email';

  String _hashPassword(final String password) {
    // Simple hash — replace with bcrypt in production
    var hash = 0;
    for (final char in password.codeUnits) {
      hash = (hash * 31 + char) & 0x7FFFFFFF;
    }
    return hash.toRadixString(16);
  }

  Future<Map<String, UserModel>> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (k, v) => MapEntry(k, UserModel.fromJson(v as Map<String, dynamic>)),
    );
  }

  Future<void> _saveUsers(final Map<String, UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(users.map((k, v) => MapEntry(k, v.toJson())));
    await prefs.setString(_usersKey, encoded);
  }

  @override
  Future<void> register(final UserModel user) async {
    final users = await _loadUsers();
    if (users.containsKey(user.email)) {
      throw Exception('Email вже зареєстровано');
    }
    final hashed = user.copyWith(passwordHash: _hashPassword(user.passwordHash));
    users[user.email] = hashed;
    await _saveUsers(users);
  }

  @override
  Future<UserModel?> login(final String email, final String password) async {
    final users = await _loadUsers();
    final user = users[email];
    if (user == null) return null;
    if (user.passwordHash != _hashPassword(password)) return null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentEmailKey, email);
    return user;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_currentEmailKey);
    if (email == null) return null;
    final users = await _loadUsers();
    return users[email];
  }

  @override
  Future<void> updateUser(final UserModel user) async {
    final users = await _loadUsers();
    users[user.email] = user;
    await _saveUsers(users);
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentEmailKey);
  }

  @override
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_currentEmailKey);
  }
}
