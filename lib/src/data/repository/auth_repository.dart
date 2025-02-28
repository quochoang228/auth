part of '../../../auth.dart';

abstract class AuthRepository {
  Future<BaseResult<AuthResponse>> login({
    required String url,
    required Map<String, dynamic> request,
  });

  Future<bool> logOut();

  Future<void> setToken(String token);

  Future<String?> fetchToken();

  Future<bool> isLoggedIn();
}

class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  AuthRepositoryImpl({
    required AuthApi authApi,
    required AuthLocalStorage authLocalStorage,
  })  : _authApi = authApi,
        _profileStorage = authLocalStorage;

  final AuthApi _authApi;
  final AuthLocalStorage _profileStorage;

  @override
  Future<BaseResult<AuthResponse>> login({
    required String url,
    required Map<String, dynamic> request,
  }) async {
    try {
      return await safeApiCall(
        _authApi.login(url: url, request: request),
        mapper: (data) {
          return AuthResponse.fromJson(data);
          // return DataResponse<AuthResponse>.fromJson(
          //   data,
          //   (Object? obj) => AuthResponse.fromJson(obj as Map<String, dynamic>),
          // );
        },
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  @override
  Future<bool> logOut() async {
    try {
      return await _profileStorage.doLogout();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  @override
  Future<void> setToken(String token) async {
    try {
      await _profileStorage.setToken(token);
    } catch (error, _) {
      LogUtils.e(error.toString());
    }
  }

  @override
  Future<String?> fetchToken() async {
    try {
      return await _profileStorage.fetchToken();
    } catch (error, _) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _profileStorage.fetchToken() != null;
  }
}
