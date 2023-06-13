// ignore_for_file: public_member_api_docs, sort_constructors_first
part of dx_shell;

abstract class DxRouteBase {
  final String path;
  // final String? shellKey;
  late List<DxRouteBase>? routes;
  DxRouteBase({
    required this.path,
    this.routes = const [],
    // this.shellKey,
  });
}

class DxGoRoute extends DxRouteBase {
  DxGoRoute({required String path, List<DxRouteBase>? routes})
      : super(path: path, routes: routes);
}

class DxShellRoute extends DxRouteBase {
  final String key;
  final List<DxShellNode> nodes;
  DxShellRoute({required this.key, required this.nodes}) : super(path: '_');
}

class DxShellNode extends DxRouteBase {
  DxShellNode({required String path, List<DxRouteBase>? routes})
      : super(path: path, routes: routes);
}

// config

class DxShellConfig {
  static final DxShellConfig _dxShellConfig = DxShellConfig._i();

  factory DxShellConfig() => _dxShellConfig;

  DxShellConfig._i();

  late List<DxRouteBase> routes;

  static final Map<String, DxShellController> _controllerMap = {};

  void createRoutes(List<DxRouteBase> routes) {
    this.routes = routes;
    DxRouteTree routeTree = DxRouteTree();
    routeTree.generateTree(routes);
  }

  static void registerController(DxShellController controller) {
    String k = controller.key;
    if (_controllerMap.containsKey(k)) {
      throw ('Duplicate key found on DxShellController ; $k. Please use unique keys for different contollers');
    }
    _controllerMap[k] = controller;
  }

  static DxShellController? findControllerByKey(String key) {
    return _controllerMap[key];
  }
}
