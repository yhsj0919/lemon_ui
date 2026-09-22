import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 展示开关状态、设备尺寸、局部主题和拖动交互。
class HyperSwitchPage extends StatefulWidget {
  const HyperSwitchPage({super.key});
  @override
  State<HyperSwitchPage> createState() => _HyperSwitchPageState();
}

class _HyperSwitchPageState extends State<HyperSwitchPage> {
  bool _enabled = true;
  bool _custom = false;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('HyperSwitch', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            '点击、键盘与拖动共用一套状态。当前 ${HyperTheme.sizesOf(context).deviceType.name} '
            '使用独立尺寸；手机参考 MIUIX 并修正为偶数48×28，桌面采用舒适44×24。',
          ),
          const SizedBox(height: 24),
          _row('关闭', HyperSwitch(value: false, onChanged: (_) {})),
          _row('开启', HyperSwitch(value: true, onChanged: (_) {})),
          _row('禁用关闭', const HyperSwitch(value: false, onChanged: null)),
          _row('禁用开启', const HyperSwitch(value: true, onChanged: null)),
          _row(
            '可交互',
            HyperSwitch(
              key: const Key('interactive-switch'),
              value: _enabled,
              onChanged: (value) => setState(() => _enabled = value),
            ),
          ),
          const SizedBox(height: 24),
          Text('局部主题', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          HyperSwitchTheme(
            data: HyperSwitchThemeData(
              style: HyperSwitchStyle(
                activeTrackColor: theme.colors.success,
                width: 52,
                height: 28,
                thumbSize: 24,
                uncheckedThumbOffset: 3,
                checkedThumbOffset: 25,
              ),
            ),
            child: _row(
              '绿色明确尺寸',
              HyperSwitch(
                value: _custom,
                onChanged: (value) => setState(() => _custom = value),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, Widget control) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        control,
      ],
    ),
  );
}
