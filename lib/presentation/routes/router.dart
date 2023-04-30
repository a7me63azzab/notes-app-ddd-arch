import 'package:auto_route/auto_route.dart';
import '../routes/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SingInRoute.page,
          path: '/signin',
        ),
        AutoRoute(
          page: SplashRoute.page,
          initial: true,
          path: '/',
        ),
      ];
}
