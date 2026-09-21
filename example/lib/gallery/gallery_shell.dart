import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'gallery_item.dart';
import 'gallery_registry.dart';

/// Example 的响应式菜单和演示页承载壳。
///
/// 前期使用 Flutter 原生列表实现。后期可以替换为 HyperSidebar、HyperMenu
/// 等正式组件，而不改变注册表和各个演示页。
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

        return Scaffold(
          appBar: AppBar(
            title: Text(selectedItem.title),
            leading: showSidebar ? null : const _OpenMenuButton(),
          ),
          drawer: showSidebar
              ? null
              : Drawer(
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
          body: Row(
            children: [
              if (showSidebar)
                SizedBox(
                  width: 260,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                    child: _GalleryMenu(
                      selectedId: _selectedId,
                      onSelected: _select,
                    ),
                  ),
                ),
              Expanded(
                child: KeyedSubtree(
                  key: ValueKey(selectedItem.id),
                  child: selectedItem.builder(context),
                ),
              ),
            ],
          ),
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
      onPressed: () => Scaffold.of(context).openDrawer(),
      icon: const Icon(Icons.menu),
    );
  }
}

class _GalleryMenu extends StatelessWidget {
  const _GalleryMenu({required this.selectedId, required this.onSelected});

  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Text(
            'Lemon UI 组件演示',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        for (final section in gallerySections) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Text(
              section.title,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          for (final item in section.items)
            ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              subtitle: Text(item.description),
              selected: item.id == selectedId,
              onTap: () => onSelected(item.id),
            ),
        ],
      ],
    );
  }
}
