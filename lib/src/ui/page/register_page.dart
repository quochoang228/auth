part of '../../../auth.dart';

class RegisterPage extends StatefulHookConsumerWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {

  @override
  Widget build(BuildContext context) {

    final PageController controller = PageController();
    ValueNotifier<Timer?> timer = useState(null);
    var timeResend = useState(60);

    final otpController = useTextEditingController();
    //
    final phoneController = useTextEditingController();
    final passwordController = useTextEditingController();
    final passwordFocusNode = useFocusNode();
    final confirmPasswordController = useTextEditingController();
    final confirmPasswordFocusNode = useFocusNode();
    final errorAccount = useState<Widget?>(null);
    var userController = useTextEditingController();

    void startTimer() {
      const oneSec = Duration(seconds: 1);
      timeResend.value = 60;
      if (timer.value != null) timer.value?.cancel();
      timer.value = Timer.periodic(
        oneSec,
            (Timer timer) {
          if (timeResend.value == 0) {
            timer.cancel();
          } else {
            timeResend.value = timeResend.value - 1;
          }
        },
      );
    }
    Future<bool> goToBack() async {
      if (controller.page == 0) {
        return true;
      } else {
        if (controller.page == 1) {
          otpController.clear();
          controller.jumpToPage(0);
        }

        if (controller.page == 2.0) {
          passwordController.clear();
          controller.jumpToPage(1);
        }
        return false;
      }
    }

    Future<bool> verifyOtp(otp) async {
      AuthState otpState =
      await ref.read(verifyOtpViewModelProvider.notifier).doVerifyOtp(
        otpCode: otp,
        receivePhone: phoneController.text,
      );
      if (otpState.status == AuthStatus.authenticated) {
        return true;
      } else {
        // showMessageErrorOtp(otpState);
        return false;
      }
    }


    ref.listen<AuthState>(
      sendOtpForForgotPasswordViewModelProvider,
          (AuthState? previous, AuthState next) {
        if (next.loading) {
          BrnLoadingDialog.show(context,
              content: "Đang gửi OTP...");
        } else {
          BrnLoadingDialog.dismiss(context);
          switch (next.status) {
            case AuthStatus.unauthenticated:
              break;
            case AuthStatus.authenticated:
              controller.jumpToPage(1);
              startTimer();
              break;
            case AuthStatus.error:
              BrnLoadingDialog.show(context,
                  content: next.errorMessage ?? '');
              break;
            case AuthStatus.notExisted:
              errorAccount.value = RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Tài khoản không tồn tại. Vui lòng đăng ký để tiếp tục",
                  style: DSTextStyle.bodySmall.copyWith(
                    color: Color(0xFF5C5F66),
                  ),
                  children: [
                    TextSpan(
                      text: "tại đây",
                      style: DSTextStyle.bodySmall.copyWith(
                        color: Color(0xFFE81D2B),
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {},
                    ),
                  ],
                ),
              );
              break;
            case AuthStatus.registed:
              break;
            case AuthStatus.twoFa:
              break;
            case AuthStatus.sentOtp:
              break;
            case AuthStatus.passwordCorrect:
              break;
          }
        }
      },
    );

    ref.listen<AuthState>(
      verifyOtpViewModelProvider,
          (AuthState? previous, AuthState next) {
        if (next.loading) {
          BrnLoadingDialog.show(context, content: "Loading...");
        } else {
          switch (next.status) {
            case AuthStatus.unauthenticated:
              break;
            case AuthStatus.authenticated:
            // if (next.user != null) {
              controller.jumpToPage(2);
              FocusScope.of(context).requestFocus(passwordFocusNode);
              // }
              break;
            case AuthStatus.error:
              BrnLoadingDialog.show(context, content: next.errorMessage ?? '');
              break;
            case AuthStatus.registed:
              break;
            case AuthStatus.notExisted:
              break;
            case AuthStatus.twoFa:
              break;
            case AuthStatus.sentOtp:
              break;
            case AuthStatus.passwordCorrect:
              break;
          }
        }
      },
    );

    // ref.listen(forgotPasswordViewModelProvider, (previous, next) {
    //   if (next.loading) {
    //     BrnLoadingDialog.show(context,
    //         content: AppStrings.authentication_forgot_pass_changing);
    //   } else {
    //     BrnLoadingDialog.dismiss(context);
    //     switch (next.status) {
    //       case AuthStatus.unauthenticated:
    //         break;
    //       case AuthStatus.authenticated:
    //         Navigator.of(context).pop(true);
    //         break;
    //       case AuthStatus.error:
    //         DialogHelper.showDialogCenter(
    //           context,
    //           message: next.errorMessage ?? '',
    //           status: DialogStatus.error,
    //         );
    //         break;
    //       case AuthStatus.registed:
    //         break;
    //     }
    //   }
    // });

