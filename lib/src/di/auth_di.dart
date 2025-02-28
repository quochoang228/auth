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

    Dependencies().getIt<RouterService>().registerRoute(
          RouteEntry(
            path: AuthService.loginRouter,
            builder: (context, state) => const LoginPage(),
          ),
        );
  }
}
