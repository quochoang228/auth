import 'package:auth/auth.dart';
import 'package:auth/src/entities/auth_state.dart';
import 'package:di/di.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final forgotPasswordViewModelProvider =
StateNotifierProvider.autoDispose<ForgotPasswordViewModel, AuthState>(
      (ref) => ForgotPasswordViewModel(),
);

class ForgotPasswordViewModel extends StateNotifier<AuthState> {
  ForgotPasswordViewModel() : super(AuthState());

  Future doRequestPassword({
    required String otpCode,
    required String receivePhone,
    required String password,
  }) async {
    state = AuthState(loading: true);

    final result = await Dependencies().getIt<AuthRepository>().login(
      url: '',
      request: {},
    );

    result.when(
      success: (data) async {
        if (data.status == 200) {
          state = AuthState(
            loading: false,
            status: AuthStatus.authenticated,
          );
        } else {
          state = AuthState(
            loading: false,
            status: AuthStatus.error,
            errorMessage: data.message ?? '',
          );
        }
      },
      error: (e) {
        state = AuthState(
          loading: false,
          status: AuthStatus.error,
          errorMessage: e.toString(),
        );
      },
    );
  }
}
