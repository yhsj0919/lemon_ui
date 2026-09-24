import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('顶栏四端尺寸集中在主题方案中，可单独覆盖', () {
    const sizes = HyperSizeThemeData();
    expect(sizes.phone.appBar.collapsedHeight, 58);
    expect(sizes.phone.appBar.mediumExpandedHeight, 80);
    expect(sizes.phone.appBar.expandedHeight, 96);
    expect(sizes.tablet.appBar.collapsedHeight, 64);
    expect(sizes.desktop.appBar.collapsedHeight, 48);
    expect(sizes.watch.appBar.collapsedHeight, 48);
    final updated = sizes.copyWith(
      phone: sizes.phone.copyWith(
        appBar: sizes.phone.appBar.copyWith(expandedHeight: 180),
      ),
    );
    expect(updated.phone.appBar.expandedHeight, 180);
    expect(updated.tablet.appBar, sizes.tablet.appBar);
  });

  testWidgets('普通顶栏使用当前设备尺寸与全局主题', (tester) async {
    final base = HyperThemeData.light();
    final theme = base.copyWith(
      appBarTheme: const HyperAppBarThemeData(
        style: HyperAppBarStyle(backgroundColor: Colors.indigo),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: theme,
          duration: Duration.zero,
          child: const HyperScaffold(
            appBar: HyperAppBar(title: Text('普通顶栏')),
            body: Text('页面内容'),
          ),
        ),
      ),
    );

    final context = tester.element(find.byType(HyperAppBar));
    final height = HyperTheme.sizesOf(context).appBar.collapsedHeight;
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.appBar!.preferredSize.height, height);
    expect(
      tester.widget<AppBar>(find.byType(AppBar)).backgroundColor,
      Colors.indigo,
    );
    expect(
      tester.widget<AppBar>(find.byType(AppBar)).titleTextStyle?.fontSize,
      base.typography.subsectionTitle,
    );
    expect(tester.widget<AppBar>(find.byType(AppBar)).centerTitle, isTrue);
    expect(find.text('普通顶栏'), findsOneWidget);
  });

  testWidgets('收起标题字号继承全局排版主题，固定和滚动变体一致', (tester) async {
    final base = HyperThemeData.light();
    final theme = base.copyWith(
      typography: base.typography.copyWith(subsectionTitle: 23),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: theme,
          duration: Duration.zero,
          child: const Scaffold(
            body: CustomScrollView(
              slivers: [
                HyperSliverAppBar(title: Text('滚动标题')),
                SliverToBoxAdapter(child: SizedBox(height: 1200)),
              ],
            ),
          ),
        ),
      ),
    );
    expect(
      tester
          .widget<SliverAppBar>(find.byType(SliverAppBar))
          .titleTextStyle
          ?.fontSize,
      23,
    );
  });

  testWidgets('展开变体配普通 ListView，向上滚动后收起', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: HyperScaffold(
            appBar: const HyperAppBar.large(title: Text('展开标题')),
            body: ListView.builder(
              itemCount: 40,
              itemBuilder: (_, index) =>
                  SizedBox(height: 64, child: Text('项目 $index')),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(NestedScrollView), findsOneWidget);
    final context = tester.element(find.byType(HyperSliverAppBar));
    final metrics = HyperTheme.sizesOf(context).appBar;
    final bar = tester.widget<SliverAppBar>(find.byType(SliverAppBar));
    expect(bar.expandedHeight, metrics.expandedHeight);
    expect(bar.toolbarHeight, metrics.collapsedHeight);
    expect(bar.pinned, isTrue);
    final scroll = tester.state<NestedScrollViewState>(
      find.byType(NestedScrollView),
    );
    expect(scroll.outerController.offset, 0);

    final largeTitle = find.descendant(
      of: find.byType(PositionedDirectional),
      matching: find.text('展开标题'),
    );
    final initialTop = tester.getTopLeft(largeTitle).dy;
    final initialOpacity = tester
        .widget<Opacity>(
          find.ancestor(of: largeTitle, matching: find.byType(Opacity)),
        )
        .opacity;
    expect(initialOpacity, 1);

    await tester.drag(find.byType(ListView), const Offset(0, -20));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(largeTitle).dy, lessThan(initialTop));
    expect(
      tester
          .widget<Opacity>(
            find.ancestor(of: largeTitle, matching: find.byType(Opacity)),
          )
          .opacity,
      lessThan(initialOpacity),
    );

    await tester.drag(find.byType(ListView), const Offset(0, -350));
    await tester.pumpAndSettle();
    expect(scroll.outerController.offset, greaterThan(0));
    expect(find.text('展开标题'), findsNWidgets(2));
    final smallTitle = find.descendant(
      of: find.byType(AnimatedSlide),
      matching: find.text('展开标题'),
    );
    expect(smallTitle, findsOneWidget);
    expect(
      tester
          .widget<AnimatedOpacity>(
            find.ancestor(
              of: smallTitle,
              matching: find.byType(AnimatedOpacity),
            ),
          )
          .opacity,
      1,
    );
  });

  testWidgets('局部主题和实例样式只覆盖明确提供的顶栏属性', (tester) async {
    final theme = HyperThemeData.light().copyWith(
      appBarTheme: const HyperAppBarThemeData(
        style: HyperAppBarStyle(
          backgroundColor: Colors.red,
          foregroundColor: Colors.black,
          centerTitle: true,
        ),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: theme,
          duration: Duration.zero,
          child: const HyperAppBarTheme(
            data: HyperAppBarThemeData(
              style: HyperAppBarStyle(backgroundColor: Colors.green),
            ),
            child: HyperScaffold(
              appBar: HyperAppBar(
                title: Text('覆盖测试'),
                style: HyperAppBarStyle(
                  backgroundColor: Colors.blue,
                  centerTitle: false,
                ),
              ),
              body: SizedBox(),
            ),
          ),
        ),
      ),
    );
    final bar = tester.widget<AppBar>(find.byType(AppBar));
    expect(bar.backgroundColor, Colors.blue);
    expect(bar.foregroundColor, Colors.black);
    expect(bar.centerTitle, isFalse);
  });

  testWidgets('CustomScrollView 直接使用滚动顶栏和展开标题主题', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const HyperAppBarTheme(
            data: HyperAppBarThemeData(
              style: HyperAppBarStyle(
                centerTitle: false,
                expandedTitleTextStyle: TextStyle(
                  fontSize: 30,
                  color: Colors.green,
                ),
              ),
            ),
            child: Scaffold(
              body: CustomScrollView(
                slivers: [
                  HyperSliverAppBar(title: Text('Sliver 标题')),
                  SliverToBoxAdapter(child: SizedBox(height: 1600)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    final largeTitle = find.descendant(
      of: find.byType(PositionedDirectional),
      matching: find.text('Sliver 标题'),
    );
    final largeStyle = DefaultTextStyle.of(tester.element(largeTitle)).style;
    expect(largeStyle.fontSize, 30);
    expect(largeStyle.color, Colors.green);
    expect(
      tester.widget<SliverAppBar>(find.byType(SliverAppBar)).centerTitle,
      isFalse,
    );

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -250));
    await tester.pumpAndSettle();
    expect(find.byType(SliverAppBar), findsOneWidget);
    final smallTitle = find.descendant(
      of: find.byType(AnimatedSlide),
      matching: find.text('Sliver 标题'),
    );
    expect(
      tester
          .widget<AnimatedOpacity>(
            find.ancestor(
              of: smallTitle,
              matching: find.byType(AnimatedOpacity),
            ),
          )
          .opacity,
      1,
    );
  });

  testWidgets('手机顶栏标题位置与 48 逻辑像素状态栏对照', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 890));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(400, 890),
            padding: EdgeInsets.only(top: 48),
          ),
          child: HyperDeviceDetector(
            deviceType: HyperDeviceType.phone,
            builder: (context, _, _) => HyperTheme(
              data: HyperThemeData.light(),
              duration: Duration.zero,
              child: const Scaffold(
                body: CustomScrollView(
                  slivers: [
                    HyperSliverAppBar(title: Text('设置')),
                    SliverToBoxAdapter(child: SizedBox(height: 1200)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final settings = tester.widget<FlexibleSpaceBarSettings>(
      find.byType(FlexibleSpaceBarSettings),
    );
    expect(settings.minExtent, 106);
    expect(settings.maxExtent, 144);
    final largeTitle = find.descendant(
      of: find.byType(PositionedDirectional),
      matching: find.text('设置'),
    );
    expect(tester.getTopLeft(largeTitle).dx, 26);
    expect(tester.getTopLeft(largeTitle).dy, 106);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -250));
    await tester.pumpAndSettle();
    final smallTitle = find.descendant(
      of: find.byType(AnimatedSlide),
      matching: find.text('设置'),
    );
    expect(tester.getCenter(smallTitle).dx, closeTo(200, 1));
    expect(tester.getCenter(smallTitle).dy, closeTo(77, 1));
  });

  testWidgets('普通 PreferredSizeWidget 保留自己的高度', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HyperScaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(72),
            child: ColoredBox(color: Colors.blue),
          ),
          body: SizedBox(),
        ),
      ),
    );
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.appBar!.preferredSize.height, 72);
  });

  testWidgets('默认顶栏使用高级柔光玻璃，统一质量和全局材质仍可覆盖', (tester) async {
    final base = HyperThemeData.light();
    Widget build(HyperThemeData theme) => MaterialApp(
      home: HyperTheme(
        data: theme,
        duration: Duration.zero,
        child: const HyperScaffold(
          appBar: HyperAppBar(title: Text('默认材质')),
          body: SizedBox(),
        ),
      ),
    );

    expect(base.materialTheme.quality, HyperMaterialQuality.advanced);
    await tester.pumpWidget(build(base));
    expect(find.byType(BackdropFilter), findsOneWidget);
    expect(
      tester
          .widget<HyperMaterialSurface>(find.byType(HyperMaterialSurface))
          .material
          ?.kind,
      HyperSurfaceMaterialKind.softLightGlass,
    );

    await tester.pumpWidget(
      build(
        base.copyWith(
          materialTheme: base.materialTheme.copyWith(
            quality: HyperMaterialQuality.standard,
          ),
        ),
      ),
    );
    expect(find.byType(BackdropFilter), findsNothing);
    expect(
      tester
          .widget<HyperMaterialSurface>(find.byType(HyperMaterialSurface))
          .material
          ?.kind,
      HyperSurfaceMaterialKind.solid,
    );

    await tester.pumpWidget(
      build(
        base.copyWith(
          materialTheme: base.materialTheme.copyWith(
            material: const HyperSurfaceMaterial.solid(
              background: HyperFill.color(Colors.red),
            ),
          ),
        ),
      ),
    );
    expect(
      tester
          .widget<HyperMaterialSurface>(find.byType(HyperMaterialSurface))
          .material
          ?.background
          ?.color,
      Colors.red,
    );
  });

  testWidgets('高级玻璃仅过滤背景，普通质量使用 fallback', (tester) async {
    const recipe = HyperSurfaceMaterial.frostedGlass(
      background: HyperFill.color(Color(0x66FFFFFF)),
      blurSigmaX: 18,
      blurSigmaY: 18,
      fallback: HyperSurfaceMaterial.solid(
        background: HyperFill.color(Color(0xFFF0F0F0)),
      ),
    );

    Widget build(HyperMaterialQuality quality) => MaterialApp(
      home: HyperTheme(
        data: HyperThemeData.light(),
        duration: Duration.zero,
        child: HyperMaterialTheme(
          data: HyperMaterialThemeData(quality: quality),
          child: HyperScaffold(
            appBar: const HyperAppBar(
              title: Text('清晰标题'),
              style: HyperAppBarStyle(material: recipe),
            ),
            body: const Text('背景内容'),
          ),
        ),
      ),
    );

    await tester.pumpWidget(build(HyperMaterialQuality.advanced));
    expect(find.byType(BackdropFilter), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(BackdropFilter),
        matching: find.text('清晰标题'),
      ),
      findsNothing,
    );

    await tester.pumpWidget(build(HyperMaterialQuality.standard));
    expect(find.byType(BackdropFilter), findsNothing);
    final surface = tester.widget<HyperMaterialSurface>(
      find.byType(HyperMaterialSurface),
    );
    expect(surface.material?.background?.color, const Color(0xFFF0F0F0));
  });

  testWidgets('玻璃顶栏透出背后画面，fallback 保持不透明', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 480));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repaintKey = GlobalKey();
    const material = HyperSurfaceMaterial.frostedGlass(
      background: HyperFill.color(Color(0x66FFFFFF)),
      fallback: HyperSurfaceMaterial.solid(
        background: HyperFill.color(Color(0xFFF0F0F0)),
      ),
    );

    Widget build(Color backdrop, HyperMaterialQuality quality) => MaterialApp(
      home: RepaintBoundary(
        key: repaintKey,
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: backdrop)),
            HyperTheme(
              data: HyperThemeData.light(),
              duration: Duration.zero,
              child: HyperMaterialTheme(
                data: HyperMaterialThemeData(quality: quality),
                child: const HyperScaffold(
                  style: HyperScaffoldStyle(
                    backgroundColor: Colors.transparent,
                  ),
                  appBar: HyperAppBar(
                    title: Text('玻璃'),
                    style: HyperAppBarStyle(material: material),
                  ),
                  body: SizedBox.expand(),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Future<List<int>> sample() async {
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(repaintKey),
      );
      final pixels = await tester.runAsync(() async {
        final image = await boundary.toImage();
        final bytes = await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        );
        final offset = (12 * image.width + 12) * 4;
        final rgba = bytes!.buffer.asUint8List();
        image.dispose();
        return rgba.sublist(offset, offset + 3);
      });
      return pixels!;
    }

    await tester.pumpWidget(build(Colors.red, HyperMaterialQuality.advanced));
    final redGlass = await sample();
    await tester.pumpWidget(build(Colors.blue, HyperMaterialQuality.advanced));
    final blueGlass = await sample();
    expect(redGlass, isNot(blueGlass));

    await tester.pumpWidget(build(Colors.red, HyperMaterialQuality.standard));
    final redFallback = await sample();
    await tester.pumpWidget(build(Colors.blue, HyperMaterialQuality.standard));
    final blueFallback = await sample();
    expect(redFallback, blueFallback);
  });

  testWidgets('展开时贴合页面背景，收起后启用玻璃材质', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 480));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repaintKey = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        home: RepaintBoundary(
          key: repaintKey,
          child: Stack(
            children: [
              const Positioned.fill(child: ColoredBox(color: Colors.red)),
              HyperTheme(
                data: HyperThemeData.light(),
                duration: Duration.zero,
                child: HyperMaterialTheme(
                  data: const HyperMaterialThemeData(
                    quality: HyperMaterialQuality.advanced,
                  ),
                  child: HyperScaffold(
                    style: const HyperScaffoldStyle(
                      backgroundColor: Colors.transparent,
                    ),
                    appBar: const HyperAppBar.large(
                      title: Text('展开标题'),
                      style: HyperAppBarStyle(
                        material: HyperSurfaceMaterial.frostedGlass(
                          background: HyperFill.color(Color(0x66FFFFFF)),
                          blurSigmaX: 0,
                          blurSigmaY: 0,
                        ),
                      ),
                    ),
                    body: ListView.builder(
                      itemCount: 30,
                      itemBuilder: (_, index) => const SizedBox(height: 64),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Future<List<int>> sample() async {
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(repaintKey),
      );
      final pixels = await tester.runAsync(() async {
        final image = await boundary.toImage();
        final bytes = await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        );
        final offset = (12 * image.width + 12) * 4;
        final rgba = bytes!.buffer.asUint8List();
        image.dispose();
        return rgba.sublist(offset, offset + 3);
      });
      return pixels!;
    }

    final expanded = await sample();
    await tester.drag(find.byType(ListView), const Offset(0, -350));
    await tester.pumpAndSettle();
    final collapsed = await sample();
    expect(expanded[1], lessThan(collapsed[1]));
    expect(collapsed[1], greaterThan(0));
    expect(collapsed, isNot(expanded));
  });
}
