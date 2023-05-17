part of dx_shell;

class DxShellController extends ChangeNotifier {
  /// set this to true if this contoller will be used on a shell
  /// which might have nested shells. This will indicate which part of
  /// the url path must be updated. when the value of this is set to true
  /// the code performs a O(N) lookup for the related path and then updates it
  /// and when the same value is set to false, the code automatically considers the
  /// last path of the URL to be related with the current shell and updates it in O(1) time
  /// By default the value of this is set to false
  late bool isRootShell;

  /// [DxNode] accepts a name and a widget
  /// the name that will be provided here will be used to update
  /// the path in the browser URL.
  ///
  /// If this controller will only be attached [DxShellObserver] there will be
  /// no need to provide a widget related to the name as well,
  /// But in case the controller will be attached to [DxShell] make sure to provide the
  /// widgets as well.
  late List<DxNode> nodes;

  // _nodeWidgets & _nodeNames are seprated from the DxNode array for further code requirements
  List<Widget?>? _nodeWidgets;
  final Set<String> _nodeNames = {};

  /// the name of the current active node that might be received from the browser URL
  /// when the app is launched
  String? activeNode;
  TabController? _tabController;
  PageController? _pageController;

  int currIndex = -1;

  /// Fixes the broken paths of the URL
  ///
  /// whenever the [DxShellController] is initialized with an incoming activeNode
  /// if the activeNode is not present in the list of [DxNode] names, then by default
  /// the first node name is selected and the required URL fix will be added to the Queue
  ///
  /// To fix all the broken URLs present in the queue use :
  /// ``` dart
  /// RouteHandler().fixUrl();
  /// ```
  /// The above line will automatically fix all the broken paths and will update the state of the
  /// browser URL without reloading the page
  bool autoFixBrokenURL;

  /// By default when the [autoFixBrokenURL] is enabled the path will be fixed to the first node present in
  /// the list of defined [DxNode]. In order to Auto correct the activeNode and update the state accordingly
  /// set this boolean to true
  bool useSmartFix;

  /// The position of the path related to this controller
  ///
  /// ``` dart
  ///  String browserURL = 'https://example.come/option-1/sub-option-1';
  /// ```
  ///  here in the above URL, the pathPosition of option-1 is 1 and sub-option-1 is 2
  ///
  /// For a root shell to lookup and update the path it takes O(N) time,
  final int? pathPosition;
  late TrieEngine? trieEngine;
  bool _containsNullWidget = false;

  DxShellController({
    required this.nodes,
    this.activeNode,
    this.isRootShell = false,
    this.autoFixBrokenURL = false,
    this.useSmartFix = false,
    this.pathPosition,
  }) {
    _initialize();
  }

  void _setTabController(TabController tabController) =>
      _tabController = tabController;

  void _setPageViewController(PageController pageController) =>
      _pageController = pageController;

  void _initialize() {
    if (nodes.length < 2) throw 'Length should be greater or equal to 2';
    _separateNodeData();
    int idx = 0;
    List<String> arr = _nodeNames.toList();
    if (activeNode != null) {
      if (arr.contains(activeNode)) {
        idx = arr.indexOf(activeNode!);
      } else {
        if (autoFixBrokenURL) {
          idx = _fixURLAndGetIndex(arr);
        }
      }
    }
    currIndex = idx;
    notifyListeners();
  }

  int _fixURLAndGetIndex(List<String> arr) {
    if (!useSmartFix) {
      RouteHandler().addURLFixToQue(activeNode!, _nodeNames.elementAt(0));
      return 0;
    }

    trieEngine = TrieEngine(src: arr);
    String? fixedNode = trieEngine?.autoCorrect(activeNode!);
    RouteHandler().addURLFixToQue(
      activeNode!,
      fixedNode ?? _nodeNames.elementAt(0),
    );

    return fixedNode == null ? 0 : arr.indexOf(fixedNode);
  }

  void animateToNode(
    int index, {
    Duration? duration,
    Curve curve = Curves.ease,
  }) {
    _switchTab(index);
    _tabController?.animateTo(currIndex);
    _pageController?.jumpToPage(currIndex);
  }

  void _switchTab(int index) {
    if (currIndex == index || !_isIndexValid(index, _nodeNames)) return;
    currIndex = index;
    notifyListeners();
    _changeUrlBasedOnState();
  }

  void _changeUrlBasedOnState() {
    if (isRootShell) {
      RouteHandler().switchTabs(currIndex, _nodeNames, pathPosition);
      return;
    }

    RouteHandler().switchTabsLast(currIndex, _nodeNames);
  }

  void _separateNodeData() {
    for (int idx = 0; idx < nodes.length; idx++) {
      if (nodes[idx].widget == null) {
        _containsNullWidget = true;
      }
      _nodeNames.add(nodes[idx].name);
      _nodeWidgets?.add(nodes[idx].widget);
    }
  }

  void _addNodeWidgets(List<Widget> nodeWidgets) {
    if (!_containsNullWidget) {
      _nodeWidgets?.clear();
    }

    _nodeWidgets = nodeWidgets;
  }

  bool _isIndexValid(int idx, Set<String> arr) =>
      (idx >= 0 && idx < arr.length);
}
