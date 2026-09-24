import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 展示轻量交互底座支持的常用输入方式和实时视觉状态。
class HyperPressablePage extends StatefulWidget {
  const HyperPressablePage({super.key});

  @override
  State<HyperPressablePage> createState() => _HyperPressablePageState();
}

class _HyperPressablePageState extends State<HyperPressablePage> {
  String _event = '尚未操作';
  int _count = 0;

  void _record(String event) {
    setState(() {
      _event = event;
      _count += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    return Material(
      color: theme.colors.background,
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: HyperTheme.sizesOf(context).pageHorizontalPadding,
          vertical: 24,
        ),
        children: [
          Text('统一交互入口', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('试试单击、双击、长按和鼠标右键。视觉完全由调用方组合。'),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 280,
              height: 120,
              child: HyperPressable(
                key: const Key('pressable-demo'),
                onTap: () => _record('单击'),
                onDoubleTap: () => _record('双击'),
                onLongPress: () => _record('长按'),
                onSecondaryTap: () => _record('右键'),
                mouseCursor: SystemMouseCursors.click,
                semanticLabel: '交互演示区域',
                builder: (context, states, child) {
                  final highest = HyperControlState.highestOf(states);
                  final active =
                      states.contains(HyperControlState.pressed) ||
                      states.contains(HyperControlState.longPressed) ||
                      states.contains(HyperControlState.secondaryPressed);
                  final hovered = states.contains(HyperControlState.hovered);
                  final focused = states.contains(HyperControlState.focused);
                  return AnimatedContainer(
                    duration: theme.motion.fastDuration,
                    curve: theme.motion.fastCurve,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: active
                          ? theme.colors.primary
                          : hovered
                          ? theme.colors.surface
                          : theme.colors.background,
                      border: Border.all(
                        color: focused
                            ? theme.colors.primary
                            : theme.colors.outline,
                        width: focused ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(active ? 24 : 16),
                    ),
                    child: Text(
                      highest?.name ?? '可以操作',
                      key: const Key('pressable-state'),
                      style: TextStyle(
                        color: active
                            ? theme.colors.onPrimary
                            : theme.colors.onBackground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('最近事件：$_event', key: const Key('pressable-event')),
          Text('累计事件：$_count'),
          const SizedBox(height: 24),
          const Text(
            'HyperPressable 不内置涟漪、背景或圆角，只汇总原生手势、焦点、'
            '鼠标和语义能力，按钮等上层控件可以按需组合视觉。',
          ),
        ],
      ),
    );
  }
}
