import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperGlobalMessagePage extends StatefulWidget {
  const HyperGlobalMessagePage({super.key});

  @override
  State<HyperGlobalMessagePage> createState() => _HyperGlobalMessagePageState();
}

class _HyperGlobalMessagePageState extends State<HyperGlobalMessagePage> {
  final _messages = HyperMessages();
  var _presentation = HyperMessagePresentation.toast;

  @override
  void dispose() {
    _messages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HyperMessageHost(
    messages: _messages,
    child: ListView(
      padding: EdgeInsets.all(
        HyperTheme.sizesOf(context).pageHorizontalPadding,
      ),
      children: [
        const HyperText('全局消息 · 未确认。统一调用切换呈现，复用当前主题与材质。Demo 使用独立实例。'),
        DemoSection(
          title: '默认主题 · 消息呈现',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HyperSelect<HyperMessagePresentation>(
                value: _presentation,
                options: const [
                  HyperSelectOption(
                    value: HyperMessagePresentation.toast,
                    label: 'Toast · 轻提示',
                  ),
                  HyperSelectOption(
                    value: HyperMessagePresentation.snackbar,
                    label: 'Snackbar · 操作提示',
                  ),
                  HyperSelectOption(
                    value: HyperMessagePresentation.notification,
                    label: '通知卡片',
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _presentation = value);
                  _messages.presentation = value;
                },
              ),
              HyperButton.filled(
                label: const Text('弹出消息'),
                onPressed: () => _messages.show(
                  content: const Text('操作已完成'),
                  title: const Text('保存成功'),
                  icon: const Icon(Icons.check_circle_outline),
                ),
              ),
              HyperButton.text(
                label: const Text('清空消息'),
                onPressed: _messages.clear,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
