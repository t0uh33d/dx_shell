import 'package:dx_shell/dx_shell.dart';

abstract class DxRouteNode {
  final String pathName;
  final List<DxRouteNode>? subRoutes;

  DxRouteNode({
    required this.pathName,
    this.subRoutes,
  });
}

class RootNode extends DxRouteNode {
  RootNode({required List<DxRouteNode>? subRoutes})
      : super(pathName: '/', subRoutes: subRoutes);
}

class GoRouteNode extends DxRouteNode {
  GoRouteNode({required String pathName, List<DxRouteNode>? subRoutes})
      : super(pathName: pathName, subRoutes: subRoutes);
}

class ShellNode extends DxRouteNode {
  final String key;
  final List<ShellNodeChildren> nodes;
  ShellNode({
    required String pathName,
    // required List<DxRouteNode> subRoutes,
    required this.nodes,
    required this.key,
  }) : super(pathName: pathName) {
    _createController();
  }

  late DxShellController controller;

  void _createController() {
    List<DxNode> dxNodes = [];
    for (int idx = 0; idx < nodes.length; idx++) {
      dxNodes.add(DxNode(name: nodes[idx].pathName));
    }
    controller = DxShellController(nodes: dxNodes, key: key);
    DxShellConfig.registerController(controller);
  }
}

class ShellNodeChildren extends DxRouteNode {
  final DxShellNode node;
  ShellNodeChildren({
    required this.node,
    List<DxRouteNode>? subRoutes,
  }) : super(pathName: node.path, subRoutes: subRoutes);
}

class DxRouteTree {
  static final DxRouteTree _dxRouteTree = DxRouteTree._i();

  factory DxRouteTree() => _dxRouteTree;

  DxRouteTree._i();

  late RootNode rootNode;

  void generateTree(List<DxRouteBase> routes) {
    rootNode = RootNode(subRoutes: _generateTree(routes, 0));
    print('tree');
  }

  List<DxRouteNode>? _generateTree(List<DxRouteBase>? routes, int depth) {
    if (routes == null) return null;
    List<DxRouteNode> r = [];
    for (int idx = 0; idx < routes.length; idx++) {
      DxRouteBase route = routes[idx];
      if (route is DxGoRoute) {
        GoRouteNode goRouteNode = GoRouteNode(
          pathName: route.path,
          subRoutes: _generateTree(route.routes, depth + 1),
        );
        r.add(goRouteNode);
      } else if (route is DxShellRoute) {
        List<ShellNodeChildren> n = [];
        for (int i = 0; i < route.nodes.length; i++) {
          DxShellNode currNode = route.nodes[idx];
          ShellNodeChildren nodeChild = ShellNodeChildren(
            node: currNode,
            subRoutes: _generateTree(currNode.routes, depth + 1),
          );
          n.add(nodeChild);
        }
        ShellNode shellNode = ShellNode(
          pathName: route.path,
          nodes: n,
          key: route.key,
        );
        r.add(shellNode);
      }
    }
    return r;
  }
}
