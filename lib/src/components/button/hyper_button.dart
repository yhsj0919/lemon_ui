import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_control_state.dart';
import '../../foundation/hyper_surface_material.dart';
import '../../interaction/hyper_pressable.dart';
import '../../theme/color/hyper_contrast_theme.dart';
import '../../theme/core/hyper_theme.dart';
import '../../theme/material/hyper_material_theme.dart';
import '../../theme/size/components/hyper_button_size.dart';
import '../progress/hyper_circular_progress_indicator.dart';
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
    this.size = HyperButtonSizeVariant.medium,
    this.style,
    this.loading = false,
    this.progress,
    this.loadingIndicator,
    this.onError,
    this.autofocus = false,
    this.focusNode,
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
    this.size = HyperButtonSizeVariant.medium,
    this.style,
    this.loading = false,
    this.progress,
    this.loadingIndicator,
    this.onError,
    this.autofocus = false,
    this.focusNode,
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
    this.size = HyperButtonSizeVariant.medium,
    this.style,
    this.loading = false,
    this.progress,
    this.loadingIndicator,
    this.onError,
    this.autofocus = false,
    this.focusNode,
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
    this.size = HyperButtonSizeVariant.medium,
    this.style,
    this.loading = false,
    this.progress,
    this.loadingIndicator,
    this.onError,
    this.autofocus = false,
    this.focusNode,
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
    this.size = HyperButtonSizeVariant.medium,
    this.style,
    this.loading = false,
    this.progress,
    this.loadingIndicator,
    this.onError,
    this.autofocus = false,
    this.focusNode,
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
    this.size = HyperButtonSizeVariant.medium,
    this.style,
    this.loading = false,
    this.progress,
    this.loadingIndicator,
    this.onError,
    this.autofocus = false,
    this.focusNode,
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

  /// 视觉尺寸档位；由当前设备的尺寸主题解析。
  final HyperButtonSizeVariant size;

  /// 当前实例的样式覆盖，优先级高于按钮主题。
  final HyperButtonStyle? style;

  /// 外部控制的加载状态。
  final bool loading;

  /// 确定进度，取值范围为 0 到 1；null 表示不确定进度。
  final double? progress;

  /// 自定义加载内容；未指定时使用默认圆形进度。
  ///
  /// 内容会被 [HyperButtonStyle.progressSize] 约束，不改变按钮外部尺寸。
  final Widget? loadingIndicator;

  /// 同步或异步操作失败时的错误回调。
  final void Function(Object error, StackTrace stackTrace)? onError;

  /// 首次显示时是否自动获取键盘焦点。
  final bool autofocus;

  /// 按钮自身的焦点节点，由调用方创建和释放。
  final FocusNode? focusNode;

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
    final sizes = HyperTheme.sizesOf(context);
    final colors = theme.colors;
    // 组件只消费主题已经解析好的当前设备规格，不再自行判断设备类型。
    final metrics = sizes.button;
    final defaults = HyperButtonStyle(
      height: metrics.heightFor(widget.size),
      minimumSize: Size(
        metrics.minimumSize.width,
        metrics.heightFor(widget.size),
      ),
      minimumTapTargetSize: Size.square(sizes.minimumInteractiveDimension),
      padding: metrics.paddingFor(widget.size),
      borderRadius: BorderRadius.circular(metrics.radius),
      textStyle: theme.textTheme.labelLarge,
      disabledForegroundColor: colors.disabled,
      iconSize: metrics.iconSize,
      iconSpacing: metrics.iconSpacing,
      animationDuration: theme.motion.fastDuration,
      animationCurve: theme.motion.fastCurve,
      progressSize: metrics.progressSize,
      progressThickness: 2,
      hoverOverlayOpacity: metrics.hoverOverlayOpacity,
      focusOverlayOpacity: metrics.focusOverlayOpacity,
      pressOverlayOpacity: metrics.pressOverlayOpacity,
    ).merge(_variantDefaults(context));
    final themedStyle = HyperButtonTheme.of(context).resolve(widget.variant);
    final style = defaults.merge(themedStyle).merge(widget.style);
    final materialTheme = HyperMaterialTheme.of(context);
    final material = materialTheme.resolveMaterial(material: style.material);
    final explicitBackground = style.material == null
        ? widget.style?.background ?? themedStyle.background
        : null;
    final enabled = widget.onPressed != null && !_loading;
    // 加载期间只锁定交互，不切换为禁用配色，避免渐变按钮闪成纯色。
    final visuallyEnabled = widget.onPressed != null || _loading;

    return HyperPressable(
      enabled: enabled,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
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
        final baseForeground = visuallyEnabled
            ? style.foregroundColor ?? colors.onSurface
            : style.disabledForegroundColor ?? colors.disabled;
        final foregroundColor = HyperContrastTheme.of(context).resolve(
          foreground: baseForeground,
          background: visuallyEnabled
              ? explicitBackground ?? material?.background ?? style.background
              : style.disabledBackground ??
                    explicitBackground ??
                    material?.background ??
                    style.background,
          canvasColor: colors.background,
          mode: style.contrastMode,
        );
        final content = _buildContent(context, style, foregroundColor);
        final visual = _buildVisual(
          context,
          style,
          content,
          overlay.withValues(alpha: overlayAlpha),
          visuallyEnabled,
          material,
          explicitBackground,
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

  Widget _buildContent(
    BuildContext context,
    HyperButtonStyle style,
    Color foregroundColor,
  ) {
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
      // 自由 child 中的图标也继承按钮前景色；显式 Icon.color 仍可覆盖。
      child: IconTheme.merge(
        data: IconThemeData(color: foregroundColor, size: style.iconSize),
        child: normal,
      ),
    );
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = reduceMotion ? Duration.zero : style.animationDuration!;
    final curve = style.animationCurve!;
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedOpacity(
          opacity: _loading ? 0 : 1,
          duration: duration,
          curve: curve,
          child: normal,
        ),
        AnimatedOpacity(
          opacity: _loading ? 1 : 0,
          duration: duration,
          curve: curve,
          child: IgnorePointer(
            child: ExcludeSemantics(
              child: AnimatedScale(
                scale: _loading ? 1 : .8,
                duration: duration,
                curve: curve,
                child: TickerMode(
                  enabled: _loading,
                  child: SizedBox.square(
                    dimension: style.progressSize,
                    child:
                        widget.loadingIndicator ??
                        HyperCircularProgressIndicator(
                          value: widget.progress,
                          size: style.progressSize,
                          thickness: style.progressThickness ?? 2,
                          color: style.progressColor ?? foregroundColor,
                          trackColor:
                              style.progressTrackColor ??
                              foregroundColor.withValues(alpha: .24),
                          excludeSemantics: true,
                        ),
                  ),
                ),
              ),
            ),
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
    HyperSurfaceMaterial? material,
    HyperFill? explicitBackground,
  ) {
    final fill = !enabled && style.disabledBackground != null
        ? style.disabledBackground
        : explicitBackground ?? material?.background ?? style.background;
    final radius = (style.borderRadius ?? BorderRadius.zero).resolve(
      Directionality.of(context),
    );
    final glass = material?.usesBackdrop ?? false;
    final shadows = style.boxShadow ?? material?.boxShadow;
    final decoration = BoxDecoration(
      color: glass ? null : fill?.color,
      gradient: glass ? null : fill?.gradient,
      borderRadius: radius,
      boxShadow: glass ? null : shadows,
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
    Widget layeredContent = Align(
      alignment: style.alignment ?? Alignment.center,
      widthFactor: 1,
      heightFactor: 1,
      // 对齐负责定位完整的“内边距 + 内容”组，内边距不参与按钮外框约束。
      child: Padding(padding: style.padding ?? EdgeInsets.zero, child: content),
    );
    if (!glass && material?.tint != null) {
      final tint = material!.tint!;
      layeredContent = Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned.fill(
            child: IgnorePointer(child: ColoredBox(color: tint)),
          ),
          layeredContent,
        ],
      );
    }
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
      margin: glass ? null : style.margin,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      child: layeredContent,
    );
    if (glass) {
      // 滤镜只作用于材质背景；文字、图标和加载状态留在清晰前景层。
      result = ClipRRect(
        borderRadius: radius,
        clipBehavior: style.clipBehavior == Clip.none
            ? Clip.antiAlias
            : style.clipBehavior ?? Clip.antiAlias,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: material!.blurSigmaX,
                  sigmaY: material.blurSigmaY,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: fill?.color,
                    gradient: fill?.gradient,
                    borderRadius: radius,
                  ),
                  child: material.tint == null
                      ? const SizedBox.expand()
                      : ColoredBox(color: material.tint!),
                ),
              ),
            ),
            result,
          ],
        ),
      );
      if (shadows != null && shadows.isNotEmpty) {
        result = DecoratedBox(
          decoration: BoxDecoration(borderRadius: radius, boxShadow: shadows),
          child: result,
        );
      }
      if (style.margin != null) {
        result = Padding(padding: style.margin!, child: result);
      }
    }
    return result;
  }
}
