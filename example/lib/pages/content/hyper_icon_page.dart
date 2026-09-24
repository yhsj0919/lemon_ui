import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 展示 HyperIcon 的设备尺寸、状态样式和三层主题覆盖。
class HyperIconPage extends StatefulWidget {
  const HyperIconPage({super.key});

  @override
  State<HyperIconPage> createState() => _HyperIconPageState();
}

class _HyperIconPageState extends State<HyperIconPage> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    final parent = HyperTheme.of(context);
    final globalIconTheme = HyperIconThemeData(
      style: HyperIconStyle(
        color: HyperStateValue.fromMap(
          fallback: parent.colors.textSecondary,
          values: {HyperControlState.selected: parent.colors.primary},
        ),
      ),
    );
    final states = _selected
        ? const {HyperControlState.selected}
        : const <HyperControlState>{};

    return HyperTheme(
      data: parent.copyWith(iconTheme: globalIconTheme),
      child: Builder(
        builder: (context) => Material(
          color: HyperTheme.of(context).colors.background,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: HyperTheme.sizesOf(context).pageHorizontalPadding,
              vertical: 24,
            ),
            children: [
              const HyperText('HyperIcon', variant: HyperTextVariant.pageTitle),
              const SizedBox(height: 8),
              const HyperText('复用 Flutter 图标绘制，只统一设备尺寸、状态和主题入口。'),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(child: HyperText('选中状态')),
                  HyperSwitch(
                    value: _selected,
                    onChanged: (value) => setState(() => _selected = value),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 24,
                runSpacing: 20,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  HyperIcon(
                    Icons.favorite,
                    states: states,
                    semanticLabel: '收藏',
                  ),
                  const HyperIcon(Icons.settings, size: 32),
                  const HyperIcon(
                    Icons.star,
                    color: Color(0xFFFF9500),
                    size: 36,
                    fill: 1,
                  ),
                  HyperIconTheme(
                    data: const HyperIconThemeData(
                      style: HyperIconStyle(
                        color: HyperStateValue.all(Color(0xFF7A4DFF)),
                        size: HyperStateValue.all(28),
                      ),
                    ),
                    child: const HyperIcon(Icons.auto_awesome),
                  ),
                  const HyperIcon.widget(
                    Icon(Icons.bolt),
                    size: 30,
                    color: Color(0xFF00A870),
                    semanticLabel: '自定义图标内容',
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const HyperText('设备默认尺寸', variant: HyperTextVariant.sectionTitle),
              const SizedBox(height: 12),
              const HyperText('手机/平板 24，桌面 18，手表 20；实例尺寸始终优先。'),
            ],
          ),
        ),
      ),
    );
  }
}
