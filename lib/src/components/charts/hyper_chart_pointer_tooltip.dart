import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../card/hyper_card.dart';
import '../card/hyper_card_style.dart';
import '../menu/hyper_menu_surface.dart';
import '../overlay/hyper_backdrop_safe_opacity.dart';
import 'hyper_chart_theme.dart';

typedef HyperPointerTooltipStyle = HyperCardStyle;
typedef HyperPointerTooltipBuilder = Widget Function(
  BuildContext context,
  String message,
);

/// 指针位置以绘图区局部坐标传入，进出场复用公共安全材质过渡。
class HyperPointerTooltipArea extends StatefulWidget {
  const HyperPointerTooltipArea({
    super.key,
    required this.child,
    required this.position,
    required this.message,
    required this.onExit,
    this.style,
    this.builder,
  });
  final Widget child;
  final Offset? position;
  final String? message;
  final VoidCallback onExit;
  final HyperCardStyle? style;
  final HyperPointerTooltipBuilder? builder;

  @override
  State<HyperPointerTooltipArea> createState() =>
      _HyperPointerTooltipAreaState();
}

class _HyperPointerTooltipAreaState extends State<HyperPointerTooltipArea> {
  Offset? _retainedPosition;
  Widget? _content;
  bool _shown = false;
  bool get _visible => widget.position != null && widget.message != null;
  @override
  void initState() {
    super.initState();
    if (_visible) {
      _show();
    }
  }

  void _show() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _visible) {
        setState(() => _shown = true);
      }
    });
  }

  @override
  void didUpdateWidget(HyperPointerTooltipArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_visible) {
      _shown = false;
    } else if (oldWidget.position == null || oldWidget.message == null) {
      _shown = false;
      _show();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_visible) {
      _retainedPosition = widget.position;
      _content =
          widget.builder?.call(context, widget.message!) ??
          Text(widget.message!);
    }
    final sizes = HyperTheme.sizesOf(context);
    final surface = resolveHyperMenuSurface(
      context,
      radius: sizes.menu.itemRadius,
      padding: EdgeInsets.all(sizes.menu.padding),
      style:
          HyperChartTheme.of(context).style.tooltipStyle?.merge(widget.style) ??
          widget.style,
    );
    return MouseRegion(
      onExit: (_) => widget.onExit(),
      child: Stack(
        children: [
          Positioned.fill(child: widget.child),
          if (_retainedPosition != null && _content != null)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomSingleChildLayout(
                  delegate: _PointerLayout(
                    _retainedPosition!,
                    sizes.overlaySpacing,
                  ),
                  child: HyperBackdropSafeAnimatedOpacity(
                    opacity: _shown ? 1 : 0,
                    duration:
                        MediaQuery.maybeOf(context)?.disableAnimations == true
                        ? Duration.zero
                        : HyperTheme.of(context).motion.fastDuration,
                    curve: HyperTheme.of(context).motion.standardCurve,
                    onEnd: () {
                      if (mounted && !_visible) {
                        setState(() {
                          _content = null;
                          _retainedPosition = null;
                        });
                      }
                    },
                    child: HyperCard(
                      style: surface,
                      child: DefaultTextStyle(
                        style:
                            HyperTheme.of(context).textTheme.bodySmall ??
                            const TextStyle(),
                        child: _content!,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PointerLayout extends SingleChildLayoutDelegate {
  _PointerLayout(this.position, this.gap);
  final Offset position;
  final double gap;
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();
  @override
  Offset getPositionForChild(Size size, Size childSize) {
    var x = position.dx + gap;
    var y = position.dy + gap;
    if (x + childSize.width > size.width) {
      x = position.dx - gap - childSize.width;
    }
    if (y + childSize.height > size.height) {
      y = position.dy - gap - childSize.height;
    }
    return Offset(
      x.clamp(0.0, (size.width - childSize.width).clamp(0.0, size.width)),
      y.clamp(0.0, (size.height - childSize.height).clamp(0.0, size.height)),
    );
  }

  @override
  bool shouldRelayout(_PointerLayout oldDelegate) =>
      oldDelegate.position != position || oldDelegate.gap != gap;
}
