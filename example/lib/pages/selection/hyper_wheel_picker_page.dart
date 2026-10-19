import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperWheelPickerPage extends StatefulWidget {
  const HyperWheelPickerPage({super.key});
  @override
  State<HyperWheelPickerPage> createState() => _State();
}

class _State extends State<HyperWheelPickerPage> {
  int value = 5, loopingValue = 0;
  String fruit = '苹果';
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    children: [
      const HyperText('未确认：拖动、鼠标滚轮、点击相邻项或聚焦后使用上下方向键。多列联动由父组件组合。'),
      DemoSection(
        title: '默认数字滚轮 · 当前 $value',
        child: HyperWheelPicker<int>(
          items: List.generate(12, (i) => i),
          value: value,
          labelBuilder: (v) => '$v',
          onChanged: (v) => setState(() => value = v),
        ),
      ),
      DemoSection(
        title: '循环 · 当前 $loopingValue',
        child: HyperWheelPicker<int>(
          items: List.generate(10, (i) => i),
          value: loopingValue,
          looping: true,
          labelBuilder: (v) => v.toString().padLeft(2, '0'),
          onChanged: (v) => setState(() => loopingValue = v),
        ),
      ),
      DemoSection(
        title: '文字选项',
        child: HyperWheelPicker<String>(
          items: const ['苹果', '橙子', '桃子', '西瓜', '葡萄'],
          value: fruit,
          labelBuilder: (v) => v,
          onChanged: (v) => setState(() => fruit = v),
        ),
      ),
      DemoSection(
        title: '外部受控更新',
        child: HyperButton.tonal(
          label: const Text('将数字滚轮设为 0'),
          onPressed: () => setState(() => value = 0),
        ),
      ),
      DemoSection(
        title: '禁用',
        child: HyperWheelPicker<int>(
          items: const [0, 1, 2, 3, 4],
          value: 2,
          labelBuilder: (v) => '$v',
          onChanged: null,
        ),
      ),
    ],
  );
}
