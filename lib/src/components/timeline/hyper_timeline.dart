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
    this.direction = Axis.vertical,
    this.style,
  });
  final List<HyperTimelineItem> items;
  final HyperTimelineAlignment alignment;
  final bool reverse;
  final Axis direction;
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
              nodeLineGap: metrics.nodeLineGap,
              highlightLine: false,
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
    double nodeTop(int index) {
      final item = model.items[index];
      final s = resolved[index];
      final hasTime =
          item.time != null && alignment != HyperTimelineAlignment.alternate;
      final first = hasTime ? item.time! : item.title;
      final text = first is Text ? first : null;
      final textStyle = (hasTime ? s.timeStyle! : s.titleStyle!).merge(
        text?.style,
      );
      final painter = TextPainter(
        text:
            text?.textSpan ??
            TextSpan(text: text?.data ?? ' ', style: textStyle),
        textDirection: Directionality.of(context),
        textScaler: text?.textScaler ?? MediaQuery.textScalerOf(context),
        textHeightBehavior: text?.textHeightBehavior,
        maxLines: 1,
      )..layout();
      final height = painter.computeLineMetrics().first.height;
      painter.dispose();
      return math.max(0, (height - s.nodeSize!) / 2);
    }

    Widget row(int index) {
      final item = model.items[index], s = resolved[index];
      final duration = reduced ? Duration.zero : s.duration!;
      final atStart =
          direction == Axis.vertical && model.contentAtStart(index, alignment);
      final alternate =
          direction == Axis.vertical &&
          alignment == HyperTimelineAlignment.alternate;
      Widget styled(Widget child, TextStyle textStyle) =>
          AnimatedDefaultTextStyle(
            style: textStyle,
            duration: duration,
            curve: s.curve!,
            textAlign: direction == Axis.horizontal
                ? TextAlign.center
                : atStart
                ? TextAlign.end
                : TextAlign.start,
            child: child,
          );
      final content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: direction == Axis.horizontal
            ? CrossAxisAlignment.center
            : atStart
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
          key: ValueKey(('timeline-node', item.id)),
          duration: duration,
          curve: s.curve!,
          width: s.nodeSize,
          height: s.nodeSize,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: s.nodeFill?.color,
            gradient: s.nodeFill?.gradient,
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
      if (direction == Axis.horizontal) {
        Widget halfLine(int source, {required bool before}) {
          if (source < 0 || source >= model.items.length - 1) {
            return const Expanded(child: SizedBox());
          }
          final lineStyle = resolved[source];
          final status = model.items[source].status;
          return Expanded(
            child: Padding(
              padding: before
                  ? EdgeInsetsDirectional.only(end: s.nodeLineGap!)
                  : EdgeInsetsDirectional.only(start: s.nodeLineGap!),
              child: _TimelineLine(
                key: ValueKey(('timeline-line', item.id, before)),
                direction: Axis.horizontal,
                thickness: lineStyle.lineThickness!,
                color: lineStyle.nodeForeground!,
                background: lineStyle.lineColor!,
                highlighted:
                    lineStyle.highlightLine! &&
                    status != HyperTimelineStatus.normal &&
                    status != HyperTimelineStatus.disabled,
                duration: reduced ? Duration.zero : lineStyle.duration!,
                curve: lineStyle.curve!,
              ),
            ),
          );
        }

        return Semantics(
          key: ValueKey(item.id),
          container: true,
          label: item.semanticLabel,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: railWidth,
                child: Row(
                  children: [
                    halfLine(index - 1, before: true),
                    node,
                    halfLine(index, before: false),
                  ],
                ),
              ),
              SizedBox(height: s.spacing),
              if (item.opposite != null) styled(item.opposite!, s.timeStyle!),
              content,
            ],
          ),
        );
      }
      final rail = SizedBox(
        width: railWidth,
        child: Column(
          children: [
            SizedBox(height: nodeTop(index)),
            node,
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: s.nodeLineGap!,
                  bottom: index == model.items.length - 1
                      ? 0
                      : math.max(
                          0,
                          resolved[index + 1].nodeLineGap! - nodeTop(index + 1),
                        ),
                ),
                child: Center(
                  child: _TimelineLine(
                    key: ValueKey(('timeline-line', item.id)),
                    duration: duration,
                    curve: s.curve!,
                    thickness: s.lineThickness!,
                    color: s.nodeForeground!,
                    background: index == model.items.length - 1
                        ? Colors.transparent
                        : s.lineColor!,
                    highlighted:
                        index != model.items.length - 1 &&
                        s.highlightLine! &&
                        item.status != HyperTimelineStatus.normal &&
                        item.status != HyperTimelineStatus.disabled,
                  ),
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

    if (direction == Axis.horizontal) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < model.items.length; i++) Expanded(child: row(i)),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [for (var i = 0; i < model.items.length; i++) row(i)],
    );
  }
}

class _TimelineLine extends StatefulWidget {
  const _TimelineLine({
    super.key,
    required this.thickness,
    required this.color,
    required this.background,
    required this.highlighted,
    required this.duration,
    required this.curve,
    this.direction = Axis.vertical,
  });
  final double thickness;
  final Color color, background;
  final bool highlighted;
  final Duration duration;
  final Curve curve;
  final Axis direction;
  @override
  State<_TimelineLine> createState() => _TimelineLineState();
}

class _TimelineLineState extends State<_TimelineLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Color _base;
  late Color _highlight;
  @override
  void initState() {
    super.initState();
    _base = widget.background;
    _highlight = widget.color;
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: widget.highlighted ? 1 : 0,
    );
  }

  @override
  void didUpdateWidget(_TimelineLine oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.duration;
    if (widget.highlighted &&
        oldWidget.highlighted &&
        widget.color != oldWidget.color) {
      _base = _highlight;
      _highlight = widget.color;
      _controller.value = 0;
    } else {
      _base = widget.background;
      if (widget.highlighted) _highlight = widget.color;
    }
    if (widget.duration == Duration.zero) {
      _controller.value = widget.highlighted ? 1 : 0;
    } else {
      _controller.animateTo(widget.highlighted ? 1 : 0, curve: widget.curve);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: widget.direction == Axis.vertical ? widget.thickness : null,
    height: widget.direction == Axis.horizontal ? widget.thickness : null,
    child: AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Stack(
        fit: StackFit.expand,
        children: [
          Container(color: _base),
          Positioned.fill(
            child: Align(
              alignment: widget.direction == Axis.vertical
                  ? AlignmentDirectional.topCenter
                  : AlignmentDirectional.centerStart,
              child: FractionallySizedBox(
                heightFactor: widget.direction == Axis.vertical
                    ? _controller.value
                    : 1,
                widthFactor: widget.direction == Axis.horizontal
                    ? _controller.value
                    : 1,
                child: ColoredBox(color: _highlight),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
