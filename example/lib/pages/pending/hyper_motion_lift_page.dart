import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

@Preview(name: '悬停上浮', group: '未确认', size: Size(420, 800))
Widget motionLiftPreview() => MaterialApp(
  home: HyperTheme(
    data: HyperThemeData.light(),
    child: const Scaffold(body: HyperMotionLiftPage()),
  ),
);

class HyperMotionLiftPage extends StatefulWidget {
  const HyperMotionLiftPage({super.key});
  @override
  State<HyperMotionLiftPage> createState() => _HyperMotionLiftPageState();
}

class _HyperMotionLiftPageState extends State<HyperMotionLiftPage> {
  final _states = WidgetStatesController();
  int _clicks = 0;
  String _fixedState = 'live';
  @override
  void dispose() {
    _states.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HyperText('悬停上浮', variant: HyperTextVariant.pageTitle),
        const HyperText('默认悬停上移 2、缩放 1.008 并带阴影；按下回压。鼠标、触屏和子控件键盘焦点均可使用。'),
        DemoSection(
          title: '默认主题 · 真实交互',
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: HyperMotion.lift(
              child: HyperButton.tonal(
                onPressed: () => setState(() => _clicks++),
                label: Text('点击计数 $_clicks'),
              ),
            ),
          ),
        ),
        DemoSection(
          title: '默认主题 · 固定状态对照',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HyperSelect<String>(
                value: _fixedState,
                options: const [
                  HyperSelectOption(value: 'live', label: '无固定状态'),
                  HyperSelectOption(value: 'hovered', label: '悬停'),
                  HyperSelectOption(value: 'pressed', label: '按下'),
                ],
                onChanged: (value) {
                  setState(() => _fixedState = value ?? 'live');
                  _states.update(WidgetState.hovered, value == 'hovered');
                  _states.update(WidgetState.pressed, value == 'pressed');
                },
              ),
              const SizedBox(height: 24),
              IgnorePointer(
                ignoring: _fixedState != 'live',
                child: HyperMotion.lift(
                  statesController: _states,
                  child: const HyperCard(child: Text('卡片内容保持布局尺寸，动效只改变绘制。')),
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: '实例 Style 覆盖 · 仅上移，无缩放或阴影',
          child: HyperMotion.lift(
            style: const HyperLiftStyle(
              hoverScale: 1,
              pressedScale: 1,
              hoverShadows: [],
            ),
            child: HyperButton.outlined(
              onPressed: () {},
              label: const Text('悬停查看'),
            ),
          ),
        ),
        DemoSection(
          title: '禁用动效包装',
          child: HyperMotion.lift(
            enabled: false,
            child: HyperButton.tonal(
              onPressed: () {},
              label: const Text('点击功能仍由子控件负责'),
            ),
          ),
        ),
      ],
    ),
  );
}