    var isPhoneControllerNotEmpty = useListenableSelector(
      phoneController,
          () => phoneController.text.isNotEmpty,
    );

    var isObscureText = useState(true);
    var isObscureTextConfirmPassword = useState(true);

    return WillPopScope(
      onWillPop: goToBack,
      child: Scaffold(
        backgroundColor: DSColors.backgroundWhite,
        appBar: AppBar(
          title: Text(
            'Đăng ký',
            style: TextStyle(color: DSColors.backgroundWhite),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: DSColors.backgroundWhite,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          backgroundColor: DSColors.primary,
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller,
          children: [
            wrapperBackground(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Gap(DSSpacing.spacing4),
                  Text(
                    'Nhập thông tin để bắt đầu đăng ký',
                    style: DSTextStyle.bodySmall,
                  ),
                  const Gap(DSSpacing.spacing4),
                  DSTextField(
                    controller: phoneController,
                    // prefix: MyAssets.icons.user.svg(),
                    keyboardType: TextInputType.number,
                    labelText: 'Số điện thoại',
                    hintText: 'Nhập số điện thoại',
                  ),
                  const Gap(DSSpacing.spacing4),
                  DSButton(
                    label: 'Gửi mã xác thực',
                    onPressed: isPhoneControllerNotEmpty ? () {
                      ref
                          .read(sendOtpForForgotPasswordViewModelProvider
                          .notifier)
                          .doSendOtp(phoneNumber: phoneController.text);
                    } : null,
                  ),
                  const Gap(DSSpacing.spacing4),
                  Center (
                    child: RichText(
                      text: TextSpan(
                        text: "Bạn đã có tài khoản? ",
                        style: DSTextStyle.captionLarge
                            .copyWith(color: DSColors.textTitle),
                        children: [
                          TextSpan(
                            text: "Đăng nhập ngay",
                            style: DSTextStyle.captionLarge
                                .copyWith(color: DSColors.primary ),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              context.push(
                                AuthRouter.loginPage,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ------------------ OTP ---------------------------
            wrapperBackground(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PinputOtpAutofill(
                    title: "Mã xác thực (OTP) đã được gửi qua Tin nhắn số ",
                    userPhone: phoneController.text,
                    onValidator: verifyOtp,
                    onCompleted: () {},
                    countdownText: "Vui lòng chờ {} để nhận lại mã xác thực.",
                    confirmText: "Tiếp tục",
                    notReceiveText: "Bạn chưa nhận được mã?",
                    supportText: "Trợ giúp",
                    errorText: "Mã OTP không đúng",
                    onSupport: () {
                      // showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return SupportOTPPopup(
                      //         phoneNumber: phone.value,
                      //         action: OTPCallAction.CHANGE_PASSWORD,
                      //       );
                      //     });
                    },
                  ),
                ],
              ),
            ),
            // ----------------- new password  ----------------
            wrapperBackground(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DSTextField(
                    controller: userController,
                    // prefix: MyAssets.icons.user.svg(),
                    labelText: 'Tên đăng nhập',
                    hintText: 'Nhập tên đăng nhập',
                  ),
                  const Gap(24),
                  DSTextField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    clear: false,
                    suffix: InkWell(
                      onTap: () {
                        isObscureText.value = !isObscureText.value;
                      },
                      child: isObscureText.value
                          ? Icon(Icons.remove_red_eye)
                          : Icon(Icons.visibility_off),
                    ),
                    obscureText: isObscureText.value,
                    labelText: 'Mật khẩu',
                    hintText: 'Nhập mật khẩu',
                  ),
                  const Gap(DSSpacing.spacing4),
                  Text(
                    "Mật khẩu có độ dài từ 8-16 ký tự bao gồm ký tự in hoa, số và ký tự đặc biệt",
                    style: DSTextStyle.bodySmall.copyWith(
                      color: Color(0xff82878B),
                      height: 1.3,
                    ),
                  ),
                  const Gap(DSSpacing.spacing4),
                  DSTextField(
                    controller: confirmPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    clear: false,
                    suffix: InkWell(
                      onTap: () {
                        isObscureTextConfirmPassword.value = !isObscureTextConfirmPassword.value;
                      },
                      child: isObscureTextConfirmPassword.value
                          ? Icon(Icons.remove_red_eye)
                          : Icon(Icons.visibility_off),
                    ),
                    obscureText: isObscureTextConfirmPassword.value,
                    labelText: 'Xác nhận mật khẩu',
                    hintText: 'Xác nhận mật khẩu',
                  ),
                  const Gap(40),
                  DSButton(
                    label: 'Xác nhận',
                    onPressed: (){
                      ref
                          .read(sendOtpForForgotPasswordViewModelProvider
                          .notifier)
                          .doSendOtp(phoneNumber: phoneController.text);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget wrapperBackground({child}) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: BoxDecoration(
            color: DSColors.backgroundWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 16,
          ),
          child: child,
        ),
      ),
    );
  }
}
