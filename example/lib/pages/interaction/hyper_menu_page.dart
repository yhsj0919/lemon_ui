import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

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
          HyperText('操作菜单', variant: HyperTextVariant.subsectionTitle),
          const SizedBox(height: 16),
          HyperMenuButton(
            groups: groups,
            onSelected: select,
            child: const HyperText('打开菜单'),
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
        ],
      ),
    );
  }
}
