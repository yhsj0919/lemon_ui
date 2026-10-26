import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/surface/hyper_navigation_surface.dart';

void main() {
  testWidgets('导航表面不改变内容的收缩尺寸，材质切换保持几何一致', (tester) async {
    for (final material in [null, HyperSurfaceMaterial.frostedGlass()]) {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 200,
                  maxHeight: 100,
                ),
                child: HyperNavigationSurface(
                  key: const ValueKey('surface'),
                  style: HyperCardStyle(
                    material: material,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const SizedBox(width: 40, height: 24),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      if (material == null) {
        expect(
          tester
              .widget<AnimatedContainer>(find.byType(AnimatedContainer).first)
              .clipBehavior,
          Clip.antiAlias,
        );
      } else {
        final surface = tester.widget<HyperMaterialSurface>(
          find.byType(HyperMaterialSurface).first,
        );
        expect(surface.borderRadius, BorderRadius.circular(16));
        expect(surface.clipBehavior, Clip.antiAlias);
      }
      expect(
        tester.getSize(find.byKey(const ValueKey('surface'))),
        const Size(40, 24),
      );
    }
  });
  test('新增导航表面支持复制、合并、插值和值相等', () {
    final surface = HyperCardStyle(
      background: const HyperFill.color(Colors.red),
      border: Border.all(color: Colors.green, width: 2),
      boxShadow: const [],
    );
    final sidebar = HyperSidebarStyle(
      surfaceStyle: surface,
      selectedItemSurfaceStyle: surface,
    );
    expect(sidebar.copyWith(), sidebar);
    expect(sidebar.copyWith().hashCode, sidebar.hashCode);
    expect(const HyperSidebarStyle().merge(sidebar), sidebar);
    expect(HyperSidebarStyle.lerp(sidebar, sidebar, .5), sidebar);
    final breadcrumb = HyperBreadcrumbStyle(highlightStyle: surface);
    expect(breadcrumb.copyWith(), breadcrumb);
    expect(const HyperBreadcrumbStyle().merge(breadcrumb), breadcrumb);
    expect(HyperBreadcrumbStyle.lerp(breadcrumb, breadcrumb, .5), breadcrumb);
    final tabs = HyperTabBarThemeData(
      separated: HyperTabBarStyle(trackStyle: surface),
    );
    final theme = HyperThemeData.light().copyWith(tabBarTheme: tabs);
    expect(theme.copyWith().tabBarTheme, tabs);
    expect(theme.copyWith(), theme);
    expect(theme.lerp(theme, .5).tabBarTheme, tabs);
    expect(const HyperTabBarThemeData().merge(tabs), tabs);
    expect(tabs.copyWith(), tabs);
    final appBar = HyperAppBarStyle(surfaceStyle: surface);
    expect(appBar.copyWith(), appBar);
    final drawer = HyperDrawerStyle(surfaceStyle: surface);
    expect(const HyperDrawerStyle().merge(drawer), drawer);
    final empty = HyperResultStyle(
      material: surface.material,
      background: surface.background,
      border: surface.border,
      borderRadius: surface.borderRadius,
      boxShadow: surface.boxShadow,
    );
    expect(empty.copyWith(), empty);
    expect(empty, isNot(const HyperResultStyle()));
    const step = HyperStepStyle(boxShadow: []);
    expect(step.copyWith(), step);
    expect(HyperStepStyle.lerp(step, step, .5), step);
    const drawerSize = HyperDrawerSize(width: 300, radius: 16);
    expect(
      HyperDrawerSize.lerp(
        drawerSize,
        drawerSize.copyWith(radius: 24),
        .5,
      ).radius,
      20,
    );
  });

  testWidgets('圆角侧栏的单边轮廓在普通与高级材质下均可绘制', (tester) async {
    for (final advanced in [false, true]) {
      final theme = HyperThemeData.light().copyWith(
        materialTheme: HyperMaterialThemeData(
          quality: advanced
              ? HyperMaterialQuality.advanced
              : HyperMaterialQuality.standard,
          material: advanced ? const HyperSurfaceMaterial.frostedGlass() : null,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: theme,
            child: Scaffold(
              body: SizedBox(
                width: 320,
                height: 400,
                child: HyperSidebar(
                  items: const [HyperSidebarItem(id: 'one', label: '项目')],
                  style: HyperSidebarStyle(
                    surfaceStyle: HyperCardStyle(
                      borderRadius: BorderRadius.circular(16),
                      border: const BorderDirectional(
                        end: BorderSide(color: Colors.red, width: 2),
                      ),
                      boxShadow: const [],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('标签变体与实例颜色覆盖在文字缩放下生效', (tester) async {
    for (final scale in [1.0, 1.3, 2.0]) {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light().copyWith(
              tabBarTheme: const HyperTabBarThemeData(
                separated: HyperTabBarStyle(
                  selectedForegroundColor: Colors.red,
                ),
              ),
            ),
            child: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: const Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 320,
                    child: DefaultTabController(
                      length: 2,
                      child: HyperTabBar.separated(
                        style: HyperTabBarStyle(foregroundColor: Colors.green),
                        tabs: [
                          HyperTab(text: '通知'),
                          HyperTab(text: '设置'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.labelColor, Colors.red);
      expect(tabBar.unselectedLabelColor, Colors.green);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('显式空阴影覆盖高级与降级材质，空实色配方继承语义背景', (tester) async {
    for (final quality in HyperMaterialQuality.values) {
      final theme = HyperThemeData.light().copyWith(
        materialTheme: HyperMaterialThemeData(
          quality: quality,
          material: const HyperSurfaceMaterial.frostedGlass(
            boxShadow: [BoxShadow(color: Colors.red, blurRadius: 12)],
            fallback: HyperSurfaceMaterial.solid(
              boxShadow: [BoxShadow(color: Colors.red, blurRadius: 12)],
            ),
          ),
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: theme,
            child: const Scaffold(
              body: HyperNotification(
                content: Text('内容'),
                style: HyperNotificationStyle(boxShadow: []),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      for (final decoration in tester.widgetList<DecoratedBox>(
        find.descendant(
          of: find.byType(HyperNotification),
          matching: find.byType(DecoratedBox),
        ),
      )) {
        if (decoration.decoration is BoxDecoration) {
          expect(
            (decoration.decoration as BoxDecoration).boxShadow ?? [],
            isEmpty,
          );
        }
      }
      expect(tester.takeException(), isNull);
    }
    final resolved = const HyperMaterialThemeData(
      material: HyperSurfaceMaterial.solid(),
    ).resolveMaterial(semanticBackground: const HyperFill.color(Colors.purple));
    expect(resolved!.background!.color!.toARGB32(), Colors.purple.toARGB32());
  });
}
