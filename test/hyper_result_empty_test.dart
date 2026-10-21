import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Widget host(Widget child, {HyperThemeData? theme, double scale = 1}) =>
    MaterialApp(
      home: HyperTheme(
        data: theme ?? HyperThemeData.light(),
        child: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(width: 180, child: child),
            ),
          ),
        ),
      ),
    );

void main() {
  test('empty 状态覆盖参与全局主题复制、插值和值相等', () {
    const a = HyperResultThemeData(
      style: HyperResultStyle(actionSpacing: 9),
      empty: HyperResultStyle(iconSize: 30),
    );
    final b = a.copyWith(empty: const HyperResultStyle(iconSize: 50));
    expect(a.resolve(HyperResultStatus.empty).actionSpacing, 9);
    expect(HyperResultThemeData.lerp(a, b, .5).empty.iconSize, 40);
    expect(a, a.copyWith());
    expect(a.hashCode, a.copyWith().hashCode);
    final theme = HyperThemeData.light().copyWith(resultTheme: a);
    final changed = theme.copyWith(resultTheme: b);
    expect(theme.lerp(changed, .5).resultTheme.empty.iconSize, 40);
    expect(changed, isNot(theme));
  });

  testWidgets('空状态主题与实例逐字段覆盖', (tester) async {
    final theme = HyperThemeData.light().copyWith(
      resultTheme: const HyperResultThemeData(
        empty: HyperResultStyle(iconColor: Colors.blue, iconSize: 24),
      ),
    );
    await tester.pumpWidget(host(const HyperResult.empty(), theme: theme));
    expect(find.byType(HyperResult), findsOneWidget);
    var icon = tester.widget<Icon>(find.byIcon(Icons.inbox_outlined));
    expect(icon.color, Colors.blue);
    expect(icon.size, 24);
    await tester.pumpWidget(
      host(
        const HyperResult.empty(
          style: HyperResultStyle(iconColor: Colors.green),
        ),
        theme: theme,
      ),
    );
    await tester.pumpAndSettle();
    icon = tester.widget<Icon>(find.byIcon(Icons.inbox_outlined));
    expect(icon.color, Colors.green);
  });

  testWidgets('实例表面与空阴影优先', (tester) async {
    await tester.pumpWidget(
      host(
        HyperResult.empty(
          style: HyperResultStyle(
            background: const HyperFill.color(Colors.amber),
            padding: const EdgeInsets.all(13),
            border: Border.all(color: Colors.red),
            boxShadow: const [],
          ),
        ),
      ),
    );
    expect(find.byType(HyperMaterialSurface), findsOneWidget);
    final surface = tester.widget<HyperMaterialSurface>(
      find.byType(HyperMaterialSurface),
    );
    expect(surface.semanticBackground, const HyperFill.color(Colors.amber));
    expect(surface.padding, const EdgeInsets.all(13));
    expect(surface.border, Border.all(color: Colors.red));
    expect(surface.boxShadow, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('空状态局部主题逐层覆盖，实例背景覆盖继承材质', (tester) async {
    final theme = HyperThemeData.light().copyWith(
      materialTheme: const HyperMaterialThemeData(
        material: HyperSurfaceMaterial.solid(
          background: HyperFill.color(Colors.blue),
        ),
      ),
    );
    await tester.pumpWidget(
      host(
        const HyperResultTheme(
          data: HyperResultThemeData(
            style: HyperResultStyle(iconSize: 29, iconColor: Colors.red),
          ),
          child: HyperResultTheme(
            data: HyperResultThemeData(
              empty: HyperResultStyle(iconColor: Colors.green),
            ),
            child: HyperResult.empty(
              style: HyperResultStyle(
                background: HyperFill.color(Colors.amber),
              ),
            ),
          ),
        ),
        theme: theme,
      ),
    );
    final icon = tester.widget<Icon>(find.byIcon(Icons.inbox_outlined));
    expect(icon.size, 29);
    expect(icon.color, Colors.green);
    final surface = tester.widget<HyperMaterialSurface>(
      find.byType(HyperMaterialSurface),
    );
    expect(surface.material!.background, const HyperFill.color(Colors.amber));
    expect(tester.takeException(), isNull);
  });

  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('空状态窄宽与文字缩放 $scale', (tester) async {
      await tester.pumpWidget(
        host(
          const HyperResult.empty(
            title: '这里还没有任何内容，可以创建新的项目',
            description: '内容随系统文字缩放换行并自然增高。',
            actions: [Text('创建项目'), Text('稍后处理')],
          ),
          scale: scale,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('这里还没有任何内容，可以创建新的项目'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('状态切换中玻璃表面无淡出祖先，内容状态持续保留', (tester) async {
    final status = ValueNotifier(HyperResultStatus.empty);
    addTearDown(status.dispose);
    final theme = HyperThemeData.light().copyWith(
      materialTheme: const HyperMaterialThemeData(
        quality: HyperMaterialQuality.advanced,
        material: HyperSurfaceMaterial.frostedGlass(
          background: HyperFill.color(Color(0x70FFFFFF)),
          boxShadow: [BoxShadow(blurRadius: 12)],
        ),
      ),
    );
    await tester.pumpWidget(
      host(
        ValueListenableBuilder<HyperResultStatus>(
          valueListenable: status,
          builder: (context, value, child) => HyperResult(
            status: value,
            title: value.name,
            content: child,
            style: const HyperResultStyle(
              background: HyperFill.color(Color(0x70FFFFFF)),
              boxShadow: [],
            ),
          ),
          child: const TextField(key: ValueKey('retained-content')),
        ),
        theme: theme,
      ),
    );
    await tester.enterText(find.byType(TextField), '保留输入');
    status.value = HyperResultStatus.success;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 70));
    void check() {
      final filters = find.byType(BackdropFilter);
      expect(filters, findsOneWidget);
      expect(
        tester
            .widgetList<FadeTransition>(
              find.ancestor(of: filters, matching: find.byType(FadeTransition)),
            )
            .where((fade) => fade.opacity.value > 0 && fade.opacity.value < 1),
        isEmpty,
      );
      expect(
        tester
            .widgetList<Opacity>(
              find.ancestor(of: filters, matching: find.byType(Opacity)),
            )
            .where((opacity) => opacity.opacity > 0 && opacity.opacity < 1),
        isEmpty,
      );
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        '保留输入',
      );
      expect(
        tester
            .widget<HyperMaterialSurface>(find.byType(HyperMaterialSurface))
            .boxShadow,
        isEmpty,
      );
      expect(tester.takeException(), isNull);
    }

    check();
    await tester.pumpAndSettle();
    check();
  });
}
