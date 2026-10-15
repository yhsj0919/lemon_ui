import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperScrollingTextPage extends StatefulWidget {
  const HyperScrollingTextPage({super.key});
  @override
  State<HyperScrollingTextPage> createState() => _HyperScrollingTextPageState();
}

class _HyperScrollingTextPageState extends State<HyperScrollingTextPage> {
  bool _hover = false;
  bool _loop = false;
  int _speed = 40;
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    children: [
      const HyperText(
        'HyperText.scrolling',
        variant: HyperTextVariant.pageTitle,
      ),
      const HyperText('单行溢出才滚动；支持自动或悬停触发。'),
      DemoSection(
        title: '交互设置（实例覆盖）',
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(child: HyperText('仅鼠标悬停时滚动')),
                HyperSwitch(
                  value: _hover,
                  onChanged: (v) => setState(() => _hover = v),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: HyperText('滚动速度：$_speed 逻辑像素/秒')),
                HyperButton.text(
                  label: const Text('减慢'),
                  onPressed: () =>
                      setState(() => _speed = (_speed - 10).clamp(10, 200)),
                ),
                HyperButton.text(
                  label: const Text('加快'),
                  onPressed: _speed < 200
                      ? () => setState(
                          () => _speed = (_speed + 10).clamp(10, 200),
                        )
                      : null,
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(child: HyperText('单向循环（跑马灯）')),
                HyperSwitch(
                  value: _loop,
                  onChanged: (v) => setState(() => _loop = v),
                ),
              ],
            ),
            SizedBox(
              width: 240,
              child: HyperText.scrolling(
                '这是一段超出容器宽度的单行文字，滚动到末尾后会返回起点。',
                trigger: _hover
                    ? HyperTextScrollTrigger.hover
                    : HyperTextScrollTrigger.automatic,
                mode: _loop
                    ? HyperTextScrollMode.loop
                    : HyperTextScrollMode.pingPong,
                speed: _speed.toDouble(),
              ),
            ),
          ],
        ),
      ),
      const DemoSection(
        title: '默认主题预览',
        child: SizedBox(
          width: 240,
          child: HyperText.scrolling('默认主题文字自动滚动，完整内容可以逐段阅读。'),
        ),
      ),
      const DemoSection(
        title: '内容未溢出时保持静止',
        child: SizedBox(width: 240, child: HyperText.scrolling('短文字')),
      ),
      const DemoSection(
        title: '单向循环 · 跑马灯',
        child: SizedBox(
          width: 240,
          child: HyperText.scrolling(
            '文字首尾衔接，持续向同一方向滚动。',
            mode: HyperTextScrollMode.loop,
          ),
        ),
      ),
      const DemoSection(
        title: '悬停触发',
        child: SizedBox(
          width: 240,
          child: HyperText.scrolling(
            '鼠标移入后开始滚动，移开后复位，再移入从头开始。',
            trigger: HyperTextScrollTrigger.hover,
          ),
        ),
      ),
    ],
  );
}
