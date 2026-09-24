import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 并列展示普通、半透明、毛玻璃与柔光玻璃及其降级行为。
class HyperMaterialSurfacePage extends StatefulWidget {
  const HyperMaterialSurfacePage({super.key});

  @override
  State<HyperMaterialSurfacePage> createState() =>
      _HyperMaterialSurfacePageState();
}

class _HyperMaterialSurfacePageState extends State<HyperMaterialSurfacePage> {
  HyperMaterialQuality _quality = HyperMaterialQuality.advanced;
  bool _reduceTransparency = false;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    const opaqueFallback = HyperSurfaceMaterial.solid(
      background: HyperFill.color(Color(0xFFF3F3F5)),
      border: BorderSide(color: Color(0x22000000)),
    );
    final materials = <(String, HyperSurfaceMaterial)>[
      (
        '普通',
        HyperSurfaceMaterial.solid(
          background: HyperFill.color(theme.colors.surface),
          border: BorderSide(color: theme.colors.outline.withValues(alpha: .2)),
        ),
      ),
      (
        '半透明',
        const HyperSurfaceMaterial.translucent(
          background: HyperFill.color(Color(0xB3FFFFFF)),
          border: BorderSide(color: Color(0x66FFFFFF)),
        ),
      ),
      (
        '毛玻璃',
        const HyperSurfaceMaterial.frostedGlass(
          background: HyperFill.color(Color(0x70FFFFFF)),
          tint: Color(0x12FFFFFF),
          border: BorderSide(color: Color(0x88FFFFFF)),
          fallback: opaqueFallback,
        ),
      ),
      (
        '柔光玻璃',
        const HyperSurfaceMaterial.softLightGlass(
          background: HyperFill.gradient(
            LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0x8AFFFFFF), Color(0x45FFE2D1)],
            ),
          ),
          tint: Color(0x10FFFFFF),
          border: BorderSide(color: Color(0xAAFFFFFF)),
          boxShadow: [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
          fallback: opaqueFallback,
        ),
      ),
    ];

    return Material(
      color: theme.colors.background,
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: HyperTheme.sizesOf(context).pageHorizontalPadding,
          vertical: 24,
        ),
        children: [
          Text('表面材质', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('材质只改变背景合成，不改变控件尺寸。普通质量和减少透明度都会让玻璃使用明确 fallback。'),
          const SizedBox(height: 16),
          SegmentedButton<HyperMaterialQuality>(
            segments: const [
              ButtonSegment(
                value: HyperMaterialQuality.standard,
                label: Text('普通质量'),
              ),
              ButtonSegment(
                value: HyperMaterialQuality.advanced,
                label: Text('高级材质'),
              ),
            ],
            selected: {_quality},
            onSelectionChanged: (value) =>
                setState(() => _quality = value.single),
          ),
          Row(
            children: [
              const Expanded(child: Text('减少透明度')),
              HyperSwitch(
                value: _reduceTransparency,
                onChanged: (value) =>
                    setState(() => _reduceTransparency = value),
              ),
            ],
          ),
          Text(
            '当前：${_quality == HyperMaterialQuality.advanced ? '高级材质' : '普通质量'} · ${_reduceTransparency ? '已降级' : '正常透明度'}',
            key: const Key('material-status'),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFF8A45),
                  Color(0xFF7E57C2),
                  Color(0xFF42A5F5),
                ],
              ),
            ),
            child: HyperMaterialTheme(
              data: HyperMaterialThemeData(
                quality: _quality,
                reduceTransparency: _reduceTransparency,
              ),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final item in materials)
                    HyperMaterialSurface(
                      key: ValueKey('material-${item.$1}'),
                      material: item.$2,
                      width: 180,
                      height: 112,
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.bottomLeft,
                      borderRadius: BorderRadius.circular(24),
                      child: Text(
                        item.$1,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF202124),
                        ),
                      ),
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
