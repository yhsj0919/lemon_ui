import 'package:flutter/widgets.dart';

// The image viewport keeps at least half of a bounded workspace. Toolbars can
// reflow with system text scaling and scroll within the remaining height.
class HyperImageWorkspaceLayout extends StatelessWidget {
  const HyperImageWorkspaceLayout({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      assert(
        constraints.hasBoundedHeight,
        'Image workspaces require a bounded height.',
      );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          children.first,
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight / 2),
            child: SingleChildScrollView(
              primary: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: children.skip(1).toList(),
              ),
            ),
          ),
        ],
      );
    },
  );
}
