import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 展示 HyperRadio 的分组选择、取消选择和禁用状态。
class HyperRadioPage extends StatefulWidget {
  const HyperRadioPage({super.key});

  @override
  State<HyperRadioPage> createState() => _HyperRadioPageState();
}

class _HyperRadioPageState extends State<HyperRadioPage> {
  String? _value = '标准';
  String? _circleValue = '桌面';
  String? _filledValue = '清晰';

  @override
  Widget build(BuildContext context) {
    final colors = HyperTheme.of(context).colors;
    return Material(
      color: colors.background,
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: HyperTheme.sizesOf(context).pageHorizontalPadding,
          vertical: 24,
        ),
        children: [
          Text('HyperRadio', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('默认使用 MIUIX 勾线样式，也提供 .circle 和 .filled 变体。'),
          const SizedBox(height: 20),
          for (final option in const ['标准', '高级', '自定义'])
            HyperRadio<String>(
              value: option,
              groupValue: _value,
              semanticLabel: option,
              onChanged: (value) => setState(() => _value = value),
              child: Text(option),
            ),
          const SizedBox(height: 20),
          const Text('禁用状态'),
          const Row(
            children: [
              HyperRadio(value: 1, groupValue: 1, onChanged: null),
              HyperRadio(value: 2, groupValue: 1, onChanged: null),
            ],
          ),
          const SizedBox(height: 20),
          const Text('普通圆形变体'),
          for (final option in const ['手机', '桌面'])
            HyperRadio<String>.circle(
              value: option,
              groupValue: _circleValue,
              semanticLabel: option,
              onChanged: (value) => setState(() => _circleValue = value),
              child: Text(option),
            ),
          const SizedBox(height: 20),
          const Text('带背景变体'),
          for (final option in const ['清晰', '醒目'])
            HyperRadio<String>.filled(
              value: option,
              groupValue: _filledValue,
              semanticLabel: option,
              onChanged: (value) => setState(() => _filledValue = value),
              child: Text(option),
            ),
          const SizedBox(height: 20),
          const Text('实例样式覆盖'),
          HyperRadio<String>.circle(
            value: '自定义',
            groupValue: '自定义',
            onChanged: (_) {},
            style: HyperRadioStyle(
              selectedBackgroundColor: colors.primary.withValues(alpha: .12),
              selectedBorder: BorderSide(color: colors.primary, width: 2),
              borderRadius: BorderRadius.circular(6),
              indicatorSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}
