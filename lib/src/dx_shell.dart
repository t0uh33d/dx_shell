library dx_shell;

import 'package:autocorrect_and_autocomplete_engine/autocorrect_and_autocomplete_engine.dart';
import 'package:dx_shell/src/route_handler.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'controller.dart';
part 'node.dart';
part 'observer.dart';

class DxShell extends StatefulWidget {
  final DxShellController dxShellController;
  final bool isRootShell;
  final Duration? animationDuration;
  final ScrollPhysics physics;
  final DragStartBehavior dragStartBehavior;
  final double viewportFraction;
  final Clip clipBehavior;

  const DxShell({
    Key? key,
    required this.dxShellController,
    this.isRootShell = false,
    this.animationDuration,
    this.physics = const NeverScrollableScrollPhysics(),
    this.dragStartBehavior = DragStartBehavior.start,
    this.viewportFraction = 1.0,
    this.clipBehavior = Clip.hardEdge,
  }) : super(key: key);

  @override
  State<DxShell> createState() => _DxShellState();
}

class _DxShellState extends State<DxShell> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      length: widget.dxShellController.nodes.length,
      vsync: this,
      initialIndex: widget.dxShellController.currIndex,
    );

    widget.dxShellController._setTabController(tabController);

    if (widget.physics is! NeverScrollableScrollPhysics) {
      tabController.addListener(_scrollChangeListener);
    }

    super.initState();
  }

  @override
  void dispose() {
    if (widget.physics is! NeverScrollableScrollPhysics) {
      tabController.removeListener(_scrollChangeListener);
    }

    tabController.dispose();
    super.dispose();
  }

  void _scrollChangeListener() {
    widget.dxShellController.animateToNode(tabController.index);
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      physics: widget.physics,
      dragStartBehavior: widget.dragStartBehavior,
      viewportFraction: widget.viewportFraction,
      clipBehavior: widget.clipBehavior,
      children: widget.dxShellController._nodeWidgets,
    );
  }
}
