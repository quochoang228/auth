part of '../../../auth.dart';

typedef OnLoginSuccess = Function(User user);

class LoginPage extends StatefulHookConsumerWidget {
  const LoginPage({super.key});

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

    var userController = useTextEditingController(text: kDebugMode ? AuthConstant.accountTestUsername : '');
    var passWorkController = useTextEditingController(text: kDebugMode ? AuthConstant.accountTestPassword : '');

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hero(
                //   tag: 'logo',
                //   child: MyAssets.images.logo.image(
                //       width: context.mqSize.width * 0.3,
                //       height: context.mqSize.width * 0.3),
                // ),
                Text('Supper App'),
                const Gap(DSSpacing.spacing4),
                Text(
                  'context.l10n.buttonLogin',
                  style: DSTextStyle.titleLarge,
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
                const Gap(DSSpacing.spacing4),
                DSButton(
                  label: 'Đăng nhập',
                  onPressed: isUserControllerNotEmpty && isPassWorkControllerNotEmpty
                      ? () {
                          ref.read(loginProvider.notifier).login(
                            url: '/service/login',
                            request: {
                              'username': userController.text,
                              'password': passWorkController.text,
                            },
                          );
                        }
                      : null,
                ),
                const Gap(DSSpacing.spacing4),
                // const Spacer(),

                DSButton(
                  label: 'Đăng ký tài khoản',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
