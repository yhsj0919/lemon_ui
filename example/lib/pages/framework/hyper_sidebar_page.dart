import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 展示分组、树形菜单、角标、自定义项和折叠悬停子菜单。
class HyperSidebarPage extends StatefulWidget {
  const HyperSidebarPage({super.key});

  @override
  State<HyperSidebarPage> createState() => _HyperSidebarPageState();
}

class _HyperSidebarPageState extends State<HyperSidebarPage> {
  bool _collapsed = false;
  bool _followParent = false;
  bool _alternateMotion = false;
  HyperSidebarSelectionStyle _selectionStyle = HyperSidebarSelectionStyle.text;
  String _selectedId = 'favorites';

  static Widget _slideChildren(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) => ClipRect(
    child: SizeTransition(
      sizeFactor: animation,
      alignment: AlignmentDirectional.topStart,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -.08),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            HyperButton.tonal(
              onPressed: () => setState(() => _collapsed = !_collapsed),
              child: HyperText(_collapsed ? '展开' : '折叠'),
            ),
            HyperButton.tonal(
              onPressed: () => setState(() => _followParent = !_followParent),
              child: HyperText(_followParent ? '父级跟随选中' : '父级独立'),
            ),
            HyperButton.tonal(
              onPressed: () => setState(
                () => _selectionStyle =
                    _selectionStyle == HyperSidebarSelectionStyle.text
                    ? HyperSidebarSelectionStyle.fill
                    : HyperSidebarSelectionStyle.text,
              ),
              child: const HyperText('切换选中样式'),
            ),
            HyperButton.tonal(
              onPressed: () =>
                  setState(() => _alternateMotion = !_alternateMotion),
              child: HyperText(_alternateMotion ? '滑入动画' : '默认动画'),
            ),
          ],
        ),
      ),
      Expanded(
        child: Row(
          children: [
            HyperSidebar(
              collapsed: _collapsed,
              selectedId: _selectedId,
              onSelected: (id) => setState(() => _selectedId = id),
              selectParentWhenChildSelected: _followParent,
              style: HyperSidebarStyle(
                selectionStyle: _selectionStyle,
                childrenTransitionBuilder: _alternateMotion
                    ? _slideChildren
                    : null,
              ),
              header: const Padding(
                padding: EdgeInsets.all(12),
                child: HyperText('固定头部'),
              ),
              footer: const Padding(
                padding: EdgeInsets.all(12),
                child: HyperText('固定尾部'),
              ),
              groups: [
                HyperSidebarGroup(
                  title: '内容',
                  items: [
                    const HyperSidebarItem(
                      id: 'home',
                      label: '首页',
                      icon: HyperIcon(Icons.home_outlined),
                    ),
                    HyperSidebarItem(
                      id: 'library',
                      label: '资源库',
                      icon: const HyperIcon(Icons.folder_outlined),
                      children: [
                        const HyperSidebarItem(
                          id: 'favorites',
                          label: '收藏',
                          icon: HyperIcon(Icons.star_border),
                          badge: HyperText('3'),
                        ),
                        const HyperSidebarItem(
                          id: 'recent',
                          label: '最近',
                          icon: HyperIcon(Icons.history),
                        ),
                      ],
                    ),
                  ],
                ),
                HyperSidebarGroup(
                  title: '管理',
                  items: [
                    HyperSidebarItem(
                      id: 'settings',
                      label: '设置',
                      icon: const HyperIcon(Icons.settings_outlined),
                      builder: (context, state, defaultItem) => Tooltip(
                        message: '自定义项：${state.selected ? '已选中' : '未选中'}',
                        child: defaultItem,
                      ),
                    ),
                    const HyperSidebarItem(
                      id: 'locked',
                      label: '已禁用',
                      icon: HyperIcon(Icons.lock_outline),
                      enabled: false,
                    ),
                  ],
                ),
              ],
            ),
            Expanded(child: Center(child: HyperText('当前选择：$_selectedId'))),
          ],
        ),
      ),
    ],
  );
}
