import 'package:go_router/go_router.dart';
import '../../presentation/views/home/home_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      // Mẫu định tuyến nested sau này
      // GoRoute(
      //   path: '/details/:id',
      //   name: 'details',
      //   builder: (context, state) => DetailScreen(id: state.pathParameters['id']),
      // ),
    ],
  );
}
