import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

/// 展示 HyperCheckbox 的三种值和禁用状态。
class HyperCheckboxPage extends StatefulWidget {
  const HyperCheckboxPage({super.key});

  @override
  State<HyperCheckboxPage> createState() => _HyperCheckboxPageState();
}

class _HyperCheckboxPageState extends State<HyperCheckboxPage> {
  bool? _value = false;
  bool? _comparisonValue = true;

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
          Text(
            'HyperCheckbox',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('点击后按未选中、选中、半选中的顺序循环。'),
          const SizedBox(height: 20),
          DemoSection(
            title: '与 Flutter 原生 Checkbox 对比',
            child: Wrap(
              spacing: HyperTheme.sizesOf(context).sectionSpacing,
              runSpacing: HyperTheme.sizesOf(context).compactSectionSpacing,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      key: const Key('native-checkbox-comparison'),
                      value: _comparisonValue,
                      tristate: true,
                      onChanged: (value) =>
                          setState(() => _comparisonValue = value),
                    ),
                    const HyperText('Flutter 原生'),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HyperCheckbox(
                      key: const Key('hyper-checkbox-comparison'),
                      value: _comparisonValue,
                      tristate: true,
                      onChanged: (value) =>
                          setState(() => _comparisonValue = value),
                    ),
                    const HyperText('Hyper 圆形'),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HyperCheckbox.rounded(
                      key: const Key('rounded-checkbox-comparison'),
                      value: _comparisonValue,
                      tristate: true,
                      onChanged: (value) =>
                          setState(() => _comparisonValue = value),
                    ),
                    const HyperText('Hyper 圆角矩形'),
                  ],
                ),
              ],
            ),
          ),
          DemoSection(
            title: '基础用法',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    HyperCheckbox(
                      value: _value,
                      tristate: true,
                      semanticLabel: '三态复选框',
                      onChanged: (value) => setState(() => _value = value),
                    ),
                    const SizedBox(width: 12),
                    Text(switch (_value) {
                      false => '未选中',
                      true => '选中',
                      null => '半选中',
                    }),
                  ],
                ),
              ],
            ),
          ),
          DemoSection(
            title: '圆角矩形变体',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 16,
                  children: [
                    HyperCheckbox.rounded(value: false, onChanged: (_) {}),
                    HyperCheckbox.rounded(value: true, onChanged: (_) {}),
                    HyperCheckbox.rounded(
                      value: null,
                      tristate: true,
                      onChanged: (_) {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Wrap(
                  spacing: 16,
                  children: [
                    HyperCheckbox(value: false, onChanged: null),
                    HyperCheckbox(value: true, onChanged: null),
                    HyperCheckbox(value: null, tristate: true, onChanged: null),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
