import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_control_state.dart';
import '../../foundation/hyper_device_type.dart';
import '../../foundation/hyper_surface_material.dart';
import '../../interaction/hyper_pressable.dart';
import '../../theme/hyper_material_theme.dart';
import '../../theme/hyper_contrast_theme.dart';
import '../../theme/hyper_theme.dart';
import 'hyper_button_style.dart';
import 'hyper_button_theme.dart';

enum HyperButtonIconAlignment { start, end }

/// 支持同步和异步操作的 Hyper 按钮。
class HyperButton extends StatefulWidget {
  const HyperButton.filled({
    super.key,
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    this.iconAlignment = HyperButtonIconAlignment.start,
    this.style,
    this.loading = false,
    this.progress,
    this.onError,
    this.autofocus = false,
  }) : variant = HyperButtonVariant.filled,
       assert((child == null) != (label == null)),
       assert(icon == null || label != null);

  const HyperButton.tonal({
    super.key,
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    this.iconAlignment = HyperButtonIconAlignment.start,
    this.style,
    this.loading = false,
    this.progress,
    this.onError,
    this.autofocus = false,
  }) : variant = HyperButtonVariant.tonal,
       assert((child == null) != (label == null)),
       assert(icon == null || label != null);

  const HyperButton.outlined({
    super.key,
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    this.iconAlignment = HyperButtonIconAlignment.start,
    this.style,
    this.loading = false,
    this.progress,
    this.onError,
    this.autofocus = false,
  }) : variant = HyperButtonVariant.outlined,
       assert((child == null) != (label == null)),
       assert(icon == null || label != null);

  const HyperButton.ghost({
    super.key,
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    this.iconAlignment = HyperButtonIconAlignment.start,
    this.style,
    this.loading = false,
    this.progress,
    this.onError,
    this.autofocus = false,
  }) : variant = HyperButtonVariant.ghost,
       assert((child == null) != (label == null)),
       assert(icon == null || label != null);

  const HyperButton.text({
    super.key,
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    this.iconAlignment = HyperButtonIconAlignment.start,
    this.style,
    this.loading = false,
    this.progress,
    this.onError,
    this.autofocus = false,
  }) : variant = HyperButtonVariant.text,
       assert((child == null) != (label == null)),
       assert(icon == null || label != null);

  const HyperButton.gradient({
    super.key,
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    this.iconAlignment = HyperButtonIconAlignment.start,
    this.style,
    this.loading = false,
    this.progress,
    this.onError,
    this.autofocus = false,
  }) : variant = HyperButtonVariant.gradient,
       assert((child == null) != (label == null)),
       assert(icon == null || label != null);

  /// 当前按钮变体，由命名构造器确定。
  final HyperButtonVariant variant;

  /// 点击操作；返回 [Future] 时按钮自动进入加载状态，null 表示禁用。
  final FutureOr<void> Function()? onPressed;

  /// 完整自定义内容；与 [label] 二选一。
  final Widget? child;

  /// 带图标按钮的文字内容；与 [child] 二选一。
  final Widget? label;

  /// 显示在 [label] 前方或后方的图标。
  final Widget? icon;

  /// 图标相对 [label] 的排列位置。
  final HyperButtonIconAlignment iconAlignment;

  /// 当前实例的样式覆盖，优先级高于按钮主题。
  final HyperButtonStyle? style;

  /// 外部控制的加载状态。
  final bool loading;

  /// 确定进度，取值范围为 0 到 1；null 表示不确定进度。
  final double? progress;

  /// 同步或异步操作失败时的错误回调。
  final void Function(Object error, StackTrace stackTrace)? onError;

  /// 首次显示时是否自动获取键盘焦点。
  final bool autofocus;

  @override
  State<HyperButton> createState() => _HyperButtonState();
}

class _HyperButtonState extends State<HyperButton> {
  bool _running = false;

  bool get _loading => widget.loading || _running;

