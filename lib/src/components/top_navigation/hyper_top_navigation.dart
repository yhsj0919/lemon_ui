import '../../foundation/hyper_icons.dart';
import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../button/hyper_button.dart';
import '../button/hyper_button_style.dart';
import '../menu/hyper_menu.dart';
import '../menu/hyper_menu_model.dart';
import '../overlay/hyper_anchored_overlay.dart';
import 'hyper_top_navigation_style.dart';
import 'hyper_top_navigation_theme.dart';

/// 横向顶部导航，复用 HyperMenuItem 及其任意深度子菜单。
///
/// 选择受控；有子菜单的项只展开，叶项才触发 onSelected。父布局负责宽度，
/// 窄空间下顶层横向滚动，描述不会强制压缩字号。浮层复用 Menu 的主题、
/// 焦点、键盘和材质基础设施，不管理路由或页面内容。
class HyperTopNavigation extends StatefulWidget {
  const HyperTopNavigation({
    super.key,
    required this.items,
    this.selectedId,
    this.onSelected,
    this.style,
  });

  /// 全树 id 必须唯一；children 表示下级菜单。
  final List<HyperMenuItem> items;

  /// 当前叶项 id；对应的顶层祖先同步显示选中样式。
  final String? selectedId;

  /// 请求选择叶项；页面导航与业务状态由调用方负责。
  final ValueChanged<String>? onSelected;

  /// 显式覆盖导航主题；子菜单配置位于 menuStyle。
  final HyperTopNavigationStyle? style;
  @override
  State<HyperTopNavigation> createState() => _HyperTopNavigationState();
}

class _HyperTopNavigationState extends State<HyperTopNavigation> {
  String? _openId;
  void _validate() {
    final ids = <String>{};
    void visit(List<HyperMenuItem> items) {
      for (final item in items) {
        if (!ids.add(item.id)) throw ArgumentError('顶部导航 id 重复：${item.id}');
        visit(item.children);
      }
    }

    visit(widget.items);
  }

  @override
  void initState() {
    super.initState();
    _validate();
  }

  @override
  void didUpdateWidget(HyperTopNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    _validate();
    if (!widget.items.any(
      (item) => item.id == _openId && item.enabled && item.children.isNotEmpty,
    )) {
      _openId = null;
    }
  }

  bool _selected(HyperMenuItem item) =>
      item.id == widget.selectedId || item.children.any(_selected);
  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context).topNavigation;
    final style = HyperTopNavigationStyle(
      itemSpacing: sizes.itemSpacing,
      descriptionGap: sizes.descriptionGap,
      descriptionStyle: theme.textTheme.bodySmall?.copyWith(
        color: theme.colors.textSecondary,
      ),
      dropdownIcon: HyperIcons.chevronDown,
      itemStyle: HyperButtonStyle(
        minimumSize: Size(0, sizes.height),
        padding: sizes.padding,
        borderRadius: BorderRadius.circular(sizes.radius),
        iconSize: sizes.iconSize,
        iconSpacing: sizes.iconSpacing,
      ),
      selectedItemStyle: HyperButtonStyle(
        foregroundColor: theme.colors.primary,
        background: null,
      ),
    ).merge(HyperTopNavigationTheme.of(context).style).merge(widget.style);
    return FocusTraversalGroup(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (index, item) in widget.items.indexed) ...[
              if (index > 0) SizedBox(width: style.itemSpacing),
              _item(context, item, style),
            ],
          ],
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    HyperMenuItem item,
    HyperTopNavigationStyle style,
  ) {
    final selected = _selected(item);
    final hasChildren = item.children.isNotEmpty;
    final open = _openId == item.id;
    final buttonStyle = (style.itemStyle ?? HyperButtonStyle()).merge(
      selected ? style.selectedItemStyle : null,
    );
    Widget button(VoidCallback action) => MouseRegion(
      onEnter: (_) {
        if (_openId != null && item.enabled) {
          setState(() => _openId = hasChildren ? item.id : null);
        }
      },
      child: Semantics(
        selected: selected,
        child: HyperButton.ghost(
          key: ValueKey('hyper-top-navigation-${item.id}'),
          onPressed: item.enabled && (hasChildren || widget.onSelected != null)
              ? action
              : null,
          style: buttonStyle,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.leading != null) ...[
                item.leading!,
                SizedBox(width: buttonStyle.iconSpacing),
              ],
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.label),
                  if (item.description != null) ...[
                    SizedBox(height: style.descriptionGap),
                    Text(item.description!, style: style.descriptionStyle),
                  ],
                ],
              ),
              if (item.trailing != null) ...[
                SizedBox(width: buttonStyle.iconSpacing),
                item.trailing!,
              ],
              if (hasChildren) ...[
                SizedBox(width: buttonStyle.iconSpacing),
                AnimatedRotation(
                  turns: open ? .5 : 0,
                  duration:
                      MediaQuery.maybeOf(context)?.disableAnimations == true
                      ? Duration.zero
                      : HyperTheme.of(context).motion.fastDuration,
                  curve: HyperTheme.of(context).motion.fastCurve,
                  child: Icon(style.dropdownIcon, size: buttonStyle.iconSize),
                ),
              ],
            ],
          ),
        ),
      ),
    );
    if (!hasChildren) return button(() => widget.onSelected?.call(item.id));
    return HyperAnchoredOverlay.builder(
      isOpen: open,
      onOpenChanged: (value) => setState(() {
        if (value) {
          _openId = item.id;
        } else if (_openId == item.id) {
          _openId = null;
        }
      }),
      transitionBuilder: style.transitionBuilder,
      anchorBuilder: (context, toggle, isOpen) => button(toggle),
      overlayBuilder: (context, close) => HyperMenu(
        items: item.children,
        selectedId: widget.selectedId,
        style: style.menuStyle,
        onSelected: (id) {
          close();
          widget.onSelected?.call(id);
        },
      ),
    );
  }
}
