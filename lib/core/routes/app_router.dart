import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/views/home/home_screen.dart';

import '../../presentation/widgets/widgets.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          final bool showSideMenu = state.extra is Map && (state.extra as Map)['showSideMenu'] == false ? false : true;
          return MainLayout(
            currentRoute: state.uri.path,
            showSideMenu: showSideMenu,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/sound',
            builder: (context, state) => const Scaffold(body: Center(child: Text('Sound Screen'))),
          ),
          GoRoute(
            path: '/payment',
            builder: (context, state) => const Scaffold(body: Center(child: Text('Payment Screen'))),
          ),
          GoRoute(
            path: '/limit',
            builder: (context, state) => const Scaffold(body: Center(child: Text('Limit Screen'))),
          ),
          GoRoute(
            path: '/machine',
            builder: (context, state) => const Scaffold(body: Center(child: Text('Machine Screen'))),
          ),
          GoRoute(
            path: '/ticket',
            builder: (context, state) => const Scaffold(body: Center(child: Text('Ticket Screen'))),
          ),
          GoRoute(
            path: '/report',
            builder: (context, state) => const Scaffold(body: Center(child: Text('Report Screen'))),
          ),
          GoRoute(
            path: '/time',
            builder: (context, state) => const Scaffold(body: Center(child: Text('Time Screen'))),
          ),
          GoRoute(
            path: '/print',
            builder: (context, state) => const Scaffold(body: Center(child: Text('Print Screen'))),
          ),
          GoRoute(
            path: '/network',
            builder: (context, state) => const Scaffold(body: Center(child: Text('Network Screen'))),
          ),
        ],
      ),
    ],
  );
}
