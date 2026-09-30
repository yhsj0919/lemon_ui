import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_widget_group_style.dart';
import 'hyper_widget_group_scope.dart';
import 'hyper_widget_group_theme.dart';

/// 子项宽度或主轴比例；[flex] 需要控件组有有限的主轴可用空间。
class HyperWidgetGroupItem extends StatelessWidget {
  const HyperWidgetGroupItem({
    super.key,
    required this.child,
    this.width,
    this.flex,
    this.borderRadius,
  }) : assert(width == null || width > 0),
       assert(flex == null || flex > 0),
       assert(width == null || flex == null);

  final Widget child;
  final double? width;
  final int? flex;

  /// 覆盖本子项的圆角，可只设置左侧或右侧。
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: borderRadius == null
        ? child
        : ClipRRect(borderRadius: borderRadius!, child: child),
  );
}

/// 混合排列任意控件；每个子项保留自己的交互和视觉职责。
class HyperWidgetGroup extends StatelessWidget {
  const HyperWidgetGroup({
    super.key,
    required this.children,
    this.direction = Axis.horizontal,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.showSeparators = false,
    this.connected = false,
    this.separatorBuilder,
    this.clipBehavior = Clip.none,
    this.style,
  });

  final List<Widget> children;
  final Axis direction;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  /// 在相邻子项间绘制分隔；分隔不占用子项的点击区域。
  final bool showSeparators;

  /// 连续组合：组接管外框，内置按钮去掉各自的边框、圆角和阴影。
  final bool connected;

  /// 替换第 [index] 个与下一个子项之间的分隔内容。
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final Clip clipBehavior;
  final HyperWidgetGroupStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final metrics = sizes.widgetGroup;
    final resolved = HyperWidgetGroupTheme.of(context).style.merge(style);
    final itemHeight =
        resolved.itemHeight ??
        (connected ? sizes.button.minimumSize.height : null);
    final spacing = resolved.spacing ?? (connected ? 0 : metrics.spacing);
    final hasFlexibleItem = children.any(
      (child) => child is HyperWidgetGroupItem && child.flex != null,
    );
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = reduceMotion
        ? Duration.zero
        : resolved.duration ?? theme.motion.fastDuration;
    final curve = resolved.curve ?? theme.motion.fastCurve;

    return AnimatedContainer(
      duration: duration,
      curve: curve,
      width: resolved.width,
      padding: resolved.padding ?? EdgeInsets.zero,
      clipBehavior: connected ? Clip.antiAlias : clipBehavior,
      decoration: BoxDecoration(
        color:
            resolved.backgroundColor ??
            (connected ? theme.colors.surface : null),
        border:
            resolved.border ??
            (connected ? Border.all(color: theme.colors.outline) : null),
        borderRadius:
            resolved.borderRadius ?? BorderRadius.circular(metrics.radius),
        boxShadow: resolved.boxShadow,
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: spacing),
        duration: duration,
        curve: curve,
        builder: (context, currentSpacing, _) {
          final arranged = <Widget>[];
          for (var index = 0; index < children.length; index++) {
            if (index > 0) {
              if (showSeparators) {
                arranged.add(_gap(currentSpacing / 2));
                arranged.add(
                  separatorBuilder?.call(context, index - 1) ??
                      _defaultSeparator(
                        resolved.separatorColor ?? theme.colors.outline,
                        resolved.separatorExtent ??
                            (connected
                                ? itemHeight ?? metrics.separatorExtent
                                : metrics.separatorExtent),
                        resolved.separatorThickness ??
                            metrics.separatorThickness,
                        duration,
                        curve,
                      ),
                );
                arranged.add(_gap(currentSpacing / 2));
              } else {
                arranged.add(_gap(currentSpacing));
              }
            }
            arranged.add(
              _buildItem(
                children[index],
                itemHeight,
                resolved.itemBorderRadius,
                duration,
                curve,
                connected,
              ),
            );
          }
          return Flex(
            direction: direction,
            mainAxisSize: hasFlexibleItem ? MainAxisSize.max : mainAxisSize,
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: arranged,
          );
        },
      ),
    );
  }

  Widget _gap(double extent) => direction == Axis.horizontal
      ? SizedBox(width: extent)
      : SizedBox(height: extent);

  Widget _buildItem(
    Widget item,
    double? itemHeight,
    BorderRadiusGeometry? itemBorderRadius,
    Duration duration,
    Curve curve,
    bool connected,
  ) {
    final wrapped = item is HyperWidgetGroupItem ? item : null;
    final child = wrapped?.child ?? item;
    final width = wrapped?.width;
    final radius = wrapped?.borderRadius ?? itemBorderRadius;
    final content = SizedBox(
      width: width,
      height: itemHeight,
      child: radius == null
          ? HyperWidgetGroupScope(
              connected: connected,
              itemHeight: itemHeight,
              fillWidth: width != null || wrapped?.flex != null,
              child: child,
            )
          : AnimatedContainer(
              duration: duration,
              curve: curve,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(borderRadius: radius),
              child: HyperWidgetGroupScope(
                connected: connected,
                itemHeight: itemHeight,
                fillWidth: width != null || wrapped?.flex != null,
                child: child,
              ),
            ),
    );
    final flex = wrapped?.flex;
    return flex == null ? content : Expanded(flex: flex, child: content);
  }

  Widget _defaultSeparator(
    Color color,
    double extent,
    double thickness,
    Duration duration,
    Curve curve,
  ) => direction == Axis.horizontal
      ? AnimatedContainer(
          duration: duration,
          curve: curve,
          width: thickness,
          height: extent,
          color: color,
        )
      : AnimatedContainer(
          duration: duration,
          curve: curve,
          width: extent,
          height: thickness,
          color: color,
        );
}
