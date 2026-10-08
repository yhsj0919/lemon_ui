import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../theme/core/hyper_theme.dart';
import '../../theme/material/hyper_material_theme.dart';
import '../button/hyper_button.dart';
import '../button/hyper_button_theme.dart';
import '../progress/hyper_circular_progress.dart';
import '../surface/hyper_material_surface.dart';
import 'hyper_loading_overlay_style.dart';
import 'hyper_loading_overlay_theme.dart';
import 'hyper_loading_visibility.dart';

/// 加载遮罩只覆盖 child 的区域；包裹页面正文即可用于整页加载。
class HyperLoadingOverlay extends StatefulWidget {
  const HyperLoadingOverlay({
    super.key,
    required this.loading,
    required this.child,
    this.blockInteraction = true,
    this.indicator,
    this.message,
    this.onCancel,
    this.cancelLabel,
    this.semanticLabel,
    this.style,
  });
  final bool loading;
  final Widget child;
  final bool blockInteraction;
  final Widget? indicator, message, cancelLabel;
  final VoidCallback? onCancel;
  final String? semanticLabel;
  final HyperLoadingOverlayStyle? style;
  @override
  State<HyperLoadingOverlay> createState() => _HyperLoadingOverlayState();
}

class _HyperLoadingOverlayState extends State<HyperLoadingOverlay> {
  final _visibility = HyperLoadingVisibility();
  late HyperLoadingOverlayStyle _style;
  @override
  void initState() {
    super.initState();
    _visibility.addListener(_changed);
  }

  void _changed() => setState(() {});
  void _sync() {
    final theme = HyperTheme.of(context);
    final metrics = HyperTheme.sizesOf(context).loadingOverlay;
    final material = HyperMaterialTheme.of(context);
    _style = HyperLoadingOverlayStyle(
      background: HyperFill.color(theme.colors.surface.withValues(alpha: .8)),
      material: material.material,
      materialQuality: material.quality,
      reduceTransparency: material.reduceTransparency,
      borderRadius: BorderRadius.zero,
      contentBackground: const HyperFill.none(),
      contentBorderRadius: BorderRadius.circular(metrics.radius),
      padding: metrics.padding,
      maxContentWidth: metrics.maxContentWidth,
      spacing: metrics.spacing,
      textStyle: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
        color: theme.colors.textPrimary,
      ),
      alignment: Alignment.center,
      showDelay: theme.motion.fastDuration,
      minimumVisibleDuration: theme.motion.standardDuration,
      duration: theme.motion.fastDuration,
      curve: theme.motion.fastCurve,
    ).merge(HyperLoadingOverlayTheme.of(context).style).merge(widget.style);
    _visibility.update(
      loading: widget.loading,
      showDelay: _style.showDelay!,
      minimumVisibleDuration: _style.minimumVisibleDuration!,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(HyperLoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  @override
  Widget build(BuildContext context) {
    final duration = (MediaQuery.maybeOf(context)?.disableAnimations ?? false)
        ? Duration.zero
        : _style.duration!;
    final label = widget.semanticLabel ?? '正在加载';
    Widget? cancel = widget.onCancel == null
        ? null
        : HyperButton.text(
            label:
                widget.cancelLabel ??
                Text(
                  Localizations.of<MaterialLocalizations>(
                        context,
                        MaterialLocalizations,
                      )?.cancelButtonLabel ??
                      '取消',
                ),
            onPressed: widget.loading ? widget.onCancel : null,
          );
    if (cancel != null && _style.buttonTheme != null) {
      cancel = HyperButtonTheme(data: _style.buttonTheme!, child: cancel);
    }
    final panel = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: _style.maxContentWidth!),
      child: Container(
        padding: _style.padding,
        decoration: BoxDecoration(
          color: _style.contentBackground?.color,
          gradient: _style.contentBackground?.gradient,
          border: _style.contentBorder,
          borderRadius: _style.contentBorderRadius,
          boxShadow: _style.boxShadow,
        ),
        child: DefaultTextStyle(
          style: _style.textStyle!,
          textAlign: TextAlign.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.indicator ??
                  HyperCircularProgress(
                    style: _style.progressStyle,
                    excludeSemantics: true,
                  ),
              if (widget.message != null) ...[
                SizedBox(height: _style.spacing),
                widget.message!,
              ],
              if (cancel != null) ...[SizedBox(height: _style.spacing), cancel],
            ],
          ),
        ),
      ),
    );
    final background = _style.material == null
        ? DecoratedBox(
            decoration: BoxDecoration(
              color: _style.background?.color,
              gradient: _style.background?.gradient,
            ),
          )
        : HyperMaterialSurface(
            material: _style.material,
            quality: _style.materialQuality,
            reduceTransparency: _style.reduceTransparency,
            borderRadius: _style.borderRadius,
            clipBehavior: Clip.antiAlias,
          );
    final overlay = ClipRRect(
      borderRadius: _style.borderRadius!,
      child: Stack(
        children: [
          Positioned.fill(child: IgnorePointer(child: background)),
          Positioned.fill(
            child: Align(
              alignment: _style.alignment!,
              child: SingleChildScrollView(child: panel),
            ),
          ),
        ],
      ),
    );
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: _visibility.visible ? 1 : 0),
      duration: duration,
      curve: _style.curve!,
      child: overlay,
      builder: (context, value, child) {
        final blocking =
            widget.blockInteraction &&
            (widget.loading || _visibility.visible || value > 0);
        return Stack(
          fit: StackFit.passthrough,
          children: [
            AbsorbPointer(
              absorbing: blocking,
              child: ExcludeFocus(
                excluding: blocking,
                child: ExcludeSemantics(
                  excluding: blocking,
                  child: widget.child,
                ),
              ),
            ),
            if (value > 0)
              Positioned.fill(
                child: IgnorePointer(
                  ignoring:
                      !_visibility.visible ||
                      !widget.loading ||
                      widget.onCancel == null,
                  child: ExcludeFocus(
                    excluding: !_visibility.visible || !widget.loading,
                    child: ExcludeSemantics(
                      excluding: !_visibility.visible,
                      child: Semantics(
                        liveRegion: true,
                        label: label,
                        child:
                            _style.transitionBuilder?.call(
                              context,
                              value,
                              child!,
                            ) ??
                            Opacity(opacity: value.clamp(0, 1), child: child),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _visibility.removeListener(_changed);
    _visibility.dispose();
    super.dispose();
  }
}
