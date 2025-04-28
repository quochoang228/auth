import 'package:ag/ag.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:di/di.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:auth/auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:router/router.dart';

void main() async {
  Dependencies().registerSingleton<RouterService>(
    RouterService(),
  );

  await PersistentDependencies.dependeincies();

  Dependencies().registerFactory(
    () => Dio(BaseOptions(baseUrl: 'http://10.248.242.247:8720/ioc-service')),
  );

  Dependencies().registerLazySingleton<ApiGateway>(
    () => ApiGateway(
      dio: Dependencies().getIt<Dio>(),
      getAccessToken: () async => '',
      onTokenExpired: () {
        print("🔐 Token Expired");
      },
      connectivity: Connectivity(),
      onTrack: (event, data) {
        print("📊 Tracking Event: $event - $data");
      },
      // cacheDuration: null,
      // refreshAccessToken: () async => '',
      // maxRequests: null,
      // rateLimitDuration: null,
      // failureThreshold: null,
      // circuitResetTimeout: null,
    ),
  );

  AuthDependency().init();

  runApp(
    ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulHookConsumerWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Future<User?> getUser() {
    final authService = Dependencies().getIt<AuthService>();
    final user = authService.getUser();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    var user = useState<User?>(User());

    goLogin() async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      user.value = await getUser();
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            user.value?.email ?? 'No user auth',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton.icon(
              onPressed: () async {
                final authService = Dependencies().getIt<AuthService>();
                final isLoggedIn = await authService
                    .isLoggedIn(); // Kiểm tra trạng thái đăng nhập
                if (!isLoggedIn) {
                  goLogin();
                }
              },
              label: const Text('Auth Button'),
              icon: const Icon(Icons.login),
            ),
          ),
          SizedBox(height: 20),
          user.value != null
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Dependencies().getIt<ApiGateway>().setToken('');
                      var data =
                          await Dependencies().getIt<AuthService>().logout();
                      if (data) {
                        user.value = await getUser();
                      }
                    },
                    label: const Text('Logout Button'),
                    icon: const Icon(Icons.logout),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
