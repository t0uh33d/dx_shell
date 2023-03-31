// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:example/nav_menu.dart';
import 'package:example/web_inititalizer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef RouterKey = GlobalKey<NavigatorState>?;

class AppRouter {
  static final AppRouter _appRouter = AppRouter._internal();

  factory AppRouter() {
    return _appRouter;
  }

  AppRouter._internal();

  late GoRouter goRouter;
  late RouterKey _rootNavigatorKey;

  RouterKey get routerRootKey => _rootNavigatorKey;

  void init() {
    _rootNavigatorKey = GlobalKey<NavigatorState>();
    goRouter = GoRouter(
      initialLocation: '/',
      navigatorKey: _rootNavigatorKey,
      routes: _routes,
    );
  }

  List<RouteBase> get _routes {
    return <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => const WebInitializer(),
      ),
      GoRoute(
        path: '/:selectedOption',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          String? selectedOption = state.params['selectedOption'];
          // String? windowType = state.params['windowType'];
          return NavMenu(
            selectedOption: selectedOption,
            key: state.pageKey,
          );
        },
      ),
    ];
  }
}
