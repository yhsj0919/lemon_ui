import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperTreeViewPage extends StatefulWidget {
  const HyperTreeViewPage({super.key});
  @override
  State<HyperTreeViewPage> createState() => _PageState();
}

class _PageState extends State<HyperTreeViewPage> {
  String _selected = '尚未选择';
  int _requests = 0, _failures = 0;
  bool _reduced = false;
  late final HyperTreeController<String> _controller;
  static const _staticNodes = [
    HyperTreeNode<String>(
      id: 'project',
      label: Text('项目'),
      leading: Icon(Icons.folder_outlined),
      children: [
        HyperTreeNode<String>(
          id: 'src',
          label: Text('源码'),
          children: [
            HyperTreeNode<String>(
              id: 'app',
              label: Text('app.dart'),
              leading: Icon(Icons.description_outlined),
            ),
          ],
        ),
        HyperTreeNode<String>(
          id: 'docs',
          label: Text('文档'),
          children: [
            HyperTreeNode<String>(id: 'readme', label: Text('README.md')),
          ],
        ),
        HyperTreeNode<String>(
          id: 'disabled',
          label: Text('禁用节点'),
          enabled: false,
        ),
        HyperTreeNode<String>(
          id: 'long',
          label: Text('很长的节点标题可以自然换行，行高不会压缩文字'),
          trailing: Icon(Icons.star_outline),
        ),
      ],
    ),
  ];
  List<HyperTreeNode<String>> get _dynamicRoots => const [
    HyperTreeNode<String>(
      id: 'server',
      label: Text('动态目录（成功 / 二级加载）'),
      hasChildren: true,
      leading: Icon(Icons.cloud_outlined),
    ),
    HyperTreeNode<String>(
      id: 'retry',
      label: Text('首次失败，重试成功'),
      hasChildren: true,
    ),
    HyperTreeNode<String>(id: 'empty', label: Text('加载后为空'), hasChildren: true),
  ];
  @override
  void initState() {
    super.initState();
    _controller = HyperTreeController<String>(
      nodes: _dynamicRoots,
      loadChildren: (node) async {
        if (mounted) {
          setState(() => _requests++);
        }
        await Future<void>.delayed(const Duration(milliseconds: 900));
        if (node.id == 'retry' && _failures++ == 0) {
          throw StateError('模拟网络失败');
        }
        if (node.id == 'empty') {
          return [];
        }
        if (node.id == 'server') {
          return const [
            HyperTreeNode<String>(
              id: 'remote-folder',
              label: Text('远程子目录'),
              hasChildren: true,
            ),
            HyperTreeNode<String>(id: 'remote-file', label: Text('远程文件')),
          ];
        }
        return [
          HyperTreeNode<String>(
            id: '${node.id}-child',
            label: const Text('已加载的子节点'),
            data: '动态数据',
          ),
        ];
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context), theme = HyperTheme.of(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        disableAnimations: _reduced || MediaQuery.of(context).disableAnimations,
      ),
      child: ListView(
        padding: EdgeInsets.all(sizes.pageHorizontalPadding),
        children: [
          DemoSection(
            title: '静态树与自定义内容',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HyperTreeView<String>(
                  nodes: _staticNodes,
                  onSelectionChanged: (node) =>
                      setState(() => _selected = node.id.toString()),
                ),
                Text('选中：$_selected'),
              ],
            ),
          ),
          DemoSection(
            title: '展开时动态请求，失败重试与缓存',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: sizes.navigationItemSpacing,
                  children: [
                    HyperButton.text(
                      label: const Text('重置数据 / 清空缓存'),
                      onPressed: () => _controller.replaceNodes(_dynamicRoots),
                    ),
                    HyperButton.text(
                      label: Text(_reduced ? '恢复动画' : '减少动画'),
                      onPressed: () => setState(() => _reduced = !_reduced),
                    ),
                  ],
                ),
                Text('请求次数：$_requests。加载时收起再展开不会重复发起请求。'),
                HyperTreeView<String>(
                  controller: _controller,
                  onNodeTap: (node) =>
                      setState(() => _selected = node.id.toString()),
                ),
              ],
            ),
          ),
          DemoSection(
            title: '局部主题、实例间距与材质',
            child: HyperTreeViewTheme(
              data: HyperTreeViewThemeData(
                style: HyperTreeViewStyle(
                  selectedBackground: HyperFill.color(
                    theme.colors.primary.withValues(alpha: .12),
                  ),
                  rowRadius: BorderRadius.circular(sizes.treeView.rowRadius),
                ),
              ),
              child: HyperTreeView<String>(
                nodes: _staticNodes,
                style: HyperTreeViewStyle(
                  rowSpacing: 8,
                  material: const HyperSurfaceMaterial.frostedGlass(),
                  borderRadius: BorderRadius.circular(sizes.card.radius),
                  padding: EdgeInsets.all(sizes.navigationItemSpacing),
                ),
              ),
            ),
          ),
          const DemoSection(title: '空树', child: HyperTreeView<String>()),
        ],
      ),
    );
  }
}
