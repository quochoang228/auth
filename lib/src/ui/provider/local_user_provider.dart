part of '../../../auth.dart';

final localUserProvider = StateNotifierProvider<LocalUserProvider, User>(
    (ref) => LocalUserProvider(ref));

class LocalUserProvider extends StateNotifier<User> {
  LocalUserProvider(this.ref) : super(User());

  final Ref ref;

  Future fetchLocalUser() async {
    final token = await Dependencies().getIt<AuthRepository>().fetchToken();

    if (token != null) {
      var parseToken = JwtDecoder.decode(token);

      state = User.fromJson(parseToken);
    }
  }
}
