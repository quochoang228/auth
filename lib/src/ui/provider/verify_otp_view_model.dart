import 'package:auth/auth.dart';
import 'package:auth/src/entities/auth_state.dart';
import 'package:di/di.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final verifyOtpViewModelProvider =
StateNotifierProvider.autoDispose<VerifyOtpViewModel, AuthState>(
      (ref) => VerifyOtpViewModel(ref),
);

class VerifyOtpViewModel extends StateNotifier<AuthState> {
  VerifyOtpViewModel(this.ref) : super(AuthState());
  final Ref ref;
  Future<AuthState> doVerifyOtp({
    required String otpCode,
    required String receivePhone,
    String? userName,
  }) async {
    // state = AuthState(loading: true);
    //
    // final result = await Dependencies().getIt<AuthRepository>().login(
    //   url: '',
    //   request: {},
    // );
    //
    // var data = result.when<AuthState>(
    //   success: (data) {
    //     if (data.status == 200) {
    //       state = AuthState(
    //         loading: false,
    //         status: AuthStatus.authenticated,
    //         // user: data.data,
    //       );
    //     } else {
    //       state = AuthState(
    //         loading: false,
    //         status: AuthStatus.error,
    //         errorMessage: data.message ?? '',
    //       );
    //     }
    //     return state;
    //   },
    //   error: (e) {
    //     state = AuthState(
    //       loading: false,
    //       status: AuthStatus.error,
    //       errorMessage: e.toString(),
    //     );
    //     return state;
    //   },
    // );
    state = AuthState(
      loading: false,
      status: AuthStatus.authenticated,
      // user: data.data,
    );
    return state;
  }
}
