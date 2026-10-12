import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

HyperTreeNode<String> node(
  String id, {
  List<HyperTreeNode<String>> children = const [],
  bool lazy = false,
  bool enabled = true,
}) => HyperTreeNode(
  id: id,
  label: Text(id),
  data: id,
  children: children,
  hasChildren: lazy,
  enabled: enabled,
);
void main() {
  test('静态树只显示展开路径，数据快照不被外部修改', () async {
    final children = [node('leaf')];
    final c = HyperTreeController<String>(
      nodes: [node('root', children: children)],
    );
    addTearDown(c.dispose);
    children.clear();
    expect(c.visibleEntries.map((e) => e.node.id), ['root']);
    await c.setExpanded('root', true);
    expect(c.visibleEntries.map((e) => e.node.id), ['root', 'leaf']);
    expect(c.visibleEntries.last.depth, 1);
    expect(c.visibleEntries.last.parentId, 'root');
    c.select('leaf');
    expect(c.selectedId, 'leaf');
    await c.setExpanded('root', false);
    expect(c.selectedId, 'leaf');
  });
  test('同节点请求合并，收起不被完成事件展开，缓存避免重复请求', () async {
    final complete = Completer<List<HyperTreeNode<String>>>();
    var requests = 0;
    final c = HyperTreeController<String>(
      nodes: [node('root', lazy: true)],
      loadChildren: (_) {
        requests++;
        return complete.future;
      },
    );
    addTearDown(c.dispose);
    final first = c.setExpanded('root', true);
    final second = c.ensureLoaded('root');
    expect(identical(first, second), isTrue);
    expect(c.loadState('root'), HyperTreeLoadState.loading);
    await c.setExpanded('root', false);
    complete.complete([node('child')]);
    await first;
    expect(requests, 1);
    expect(c.isExpanded('root'), isFalse);
    await c.setExpanded('root', true);
    expect(c.visibleEntries.length, 2);
    expect(requests, 1);
  });
  test('加载失败保留异常，可重试；空结果成为叶节点', () async {
    var attempts = 0;
    final c = HyperTreeController<String>(
      nodes: [node('root', lazy: true)],
      loadChildren: (_) async {
        if (attempts++ == 0) {
          throw StateError('failed');
        }
        return [];
      },
    );
    addTearDown(c.dispose);
    await c.setExpanded('root', true);
    expect(c.loadState('root'), HyperTreeLoadState.error);
    expect(c.errorFor('root'), isA<StateError>());
    await c.ensureLoaded('root');
    expect(c.loadState('root'), HyperTreeLoadState.loaded);
    expect(c.errorFor('root'), isNull);
    expect(c.canExpand('root'), isFalse);
    await c.ensureLoaded('root');
    expect(attempts, 2);
  });
  test('替换数据忽略旧请求，但允许同 id 新请求', () async {
    final old = Completer<List<HyperTreeNode<String>>>();
    var requests = 0;
    final c = HyperTreeController<String>(
      nodes: [node('root', lazy: true)],
      loadChildren: (_) {
        requests++;
        return requests == 1 ? old.future : Future.value([node('new')]);
      },
    );
    addTearDown(c.dispose);
    final pending = c.setExpanded('root', true);
    await Future<void>.delayed(Duration.zero);
    c.replaceNodes([node('root', lazy: true)]);
    await c.setExpanded('root', true);
    old.complete([node('old')]);
    await pending;
    expect(c.childrenOf('root').single.id, 'new');
    expect(c.nodeFor('old'), isNull);
  });
  test('销毁后完成请求不通知或写入', () async {
    final complete = Completer<List<HyperTreeNode<String>>>();
    final c = HyperTreeController<String>(
      nodes: [node('root', lazy: true)],
      loadChildren: (_) => complete.future,
    );
    var notifications = 0;
    c.addListener(() => notifications++);
    final pending = c.setExpanded('root', true);
    await Future<void>.delayed(Duration.zero);
    c.dispose();
    final before = notifications;
    complete.complete([node('child')]);
    await pending;
    expect(notifications, before);
    expect(c.nodeFor('child'), isNull);
  });
  test('全局 id 验证及动态失败不会部分写入，禁用不请求', () async {
    expect(
      () => HyperTreeController<String>(nodes: [node('a'), node('a')]),
      throwsArgumentError,
    );
    var requests = 0;
    final c = HyperTreeController<String>(
      nodes: [
        node('root', lazy: true),
        node('disabled', lazy: true, enabled: false),
      ],
      loadChildren: (_) async {
        requests++;
        return [node('child'), node('root')];
      },
    );
    addTearDown(c.dispose);
    await c.setExpanded('disabled', true);
    c.select('disabled');
    expect(requests, 0);
    expect(c.selectedId, isNull);
    await c.setExpanded('root', true);
    expect(c.loadState('root'), HyperTreeLoadState.error);
    expect(c.nodeFor('child'), isNull);
    expect(
      () => c.replaceNodes([node('duplicate'), node('duplicate')]),
      throwsArgumentError,
    );
    expect(c.nodeFor('root'), isNotNull);
  });
  test('并行分支请求独立，跨请求重复 id 保持树完整', () async {
    final a = Completer<List<HyperTreeNode<String>>>(),
        b = Completer<List<HyperTreeNode<String>>>();
    final c = HyperTreeController<String>(
      nodes: [node('a', lazy: true), node('b', lazy: true)],
      loadChildren: (n) => n.id == 'a' ? a.future : b.future,
    );
    addTearDown(c.dispose);
    final pa = c.setExpanded('a', true), pb = c.setExpanded('b', true);
    a.complete([node('shared')]);
    await pa;
    b.complete([node('shared')]);
    await pb;
    expect(c.loadState('a'), HyperTreeLoadState.loaded);
    expect(c.loadState('b'), HyperTreeLoadState.error);
    expect(c.childrenOf('a').length, 1);
    expect(c.childrenOf('b'), isEmpty);
  });
  test('树主题与四端尺寸独立覆盖、合并和插值', () {
    final base = HyperThemeData.light();
    const style = HyperTreeViewStyle(
      rowHeight: 32,
      textStyle: TextStyle(fontSize: 14),
    );
    final merged = style.merge(
      const HyperTreeViewStyle(
        textStyle: TextStyle(fontWeight: FontWeight.bold),
        rowHeight: 40,
      ),
    );
    expect(merged.textStyle!.fontSize, 14);
    expect(HyperTreeViewStyle.lerp(style, merged, .5).rowHeight, 36);
    final changed = base.copyWith(
      treeViewTheme: HyperTreeViewThemeData(style: merged),
    );
    expect(changed.sidebarTheme, base.sidebarTheme);
    expect(changed.copyWith(), changed);
    expect(base.lerp(changed, 1).treeViewTheme, changed.treeViewTheme);
    const sizes = [
      HyperSizeScheme.phone(),
      HyperSizeScheme.tablet(),
      HyperSizeScheme.desktop(),
      HyperSizeScheme.watch(),
    ];
    expect(sizes.map((s) => s.treeView.rowHeight), [48, 48, 32, 48]);
    final desktop = sizes[2].copyWith(
      treeView: sizes[2].treeView.copyWith(indent: 24),
    );
    expect(desktop.deviceType, HyperDeviceType.desktop);
    expect(HyperSizeScheme.lerp(sizes[2], desktop, .5).treeView.indent, 20);
  });
}