  Future<void> _invoke() async {
    if (_loading || widget.onPressed == null) return;
    try {
      final result = widget.onPressed!();
      if (result is Future<void>) {
        setState(() => _running = true);
        await result;
      }
    } catch (error, stackTrace) {
      if (widget.onError case final callback?) {
        callback(error, stackTrace);
      } else {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'lemon_ui',
            context: ErrorDescription('执行 HyperButton.onPressed 时'),
          ),
        );
      }
    } finally {
      if (mounted && _running) setState(() => _running = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final colors = theme.colors;
    final metrics = switch (theme.sizes.deviceType) {
      HyperDeviceType.phone => (
        minimumSize: const Size(58, 40),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        radius: 16.0,
        fontSize: 16.0,
        iconSize: 24.0,
        iconSpacing: 8.0,
        progressSize: 18.0,
      ),
      HyperDeviceType.tablet => (
        minimumSize: const Size(64, 44),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        radius: 16.0,
        fontSize: 16.0,
        iconSize: 24.0,
        iconSpacing: 8.0,
        progressSize: 18.0,
      ),
      HyperDeviceType.desktop => (
        minimumSize: const Size(52, 36),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        radius: 10.0,
        fontSize: 14.0,
        iconSize: 18.0,
        iconSpacing: 6.0,
        progressSize: 16.0,
      ),
      HyperDeviceType.watch => (
        minimumSize: const Size(52, 40),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        radius: 20.0,
        fontSize: 16.0,
        iconSize: 20.0,
        iconSpacing: 6.0,
        progressSize: 18.0,
      ),
    };
    final defaults = HyperButtonStyle(
      height: metrics.minimumSize.height,
      minimumSize: metrics.minimumSize,
      minimumTapTargetSize: Size.square(
        theme.sizes.minimumInteractiveDimension,
      ),
      padding: metrics.padding,
      borderRadius: BorderRadius.circular(metrics.radius),
      textStyle: TextStyle(fontSize: metrics.fontSize),
      disabledForegroundColor: colors.disabled,
      iconSize: metrics.iconSize,
      iconSpacing: metrics.iconSpacing,
      animationDuration: theme.motion.fastDuration,
      animationCurve: theme.motion.fastCurve,
      progressSize: metrics.progressSize,
      progressThickness: 2,
      hoverOverlayOpacity: theme.sizes.deviceType == HyperDeviceType.desktop
          ? .05
          : .06,
      focusOverlayOpacity: theme.sizes.deviceType == HyperDeviceType.desktop
          ? .07
          : .08,
      pressOverlayOpacity: theme.sizes.deviceType == HyperDeviceType.desktop
          ? .08
          : .10,
    ).merge(_variantDefaults(context));
    final style = defaults
        .merge(HyperButtonTheme.of(context).resolve(widget.variant))
        .merge(widget.style);
    final enabled = widget.onPressed != null && !_loading;

    return HyperPressable(
      enabled: enabled,
      autofocus: widget.autofocus,
      onTap: enabled ? _invoke : null,
      semanticButton: true,
      builder: (context, states, _) {
        final pressed = states.contains(HyperControlState.pressed);
        final hovered = states.contains(HyperControlState.hovered);
        final focused = states.contains(HyperControlState.focused);
        final overlay = style.overlayColor ?? colors.stateLayer;
        final overlayAlpha = switch ((pressed, focused, hovered)) {
          (true, _, _) => style.pressOverlayOpacity!,
          (_, true, _) => style.focusOverlayOpacity!,
          (_, _, true) => style.hoverOverlayOpacity!,
          _ => 0.0,
        };
        final baseForeground = enabled
            ? style.foregroundColor ?? colors.onSurface
            : style.disabledForegroundColor ?? colors.disabled;
        final foregroundColor = HyperContrastTheme.of(context).resolve(
          foreground: baseForeground,
          background: enabled
              ? style.material?.background ?? style.background
              : style.disabledBackground ??
                    style.material?.background ??
                    style.background,
          canvasColor: colors.background,
          mode: style.contrastMode,
        );
        final content = _buildContent(style, foregroundColor);
        final visual = _buildVisual(
          context,
          style,
          content,
          overlay.withValues(alpha: overlayAlpha),
          enabled,
        );
        final tapSize = style.minimumTapTargetSize;
        if (tapSize == null) return visual;
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: tapSize.width,
            minHeight: tapSize.height,
          ),
          child: Center(widthFactor: 1, heightFactor: 1, child: visual),
        );
      },
    );
  }

  HyperButtonStyle _variantDefaults(BuildContext context) {
    final colors = HyperTheme.of(context).colors;
    return switch (widget.variant) {
      HyperButtonVariant.filled => HyperButtonStyle(
        background: HyperFill.color(colors.primary),
        disabledBackground: HyperFill.color(
          colors.primary.withValues(alpha: .35),
        ),
        foregroundColor: colors.onPrimary,
      ),
      HyperButtonVariant.tonal => HyperButtonStyle(
        background: HyperFill.color(colors.surface),
        disabledBackground: HyperFill.color(colors.surfaceMuted),
        foregroundColor: colors.onSurface,
      ),
      HyperButtonVariant.outlined => HyperButtonStyle(
        background: const HyperFill.none(),
        disabledBackground: const HyperFill.none(),
        foregroundColor: colors.primary,
        border: BorderSide(color: colors.outline),
      ),
      HyperButtonVariant.ghost => HyperButtonStyle(
        background: const HyperFill.none(),
        disabledBackground: const HyperFill.none(),
        foregroundColor: colors.onSurface,
      ),
      HyperButtonVariant.text => HyperButtonStyle(
        background: const HyperFill.none(),
        disabledBackground: const HyperFill.none(),
        foregroundColor: colors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      HyperButtonVariant.gradient => HyperButtonStyle(
        background: HyperFill.gradient(
          LinearGradient(
            colors: [
              colors.primary,
              Color.lerp(colors.primary, colors.error, .45)!,
            ],
          ),
        ),
        disabledBackground: HyperFill.color(
          colors.primary.withValues(alpha: .35),
        ),
        foregroundColor: colors.onPrimary,
      ),
    };
  }

  Widget _buildContent(HyperButtonStyle style, Color foregroundColor) {
    Widget normal = widget.child ?? widget.label!;
    if (widget.icon != null) {
      final icon = IconTheme(
        data: IconThemeData(size: style.iconSize, color: foregroundColor),
        child: widget.icon!,
      );
      final gap = SizedBox(width: style.iconSpacing);
      normal = Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.iconAlignment == HyperButtonIconAlignment.start
            ? [icon, gap, widget.label!]
            : [widget.label!, gap, icon],
      );
    }
    normal = DefaultTextStyle.merge(
      style: (style.textStyle ?? const TextStyle()).copyWith(
        color: foregroundColor,
      ),
      child: normal,
    );
    if (!_loading) return normal;
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(opacity: 0, child: normal),
        SizedBox.square(
          dimension: style.progressSize,
          child: CircularProgressIndicator(
            value: widget.progress?.clamp(0, 1),
            strokeWidth: style.progressThickness ?? 2,
            color: style.progressColor ?? foregroundColor,
            backgroundColor: style.progressTrackColor,
          ),
        ),
      ],
    );
  }

  Widget _buildVisual(
    BuildContext context,
    HyperButtonStyle style,
    Widget content,
    Color overlay,
    bool enabled,
  ) {
    final materialTheme = HyperMaterialTheme.of(context);
    final material = style.material?.resolve(
      quality: materialTheme.quality ?? HyperMaterialQuality.standard,
      reduceTransparency: materialTheme.reduceTransparency ?? false,
    );
    final fill = !enabled && style.disabledBackground != null
        ? style.disabledBackground
        : material?.background ?? style.background;
    final radius = (style.borderRadius ?? BorderRadius.zero).resolve(
      Directionality.of(context),
    );
    final decoration = BoxDecoration(
      color: fill?.color,
      gradient: fill?.gradient,
      borderRadius: radius,
      boxShadow: style.boxShadow ?? material?.boxShadow,
    );
    final border = style.border ?? material?.border;
    final foregroundDecoration =
        overlay.a > 0 || (border != null && border != BorderSide.none)
        ? BoxDecoration(
            color: overlay.a > 0 ? overlay : null,
            border: border == null || border == BorderSide.none
                ? null
                : Border.fromBorderSide(border),
            borderRadius: radius,
          )
        : null;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    Widget result = AnimatedContainer(
      duration: reduceMotion ? Duration.zero : style.animationDuration!,
      curve: style.animationCurve!,
      width: style.width,
      height: style.height,
      constraints: BoxConstraints(
        minWidth: style.minimumSize?.width ?? 0,
        minHeight: style.minimumSize?.height ?? 0,
        maxWidth: style.maximumSize?.width ?? double.infinity,
        maxHeight: style.maximumSize?.height ?? double.infinity,
      ),
      padding: style.padding,
      margin: style.margin,
      alignment: style.alignment ?? Alignment.center,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      child: content,
    );
    if (material?.usesBackdrop ?? false) {
      result = ClipRRect(
        borderRadius: radius,
        clipBehavior: style.clipBehavior ?? Clip.antiAlias,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: material!.blurSigmaX,
            sigmaY: material.blurSigmaY,
          ),
          child: result,
        ),
      );
    }
    return result;
  }
}
