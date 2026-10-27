import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

const _nodes = [
  HyperTreeSelectNode(
    value: 'team',
    label: '团队',
    children: [HyperTreeSelectNode(value: 'member', label: '成员')],
  ),
  HyperTreeSelectNode(value: 'disabled', label: '停用项', enabled: false),
];

Widget _app(Widget child, {HyperDeviceType device = HyperDeviceType.desktop}) =>
    MaterialApp(
      home: HyperDeviceDetector(
        deviceType: device,
        builder: (context, _, child) =>
            HyperTheme(data: HyperThemeData.light(), child: child!),
        child: Scaffold(
          body: Center(child: SizedBox(width: 320, child: child)),
        ),
      ),
    );

void main() {
  testWidgets('branch selection and expansion are separate; leaf commits', (
    tester,
  ) async {
    String? value;
    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (_, update) => HyperTreeSelect<String>(
            nodes: _nodes,
            value: value,
            onChanged: (next) => update(() => value = next),
          ),
        ),
      ),
    );
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(HyperIcons.chevronRight).first);
    await tester.pumpAndSettle();
    expect(value, isNull);
    expect(find.text('成员'), findsOneWidget);
    await tester.tap(find.text('团队'));
    await tester.pumpAndSettle();
    expect(value, 'team');
    await tester.tap(find.text('团队'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('成员'));
    await tester.pumpAndSettle();
    expect(value, 'member');
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'committing a node closes without flashing a transient selection',
    (tester) async {
      String? value;
      await tester.pumpWidget(
        _app(
          StatefulBuilder(
            builder: (_, update) => HyperTreeSelect<String>(
              nodes: _nodes,
              value: value,
              onChanged: (next) => update(() => value = next),
            ),
          ),
        ),
      );
      await tester.tap(find.text('请选择'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(HyperIcons.chevronRight).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('成员'));
      await tester.pump();
      final memberRows = find.ancestor(
        of: find.text('成员'),
        matching: find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.selected == true,
        ),
      );
      expect(memberRows, findsNothing);
      await tester.pumpAndSettle();
      expect(value, 'member');
      await tester.tap(find.text('成员'));
      await tester.pumpAndSettle();
      final tree = tester.widget<HyperTreeView<HyperTreeSelectNode<String>>>(
        find.byType(HyperTreeView<HyperTreeSelectNode<String>>),
      );
      expect(tree.controller!.selectedId, 'member');
      expect(
        find.ancestor(
          of: find.text('成员'),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Semantics && widget.properties.selected == true,
          ),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('leafOnly and disabled nodes cannot commit', (tester) async {
    String? value;
    await tester.pumpWidget(
      _app(
        HyperTreeSelect<String>(
          nodes: _nodes,
          value: null,
          leafOnly: true,
          onChanged: (next) => value = next,
        ),
      ),
    );
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('团队'));
    await tester.pumpAndSettle();
    expect(value, isNull);
    expect(find.text('成员'), findsOneWidget);
    await tester.tap(find.text('停用项'));
    expect(value, isNull);
  });

  testWidgets('async error exposes retry and loaded leaf can be selected', (
    tester,
  ) async {
    var attempts = 0;
    String? value;
    Future<List<HyperTreeSelectNode<String>>> load(
      HyperTreeSelectNode<String> node,
    ) async {
      attempts++;
      if (attempts == 1) throw StateError('first request fails');
      return const [HyperTreeSelectNode(value: 'loaded', label: '已加载')];
    }

    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (_, update) => HyperTreeSelect<String>(
            nodes: const [
              HyperTreeSelectNode(
                value: 'async',
                label: '异步项',
                hasChildren: true,
              ),
            ],
            value: value,
            loadChildren: load,
            onChanged: (next) => update(() => value = next),
          ),
        ),
      ),
    );
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(HyperIcons.chevronRight).first);
    await tester.pumpAndSettle();
    expect(find.text('加载失败，点击重试'), findsOneWidget);
    await tester.tap(find.text('加载失败，点击重试'));
    await tester.pumpAndSettle();
    expect(attempts, 2);
    expect(find.text('已加载'), findsOneWidget);
    await tester.tap(find.text('已加载'));
    await tester.pumpAndSettle();
    expect(value, 'loaded');
    expect(tester.takeException(), isNull);
  });

  testWidgets('phone uses bottom sheet and title clear commits null', (
    tester,
  ) async {
    String? value = 'member';
    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (_, update) => HyperTreeSelect<String>(
            nodes: _nodes,
            value: value,
            onChanged: (next) => update(() => value = next),
          ),
        ),
        device: HyperDeviceType.phone,
      ),
    );
    await tester.tap(find.text('成员'));
    await tester.pumpAndSettle();
    expect(find.byType(HyperBottomSheet), findsOneWidget);
    await tester.tap(find.text('清空').first);
    await tester.pumpAndSettle();
    expect(value, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('large text remains reachable in a narrow tree panel', (
    tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: _app(
          HyperTreeSelect<String>(
            nodes: const [
              HyperTreeSelectNode(
                value: 'long',
                label: '这是一个很长很长的树节点名称，需要在窄面板中自动换行',
              ),
            ],
            value: null,
            onChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    expect(find.textContaining('这是一个很长'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Form field validates, submits and resets one node value', (
    tester,
  ) async {
    final form = HyperFormController();
    String? submitted;
    await tester.pumpWidget(
      _app(
        HyperForm(
          controller: form,
          child: Column(
            children: [
              HyperTreeSelectFormField<String>(
                name: 'team',
                label: '团队',
                nodes: _nodes,
                validator: (value) => value == null ? '请选择团队' : null,
              ),
              TextButton(
                onPressed: () => form.submit((values) {
                  submitted = values['team'] as String?;
                }),
                child: const Text('提交'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('提交'));
    await tester.pumpAndSettle();
    expect(find.text('请选择团队'), findsOneWidget);
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(HyperIcons.chevronRight).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('成员'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('提交'));
    await tester.pumpAndSettle();
    expect(submitted, 'member');
    form.reset();
    await tester.pumpAndSettle();
    expect(find.text('请选择'), findsOneWidget);
    form.dispose();
  });

  test('tree selector styles merge and interpolate', () {
    const base = HyperTreeSelectStyle(
      treeStyle: HyperTreeViewStyle(rowHeight: 40),
    );
    const override = HyperTreeSelectStyle(
      treeStyle: HyperTreeViewStyle(rowHeight: 48),
    );
    expect(base.merge(override).treeStyle!.rowHeight, 48);
    expect(
      HyperTreeSelectStyle.lerp(base, override, .5).treeStyle!.rowHeight,
      44,
    );
    expect(
      base.copyWith(treeStyle: const HyperTreeViewStyle(rowHeight: 40)),
      base,
    );
  });

  test(
    'global theme copies, interpolates and compares tree select styling',
    () {
      final base = HyperThemeData.light().copyWith(
        treeSelectTheme: const HyperTreeSelectThemeData(
          style: HyperTreeSelectStyle(
            treeStyle: HyperTreeViewStyle(rowHeight: 40),
          ),
        ),
      );
      final changed = base.copyWith(
        treeSelectTheme: const HyperTreeSelectThemeData(
          style: HyperTreeSelectStyle(
            treeStyle: HyperTreeViewStyle(rowHeight: 48),
          ),
        ),
      );
      final midpoint = base.lerp(changed, .5);
      expect(midpoint.treeSelectTheme.style.treeStyle!.rowHeight, 44);
      final same = base.copyWith(treeSelectTheme: base.treeSelectTheme);
      expect(same, base);
      expect(same.hashCode, base.hashCode);
      expect(changed, isNot(base));
      expect(changed.hashCode, isNot(base.hashCode));
    },
  );
}
