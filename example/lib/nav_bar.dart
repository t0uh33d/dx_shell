import 'package:dx_shell/dx_shell.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  final DxShellController dxShellController;
  const NavBar({super.key, required this.dxShellController});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DxShellObserver(
      dxShellController: widget.dxShellController,
      builder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _barOption(selectedIndex: index, index: 0, title: 'option-1'),
            _barOption(selectedIndex: index, index: 1, title: 'option-2'),
            _barOption(selectedIndex: index, index: 2, title: 'option-3'),
          ],
        );
      },
    );
  }

  Widget _barOption({
    required int selectedIndex,
    required int index,
    required String title,
  }) {
    return InkWell(
      onTap: () => widget.dxShellController.animateToNode(index),
      child: Container(
        height: 100,
        width: 200,
        color: index == selectedIndex ? Colors.deepPurple : null,
        child: Text(
          title,
          style: TextStyle(
              color: index == selectedIndex ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
