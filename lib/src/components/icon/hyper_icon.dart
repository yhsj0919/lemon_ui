import 'package:flutter/material.dart';

import '../../foundation/hyper_control_state.dart';
import '../../foundation/hyper_state_value.dart';
import '../../theme/core/hyper_theme.dart';
import 'hyper_icon_style.dart';
import 'hyper_icon_theme.dart';

/// 使用 Hyper 主题、明确设备尺寸和状态样式的基础图标控件。
class HyperIcon extends StatelessWidget {
  const HyperIcon(
    this.icon, {
    super.key,
    this.style,
    this.states = const {},
    this.color,
    this.size,
    this.fill,
    this.weight,
    this.grade,
    this.opticalSize,
    this.shadows,
    this.semanticLabel,
    this.textDirection,
    this.applyTextScaling,
    this.blendMode,
  }) : child = null;

  const HyperIcon.widget(
    this.child, {
    super.key,
    this.style,
    this.states = const {},
    this.color,
    this.size,
    this.fill,
    this.weight,
    this.grade,
    this.opticalSize,
    this.shadows,
    this.semanticLabel,
    this.textDirection,
    this.applyTextScaling,
    this.blendMode,
  }) : icon = null;

  /// Flutter 原生图标数据。
  final IconData? icon;

  /// 自定义图标内容；通过 IconTheme 接收解析后的视觉属性。
  final Widget? child;

  /// 当前实例的状态样式，优先级高于全局和局部主题。
  final HyperIconStyle? style;

  /// 当前需要参与样式解析的状态集合。
  final Set<HyperControlState> states;

  /// 当前实例的明确颜色，优先级最高。
  final Color? color;

  /// 当前实例的明确尺寸，优先级最高。
  final double? size;

  /// 可变图标的填充轴。
  final double? fill;

  /// 可变图标的字重轴。
  final double? weight;

  /// 可变图标的等级轴。
  final double? grade;

  /// 可变图标的光学尺寸轴。
  final double? opticalSize;

  /// 当前实例的图标阴影；空列表表示移除阴影。
  final List<Shadow>? shadows;

  /// 屏幕阅读器使用的图标说明。
  final String? semanticLabel;

  /// 图标方向；null 时继承当前方向环境。
  final TextDirection? textDirection;

  /// 是否跟随系统文字缩放。
  final bool? applyTextScaling;

  /// 图标颜色与背景的混合方式。
  final BlendMode? blendMode;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final defaultSize = sizes.icon.size;
    final inherited = IconTheme.of(context);
    final defaults = HyperIconStyle(
      color: HyperStateValue.all(inherited.color ?? theme.colors.onSurface),
      size: HyperStateValue.all(defaultSize),
    );
    final resolved = defaults
        .merge(HyperIconTheme.of(context).style)
        .merge(style);
    final resolvedColor = color ?? resolved.color?.resolve(states);
    final resolvedSize = size ?? resolved.size?.resolve(states);
    final resolvedFill = fill ?? resolved.fill?.resolve(states);
    final resolvedWeight = weight ?? resolved.weight?.resolve(states);
    final resolvedGrade = grade ?? resolved.grade?.resolve(states);
    final resolvedOpticalSize =
        opticalSize ?? resolved.opticalSize?.resolve(states);
    final resolvedShadows = shadows ?? resolved.shadows;

    if (icon case final icon?) {
      return Icon(
        icon,
        color: resolvedColor,
        size: resolvedSize,
        fill: resolvedFill,
        weight: resolvedWeight,
        grade: resolvedGrade,
        opticalSize: resolvedOpticalSize,
        shadows: resolvedShadows,
        semanticLabel: semanticLabel,
        textDirection: textDirection,
        applyTextScaling: applyTextScaling,
        blendMode: blendMode,
      );
    }

    Widget result = IconTheme.merge(
      data: IconThemeData(
        color: resolvedColor,
        size: resolvedSize,
        fill: resolvedFill,
        weight: resolvedWeight,
        grade: resolvedGrade,
        opticalSize: resolvedOpticalSize,
        shadows: resolvedShadows,
      ),
      child: child!,
    );
    if (semanticLabel case final label?) {
      result = Semantics(label: label, image: true, child: result);
    }
    return result;
  }
}
