import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 展示全局基础主题、局部主题覆盖和 Material 同步效果。
class HyperThemePage extends StatefulWidget {
  const HyperThemePage({super.key});

  @override
  State<HyperThemePage> createState() => _HyperThemePageState();
}

class _HyperThemePageState extends State<HyperThemePage> {
  Brightness _brightness = Brightness.light;
  Color _seedColor = const Color(0xFFFF6900);

  @override
  Widget build(BuildContext context) {
    final data = HyperThemeData.fromSeed(
      seedColor: _seedColor,
      brightness: _brightness,
    );

    return HyperTheme(
      data: data,
      child: Builder(
        builder: (context) {
          final theme = HyperTheme.of(context);
          final sizes = HyperTheme.sizesOf(context);
          return Material(
            key: const Key('theme-background'),
            color: theme.colors.background,
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: HyperTheme.sizesOf(context).pageHorizontalPadding,
                vertical: 24,
              ),
              children: [
                Text('总主题', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  '这里修改全局默认值；局部作用域仍可显式覆盖，不会改动外部区域。',
                  style: TextStyle(color: theme.colors.onBackground),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SegmentedButton<Brightness>(
                      segments: const [
                        ButtonSegment(
                          value: Brightness.light,
                          label: Text('亮色'),
                        ),
                        ButtonSegment(
                          value: Brightness.dark,
                          label: Text('暗色'),
                        ),
                      ],
                      selected: {_brightness},
                      onSelectionChanged: (value) {
                        setState(() => _brightness = value.single);
                      },
                    ),
                    ChoiceChip(
                      label: const Text('小米橙'),
                      selected: _seedColor == const Color(0xFFFF6900),
                      onSelected: (_) {
                        setState(() => _seedColor = const Color(0xFFFF6900));
                      },
                    ),
                    ChoiceChip(
                      label: const Text('蓝色'),
                      selected: _seedColor == const Color(0xFF3367D6),
                      onSelected: (_) {
                        setState(() => _seedColor = const Color(0xFF3367D6));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _ThemePreview(
                  title: '全局默认值',
                  description:
                      '高度 ${sizes.controlHeightMd.toStringAsFixed(0)} · '
                      '圆角 ${sizes.controlRadius.toStringAsFixed(0)}',
                  controlKey: const Key('global-control'),
                ),
                const SizedBox(height: 16),
                HyperTheme(
                  data: theme.copyWith(
                    sizes: _replaceCurrentSizes(
                      theme.sizes,
                      sizes.copyWith(
                        controlHeightMd: 68,
                        controlRadius: 28,
                        controlPadding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  child: const _ThemePreview(
                    title: '局部显式覆盖',
                    description: '高度 68 · 圆角 28 · 内边距 28 / 16',
                    controlKey: Key('local-control'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

HyperSizeThemeData _replaceCurrentSizes(
  HyperSizeThemeData source,
  HyperSizeScheme current,
) => switch (current.deviceType) {
  HyperDeviceType.phone => source.copyWith(phone: current),
  HyperDeviceType.tablet => source.copyWith(tablet: current),
  HyperDeviceType.desktop => source.copyWith(desktop: current),
  HyperDeviceType.watch => source.copyWith(watch: current),
};

class _ThemePreview extends StatelessWidget {
  const _ThemePreview({
    required this.title,
    required this.description,
    required this.controlKey,
  });

  final String title;
  final String description;
  final Key controlKey;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colors.surface,
        borderRadius: BorderRadius.circular(sizes.controlRadius),
        border: Border.all(color: theme.colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(description),
          const SizedBox(height: 16),
          Container(
            key: controlKey,
            height: sizes.controlHeightMd,
            padding: sizes.controlPadding,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colors.primary,
              borderRadius: BorderRadius.circular(sizes.controlRadius),
            ),
            child: Text(
              '按主题绘制的区域',
              style: TextStyle(color: theme.colors.onPrimary),
            ),
          ),
          const SizedBox(height: 12),
          const FilledButton(onPressed: null, child: Text('Material 主题同步示例')),
        ],
      ),
    );
  }
}
