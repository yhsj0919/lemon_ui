import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'gallery_item.dart';
import 'gallery_registry.dart';

/// Example 的响应式菜单和演示页承载壳。
///
/// 菜单内容由 HyperSidebar 统一绘制，窄屏时交给 HyperDrawer 承载。
class GalleryShell extends StatefulWidget {
  const GalleryShell({super.key});

  @override
  State<GalleryShell> createState() => _GalleryShellState();
}

class _GalleryShellState extends State<GalleryShell> {
  static const double _sidebarBreakpoint = 720;

  late String _selectedId = galleryItems.first.id;

  GalleryItem get _selectedItem => galleryItems.firstWhere(
    (item) => item.id == _selectedId,
    orElse: () => galleryItems.first,
  );

  void _select(String id) {
    if (_selectedId == id) {
      return;
    }
    setState(() => _selectedId = id);
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = _selectedItem;

    return LayoutBuilder(
      builder: (context, constraints) {
        final showSidebar = constraints.maxWidth >= _sidebarBreakpoint;

        final page = KeyedSubtree(
          key: ValueKey(selectedItem.id),
          child: selectedItem.builder(context),
        );
        if (showSidebar) {
          return HyperScaffold(
            // 宽屏的侧栏占完整左列，页面标题只属于右侧内容列。
            body: SafeArea(
              child: Row(
                children: [
                  _GalleryMenu(
                    selectedId: _selectedId,
                    onSelected: _select,
                    style: HyperSidebarStyle(
                      width: HyperTheme.sizesOf(context).drawer.width,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        if (!selectedItem.ownsAppBar)
                          SizedBox(
                            height: HyperTheme.sizesOf(context)
                                .appBar
                                .collapsedHeight,
                            child: HyperAppBar(
                              title: Text(selectedItem.title),
                              style: const HyperAppBarStyle(centerTitle: false),
                            ),
                          ),
                        Expanded(child: page),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return HyperScaffold(
          appBar: selectedItem.ownsAppBar
              ? null
              : HyperAppBar(
                  title: Text(selectedItem.title),
                  leading: const _OpenMenuButton(),
                ),
          drawer: HyperDrawer(
            child: SafeArea(
              child: _GalleryMenu(
                selectedId: _selectedId,
                onSelected: (id) {
                  _select(id);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          body: page,
        );
      },
    );
  }
}

class _OpenMenuButton extends StatelessWidget {
  const _OpenMenuButton();

  @override
  Widget build(BuildContext context) {
    return HyperIconButton.ghost(
      tooltip: '打开组件菜单',
      onPressed: () => HyperScaffold.openDrawer(context),
      icon: const Icon(Icons.menu),
    );
  }
}

class _GalleryMenu extends StatefulWidget {
  const _GalleryMenu({
    required this.selectedId,
    required this.onSelected,
    this.style,
  });

  final String selectedId;
  final ValueChanged<String> onSelected;
  final HyperSidebarStyle? style;

  @override
  State<_GalleryMenu> createState() => _GalleryMenuState();
}

class _GalleryMenuState extends State<_GalleryMenu> {
  String? _expandedSectionId;

  String? _sectionIdFor(String itemId) {
    for (final (index, section) in gallerySections.indexed) {
      if (section.items.any((item) => item.id == itemId)) {
        return 'gallery-section-$index';
      }
    }
    return null;
  }

  @override
  void didUpdateWidget(_GalleryMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedId != widget.selectedId) {
      _expandedSectionId = _sectionIdFor(widget.selectedId);
    }
  }

  void _onExpandedIdsChanged(Set<String> ids) {
    final added = ids.difference({?_expandedSectionId});
    setState(() => _expandedSectionId = added.isEmpty ? null : added.first);
  }

  @override
  Widget build(BuildContext context) {
    return HyperSidebar(
      style: widget.style,
      selectedId: widget.selectedId,
      onSelected: widget.onSelected,
      expandedIds: {?_expandedSectionId},
      onExpandedIdsChanged: _onExpandedIdsChanged,
      header: const Padding(
        padding: EdgeInsets.all(16),
        child: HyperText(
          'Lemon UI 组件演示',
          variant: HyperTextVariant.bodyLarge,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      groups: [
        for (final audience in GalleryAudience.values)
          HyperSidebarGroup(
            title: audience.label,
            items: [
              for (final (index, section) in gallerySections.indexed)
                if (section.audience == audience)
                  HyperSidebarItem(
                    id: 'gallery-section-$index',
                    label: section.title,
                    children: [
                      for (final item in section.items)
                        HyperSidebarItem(
                          id: item.id,
                          label: item.title,
                          description: item.description,
                          icon: HyperIcon(item.icon),
                        ),
                    ],
                  ),
            ],
          ),
      ],
    );
  }
}
