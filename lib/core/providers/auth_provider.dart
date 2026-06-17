import 'package:flutter/material.dart';
import 'package:smart_home/core/services/session_service.dart';
import 'package:smart_home/data/models/user_model.dart';
import 'package:smart_home/data/repositories/local_auth_repository.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _init();
  }

  final _repo = LocalAuthRepository();
  final _session = SessionService.instance;

  AuthStatus _status = AuthStatus.unknown;
  UserModel? _user;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> _init() async {
    final hasSession = await _session.hasSession();
    if (!hasSession) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }
    _user = await _repo.getCurrentUser();
    _status = _user != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<String?> login(final String email, final String password) async {
    final user = await _repo.login(email, password);
    if (user == null) return 'Невірний email або пароль';
    await _session.saveSession(email: email, token: '${email}_token');
    _user = user;
    _status = AuthStatus.authenticated;
    notifyListeners();
    return null;
  }

  Future<void> logout() async {
    await _repo.logout();
    await _session.clearSession();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> updateUser(final UserModel updated) async {
    await _repo.updateUser(updated);
    _user = updated;
    notifyListeners();
  }
}
