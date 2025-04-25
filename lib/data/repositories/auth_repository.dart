class AuthRepository {
  Future<bool> login(String username, String password) async {
    // Mock authentication (hardcoded for simplicity)
    await Future.delayed(const Duration(seconds: 1));
    return username == 'admin' && password == 'password';
  }
}