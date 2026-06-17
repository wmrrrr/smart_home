import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionService {
  SessionService._();

  static final SessionService instance = SessionService._();

  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'sh_session_token';
  static const _emailKey = 'sh_session_email';

  Future<void> saveSession({
    required final String email,
    required final String token,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _emailKey, value: email);
  }

  Future<String?> getToken() => _storage.read(key: _tokenKey);

  Future<String?> getEmail() => _storage.read(key: _emailKey);

  Future<bool> hasSession() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<void> clearSession() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _emailKey);
  }
}
