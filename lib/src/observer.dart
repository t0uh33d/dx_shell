part of dx_shell;

typedef DxTabBuilder = Widget Function(BuildContext context, int index);

class DxShellObserver extends StatelessWidget {
  final DxShellController dxShellController;
  final DxTabBuilder builder;
  const DxShellObserver({
    super.key,
    required this.dxShellController,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: dxShellController,
      child: Consumer<DxShellController>(
        builder: (context, value, child) =>
            builder.call(context, value.currIndex),
      ),
    );
  }
}
