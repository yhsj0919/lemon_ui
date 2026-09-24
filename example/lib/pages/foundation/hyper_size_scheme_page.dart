import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 可视化比较四类终端的明确尺寸方案。
class HyperSizeSchemePage extends StatefulWidget {
  const HyperSizeSchemePage({super.key});

  @override
  State<HyperSizeSchemePage> createState() => _HyperSizeSchemePageState();
}

class _HyperSizeSchemePageState extends State<HyperSizeSchemePage> {
  HyperDeviceType _deviceType = HyperDeviceType.phone;

  @override
  Widget build(BuildContext context) {
    const sizeTheme = HyperSizeThemeData();
    final sizes = sizeTheme.resolve(_deviceType);
    final theme = HyperThemeData.light(sizes: sizeTheme);

    return HyperDeviceDetector(
      deviceType: _deviceType,
      builder: (context, _, _) => HyperTheme(
        data: theme,
        child: Material(
          color: theme.colors.background,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: sizes.pageHorizontalPadding,
              vertical: 24,
            ),
            children: [
              Text('尺寸系统', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              const Text('四套方案使用明确数值，切换终端不会应用倍率缩放。'),
              const SizedBox(height: 20),
              SegmentedButton<HyperDeviceType>(
                segments: const [
                  ButtonSegment(
                    value: HyperDeviceType.phone,
                    label: Text('手机'),
                  ),
                  ButtonSegment(
                    value: HyperDeviceType.tablet,
                    label: Text('平板'),
                  ),
                  ButtonSegment(
                    value: HyperDeviceType.desktop,
                    label: Text('桌面'),
                  ),
                  ButtonSegment(
                    value: HyperDeviceType.watch,
                    label: Text('手表'),
                  ),
                ],
                selected: {_deviceType},
                onSelectionChanged: (value) {
                  setState(() => _deviceType = value.single);
                },
              ),
              SizedBox(height: sizes.sectionSpacing),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _ValueCard(label: '通用 md 高度', value: sizes.controlHeightMd),
                  _ValueCard(label: '控件圆角', value: sizes.controlRadius),
                  _ValueCard(
                    label: '最小命中区',
                    value: sizes.minimumInteractiveDimension,
                  ),
                  _ValueCard(label: '页面边距', value: sizes.pageHorizontalPadding),
                  _ValueCard(label: '默认图标', value: sizes.iconSize),
                  _ValueCard(label: '工具栏', value: sizes.toolbarHeight),
                ],
              ),
              SizedBox(height: sizes.sectionSpacing),
              Text('通用高度参考', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              const Text('用于没有专属规格的控件；按钮等组件使用各自的尺寸。'),
              const SizedBox(height: 12),
              for (final item in <(String, double)>[
                ('xs', sizes.controlHeightXs),
                ('sm', sizes.controlHeightSm),
                ('md', sizes.controlHeightMd),
                ('lg', sizes.controlHeightLg),
                ('xl', sizes.controlHeightXl),
              ]) ...[
                _HeightMeasure(label: item.$1, height: item.$2),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 16),
              Text('视觉尺寸与命中区域', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Center(
                child: Container(
                  key: const Key('hit-target-preview'),
                  width: sizes.minimumInteractiveDimension,
                  height: sizes.minimumInteractiveDimension,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colors.outline),
                    borderRadius: BorderRadius.circular(sizes.controlRadius),
                  ),
                  child: Container(
                    key: const Key('visual-control-preview'),
                    width: sizes.iconSize,
                    height: sizes.iconSize,
                    decoration: BoxDecoration(
                      color: theme.colors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValueCard extends StatelessWidget {
  const _ValueCard({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    return Container(
      width: 132,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colors.surface,
        borderRadius: BorderRadius.circular(sizes.surfaceRadius),
        border: Border.all(color: theme.colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          Text(
            value.toStringAsFixed(0),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}

class _HeightMeasure extends StatelessWidget {
  const _HeightMeasure({required this.label, required this.height});

  final String label;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    return Row(
      children: [
        SizedBox(width: 28, child: Text(label)),
        const SizedBox(width: 8),
        // 刻度线的高度对应主题数值，仅展示测量，不模拟可点击控件。
        SizedBox(
          key: ValueKey('height-$label'),
          width: 20,
          height: height,
          child: Column(
            children: [
              Container(
                width: 12,
                height: 1,
                color: theme.colors.textSecondary,
              ),
              Expanded(
                child: Container(width: 1, color: theme.colors.textSecondary),
              ),
              Container(
                width: 12,
                height: 1,
                color: theme.colors.textSecondary,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text('${height.toStringAsFixed(0)} dp'),
      ],
    );
  }
}
