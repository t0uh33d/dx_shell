// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:dx_shell/dx_shell.dart';
import 'package:example/nav_menu.dart';
import 'package:example/nesting/nesting_example_ui.dart';
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
      observers: [GoRouterObserver()],
      initialLocation: '/',
      navigatorKey: _rootNavigatorKey,
      routes: _routes,
    );
    _traverseGoRouteAndBuildDxNodeTree();
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
          String? selectedOption = state.pathParameters['selectedOption'];
          // String? windowType = state.params['windowType'];
          return NavMenu(
            selectedOption: selectedOption,
            key: state.pageKey,
          );
        },
        routes: [
          GoRoute(
            path: 'nesting/:navOption/:subNavOption',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) {
              String? selectedNavOption = state.pathParameters['navOption'];
              String? selectedSubNavOption =
                  state.pathParameters['subNavOption'];
              return NestingExample(
                navOption: selectedNavOption,
                subNavOption: selectedSubNavOption,
              );
            },
          )
        ],
      ),
    ];
  }

  void _traverseGoRouteAndBuildDxNodeTree() {
    DxShellConfig().createRoutes([
      DxGoRoute(
        path: 'explore',
        routes: [
          DxShellRoute(
            key: 'explore-shell-key',
            nodes: [
              DxShellNode(path: 'g-sec-explore'),
              DxShellNode(
                path: 't-bill-explore',
                routes: [
                  DxGoRoute(
                    path: 'place-order',
                  )
                ],
              ),
              DxShellNode(path: 'SDL-explore'),
            ],
          ),
          DxShellRoute(
            key: 'tab-key',
            nodes: [
              DxShellNode(path: 'tab-1'),
              DxShellNode(path: 'tab-2'),
              DxShellNode(path: 'tab-3'),
              DxShellNode(path: 'tab-4'),
            ],
          ),
        ],
      ),
      DxGoRoute(
        path: 'orders',
        routes: [
          DxGoRoute(path: 'g-sec-orders'),
          DxGoRoute(path: 't-bill-orders'),
          DxGoRoute(path: 'SDL-orders'),
        ],
      ),
      DxGoRoute(
        path: 'support',
        routes: [
          DxGoRoute(path: 'general-support'),
          DxGoRoute(path: 'community-support'),
          DxGoRoute(path: 'xyz-support'),
        ],
      ),
    ]);
  }
}

class GoRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('MyTest didPush: ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('MyTest didPop: $route');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('MyTest didRemove: $route');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print('MyTest didReplace: $newRoute');
  }
}
