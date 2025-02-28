part of '../../../auth.dart';

abstract class AuthLocalStorageKeys {
  static const userLocalKey = '__user_storage_key__';
}

abstract class AuthLocalStorage {
  Future<void> setToken(String token);

  Future<String?> fetchToken();

  Future<bool> doLogout();
}

class AuthLocalStorageImpl implements AuthLocalStorage {
  const AuthLocalStorageImpl({
    required SharedPreferencesStorage storage,
  }) : _storage = storage;

  final SharedPreferencesStorage _storage;

  /// Sets authToken in Storage.
  @override
  Future<void> setToken(String token) => _storage.write(
        key: AuthLocalStorageKeys.userLocalKey,
        value: token,
      );

  /// Fetches authToken from Storage.
  @override
  Future<String?> fetchToken() async {
    final userLocal =
        await _storage.read(key: AuthLocalStorageKeys.userLocalKey);
    return userLocal;
  }

  @override
  Future<bool> doLogout() async {
    try {
      await _storage.clear();
      return true;
    } catch (e) {
      return false;
    }
  }
}
