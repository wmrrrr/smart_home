import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/core/services/session_service.dart';
import 'package:smart_home/cubits/auth/auth_state.dart';
import 'package:smart_home/data/models/user_model.dart';
import 'package:smart_home/data/repositories/local_auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial()) {
    _autoLogin();
  }

  final _repo = LocalAuthRepository();
  final _session = SessionService.instance;

  Future<void> _autoLogin() async {
    final hasSession = await _session.hasSession();
    if (!hasSession) {
      emit(const AuthUnauthenticated());
      return;
    }
    final user = await _repo.getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> login(final String email, final String password) async {
    emit(const AuthLoading());
    final user = await _repo.login(email, password);
    if (user == null) {
      emit(const AuthError('Невірний email або пароль'));
      return;
    }
    await _session.saveSession(email: email, token: '${email}_token');
    emit(AuthAuthenticated(user));
  }

  Future<void> register(final UserModel user) async {
    emit(const AuthLoading());
    try {
      await _repo.register(user);
      emit(const AuthUnauthenticated());
    } on Exception catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> updateUser(final UserModel updated) async {
    await _repo.updateUser(updated);
    emit(AuthAuthenticated(updated));
  }

  Future<void> logout() async {
    await _repo.logout();
    await _session.clearSession();
    emit(const AuthUnauthenticated());
  }
}
