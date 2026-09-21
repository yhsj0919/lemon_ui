import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 可交互查看多个状态同时存在时的统一解析结果。
class HyperStateValuePage extends StatefulWidget {
  const HyperStateValuePage({super.key});

  @override
  State<HyperStateValuePage> createState() => _HyperStateValuePageState();
}

class _HyperStateValuePageState extends State<HyperStateValuePage> {
  final Set<HyperControlState> _states = {};

  static final _background = HyperStateValue<Color>.fromMap(
    fallback: const Color(0xFFFFE4D1),
    values: const {
      HyperControlState.hovered: Color(0xFFFFCCAA),
      HyperControlState.focused: Color(0xFFFFB77A),
      HyperControlState.selected: Color(0xFF90CAF9),
      HyperControlState.dragged: Color(0xFF80CBC4),
      HyperControlState.pressed: Color(0xFFFF6900),
      HyperControlState.tertiaryPressed: Color(0xFF26A69A),
      HyperControlState.secondaryPressed: Color(0xFF5C6BC0),
      HyperControlState.longPressed: Color(0xFF8D6E63),
      HyperControlState.success: Color(0xFF66BB6A),
      HyperControlState.error: Color(0xFFEF5350),
      HyperControlState.loading: Color(0xFF7E57C2),
      HyperControlState.disabled: Color(0xFFBDBDBD),
    },
  );

  static final _label = HyperStateValue<String>.fromMap(
    fallback: '默认',
    values: const {
      HyperControlState.hovered: '悬停',
      HyperControlState.focused: '聚焦',
      HyperControlState.selected: '选中',
      HyperControlState.dragged: '拖动',
      HyperControlState.pressed: '按压',
      HyperControlState.tertiaryPressed: '中键按压',
      HyperControlState.secondaryPressed: '右键按压',
      HyperControlState.longPressed: '长按',
      HyperControlState.success: '成功',
      HyperControlState.error: '错误',
      HyperControlState.loading: '加载',
      HyperControlState.disabled: '禁用',
    },
  );

  @override
  Widget build(BuildContext context) {
    final color = _background.resolve(_states);
    final label = _label.resolve(_states);
    final highest = HyperControlState.highestOf(_states);

    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('控件状态解析', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('可以同时启用多个状态；最终样式始终按统一优先级解析。'),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final state in HyperControlState.values)
                FilterChip(
                  label: Text(_stateName(state)),
                  selected: _states.contains(state),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _states.add(state);
                      } else {
                        _states.remove(state);
                      }
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 24),
          AnimatedContainer(
            key: const Key('state-preview'),
            height: 120,
            alignment: Alignment.center,
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              key: const Key('resolved-state-label'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),
          Text('最高优先级：${highest == null ? '无' : _stateName(highest)}'),
          const SizedBox(height: 8),
          const Text(
            '禁用 > 加载 > 错误 > 成功 > 长按 > 右键按压 > 中键按压 > 按压 > 拖动 > 选中 > 聚焦 > 悬停',
          ),
        ],
      ),
    );
  }

  String _stateName(HyperControlState state) => switch (state) {
    HyperControlState.hovered => '悬停',
    HyperControlState.focused => '聚焦',
    HyperControlState.selected => '选中',
    HyperControlState.dragged => '拖动',
    HyperControlState.pressed => '按压',
    HyperControlState.tertiaryPressed => '中键按压',
    HyperControlState.secondaryPressed => '右键按压',
    HyperControlState.longPressed => '长按',
    HyperControlState.success => '成功',
    HyperControlState.error => '错误',
    HyperControlState.loading => '加载',
    HyperControlState.disabled => '禁用',
  };
}
