import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperNumberInputPage extends StatefulWidget {
  const HyperNumberInputPage({super.key});
  @override
  State<HyperNumberInputPage> createState() => _HyperNumberInputPageState();
}

class _HyperNumberInputPageState extends State<HyperNumberInputPage> {
  double? count, price = 1.25;
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    children: [
      const HyperText('数字输入 · 未确认。输入框与步进按钮继承现有主题；上下键调整，失焦整理输入。'),
      DemoSection(
        title: '默认 · 空值和清空',
        child: HyperNumberInput(
          value: count,
          onChanged: (v) => setState(() => count = v),
          hintText: '输入数量',
          showClearButton: true,
        ),
      ),
      DemoSection(
        title: '范围 0–10 · 步长 0.25 · 两位小数',
        child: HyperNumberInput(
          value: price,
          minimum: 0,
          maximum: 10,
          step: .25,
          precision: 2,
          onChanged: (v) => setState(() => price = v),
        ),
      ),
      DemoSection(
        title: '禁用',
        child: HyperNumberInput(value: 10, onChanged: null),
      ),
      DemoSection(
        title: '只读',
        child: HyperNumberInput(value: 20, onChanged: (_) {}, readOnly: true),
      ),
    ],
  );
}
