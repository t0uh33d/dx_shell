import 'package:dx_shell/dx_shell.dart';
import 'package:example/nav_bar.dart';
import 'package:example/options/option1.dart';
import 'package:flutter/material.dart';

import 'options/option2.dart';
import 'options/option3.dart';

class NavMenu extends StatefulWidget {
  final String? selectedOption;
  const NavMenu({super.key, required this.selectedOption});

  @override
  State<NavMenu> createState() => _NavMenuState();
}

class _NavMenuState extends State<NavMenu> {
  late DxShellController dxShellController;
  @override
  void initState() {
    List<DxNode> nodes = [
      DxNode(name: 'option-1', widget: const Option1()),
      DxNode(name: 'option-2', widget: const Option2()),
      DxNode(name: 'option-3', widget: const Option3()),
    ];
    dxShellController = DxShellController(
      nodes: nodes,
      activeNode: widget.selectedOption,
      autoFixBrokenURL: true,
      useSmartFix: true,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RouteHandler().fixUrl();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DxShell Example'),
      ),
      bottomNavigationBar: NavBar(dxShellController: dxShellController),
      body: DxShell(
        dxShellController: dxShellController,
      ),
    );
  }
}
