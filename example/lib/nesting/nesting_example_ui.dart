import 'package:dx_shell/dx_shell.dart';
import 'package:flutter/material.dart';

class NestingExample extends StatefulWidget {
  final String? navOption;
  final String? subNavOption;
  const NestingExample({
    super.key,
    required this.navOption,
    required this.subNavOption,
  });

  @override
  State<NestingExample> createState() => _NestingExampleState();
}

class _NestingExampleState extends State<NestingExample> {
  late DxShellController _navMenuController;

  @override
  void initState() {
    _navMenuController = DxShellController(
      activeNode: widget.navOption,
      isRootShell: true,
      nodes: [
        DxNode(name: 'nav-option-1'),
        DxNode(name: 'nav-option-2'),
        DxNode(name: 'nav-option-3'),
      ],
    );

    super.initState();
  }

  final List<GlobalKey> _keys = [GlobalKey(), GlobalKey(), GlobalKey()];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nesting UI example',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            Container(
              height: size.height,
              width: size.width * 0.2,
              color: Colors.grey,
              child: DxShellObserver(
                dxShellController: _navMenuController,
                builder: (context, selectedIndex) {
                  return Column(
                    children: List.generate(
                      3,
                      (index) => _navOption(index, selectedIndex),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: size.width * 0.2,
              child: Container(
                height: size.height,
                width: size.width * 0.8,
                color: Colors.white,
                child: DxPageView(
                  dxShellController: _navMenuController,
                  children: [
                    ...List.generate(
                      3,
                      (index) => SubNavMenu(
                        subNavSelectedOption:
                            index == _navMenuController.currIndex
                                ? widget.subNavOption
                                : null,
                        key: _keys[index],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navOption(int index, int selectedIndex) {
    bool isActive = index == selectedIndex;
    return Expanded(
      child: InkWell(
        onTap: () {
          _navMenuController.animateToNode(index);
        },
        child: Container(
          color: isActive ? Colors.primaries[5] : null,
          child: Center(
            child: Text(
              'nav option ${index + 1}',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SubNavMenu extends StatefulWidget {
  final String? subNavSelectedOption;
  const SubNavMenu({
    super.key,
    required this.subNavSelectedOption,
  });

  @override
  State<SubNavMenu> createState() => _SubNavMenuState();
}

class _SubNavMenuState extends State<SubNavMenu>
    with AutomaticKeepAliveClientMixin {
  late DxShellController _subNavController;

  @override
  void initState() {
    _subNavController = DxShellController(
      activeNode: widget.subNavSelectedOption,
      nodes: [
        DxNode(name: 'sub-nav-option-1'),
        DxNode(name: 'sub-nav-option-2'),
        DxNode(name: 'sub-nav-option-3'),
        DxNode(name: 'sub-nav-option-4'),
      ],
      autoFixBrokenURL: true,
      useSmartFix: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Container(
        height: 400,
        width: 400,
        color: Colors.red,
        child: Stack(
          alignment: Alignment.center,
          children: [
            DxShellObserver(
              dxShellController: _subNavController,
              builder: (context, selectedIndex) {
                return Wrap(
                  children: List.generate(
                    4,
                    (index) => _sqaureFrameElement(index, selectedIndex),
                  ),
                );
              },
            ),
            Container(
              height: 200,
              width: 200,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sqaureFrameElement(int index, int selectedIndex,
      {bool isCenter = false}) {
    bool isActive = index == selectedIndex;
    return InkWell(
      onTap: () {
        _subNavController.animateToNode(index);
      },
      child: Container(
        height: 200,
        width: 200,
        color: isCenter
            ? Colors.white
            : greyOutColor(
                Colors.primaries[index],
                isActive ? 0 : 0.8,
              ),
      ),
    );
  }

  Color greyOutColor(Color color, double greyFactor) {
    double greyOverlayOpacity = greyFactor;
    // Adjust the opacity as needed

    // Calculate the greyed-out color by applying the grey overlay
    Color greyColor = Colors.grey.withOpacity(greyOverlayOpacity);
    return Color.alphaBlend(greyColor, color);
  }

  @override
  bool get wantKeepAlive => true;
}
