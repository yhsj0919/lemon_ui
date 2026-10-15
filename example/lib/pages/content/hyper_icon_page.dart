import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

/// 图标主题预览与明确标记的局部、实例覆盖。
class HyperIconPage extends StatelessWidget {
  const HyperIconPage({super.key});

  @override
  Widget build(BuildContext context) => Material(
    color: HyperTheme.of(context).colors.background,
    child: ListView(
      padding: EdgeInsets.all(
        HyperTheme.sizesOf(context).pageHorizontalPadding,
      ),
      children: [
        const HyperText('HyperIcon', variant: HyperTextVariant.pageTitle),
        const HyperText('默认示例直接继承图标主题，局部和实例覆盖单独展示。'),
        const DemoSection(
          title: '默认主题预览',
          child: Wrap(
            spacing: 24,
            runSpacing: 20,
            children: [
              HyperIcon(
                Icons.favorite,
                key: Key('icon-theme-preview'),
                semanticLabel: '收藏',
              ),
              HyperIcon(Icons.settings),
              HyperIcon(Icons.star),
              HyperIcon.widget(Icon(Icons.bolt), semanticLabel: '自定义图标内容'),
            ],
          ),
        ),
        const DemoSection(
          title: '实例与局部主题覆盖（显式设置）',
          child: Wrap(
            spacing: 24,
            runSpacing: 20,
            children: [
              HyperIcon(Icons.settings, size: 32),
              HyperIcon(
                Icons.star,
                color: Color(0xFFFF9500),
                size: 36,
                fill: 1,
              ),
              HyperIconTheme(
                data: HyperIconThemeData(
                  style: HyperIconStyle(
                    color: HyperStateValue.all(Color(0xFF7A4DFF)),
                    size: HyperStateValue.all(28),
                  ),
                ),
                child: HyperIcon(Icons.auto_awesome),
              ),
              HyperIcon.widget(
                Icon(Icons.bolt),
                size: 30,
                color: Color(0xFF00A870),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
