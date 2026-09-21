import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 可交互查看语义色、种子色和亮暗模式的演示页。
class HyperColorSchemePage extends StatefulWidget {
  const HyperColorSchemePage({super.key});

  @override
  State<HyperColorSchemePage> createState() => _HyperColorSchemePageState();
}

class _HyperColorSchemePageState extends State<HyperColorSchemePage> {
  static const _seeds = <String, Color>{
    '蓝色': Color(0xFF3482FF),
    '小米橙': Color(0xFFFF6900),
    '紫色': Color(0xFF7E57C2),
    '绿色': Color(0xFF2E7D32),
  };

  String _seedName = _seeds.keys.first;
  Brightness _brightness = Brightness.light;

  @override
  Widget build(BuildContext context) {
    final seed = _seeds[_seedName]!;
    final scheme = HyperColorScheme.fromSeed(
      seedColor: seed,
      brightness: _brightness,
    );

    return ColoredBox(
      color: scheme.background,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            '语义颜色',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: scheme.onBackground,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '切换种子色和亮暗模式，观察完整颜色方案。',
            style: TextStyle(color: scheme.onBackground),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SegmentedButton<Brightness>(
                segments: const [
                  ButtonSegment(
                    value: Brightness.light,
                    label: Text('亮色'),
                    icon: Icon(Icons.light_mode_outlined),
                  ),
                  ButtonSegment(
                    value: Brightness.dark,
                    label: Text('暗色'),
                    icon: Icon(Icons.dark_mode_outlined),
                  ),
                ],
                selected: {_brightness},
                onSelectionChanged: (value) {
                  setState(() => _brightness = value.single);
                },
              ),
              for (final entry in _seeds.entries)
                ChoiceChip(
                  label: Text(entry.key),
                  selected: entry.key == _seedName,
                  avatar: CircleAvatar(backgroundColor: entry.value),
                  onSelected: (_) => setState(() => _seedName = entry.key),
                ),
            ],
          ),
          const SizedBox(height: 24),
          _RealPagePreview(scheme: scheme),
          const SizedBox(height: 24),
          _ColorGrid(scheme: scheme),
        ],
      ),
    );
  }
}

/// 用真实系统页面的层级关系验证颜色语义，而不是复刻具体业务页面。
class _RealPagePreview extends StatelessWidget {
  const _RealPagePreview({required this.scheme});

  final HyperColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.outline),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.arrow_back, color: scheme.textPrimary),
                const SizedBox(height: 28),
                Text(
                  '合并重复联系人',
                  style: TextStyle(
                    color: scheme.textPrimary,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  '系统将帮助您查找与合并重复的联系人。',
                  style: TextStyle(color: scheme.textSecondary, fontSize: 16),
                ),
              ],
            ),
          ),
          Positioned.fill(child: ColoredBox(color: scheme.scrim)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
              decoration: BoxDecoration(
                color: scheme.surfaceElevated,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '退出合并',
                    style: TextStyle(
                      color: scheme.onSurfaceElevated,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '是否要退出联系人合并？',
                    style: TextStyle(color: scheme.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _PreviewAction(
                          label: '取消',
                          background: scheme.surfaceMuted,
                          foreground: scheme.onSurfaceMuted,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PreviewAction(
                          label: '确定',
                          background: scheme.primary,
                          foreground: scheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewAction extends StatelessWidget {
  const _PreviewAction({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(label, style: TextStyle(color: foreground, fontSize: 17)),
    );
  }
}

class _ColorGrid extends StatelessWidget {
  const _ColorGrid({required this.scheme});

  final HyperColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final colors = <(String, Color, Color)>[
      ('primary', scheme.primary, scheme.onPrimary),
      ('onPrimary', scheme.onPrimary, scheme.primary),
      ('primaryContainer', scheme.primaryContainer, scheme.onPrimaryContainer),
      ('background', scheme.background, scheme.onBackground),
      ('onBackground', scheme.onBackground, scheme.background),
      ('surface', scheme.surface, scheme.onSurface),
      ('onSurface', scheme.onSurface, scheme.surface),
      ('surfaceElevated', scheme.surfaceElevated, scheme.onSurfaceElevated),
      ('surfaceMuted', scheme.surfaceMuted, scheme.onSurfaceMuted),
      ('textPrimary', scheme.textPrimary, scheme.background),
      ('textSecondary', scheme.textSecondary, scheme.background),
      ('textTertiary', scheme.textTertiary, scheme.background),
      ('outline', scheme.outline, scheme.background),
      ('scrim', scheme.scrim, Colors.white),
      ('disabled', scheme.disabled, scheme.background),
      ('error', scheme.error, scheme.onError),
      ('onError', scheme.onError, scheme.error),
      ('success', scheme.success, scheme.onSuccess),
      ('onSuccess', scheme.onSuccess, scheme.success),
      ('warning', scheme.warning, scheme.onWarning),
      ('onWarning', scheme.onWarning, scheme.warning),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900
            ? 4
            : constraints.maxWidth >= 560
            ? 3
            : 2;
        const spacing = 12.0;
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final color in colors)
              SizedBox(
                width: width,
                child: _ColorTile(
                  name: color.$1,
                  color: color.$2,
                  foreground: color.$3,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ColorTile extends StatelessWidget {
  const _ColorTile({
    required this.name,
    required this.color,
    required this.foreground,
  });

  final String name;
  final Color color;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final hex = color
        .toARGB32()
        .toRadixString(16)
        .padLeft(8, '0')
        .toUpperCase();

    return Container(
      height: 104,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: foreground.withValues(alpha: 0.22)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            name,
            style: TextStyle(color: foreground, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text('#$hex', style: TextStyle(color: foreground)),
        ],
      ),
    );
  }
}
