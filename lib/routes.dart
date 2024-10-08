import 'package:go_router/go_router.dart';

import 'auth/auth_page.dart';
import 'main.dart';
import 'pages/home.dart';

class CustomRoutes {
  static final GoRouter router = GoRouter(routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: "/auth/:page",
      builder: (context, state) => AuthPage(
        page: state.pathParameters['page']!,
      ),
    ),
    GoRoute(
      path: "/:userID/:page",
      builder: (context, state) {
        String? layout = state.uri.queryParameters['layout'];
        return HomePage(
          userID: state.pathParameters['userID']!,
          currentPage: state.pathParameters['page']!,
          secondID: "",
          thirdPage: "",
          query: {"layout": layout},
        );
      },
    ),
    GoRoute(
      path: "/:userID/:page/:secondID",
      builder: (context, state) {
        return HomePage(
          userID: state.pathParameters['userID']!,
          currentPage: state.pathParameters['page']!,
          secondID: state.pathParameters['secondID']!,
          thirdPage: "",
          query: {},
        );
      },
    ),
    GoRoute(
      path: "/:userID/:page/:secondID/:thirdPage",
      builder: (context, state) => HomePage(
        userID: state.pathParameters['userID']!,
        currentPage: state.pathParameters['page']!,
        secondID: state.pathParameters['secondID']!,
        thirdPage: state.pathParameters['thirdPage']!,
        query: {},
      ),
    )
  ]);
}
