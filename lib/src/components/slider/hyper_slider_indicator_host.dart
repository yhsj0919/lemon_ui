import '../../theme/material/hyper_material_theme.dart';
import '../../foundation/hyper_fill.dart';
import '../card/hyper_card_style.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../theme/core/hyper_theme.dart';
import '../card/hyper_card.dart';
import '../menu/hyper_menu_surface.dart';
import 'hyper_slider_style.dart';
import 'hyper_slider_value_indicator_shapes.dart';

class HyperSliderIndicatorHost extends StatefulWidget {
  const HyperSliderIndicatorHost({
    super.key,
    required this.style,
    required this.builder,
  });
  final HyperSliderStyle style;
  final Widget Function(HyperSliderLabelCallback callback) builder;
  @override
  State<HyperSliderIndicatorHost> createState() => _IndicatorHostState();
}

class _IndicatorHostState extends State<HyperSliderIndicatorHost> {
  final _portal = OverlayPortalController();
  final _labels = <Thumb?, (RenderBox, Offset, InlineSpan, TextDirection)>{};
  bool _queued = false, _pressed = false;
  void _label(
    RenderBox parent,
    Offset center,
    TextPainter painter,
    Thumb? thumb,
  ) {
    final next = (parent, center, painter.text!, painter.textDirection!);
    if (_labels[thumb] == next && _portal.isShowing) return;
    _labels[thumb] = next;
    if (_queued) return;
    _queued = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _queued = false;
      if (!mounted) return;
      final mode = widget.style.showValueIndicator ?? ShowValueIndicator.never;
      if (mode == ShowValueIndicator.alwaysVisible || _pressed) {
        if (!_portal.isShowing) _portal.show();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) => Listener(
    onPointerDown: (_) => _pressed = true,
    onPointerUp: (_) => _end(),
    onPointerCancel: (_) => _end(),
    child: OverlayPortal.overlayChildLayoutBuilder(
      controller: _portal,
      overlayChildBuilder: (overlayContext, layoutInfo) {
        final metrics = HyperTheme.sizesOf(context);
        final style = widget.style;
        final surface = resolveHyperMenuSurface(
          context,
          radius: metrics.menu.itemRadius,
          padding: EdgeInsets.symmetric(
            horizontal: metrics.menu.padding,
            vertical: metrics.menu.padding / 2,
          ),
          style: HyperCardStyle(
            material: HyperMaterialTheme.of(context).material,
            background: HyperFill.color(
              style.valueIndicatorColor ??
                  HyperTheme.of(context).colors.primary,
            ),
          ).merge(style.valueIndicatorSurface),
        );
        final padding = surface.padding!.resolve(Directionality.of(context));
        return IgnorePointer(
          child: Stack(
            children: [
              for (final entry in _labels.values)
                Builder(
                  builder: (_) {
                    final painter = TextPainter(
                      text: entry.$3,
                      textDirection: entry.$4,
                      textScaler: MediaQuery.textScalerOf(context),
                    )..layout();
                    final size = Size(
                      painter.width + padding.horizontal,
                      painter.height + padding.vertical,
                    );
                    painter.dispose();
                    final overlay =
                        Overlay.of(context).context.findRenderObject()!
                            as RenderBox;
                    final parent = entry.$1;
                    if (!parent.attached) return const SizedBox.shrink();
                    final globalAnchor = parent.localToGlobal(entry.$2);
                    // Overlay content escapes ancestor clips; explicitly hide a
                    // label when its thumb is outside any ancestor paint clip.
                    RenderObject child = parent;
                    for (
                      RenderObject? ancestor = child.parent;
                      ancestor != null;
                      child = ancestor, ancestor = ancestor.parent
                    ) {
                      final clip = ancestor.describeApproximatePaintClip(child);
                      if (clip != null) {
                        final localAnchor = MatrixUtils.transformPoint(
                          Matrix4.inverted(ancestor.getTransformTo(null)),
                          globalAnchor,
                        );
                        if (!clip.contains(localAnchor)) {
                          return const SizedBox.shrink();
                        }
                      }
                    }
                    final anchor = overlay.globalToLocal(globalAnchor);
                    final width = overlay.size.width;
                    final left = (anchor.dx - size.width / 2).clamp(
                      0.0,
                      (width - size.width).clamp(0.0, double.infinity),
                    );
                    return Positioned(
                      left: left,
                      top:
                          (anchor.dy -
                                  size.height -
                                  (style.thumbHeight ??
                                          metrics.slider.thumbHeight ??
                                          metrics.slider.thumbRadius * 2) /
                                      2 -
                                  (style.valueIndicatorGap ??
                                      metrics.menu.descriptionGap))
                              .clamp(0.0, double.infinity),
                      child: ExcludeSemantics(
                        child: HyperCard(
                          style: surface,
                          child: RichText(
                            text: entry.$3,
                            textDirection: entry.$4,
                            textScaler: MediaQuery.textScalerOf(context),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
      child: widget.builder(_label),
    ),
  );
  void _end() {
    _pressed = false;
    if (widget.style.showValueIndicator != ShowValueIndicator.alwaysVisible &&
        _portal.isShowing) {
      _portal.hide();
    }
  }
}
