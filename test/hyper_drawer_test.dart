import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('抽屉宽度由四端主题集中管理，并支持强类型覆盖', () {
    const sizes = HyperSizeThemeData();
    expect(sizes.phone.drawer.width, 304);
    expect(sizes.tablet.drawer.width, 304);
    expect(sizes.desktop.drawer.width, 304);
    expect(sizes.watch.drawer.width, 200);
    final changed = sizes.copyWith(
      phone: sizes.phone.copyWith(
        drawer: sizes.phone.drawer.copyWith(width: 280),
      ),
    );
    expect(changed.phone.drawer.width, 280);
    expect(changed.tablet.drawer, sizes.tablet.drawer);
  });

  testWidgets('抽屉沿用 Scaffold 的开合、遮罩与返回行为', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: HyperScaffold(
            drawer: const HyperDrawer(child: Text('自由内容')),
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => HyperScaffold.openDrawer(context),
                child: const Text('打开抽屉'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开抽屉'));
    await tester.pumpAndSettle();
    expect(find.text('自由内容'), findsOneWidget);
    expect(tester.widget<Drawer>(find.byType(Drawer)).width, 304);
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
      isTrue,
    );

    await tester.tapAt(const Offset(380, 350));
    await tester.pumpAndSettle();
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
      isFalse,
    );
  });

  testWidgets('桌面鼠标可沿关闭方向拖动起始侧和结束侧抽屉', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.windows),
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: HyperScaffold(
            drawer: const HyperDrawer(child: SizedBox.expand()),
            endDrawer: const HyperDrawer(child: SizedBox.expand()),
            body: Builder(
              builder: (context) => Column(
                children: [
                  TextButton(
                    onPressed: () => HyperScaffold.openDrawer(context),
                    child: const Text('打开起始侧'),
                  ),
                  TextButton(
                    onPressed: () => HyperScaffold.openEndDrawer(context),
                    child: const Text('打开结束侧'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开起始侧'));
    await tester.pumpAndSettle();
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
      isTrue,
    );
    await tester.dragFrom(
      const Offset(250, 350),
      const Offset(-200, 0),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pumpAndSettle();
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
      isFalse,
    );

    await tester.tap(find.text('打开结束侧'));
    await tester.pumpAndSettle();
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isEndDrawerOpen,
      isTrue,
    );
    await tester.dragFrom(
      const Offset(150, 350),
      const Offset(200, 0),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pumpAndSettle();
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isEndDrawerOpen,
      isFalse,
    );
  });

  testWidgets('桌面 RTL 起始侧抽屉沿正确方向拖动关闭', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.windows),
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: HyperScaffold(
              drawer: const HyperDrawer(child: SizedBox.expand()),
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => HyperScaffold.openDrawer(context),
                  child: const Text('打开'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    await tester.dragFrom(
      const Offset(150, 350),
      const Offset(200, 0),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pumpAndSettle();
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
      isFalse,
    );
  });

  testWidgets('头尾固定在中间滚动内容之外', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: HyperScaffold(
            drawer: HyperDrawer(
              header: const SizedBox(height: 80, child: Text('头部')),
              footer: const SizedBox(height: 70, child: Text('尾部')),
              child: ListView(
                controller: controller,
                children: [
                  for (var index = 0; index < 30; index++)
                    SizedBox(height: 60, child: Text('内容 $index')),
                ],
              ),
            ),
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => HyperScaffold.openDrawer(context),
                child: const Text('打开'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    final headerTop = tester.getTopLeft(find.text('头部'));
    final footerTop = tester.getTopLeft(find.text('尾部'));
    expect(tester.getTopLeft(find.text('内容 0')).dy, greaterThan(headerTop.dy));
    expect(footerTop.dy, greaterThan(headerTop.dy));

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(controller.offset, greaterThan(0));
    expect(tester.getTopLeft(find.text('头部')), headerTop);
    expect(tester.getTopLeft(find.text('尾部')), footerTop);
  });

  testWidgets('全局、局部和实例只覆盖明确提供的抽屉属性', (tester) async {
    final base = HyperThemeData.light();
    final theme = base.copyWith(
      drawerTheme: const HyperDrawerThemeData(
        style: HyperDrawerStyle(
          width: 280,
          backgroundColor: Colors.red,
          elevation: 3,
        ),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: theme,
          duration: Duration.zero,
          child: HyperScaffold(
            drawer: const HyperDrawerTheme(
              data: HyperDrawerThemeData(
                style: HyperDrawerStyle(backgroundColor: Colors.green),
              ),
              child: HyperDrawer(
                style: HyperDrawerStyle(width: 260),
                child: Text('主题内容'),
              ),
            ),
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => HyperScaffold.openDrawer(context),
                child: const Text('打开'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    final drawer = tester.widget<Drawer>(find.byType(Drawer));
    expect(drawer.width, 260);
    expect(drawer.backgroundColor, Colors.green);
    expect(drawer.elevation, 3);
  });
}
