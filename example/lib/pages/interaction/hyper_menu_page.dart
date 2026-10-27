import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

/// 展示菜单分组、多级操作、禁用项与锚定浮层的组合。
class HyperMenuPage extends StatefulWidget {
  const HyperMenuPage({super.key});

  @override
  State<HyperMenuPage> createState() => _HyperMenuPageState();
}

class _HyperMenuPageState extends State<HyperMenuPage> {
  String _lastAction = '尚未操作';

  @override
  Widget build(BuildContext context) {
    const groups = [
      HyperMenuGroup(
        items: [
          HyperMenuItem(id: 'new_window', label: '新建窗口'),
          HyperMenuItem(
            id: 'preferences',
            label: '偏好设置',
            children: [
              HyperMenuItem(id: 'general', label: '通用'),
              HyperMenuItem(
                id: 'appearance',
                label: '外观',
                children: [HyperMenuItem(id: 'theme', label: '主题')],
              ),
            ],
          ),
        ],
      ),
      HyperMenuGroup(
        items: [HyperMenuItem(id: 'sign_out', label: '退出登录')],
      ),
    ];
    void select(String id) => setState(() => _lastAction = id);
    return Padding(
      padding: EdgeInsets.all(
        HyperTheme.sizesOf(context).pageHorizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DemoSection(
            title: '操作菜单',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: HyperTheme.sizesOf(context).menu.padding,
                  runSpacing: HyperTheme.sizesOf(context).menu.padding,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    HyperMenuButton(
                      groups: groups,
                      onSelected: select,
                      child: const HyperText('打开菜单'),
                    ),
                    PopupMenuButton<String>(
                      tooltip: 'Flutter 原生 PopupMenu',
                      onSelected: select,
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'new_window', child: Text('新建窗口')),
                        PopupMenuItem(
                          value: 'preferences',
                          child: Text('偏好设置'),
                        ),
                        PopupMenuDivider(),
                        PopupMenuItem(value: 'sign_out', child: Text('退出登录')),
                      ],
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Flutter 原生 PopupMenu'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                HyperContextMenu(
                  groups: groups,
                  onSelected: select,
                  child: const HyperCard(
                    child: SizedBox(
                      width: 240,
                      height: 72,
                      child: Center(child: HyperText('右键或长按此区域')),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                HyperText('最近操作：$_lastAction'),
                const SizedBox(height: 16),
                HyperMenuButton(
                  groups: groups,
                  onSelected: select,
                  menuStyle: const HyperMenuStyle(itemSpacing: 6),
                  child: HyperText(
                    '项间距 6（默认 ${HyperTheme.sizesOf(context).menu.itemSpacing ?? HyperTheme.sizesOf(context).navigationItemSpacing}）',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
