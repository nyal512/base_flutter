import 'package:base_flutter/presentation/views/wallet/wallet_screen.dart';
import 'package:base_flutter/presentation/views/payment/payment_screen.dart';
import 'package:base_flutter/presentation/views/sound/sound_screen.dart';
import 'package:base_flutter/presentation/views/fingerprint/fingerprint_screen.dart';
import 'package:base_flutter/presentation/views/summary_format/summary_format_screen.dart';
import 'package:base_flutter/presentation/views/summary_time/summary_time_screen.dart';
import 'package:base_flutter/presentation/views/ticket/ticket_screen.dart';
import 'package:base_flutter/presentation/views/operation_print/operation_print_screen.dart';
import 'package:base_flutter/presentation/views/network/network_screen.dart';
import 'package:base_flutter/presentation/views/ordering/ordering_screen.dart';
import 'package:base_flutter/presentation/views/ftp/ftp_screen.dart';
import 'package:base_flutter/presentation/views/parent_child/parent_child_screen.dart';
import 'package:base_flutter/presentation/views/options/option_1_screen.dart';
import 'package:base_flutter/presentation/views/options/empty_option_screen.dart';
import 'package:base_flutter/presentation/views/details/details_screen.dart';
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
            name: 'sound',
            builder: (context, state) => const SoundScreen(),
          ),
          GoRoute(
            path: '/payment',
            name: 'payment',
            builder: (context, state) => const PaymentScreen(),
          ),
          GoRoute(
            path: '/wallet',
            name: "wallet",
            builder: (context, state) => const WalletScreen(),
          ),
          GoRoute(
            path: '/fingerprint',
            name: "fingerprint",
            builder: (context, state) => const FingerprintScreen(),
          ),
          GoRoute(
            path: '/ticket',
            name: "ticket",
            builder: (context, state) => const TicketScreen(),
          ),
          GoRoute(
            path: '/report',
            name: "report",
            builder: (context, state) => const SummaryFormatScreen(),
          ),
          GoRoute(
            path: '/time',
            name: "time",
            builder: (context, state) => const SummaryTimeScreen(),
          ),
          GoRoute(
            path: '/print',
            name: "print",
            builder: (context, state) => const OperationPrintScreen(),
          ),
          GoRoute(
            path: '/network',
            name: "network",
            builder: (context, state) => const NetworkScreen(),
          ),
          GoRoute(
            path: '/ordering',
            name: "ordering",
            builder: (context, state) => const OrderingScreen(),
          ),
          GoRoute(
            path: '/ftp',
            name: "ftp",
            builder: (context, state) => const FtpScreen(),
          ),
          GoRoute(
            path: '/parent',
            name: "parent",
            builder: (context, state) => const ParentChildScreen(),
          ),
          GoRoute(
            path: '/option1',
            name: "option1",
            builder: (context, state) => const Option1Screen(),
          ),
          GoRoute(
            path: '/option2',
            name: "option2",
            builder: (context, state) => const EmptyOptionScreen(),
          ),
          GoRoute(
            path: '/option3',
            name: "option3",
            builder: (context, state) => const EmptyOptionScreen(),
          ),
          GoRoute(
            path: '/option4',
            name: "option4",
            builder: (context, state) => const EmptyOptionScreen(),
          ),
          GoRoute(
            path: '/details',
            name: "details",
            builder: (context, state) => const DetailsScreen(),
          ),
        ],
      ),
    ],
  );
}
