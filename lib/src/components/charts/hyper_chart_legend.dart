import 'package:flutter/material.dart';

enum HyperChartLegendPosition { top, bottom, left, right }

@immutable
class HyperChartLegendOptions {
  const HyperChartLegendOptions({
    this.position,
    this.direction,
    this.alignment,
    this.itemBuilder,
  });
  final HyperChartLegendPosition? position;
  final Axis? direction;
  final WrapAlignment? alignment;
  final Widget Function(
    BuildContext context,
    String label,
    Color color,
    bool hidden,
    VoidCallback toggle,
  )?
  itemBuilder;

  HyperChartLegendOptions merge(HyperChartLegendOptions? other) => other == null
      ? this
      : HyperChartLegendOptions(
          position: other.position ?? position,
          direction: other.direction ?? direction,
          alignment: other.alignment ?? alignment,
          itemBuilder: other.itemBuilder ?? itemBuilder,
        );
  @override
  bool operator ==(Object other) =>
      other is HyperChartLegendOptions &&
      other.position == position &&
      other.direction == direction &&
      other.alignment == alignment &&
      other.itemBuilder == itemBuilder;
  @override
  int get hashCode => Object.hash(position, direction, alignment, itemBuilder);
}

/// 绘图区和图例的统一布局，图例超出可用空间时独立滚动。
class HyperChartLayout extends StatelessWidget {
  const HyperChartLayout({
    super.key,
    required this.options,
    required this.children,
  });
  final HyperChartLegendOptions options;
  final List<Widget> children;
  static HyperChartLegendOptions of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_LegendScope>()?.options ??
      const HyperChartLegendOptions();

  @override
  Widget build(BuildContext context) {
    final plot = children.last;
    final content = plot is Expanded ? plot.child : plot;
    if (children.length == 1) return content;
    final position = options.position ?? HyperChartLegendPosition.top;
    final side =
        position == HyperChartLegendPosition.left ||
        position == HyperChartLegendPosition.right;
    final before =
        position == HyperChartLegendPosition.top ||
        position == HyperChartLegendPosition.left;
    return LayoutBuilder(
      builder: (context, constraints) {
        final legend = ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: side ? constraints.maxWidth * .35 : constraints.maxWidth,
            maxHeight: side
                ? constraints.maxHeight
                : constraints.maxHeight * .35,
          ),
          child: SingleChildScrollView(
            child: _LegendScope(options: options, child: children.first),
          ),
        );
        final gap = children.length > 2 && children[1] is SizedBox
            ? (children[1] as SizedBox).height ?? 0.0
            : 0.0;
        final items = <Widget>[
          if (before) legend,
          if (before) SizedBox(width: side ? gap : 0, height: side ? 0 : gap),
          Expanded(child: content),
          if (!before) SizedBox(width: side ? gap : 0, height: side ? 0 : gap),
          if (!before) legend,
        ];
        return Flex(
          direction: side ? Axis.horizontal : Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: items,
        );
      },
    );
  }
}

class _LegendScope extends InheritedWidget {
  const _LegendScope({required this.options, required super.child});
  final HyperChartLegendOptions options;
  @override
  bool updateShouldNotify(_LegendScope oldWidget) =>
      oldWidget.options != options;
}
