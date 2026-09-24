import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 在按钮本体实现前，先展示按钮公共样式、六种变体和局部主题覆盖。
class HyperButtonThemePage extends StatefulWidget {
  const HyperButtonThemePage({super.key});

  @override
  State<HyperButtonThemePage> createState() => _HyperButtonThemePageState();
}

class _HyperButtonThemePageState extends State<HyperButtonThemePage> {
  bool _useLocalTheme = false;

  @override
  Widget build(BuildContext context) {
    final colors = HyperTheme.of(context).colors;
    final base = HyperButtonThemeData(
      style: HyperButtonStyle(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        borderRadius: BorderRadius.circular(16),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        iconSize: 20,
        iconSpacing: 8,
        animationDuration: const Duration(milliseconds: 240),
      ),
      filled: HyperButtonStyle(
        background: HyperFill.color(colors.primary),
        foregroundColor: colors.onPrimary,
      ),
      tonal: HyperButtonStyle(
        background: HyperFill.color(colors.surface),
        foregroundColor: colors.onSurface,
      ),
      outlined: HyperButtonStyle(
        background: const HyperFill.none(),
        foregroundColor: colors.primary,
        border: BorderSide(color: colors.outline),
      ),
      ghost: HyperButtonStyle(
        background: const HyperFill.none(),
        foregroundColor: colors.onBackground,
      ),
      text: HyperButtonStyle(
        background: const HyperFill.none(),
        foregroundColor: colors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      gradient: HyperButtonStyle(
        background: const HyperFill.gradient(
          LinearGradient(colors: [Color(0xFFFF6900), Color(0xFFFF3D71)]),
        ),
        foregroundColor: Colors.white,
      ),
    );
    final local = HyperButtonThemeData(
      outlined: HyperButtonStyle(
        foregroundColor: Colors.purple,
        border: const BorderSide(color: Colors.purple, width: 2),
        borderRadius: BorderRadius.circular(24),
      ),
    );

    Widget content = _PreviewGrid(localEnabled: _useLocalTheme);
    if (_useLocalTheme) {
      content = HyperButtonTheme(data: local, child: content);
    }
    content = HyperButtonTheme(data: base, child: content);
    return Material(
      color: colors.background,
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: HyperTheme.sizesOf(context).pageHorizontalPadding,
          vertical: 24,
        ),
        children: [
          Text('按钮样式与主题', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('同一个样式类型同时服务公共属性、变体属性和局部主题。当前预览仅展示视觉，不包含按钮行为。'),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(child: Text('启用局部 outlined 覆盖')),
              HyperSwitch(
                value: _useLocalTheme,
                onChanged: (value) => setState(() => _useLocalTheme = value),
              ),
            ],
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }
}

class _PreviewGrid extends StatelessWidget {
  const _PreviewGrid({required this.localEnabled});

  final bool localEnabled;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        localEnabled ? '局部 outlined：紫色' : '使用公共按钮主题',
        key: const Key('button-theme-status'),
      ),
      const SizedBox(height: 16),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: const [
          _StylePreview(HyperButtonVariant.filled, 'filled'),
          _StylePreview(HyperButtonVariant.tonal, 'tonal'),
          _StylePreview(HyperButtonVariant.outlined, 'outlined'),
          _StylePreview(HyperButtonVariant.ghost, 'ghost'),
          _StylePreview(HyperButtonVariant.text, 'text'),
          _StylePreview(HyperButtonVariant.gradient, 'gradient'),
        ],
      ),
    ],
  );
}

class _StylePreview extends StatelessWidget {
  const _StylePreview(this.variant, this.label);

  final HyperButtonVariant variant;
  final String label;

  @override
  Widget build(BuildContext context) {
    final style = HyperButtonTheme.of(context).resolve(variant);
    final fill = style.background;
    final decoration = BoxDecoration(
      color: fill?.color,
      gradient: fill?.gradient,
      border: style.border == null || style.border == BorderSide.none
          ? null
          : Border.fromBorderSide(style.border!),
      borderRadius: style.borderRadius,
      boxShadow: style.boxShadow,
    );
    return Container(
      key: ValueKey('button-style-$label'),
      width: style.width,
      height: style.height,
      constraints: BoxConstraints(
        minWidth: style.minimumSize?.width ?? 108,
        minHeight: style.minimumSize?.height ?? 0,
      ),
      padding: style.padding,
      alignment: style.alignment ?? Alignment.center,
      decoration: decoration,
      child: Text(
        label,
        style:
            style.textStyle?.copyWith(color: style.foregroundColor) ??
            TextStyle(color: style.foregroundColor),
      ),
    );
  }
}
