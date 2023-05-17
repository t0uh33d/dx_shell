part of dx_shell;

class DxPageView extends StatefulWidget {
  final DxShellController dxShellController;
  final Duration? animationDuration;
  final ScrollPhysics physics;
  final DragStartBehavior dragStartBehavior;

  final Clip clipBehavior;
  final List<Widget>? children;
  final bool force;

  const DxPageView({
    Key? key,
    required this.dxShellController,
    this.animationDuration,
    this.physics = const NeverScrollableScrollPhysics(),
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    this.children,
    this.force = false,
  }) : super(key: key);

  @override
  State<DxPageView> createState() => _DxPageViewState();
}

class _DxPageViewState extends State<DxPageView> with TickerProviderStateMixin {
  late PageController pageController;

  @override
  void initState() {
    if (widget.dxShellController._containsNullWidget &&
        widget.children == null) {
      throw ('Make sure the node widgets aren\'t null when attaching the controller to the shell');
    }

    if (widget.children != null || widget.force) {
      assert(
          widget.dxShellController._nodeNames.length == widget.children!.length,
          'Number of DxNodes provided during the initilization of the contoller doesn\'t match the children');

      widget.dxShellController._addNodeWidgets(widget.children!);
    }

    pageController = PageController(
      initialPage: widget.dxShellController.currIndex,
    );

    widget.dxShellController._setPageViewController(pageController);

    if (widget.physics is! NeverScrollableScrollPhysics) {
      pageController.addListener(_scrollChangeListener);
    }

    super.initState();
  }

  @override
  void dispose() {
    if (widget.physics is! NeverScrollableScrollPhysics) {
      pageController.removeListener(_scrollChangeListener);
    }

    pageController.dispose();
    super.dispose();
  }

  void _scrollChangeListener() {
    widget.dxShellController.animateToNode(pageController.page!.toInt());
  }

  @override
  Widget build(BuildContext context) {
    if (widget.force && widget.children != null) {
      widget.dxShellController._addNodeWidgets(widget.children!);
    }
    return PageView(
      controller: pageController,
      physics: widget.physics,
      dragStartBehavior: widget.dragStartBehavior,
      onPageChanged: (value) {},
      clipBehavior: widget.clipBehavior,
      children: List<Widget>.from(widget.dxShellController._nodeWidgets!),
    );
  }
}
