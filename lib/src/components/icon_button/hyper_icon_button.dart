import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../foundation/hyper_control_state.dart';
import '../../foundation/hyper_device_type.dart';
import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';
import '../../interaction/hyper_pressable.dart';
import '../../theme/hyper_contrast_theme.dart';
import '../../theme/hyper_material_theme.dart';
import '../../theme/hyper_theme.dart';
import 'hyper_icon_button_style.dart';
import 'hyper_icon_button_theme.dart';

/// 轻量、可异步执行的 Hyper 图标按钮。
class HyperIconButton extends StatefulWidget {
  const HyperIconButton.filled({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.style,
    this.loading = false,
    this.onError,
    this.autofocus = false,
  }) : variant = HyperIconButtonVariant.filled;

  const HyperIconButton.tonal({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.style,
    this.loading = false,
    this.onError,
    this.autofocus = false,
  }) : variant = HyperIconButtonVariant.tonal;

  const HyperIconButton.outlined({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.style,
    this.loading = false,
    this.onError,
    this.autofocus = false,
  }) : variant = HyperIconButtonVariant.outlined;

  const HyperIconButton.ghost({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.style,
    this.loading = false,
    this.onError,
    this.autofocus = false,
  }) : variant = HyperIconButtonVariant.ghost;

  /// 当前图标按钮变体，由命名构造器确定。
  final HyperIconButtonVariant variant;

  /// 按钮显示的图标。
  final Widget icon;

  /// 点击操作；返回 [Future] 时自动显示加载状态，null 表示禁用。
  final FutureOr<void> Function()? onPressed;

  /// 鼠标悬停或长按时显示的提示文字。
  final String? tooltip;

  /// 当前实例的样式覆盖。
  final HyperIconButtonStyle? style;

  /// 外部控制的加载状态。
  final bool loading;

  /// 同步或异步操作失败时的错误回调。
  final void Function(Object error, StackTrace stackTrace)? onError;

  /// 首次显示时是否自动获取键盘焦点。
  final bool autofocus;

  @override
  State<HyperIconButton> createState() => _HyperIconButtonState();
}

class _HyperIconButtonState extends State<HyperIconButton> {
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
            context: ErrorDescription('执行 HyperIconButton.onPressed 时'),
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
        size: 40.0,
        iconSize: 24.0,
        progressSize: 18.0,
        radius: 20.0,
      ),
      HyperDeviceType.tablet => (
        size: 44.0,
        iconSize: 24.0,
        progressSize: 18.0,
        radius: 22.0,
      ),
      HyperDeviceType.desktop => (
        size: 36.0,
        iconSize: 18.0,
        progressSize: 16.0,
        radius: 10.0,
      ),
      HyperDeviceType.watch => (
        size: 40.0,
        iconSize: 20.0,
        progressSize: 18.0,
        radius: 20.0,
      ),
    };
    final defaults = HyperIconButtonStyle(
      size: metrics.size,
      minimumTapTargetSize: theme.sizes.minimumInteractiveDimension,
      iconSize: metrics.iconSize,
      progressSize: metrics.progressSize,
      borderRadius: BorderRadius.circular(metrics.radius),
      progressThickness: 2,
    ).merge(_variantDefaults(context));
    final style = defaults
        .merge(HyperIconButtonTheme.of(context).resolve(widget.variant))
        .merge(widget.style);
    final enabled = widget.onPressed != null && !_loading;

    Widget result = HyperPressable(
      enabled: enabled,
      autofocus: widget.autofocus,
      onTap: enabled ? _invoke : null,
      semanticButton: true,
      builder: (context, states, _) {
        final pressed = states.contains(HyperControlState.pressed);
        final hovered = states.contains(HyperControlState.hovered);
        final overlayAlpha = pressed
            ? .12
            : hovered
            ? .07
            : 0.0;
        final foreground = HyperContrastTheme.of(context).resolve(
          foreground: style.foregroundColor ?? colors.onSurface,
          background: style.material?.background ?? style.background,
          canvasColor: colors.background,
          mode: style.contrastMode,
        );
        final visual = _buildVisual(
          context,
          style,
          foreground,
          (style.overlayColor ?? colors.stateLayer).withValues(
            alpha: overlayAlpha,
          ),
        );
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: style.minimumTapTargetSize ?? 0,
            minHeight: style.minimumTapTargetSize ?? 0,
          ),
          child: Center(widthFactor: 1, heightFactor: 1, child: visual),
        );
      },
    );
    if (widget.tooltip case final message?) {
      result = Tooltip(message: message, child: result);
    }
    return result;
  }

  HyperIconButtonStyle _variantDefaults(BuildContext context) {
    final colors = HyperTheme.of(context).colors;
    return switch (widget.variant) {
      HyperIconButtonVariant.filled => HyperIconButtonStyle(
        background: HyperFill.color(colors.primary),
        foregroundColor: colors.onPrimary,
      ),
      HyperIconButtonVariant.tonal => HyperIconButtonStyle(
        background: HyperFill.color(colors.surfaceMuted),
        foregroundColor: colors.onSurfaceMuted,
      ),
      HyperIconButtonVariant.outlined => HyperIconButtonStyle(
        background: const HyperFill.none(),
        foregroundColor: colors.primary,
        border: BorderSide(color: colors.outline),
      ),
      HyperIconButtonVariant.ghost => HyperIconButtonStyle(
        background: const HyperFill.none(),
        foregroundColor: colors.textPrimary,
      ),
    };
  }

  Widget _buildVisual(
    BuildContext context,
    HyperIconButtonStyle style,
    Color foreground,
    Color overlay,
  ) {
    final materialTheme = HyperMaterialTheme.of(context);
    final material = style.material?.resolve(
      quality: materialTheme.quality ?? HyperMaterialQuality.standard,
      reduceTransparency: materialTheme.reduceTransparency ?? false,
    );
    final fill = material?.background ?? style.background;
    final radius = (style.borderRadius ?? BorderRadius.zero).resolve(
      Directionality.of(context),
    );
    final disabled = widget.onPressed == null;
    final content = _loading
        ? SizedBox.square(
            dimension: style.progressSize,
            child: CircularProgressIndicator(
              strokeWidth: style.progressThickness ?? 2,
              color: style.progressColor ?? foreground,
            ),
          )
        : IconTheme(
            data: IconThemeData(
              size: style.iconSize,
              color: disabled
                  ? HyperTheme.of(context).colors.disabled
                  : foreground,
            ),
            child: widget.icon,
          );
    final border = style.border ?? material?.border;
    Widget result = Container(
      width: style.size,
      height: style.size,
      margin: style.margin,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill?.color,
        gradient: fill?.gradient,
        borderRadius: radius,
        boxShadow: style.boxShadow ?? material?.boxShadow,
      ),
      foregroundDecoration:
          overlay.a > 0 || (border != null && border != BorderSide.none)
          ? BoxDecoration(
              color: overlay.a > 0 ? overlay : null,
              border: border == null || border == BorderSide.none
                  ? null
                  : Border.fromBorderSide(border),
              borderRadius: radius,
            )
          : null,
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
