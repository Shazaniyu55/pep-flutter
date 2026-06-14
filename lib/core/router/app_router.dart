import 'package:go_router/go_router.dart';
import 'package:pep/screens/auth/login.dart';


import '../../screens/splash.dart';

/// All route paths in one place so you never hard-code strings at call sites.
/// Navigate with `context.go(AppRoutes.login)` etc.
abstract class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const riderHome = '/home';
  static const driverHome = '/driver';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    // GoRoute(
    //   path: AppRoutes.riderHome,
    //   builder: (context, state) => const RiderHomeScreen(),
    // ),
    // GoRoute(
    //   path: AppRoutes.driverHome,
    //   builder: (context, state) => const DriverHomeScreen(),
    // ),
  ],
);