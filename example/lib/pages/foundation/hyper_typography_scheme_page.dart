import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 展示语义字号及全局精确覆盖效果。
class HyperTypographySchemePage extends StatefulWidget {
  const HyperTypographySchemePage({super.key});

  @override
  State<HyperTypographySchemePage> createState() =>
      _HyperTypographySchemePageState();
}

class _HyperTypographySchemePageState extends State<HyperTypographySchemePage> {
  bool _useLargeBody = false;

  @override
  Widget build(BuildContext context) {
    final parent = HyperTheme.of(context);
    final typography = parent.typography.copyWith(
      body: _useLargeBody ? 18 : 16,
    );
    final theme = parent.copyWith(typography: typography);

    return HyperTheme(
      data: theme,
      child: Builder(
        builder: (context) {
          final text = Theme.of(context).textTheme;
          final colors = HyperTheme.of(context).colors;
          return ColoredBox(
            color: colors.background,
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: HyperTheme.sizesOf(context).pageHorizontalPadding,
                vertical: 24,
              ),
              children: [
                Text('字号规范', style: text.headlineSmall),
                const SizedBox(height: 8),
                Text('每一级都是明确逻辑字号，不使用倍率缩放。', style: text.bodyMedium),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(child: Text('全局正文改为 18')),
                    HyperSwitch(
                      value: _useLargeBody,
                      onChanged: (value) =>
                          setState(() => _useLargeBody = value),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _sample('超大展示 · 48', text.displayLarge),
                _sample('大展示 · 40', text.displayMedium),
                _sample('小展示 · 36', text.displaySmall),
                _sample('页面标题 · 32', text.headlineLarge),
                _sample('区块标题 · 24', text.headlineMedium),
                _sample('小节标题 · 20', text.headlineSmall),
                _sample('强调正文 · 18', text.bodyLarge),
                _sample(
                  '正文 · ${typography.body.toStringAsFixed(0)}',
                  text.bodyMedium,
                ),
                _sample('辅助正文 · 14', text.bodySmall),
                _sample('控件文字 · 16', text.labelLarge),
                _sample('标签 · 14', text.labelMedium),
                _sample('注释 · 12', text.labelSmall),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sample(String label, TextStyle? style) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(label, style: style),
  );
}
