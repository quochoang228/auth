part of '../../../auth.dart';

typedef OnLoginSuccess = Function(User user);

class LoginPage extends StatefulHookConsumerWidget {
  const LoginPage({required this.argument, super.key});

  final LoginPageArgument argument;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // late String endPoint;
  // late OnLoginSuccess onLoginSuccess;

  // @override
  // void initState() {
  //   super.initState();
  //   final data = GoRouterState.of(context).extra as Map<String, dynamic>?;
  //   endPoint = data?['endPoint'];
  //   onLoginSuccess = data?['onLoginSuccess'];
  // }

  @override
  Widget build(BuildContext context) {
    //     final data = GoRouterState.of(context).extra as Map<String, dynamic>?;
    // endPoint = data?['endPoint'];
    // onLoginSuccess = data?['onLoginSuccess'];

    var userController = useTextEditingController(
        text: kDebugMode ? AuthConstant.accountTestUsername : '');
    var passWorkController = useTextEditingController(
        text: kDebugMode ? AuthConstant.accountTestPassword : '');

    var isUserControllerNotEmpty = useListenableSelector(
      userController,
      () => userController.text.isNotEmpty,
    );
    var isPassWorkControllerNotEmpty = useListenableSelector(
      passWorkController,
      () => passWorkController.text.isNotEmpty,
    );

    var isObscureText = useState(true);

    ref.listen(loginProvider, (previous, next) {
      next.match(
        notLoaded: (_) => const SizedBox(),
        loading: (_) => LoadingDialog.show(context),
        fetched: (value) {
          LoadingDialog.dismiss(context);
          // BaseNormalToast.showError(
          //   context: context,
          //   text: 'Đăng nhập thành công!',
          // );
          Dependencies().getIt<AuthService>().onLoginSuccess(context);
        },
        noData: (_) => const SizedBox(),
        failed: (err) {
          LoadingDialog.dismiss(context);
          // BaseNormalToast.showError(
          //   context: context,
          //   text: (err as ErrorResponse).message ?? '',
          // );
        },
      );
    });

    return Scaffold(
      backgroundColor: DSColors.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(DSSpacing.spacing6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hero(
                    //   tag: 'logo',
                    //   child: Image.asset(
                    //     "",
                    //     width: context.mqSize.width * 0.3,
                    //     height: context.mqSize.width * 0.3,
                    //   ),
                    // ),
                    const Gap(DSSpacing.spacing4),
                    Text(
                      widget.argument.title ?? '',
                      style: DSTextStyle.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(DSSpacing.spacing4),
                    DSTextField(
                      controller: userController,
                      // prefix: MyAssets.icons.user.svg(),
                      labelText: 'Tài khoản',
                      hintText: 'Nhập tài khoản',
                    ),
                    const Gap(DSSpacing.spacing4),
                    DSTextField(
                      controller: passWorkController,
                      labelText: 'Mật khẩu',
                      hintText: 'Nhập mật khẩu đăng nhập',
                      // prefix: MyAssets.icons.unlockOtp.svg(),
                      keyboardType: TextInputType.visiblePassword,
                      // suffix: InkWell(
                      //   onTap: () {
                      //     isObscureText.value = !isObscureText.value;
                      //   },
                      //   child: isObscureText.value
                      //       ? MyAssets.icons.eye.svg()
                      //       : MyAssets.icons.eyeSlash.svg(),
                      // ),
                      obscureText: isObscureText.value,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          context.push(
                            AuthRouter.forgotPasswordPage,
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: DSColors.primary,
                        ),
                        child: Text("Quên mật khẩu"),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Tôi đồng ý với ",
                        style: DSTextStyle.captionLarge
                            .copyWith(color: DSColors.textTitle),
                        children: [
                          TextSpan(
                            text: "Điều khoản dịch vụ ",
                            style: DSTextStyle.captionLarge
                                .copyWith(color: DSColors.info),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          TextSpan(
                            text: "và ",
                            style: DSTextStyle.captionLarge
                                .copyWith(color: DSColors.textTitle),
                          ),
                          TextSpan(
                            text: "chính sách bảo mật ",
                            style: DSTextStyle.captionLarge
                                .copyWith(color: DSColors.info),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          TextSpan(
                            text: "của Viettel Construction ",
                            style: DSTextStyle.captionLarge
                                .copyWith(color: DSColors.textTitle),
                          ),
                        ],
                      ),
                    ),
                    const Gap(DSSpacing.spacing4),
                    DSButton(
                      label: 'Đăng nhập',
                      onPressed: isUserControllerNotEmpty &&
                              isPassWorkControllerNotEmpty
                          ? () {
                              ref.read(loginProvider.notifier).login(
                                url: URL_LOGIN,
                                request: {
                                  'username': userController.text,
                                  'password': passWorkController.text,
                                },
                              );
                            }
                          : null,
                    ),
                  ],
                ),
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Bạn chưa có tài khoản? ",
                    style: DSTextStyle.captionLarge
                        .copyWith(color: DSColors.textTitle),
                    children: [
                      TextSpan(
                        text: "Đăng ký ngay",
                        style: DSTextStyle.captionLarge
                            .copyWith(color: DSColors.primary ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          context.push(
                            AuthRouter.registerPage,
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
      ),
    );
  }
}
