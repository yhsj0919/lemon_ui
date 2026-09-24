import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('展开顶栏兼容普通列表时不生成随内部视口移动的滚动条', (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.windows),
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: HyperScaffold(
            appBar: const HyperAppBar.large(title: Text('展开标题')),
            body: ListView.builder(
              itemCount: 30,
              itemBuilder: (_, index) =>
                  SizedBox(height: 64, child: Text('列表项目 $index')),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(NestedScrollView), findsOneWidget);
    expect(find.byType(Scrollbar), findsNothing);
    final scroll = tester.state<NestedScrollViewState>(
      find.byType(NestedScrollView),
    );
    await tester.drag(find.text('列表项目 1'), const Offset(0, -200));
    await tester.pumpAndSettle();
    expect(scroll.outerController.offset, greaterThan(0));
    expect(find.byType(Scrollbar), findsNothing);
  });

  testWidgets('页面背景由 Hyper 颜色主题解析，顶栏和底部插槽正常承载', (tester) async {
    final theme = HyperThemeData.light();
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: theme,
          duration: Duration.zero,
          child: const HyperScaffold(
            appBar: _TestAppBar(),
            body: Center(child: Text('页面内容')),
            bottomBar: Text('底部内容'),
          ),
        ),
      ),
    );

    expect(
      tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
      theme.colors.background,
    );
    expect(find.text('顶栏'), findsOneWidget);
    expect(find.text('页面内容'), findsOneWidget);
    expect(find.text('底部内容'), findsOneWidget);
  });

  testWidgets('全局、局部和实例按顺序覆盖页面背景', (tester) async {
    final theme = HyperThemeData.light().copyWith(
      scaffoldTheme: const HyperScaffoldThemeData(
        style: HyperScaffoldStyle(backgroundColor: Colors.red),
      ),
    );

    Widget build({HyperScaffoldStyle? style, bool local = false}) =>
        MaterialApp(
          home: HyperTheme(
            data: theme,
            duration: Duration.zero,
            child: local
                ? HyperScaffoldTheme(
                    data: const HyperScaffoldThemeData(
                      style: HyperScaffoldStyle(backgroundColor: Colors.green),
                    ),
                    child: HyperScaffold(style: style, body: const Text('内容')),
                  )
                : HyperScaffold(style: style, body: const Text('内容')),
          ),
        );

    await tester.pumpWidget(build());
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
      Colors.red,
    );

    await tester.pumpWidget(build(local: true));
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
      Colors.green,
    );

    await tester.pumpWidget(
      build(
        local: true,
        style: const HyperScaffoldStyle(backgroundColor: Colors.blue),
      ),
    );
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
      Colors.blue,
    );
  });
}

class _TestAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _TestAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) => const Text('顶栏');
}
