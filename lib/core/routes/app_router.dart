import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/views/home/home_screen.dart';
import '../../presentation/views/menu_button_master/menu_button_master_screen.dart';
import '../../presentation/views/product_area/product_area_screen.dart';

import '../../presentation/widgets/widgets.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          final String path = state.uri.path;
          final bool isHome = path == '/';
          final bool isMenuMaster = path == '/menu-button-master';
          final bool isProductArea = path == '/product-area';
          
          final bool showSideMenu = isHome ? false : (state.extra is Map && (state.extra as Map)['showSideMenu'] == false ? false : true);
          final bool showHeader = !isHome && !isMenuMaster && !isProductArea;

          return MainLayout(
            currentRoute: path,
            showSideMenu: showSideMenu,
            showHeader: showHeader,
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
            path: '/menu-button-master',
            builder: (context, state) => const MenuButtonMasterScreen(),
          ),
          GoRoute(
            path: '/product-area',
            builder: (context, state) => const ProductAreaScreen(),
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
