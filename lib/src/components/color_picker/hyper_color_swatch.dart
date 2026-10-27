import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';

/// Internal filled color sample; unlike an icon, its center displays the color.
class HyperColorSwatch extends StatelessWidget {
  const HyperColorSwatch({super.key, required this.color, this.circle = false});

  final Color color;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    final size =
        IconTheme.of(context).size ??
        HyperTheme.sizesOf(context).iconButton.iconSize;
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: circle ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }
}
