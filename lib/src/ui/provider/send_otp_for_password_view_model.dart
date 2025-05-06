import 'dart:convert';
import 'package:auth/auth.dart';
import 'package:auth/src/entities/auth_state.dart';
import 'package:di/di.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final sendOtpForForgotPasswordViewModelProvider = StateNotifierProvider
    .autoDispose<SendOtpForForgotPasswordViewModel, AuthState>(
  (ref) => SendOtpForForgotPasswordViewModel(),
);

class SendOtpForForgotPasswordViewModel extends StateNotifier<AuthState> {
  SendOtpForForgotPasswordViewModel() : super(AuthState());

  Future doSendOtp({
    required String phoneNumber,
  }) async {
    state = AuthState(
      loading: false,
      status: AuthStatus.authenticated,
    );
    // state = AuthState(loading: true);
    // final result = await Dependencies().getIt<AuthRepository>().login(
    //   url: '',
    //   request: {},
    // );
    //
    // result.when(
    //   success: (data) async {
    //     if (data.status == 200) {
    //       state = AuthState(
    //         loading: false,
    //         status: AuthStatus.authenticated,
    //       );
    //     } else if (data.status == 405) {
    //       state = AuthState(
    //         loading: false,
    //         status: AuthStatus.notExisted,
    //         errorMessage: data.message ?? '',
    //       );
    //     } else {
    //       state = AuthState(
    //         loading: false,
    //         status: AuthStatus.error,
    //         errorMessage: data.message ?? '',
    //       );
    //     }
    //   },
    //   error: (e) {
    //     state = AuthState(
    //       loading: false,
    //       status: AuthStatus.error,
    //       errorMessage: e.toString(),
    //     );
    //   },
    // );
  }
}
