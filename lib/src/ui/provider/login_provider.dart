part of '../../../auth.dart';

final loginProvider =
    StateNotifierProvider.autoDispose<LoginProvider, DataState<User, ErrorResponse>>(
  (ref) => LoginProvider(ref),
);

class LoginProvider extends StateNotifier<DataState<User, ErrorResponse>> {
  LoginProvider(this.ref) : super(NotLoaded<User>());

  final Ref ref;

  Future login({
    required String url,
    required Map<String, dynamic> request,
  }) async {
    if (state.state != CurrentDataState.loading) {
      state = Loading<User>();
      try {
        final result = await Dependencies().getIt<AuthRepository>().login(
              url: url,
              request: request,
            );
        result.when(
          success: (data) async {
            if (data.token != null) {
              await Dependencies()
                  .getIt<AuthRepository>()
                  .setToken(data.token ?? '');

              await Dependencies()
                  .getIt<ApiGateway>()
                  .setToken(data.token ?? '');

              // get local user
              await ref.read(localUserProvider.notifier).fetchLocalUser();;

              if (data.token != null) {
                var parseToken = JwtDecoder.decode(data.token!);
                state = Fetched(User.fromJson(parseToken));
              } else {
                state = Fetched(User());
              }
            } else {
              state = Failed(ErrorResponse(message: data.message ?? ''));
            }
            // if (data.status == 201 && data.data != null) {
            //   await Dependencies()
            //       .getIt<AuthRepository>()
            //       .setToken(data.data!.token ?? '');
            //
            //   // get local user
            //   await ref.read(localUserProvider.notifier).fetchLocalUser();;
            //
            //   if (data.data!.token != null) {
            //     var parseToken = JwtDecoder.decode(data.data!.token!);
            //     state = Fetched(User.fromJson(parseToken));
            //   } else {
            //     state = Fetched(User());
            //   }
            // } else {
            //   // state = Failed(data.errors);
            //   state = Failed(ErrorResponse(message: data.message ?? ''));
            // }
          },
          error: (err) {
            state = Failed(ErrorResponse(message: err.message));
          },
        );
      } catch (error) {
        state = Failed(ErrorResponse(message: error.toString()));
      }
    }
  }
}
