import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 共用样式对象演示，沿用当前设备 Divider 规格，不新增独立尺寸默认值。
class HyperLinePage extends StatelessWidget {
  const HyperLinePage({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final metrics = sizes.divider;
    return ListView(
      padding: EdgeInsets.all(sizes.pageHorizontalPadding),
      children: [
        const HyperText('共用线条样式'),
        const HyperText('以下实例把同一个样式用于分割线和卡片轮廓；默认颜色和尺寸来自当前主题。'),
        for (final pattern in HyperLinePattern.values)
          ..._preview(
            pattern,
            HyperLine(
              fill: HyperFill.color(theme.colors.outline),
              thickness: metrics.thickness,
              pattern: pattern,
              dashLength: metrics.dashLength,
              gap: metrics.gap,
            ),
            sizes.pageHorizontalPadding,
          ),
        const HyperText('显式关闭线条'),
        const HyperDivider(line: HyperLine.none()),
        HyperCard(
          style: HyperCardStyle(border: const HyperLine.none().toBorder()),
          child: const HyperText('无轮廓'),
        ),
      ],
    );
  }

  List<Widget> _preview(
    HyperLinePattern pattern,
    HyperLine line,
    double spacing,
  ) => [
    SizedBox(height: spacing),
    HyperText(switch (pattern) {
      HyperLinePattern.solid => '实线',
      HyperLinePattern.dashed => '虚线',
      HyperLinePattern.dotted => '点线',
    }),
    SizedBox(height: spacing),
    HyperDivider(line: line),
    SizedBox(height: spacing),
    HyperCard(
      style: HyperCardStyle(
        border: line.toBorder(),
        padding: EdgeInsets.all(spacing),
      ),
      child: const HyperText('使用同一条线的卡片轮廓（实例样式）'),
    ),
  ];
}
