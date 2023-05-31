// ignore_for_file: avoid_web_libraries_in_flutter

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
          String? selectedOption = state.params['selectedOption'];
          // String? windowType = state.params['windowType'];
          return NavMenu(
            selectedOption: selectedOption,
            key: state.pageKey,
          );
        },
        routes: [
          GoRoute(
            path: 'nesting',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) {
              return const NestingExample(
                navOption: null,
                subNavOption: null,
              );
            },
            routes: [
              GoRoute(
                path: ':navOption/:subNavOption',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  String? selectedNavOption = state.params['navOption'];
                  String? selectedSubNavOption = state.params['subNavOption'];
                  return NestingExample(
                    navOption: selectedNavOption,
                    subNavOption: selectedSubNavOption,
                  );
                },
              )
            ],
          )
        ],
      ),
    ];
  }

  void _traverseGoRouteAndBuildDxNodeTree() {
    List<RouteBase> testRoute = [
      GoRoute(
        path: 'a1',
        builder: (context, state) => const Placeholder(),
        routes: [
          GoRoute(
            path: 'a1-b1',
            builder: (context, state) => const Placeholder(),
            routes: [
              GoRoute(
                path: 'a1-b1-c1',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'a1-b1-c2',
                builder: (context, state) => const Placeholder(),
              ),
            ],
          ),
          GoRoute(
            path: 'a1-b2',
            builder: (context, state) => const Placeholder(),
          ),
          GoRoute(
            path: 'a1-b3',
            builder: (context, state) => const Placeholder(),
          ),
        ],
      ),
      GoRoute(
        path: 'a2',
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        path: 'a3',
        builder: (context, state) => const Placeholder(),
      ),
    ];
    _printTree(testRoute, 0);
  }

  void _printTree(List<RouteBase> routes, int depth) {
    for (int idx = 0; idx < routes.length; idx++) {
      GoRoute route = routes[idx] as GoRoute;
      print('${route.path} at depth : $depth');
      if (route.routes.isNotEmpty) {
        _printTree(route.routes, depth + 1);
      }
    }
  }
}
