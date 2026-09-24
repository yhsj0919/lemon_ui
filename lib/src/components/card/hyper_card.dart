import 'dart:ui';

import 'package:flutter/material.dart';

import '../../foundation/hyper_control_state.dart';
import '../../foundation/hyper_fill.dart';
import '../../interaction/hyper_pressable.dart';
import '../../theme/core/hyper_theme.dart';
import '../../theme/material/hyper_material_theme.dart';
import 'hyper_card_style.dart';
import 'hyper_card_theme.dart';

/// 独立主题的基础内容卡片。
///
/// Card 只负责表面、内容内边距和可选整卡交互；标题、媒体和操作区由调用方组合。
class HyperCard extends StatelessWidget {
  const HyperCard({
    super.key,
    this.child,
    this.onTap,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
    this.width,
    this.height,
    this.alignment,
    this.style,
  });

  final Widget? child;
  final VoidCallback? onTap;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? semanticLabel;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final HyperCardStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final metrics = HyperTheme.sizesOf(context).card;
    final cardThemeStyle = HyperCardTheme.of(context).style;
    final resolved = HyperCardStyle(
      background: HyperFill.color(theme.colors.surface),
      foregroundColor: theme.colors.onSurface,
      overlayColor: theme.colors.stateLayer,
      border: null,
      borderRadius: BorderRadius.circular(metrics.radius),
      padding: metrics.padding,
      pressedScale: .98,
      animationDuration: theme.motion.fastDuration,
      animationCurve: theme.motion.standardCurve,
      clipBehavior: Clip.antiAlias,
    ).merge(cardThemeStyle).merge(style);
    final materialTheme = HyperMaterialTheme.of(context);
    // 组件材质优先于统一材质；未指定时继承全局或子树的材质配方。
    final material = materialTheme.resolveMaterial(material: resolved.material);
    Widget buildVisual(Set<HyperControlState> states) {
      final pressed = states.contains(HyperControlState.pressed);
      final hovered = states.contains(HyperControlState.hovered);
      final focused = states.contains(HyperControlState.focused);
      final overlayAlpha = pressed
          ? .10
          : hovered || focused
          ? .06
          : 0.0;
      final fill =
          (resolved.material == null
              ? style?.background ?? cardThemeStyle?.background
              : null) ??
          material?.background ??
          resolved.background!;
      final radius = resolved.borderRadius!.resolve(Directionality.of(context));
      final border =
          resolved.border ??
          (material?.border == null || material?.border == BorderSide.none
              ? null
              : Border.fromBorderSide(material!.border!));
      final reduceMotion =
          MediaQuery.maybeOf(context)?.disableAnimations ?? false;
      final duration = reduceMotion
          ? Duration.zero
          : resolved.animationDuration!;

      final content = DefaultTextStyle.merge(
        style: TextStyle(color: resolved.foregroundColor),
        child: child ?? const SizedBox.shrink(),
      );
      final shadows = resolved.boxShadow ?? material?.boxShadow;
      final foregroundDecoration = BoxDecoration(
        color: resolved.overlayColor!.withValues(alpha: overlayAlpha),
        border: border,
        borderRadius: radius,
      );
      Widget surface;
      if (material?.usesBackdrop ?? false) {
        // 毛玻璃只过滤背景；内容作为兄弟前景层保持清晰，避免文字重影。
        final background = BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: material!.blurSigmaX,
            sigmaY: material.blurSigmaY,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: fill.color,
              gradient: fill.gradient,
              borderRadius: radius,
            ),
            child: material.tint == null
                ? const SizedBox.expand()
                : ColoredBox(color: material.tint!),
          ),
        );
        final foreground = AnimatedContainer(
          width: width,
          height: height,
          alignment: alignment,
          constraints: resolved.constraints,
          padding: resolved.padding,
          duration: duration,
          curve: resolved.animationCurve!,
          foregroundDecoration: foregroundDecoration,
          child: content,
        );
        final effectiveClip = resolved.clipBehavior == Clip.none
            ? Clip.antiAlias
            : resolved.clipBehavior!;
        surface = ClipRRect(
          borderRadius: radius,
          clipBehavior: effectiveClip,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Positioned.fill(child: background),
              foreground,
            ],
          ),
        );
        if (shadows case final shadows? when shadows.isNotEmpty) {
          surface = DecoratedBox(
            decoration: BoxDecoration(borderRadius: radius, boxShadow: shadows),
            child: surface,
          );
        }
      } else {
        Widget layeredContent = content;
        if (material?.tint case final tint?) {
          layeredContent = Stack(
            fit: StackFit.passthrough,
            children: [
              Positioned.fill(
                child: IgnorePointer(child: ColoredBox(color: tint)),
              ),
              content,
            ],
          );
        }
        surface = AnimatedContainer(
          width: width,
          height: height,
          alignment: alignment,
          constraints: resolved.constraints,
          padding: resolved.padding,
          duration: duration,
          curve: resolved.animationCurve!,
          decoration: BoxDecoration(
            color: fill.color,
            gradient: fill.gradient,
            borderRadius: radius,
            boxShadow: shadows,
          ),
          foregroundDecoration: foregroundDecoration,
          clipBehavior: resolved.clipBehavior!,
          child: layeredContent,
        );
      }

      return AnimatedScale(
        scale: pressed ? resolved.pressedScale! : 1,
        duration: duration,
        curve: resolved.animationCurve!,
        child: surface,
      );
    }

    final Widget card = onTap == null
        ? buildVisual(const {})
        : HyperPressable(
            enabled: enabled,
            onTap: onTap,
            autofocus: autofocus,
            focusNode: focusNode,
            semanticLabel: semanticLabel,
            semanticButton: true,
            mouseCursor: enabled
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
            builder: (context, states, _) => buildVisual(states),
          );
    return Padding(padding: resolved.margin ?? EdgeInsets.zero, child: card);
  }
}
