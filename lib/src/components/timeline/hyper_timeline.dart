import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../theme/core/hyper_theme.dart';
import '../../theme/material/hyper_material_theme.dart';
import '../surface/hyper_material_surface.dart';
import 'hyper_timeline_model.dart';
import 'hyper_timeline_style.dart';
import 'hyper_timeline_theme.dart';

/// 垂直时间线，按输入顺序呈现，不推断时间或排序，不持有业务状态。
class HyperTimeline extends StatelessWidget {
  const HyperTimeline({
    super.key,
    required this.items,
    this.alignment = HyperTimelineAlignment.start,
    this.reverse = false,
    this.style,
  });
  final List<HyperTimelineItem> items;
  final HyperTimelineAlignment alignment;
  final bool reverse;
  final HyperTimelineStyle? style;
  @override
  Widget build(BuildContext context) {
    final model = HyperTimelineModel(items, reverse: reverse);
    if (model.items.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = HyperTheme.of(context);
    final metrics = HyperTheme.sizesOf(context).timeline;
    final material = HyperMaterialTheme.of(context);
    final componentTheme = HyperTimelineTheme.of(context);
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final resolved = <HyperTimelineStyle>[];
    for (final item in model.items) {
      final color = switch (item.status) {
        HyperTimelineStatus.normal => theme.colors.textTertiary,
        HyperTimelineStatus.active => theme.colors.primary,
        HyperTimelineStatus.success => theme.colors.success,
        HyperTimelineStatus.warning => theme.colors.warning,
        HyperTimelineStatus.error => theme.colors.error,
        HyperTimelineStatus.disabled => theme.colors.textTertiary,
      };
      resolved.add(
        HyperTimelineStyle(
              nodeFill: HyperFill.color(color),
              nodeForeground: color,
              nodeBorder: BorderSide.none,
              nodeBorderRadius: BorderRadius.circular(metrics.iconSize),
              nodeSize: item.node == null ? metrics.nodeSize : metrics.iconSize,
              iconSize: metrics.iconSize,
              material: material.material,
              materialQuality: material.quality,
              reduceTransparency: material.reduceTransparency,
              lineColor: theme.colors.outline,
              lineThickness: metrics.lineThickness,
              spacing: metrics.spacing,
              itemSpacing: metrics.itemSpacing,
              textSpacing: metrics.textSpacing,
              timeStyle: theme.textTheme.bodySmall?.copyWith(
                color: theme.colors.textTertiary,
              ),
              titleStyle: theme.textTheme.bodyMedium?.copyWith(
                color: item.status == HyperTimelineStatus.disabled
                    ? theme.colors.textSecondary
                    : theme.colors.textPrimary,
              ),
              contentStyle: theme.textTheme.bodySmall?.copyWith(
                color: theme.colors.textSecondary,
              ),
              duration: theme.motion.fastDuration,
              curve: theme.motion.fastCurve,
            )
            .merge(componentTheme.resolve(item.status))
            .merge(style)
            .merge(item.style),
      );
    }
    // 同一时间线按最大节点宽度分配轨道，混合节点保持同一根连接线。
    final railWidth = resolved.map((s) => s.nodeSize!).reduce(math.max);
    final hasOppositeColumn = model.hasOppositeColumn(alignment);
    Widget row(int index) {
      final item = model.items[index], s = resolved[index];
      final duration = reduced ? Duration.zero : s.duration!;
      final atStart = model.contentAtStart(index, alignment);
      final alternate = alignment == HyperTimelineAlignment.alternate;
      Widget styled(Widget child, TextStyle textStyle) =>
          AnimatedDefaultTextStyle(
            style: textStyle,
            duration: duration,
            curve: s.curve!,
            textAlign: atStart ? TextAlign.end : TextAlign.start,
            child: child,
          );
      final content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: atStart
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (item.time != null && !alternate) ...[
            styled(item.time!, s.timeStyle!),
            SizedBox(height: s.textSpacing),
          ],
          styled(item.title, s.titleStyle!),
          if (item.content != null) ...[
            SizedBox(height: s.textSpacing),
            styled(item.content!, s.contentStyle!),
          ],
        ],
      );
      Widget node;
      if (item.node != null) {
        node = IconTheme(
          data: IconThemeData(size: s.iconSize, color: s.nodeForeground),
          child: SizedBox(
            width: s.nodeSize,
            height: s.nodeSize,
            child: AnimatedSwitcher(
              duration: duration,
              transitionBuilder:
                  s.transitionBuilder ??
                  AnimatedSwitcher.defaultTransitionBuilder,
              switchInCurve: s.curve!,
              switchOutCurve: s.curve!,
              child: KeyedSubtree(
                key: ValueKey((item.node!.runtimeType, item.node!.key)),
                child: item.node!,
              ),
            ),
          ),
        );
      } else {
        node = AnimatedContainer(
          duration: duration,
          curve: s.curve!,
          width: s.nodeSize,
          height: s.nodeSize,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: s.material == null ? s.nodeFill?.color : null,
            gradient: s.material == null ? s.nodeFill?.gradient : null,
            borderRadius: s.nodeBorderRadius,
          ),
          foregroundDecoration: BoxDecoration(
            border: Border.fromBorderSide(s.nodeBorder!),
            borderRadius: s.nodeBorderRadius,
          ),
        );
        if (s.material != null) {
          node = HyperMaterialSurface(
            material: s.material,
            quality: s.materialQuality,
            reduceTransparency: s.reduceTransparency,
            width: s.nodeSize,
            height: s.nodeSize,
            borderRadius: s.nodeBorderRadius,
            clipBehavior: Clip.antiAlias,
            child: node,
          );
        }
      }
      final rail = SizedBox(
        width: railWidth,
        child: Column(
          children: [
            node,
            Expanded(
              child: Center(
                child: AnimatedContainer(
                  duration: duration,
                  curve: s.curve!,
                  width: s.lineThickness,
                  color: index == model.items.length - 1
                      ? Colors.transparent
                      : s.lineColor,
                ),
              ),
            ),
          ],
        ),
      );
      Widget side(Widget? child, {required bool leading}) => Expanded(
        child: Padding(
          padding: leading
              ? EdgeInsetsDirectional.only(end: s.spacing!)
              : EdgeInsetsDirectional.only(start: s.spacing!),
          child: Align(
            alignment: leading
                ? AlignmentDirectional.topEnd
                : AlignmentDirectional.topStart,
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      );
      final opposite = item.opposite ?? (alternate ? item.time : null);
      final oppositeContent = opposite == null
          ? null
          : Padding(
              padding: EdgeInsets.only(
                bottom: index == model.items.length - 1 ? 0 : s.itemSpacing!,
              ),
              child: AnimatedDefaultTextStyle(
                style: s.timeStyle!,
                duration: duration,
                curve: s.curve!,
                textAlign: atStart ? TextAlign.start : TextAlign.end,
                child: opposite,
              ),
            );
      final hasOpposite = hasOppositeColumn;
      Widget paddedContent = Padding(
        padding: EdgeInsets.only(
          bottom: index == model.items.length - 1 ? 0 : s.itemSpacing!,
        ),
        child: content,
      );
      final children = <Widget>[
        if (atStart)
          side(paddedContent, leading: true)
        else if (hasOpposite)
          side(oppositeContent, leading: true),
        rail,
        if (!atStart)
          side(paddedContent, leading: false)
        else if (hasOpposite)
          side(oppositeContent, leading: false),
      ];
      return Semantics(
        key: ValueKey(item.id),
        container: true,
        label: item.semanticLabel,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [for (var i = 0; i < model.items.length; i++) row(i)],
    );
  }
}
