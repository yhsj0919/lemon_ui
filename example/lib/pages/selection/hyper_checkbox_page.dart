import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 展示 HyperCheckbox 的三种值和禁用状态。
class HyperCheckboxPage extends StatefulWidget {
  const HyperCheckboxPage({super.key});

  @override
  State<HyperCheckboxPage> createState() => _HyperCheckboxPageState();
}

class _HyperCheckboxPageState extends State<HyperCheckboxPage> {
  bool? _value = false;

  @override
  Widget build(BuildContext context) {
    final colors = HyperTheme.of(context).colors;
    return Material(
      color: colors.background,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'HyperCheckbox',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('点击后按未选中、选中、半选中的顺序循环。'),
          const SizedBox(height: 20),
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
          const SizedBox(height: 20),
          Text('圆角矩形变体', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
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
    );
  }
}
