part of '../../../auth.dart';

class AuthDependency implements BaseDependencies {
  @override
  void apiDependency() {
    final dependencies = Dependencies();

    dependencies.registerFactory<AuthApi>(
      () => AuthApiImpl(apiGateway: dependencies.getIt()),
    );

    dependencies.registerFactory<AuthLocalStorage>(
      () => AuthLocalStorageImpl(storage: dependencies.getIt()),
    );
  }

  @override
  void repositoryDependency() {
    final dependencies = Dependencies();

    dependencies.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        authApi: dependencies.getIt(),
        authLocalStorage: dependencies.getIt(),
      ),
    );
  }

  @override
  void init() {
    apiDependency();
    repositoryDependency();

    Dependencies().registerLazySingleton<AuthService>(
      () => AuthService(Dependencies().getIt()),
    );

    Dependencies().registerLazySingleton<AuthRouter>(
      () => AuthRouter(),
    );

    Dependencies().getIt<RouterService>().registerRoutes([
      RouteEntry(
        path: AuthRouter.loginPage,
        builder: (context, state) => LoginPage(
          argument: state.extra as LoginPageArgument,
        ),
      ),
      RouteEntry(
        path: AuthRouter.forgotPasswordPage,
        builder: (context, state) => ForgotPasswordPage(),
      ),
      RouteEntry(
        path: AuthRouter.registerPage,
        builder: (context, state) => RegisterPage(),
      ),
    ]);
  }
}
