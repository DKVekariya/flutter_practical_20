import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository.dart';

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false);

  final _authRepository = AuthRepository();

  Future<bool> login(String username, String password) async {
    final success = await _authRepository.login(username, password);
    state = success;
    return success;
  }
}