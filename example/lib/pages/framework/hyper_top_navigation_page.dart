import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

/// 顶部导航的多级、描述与主题覆盖演示。
class HyperTopNavigationPage extends StatefulWidget {
  const HyperTopNavigationPage({super.key});
  @override
  State<HyperTopNavigationPage> createState() => _HyperTopNavigationPageState();
}

class _HyperTopNavigationPageState extends State<HyperTopNavigationPage> {
  String _selected = 'overview';
  static const _items = [
    HyperMenuItem(id: 'overview', label: '概览', description: '工作区总览'),
    HyperMenuItem(
      id: 'file',
      label: '文件',
      children: [
        HyperMenuItem(id: 'new', label: '新建窗口', description: '打开一个独立工作区'),
        HyperMenuItem(
          id: 'settings',
          label: '偏好设置',
          description: '配置界面与工作方式',
          children: [
            HyperMenuItem(
              id: 'appearance',
              label: '外观',
              children: [
                HyperMenuItem(
                  id: 'light',
                  label: '亮色主题',
                  description: '适合白天使用',
                ),
                HyperMenuItem(id: 'dark', label: '暗色主题', description: '降低夜间亮度'),
              ],
            ),
            HyperMenuItem(
              id: 'shortcuts',
              label: '快捷键',
              description: '查看与修改快捷键',
            ),
          ],
        ),
        HyperMenuItem(
          id: 'unavailable',
          label: '同步设置',
          enabled: false,
          description: '当前不可用',
        ),
      ],
    ),
    HyperMenuItem(
      id: 'help',
      label: '帮助',
      children: [
        HyperMenuItem(id: 'docs', label: '文档', description: '查看组件使用手册'),
      ],
    ),
  ];
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      DemoSection(
        title: '多级导航与描述',
        child: HyperTopNavigation(
          items: _items,
          selectedId: _selected,
          onSelected: (id) => setState(() => _selected = id),
        ),
      ),
      const SizedBox(height: 16),
      HyperText('当前选择：$_selected'),
      const SizedBox(height: 16),
      DemoSection(
        title: '局部主题与实例覆盖',
        child: HyperTopNavigationTheme(
          data: HyperTopNavigationThemeData(
            style: HyperTopNavigationStyle(
              selectedItemStyle: HyperButtonStyle(
                foregroundColor: HyperTheme.of(context).colors.primary,
              ),
              menuStyle: HyperMenuStyle(
                descriptionStyle: TextStyle(
                  color: HyperTheme.of(context).colors.primary,
                ),
              ),
            ),
          ),
          child: HyperTopNavigation(
            items: _items,
            selectedId: _selected,
            style: const HyperTopNavigationStyle(itemSpacing: 12),
            onSelected: (id) => setState(() => _selected = id),
          ),
        ),
      ),
    ],
  );
}
