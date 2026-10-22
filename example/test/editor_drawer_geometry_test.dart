import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/editor/editor_review_fields.dart';
import 'package:lemon_ui_example/editor/editor_dimension_limits.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:lemon_ui_example/pages/framework/hyper_drawer_page.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('四边和四角按设备保存，恢复后重回方向性默认圆角', () {
    final doc = EditorThemeDocument();
    final d = doc.desktop.reviews.drawer;
    d.insetPaddingLeft = 10;
    d.insetPaddingTop = 20;
    d.insetPaddingRight = 30;
    d.insetPaddingBottom = 40;
    d.radiusTopLeft = 4;
    d.radiusTopRight = 8;
    d.radiusBottomRight = 12;
    d.radiusBottomLeft = 16;
    final restored = EditorThemeDocument.decode(doc.encode());
    expect(restored.encode(), doc.encode());
    for (final dark in [false, true]) {
      final theme = restored.resolve(dark);
      expect(
        theme.sizes.desktop.drawer.margin,
        const EdgeInsets.fromLTRB(10, 20, 30, 40),
      );
      expect(
        theme.sizes.desktop.drawer.borderRadius,
        const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(12),
          bottomLeft: Radius.circular(16),
        ),
      );
      expect(theme.sizes.phone.drawer.margin, EdgeInsets.zero);
      expect(theme.sizes.phone.drawer.borderRadius, isNull);
    }
    final legacy = EditorThemeDocument.decode(
      '{"formatVersion":1,"base":"lemon-hyper-v1","name":"旧主题","devices":{"desktop":{"reviews":{"drawer":{"radius":22}}}}}',
    );
    expect(legacy.resolve(false).sizes.desktop.drawer.radius, 22);
    expect(legacy.resolve(false).sizes.desktop.drawer.borderRadius, isNull);
    d.radiusTopLeft = d.radiusTopRight = d.radiusBottomRight =
        d.radiusBottomLeft = null;
    expect(doc.resolve(false).sizes.desktop.drawer.borderRadius, isNull);
    d.width = 40;
    d.radiusTopLeft = 90;
    constrainEditorReviewDimensions(
      'drawer',
      d,
      doc.resolve(false).sizes.desktop,
      viewport: const Size(100, 100),
    );
    expect(d.radiusTopLeft, 20);
    expect(
      editorDrawerRadiusLimit(
        100,
        const Size(100, 100),
        const EdgeInsets.fromLTRB(10, 35, 10, 35),
      ),
      15,
    );
    final desktop = doc.resolve(false).sizes.desktop;
    expect(
      editorDrawerRadiusLimit(304, const Size(1280, 800), EdgeInsets.zero),
      60,
    );
    expect(
      editorDrawerRadiusLimit(32, const Size(1280, 800), EdgeInsets.zero),
      16,
    );
    expect(
      editorDrawerMarginLimit(desktop),
      desktop.minimumInteractiveDimension.floorToDouble(),
    );
  });

  testWidgets('抽屉编辑器写入整数、关联收紧圆角并可恢复继承', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1600, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-drawer');
    await tester.pumpAndSettle();
    final panel = find.byKey(const ValueKey('editor-panel-抽屉'));
    final scroll = find
        .descendant(of: panel, matching: find.byType(Scrollable))
        .first;
    final leftMargin = find.byKey(const ValueKey('editor-number-左外边距'));
    await tester.scrollUntilVisible(leftMargin, 200, scrollable: scroll);
    final initialSlider = tester.widget<HyperSlider>(
      find.descendant(of: leftMargin, matching: find.byType(HyperSlider)),
    );
    expect(initialSlider.value, 0);
    expect(initialSlider.min, 0);
    expect(initialSlider.max, 36);
    Future<void> number(String label, double value) async {
      tester.state<ScrollableState>(scroll).position.jumpTo(0);
      await tester.pump();
      final row = find.byKey(ValueKey('editor-number-$label'));
      await tester.scrollUntilVisible(row, 200, scrollable: scroll);
      tester
          .widget<HyperSlider>(
            find.descendant(of: row, matching: find.byType(HyperSlider)),
          )
          .onChanged!(value);
      await tester.pumpAndSettle();
    }

    HyperDrawerSize size() =>
        HyperTheme.of(tester.element(find.byType(HyperDrawerPage)))
            .sizes
            .desktop
            .drawer;
    await number('左外边距', 17.7);
    await number('上外边距', 23.2);
    await number('左上圆角', 31.6);
    expect(size().margin.resolve(TextDirection.ltr).left, 18);
    expect(size().margin.resolve(TextDirection.ltr).top, 23);
    expect(size().borderRadius!.resolve(TextDirection.ltr).topLeft.x, 32);
    await number('展开宽度', 40.2);
    expect(size().width, 40);
    expect(size().borderRadius!.resolve(TextDirection.ltr).topLeft.x, 20);
    final cornerRow = find.byKey(const ValueKey('editor-number-左上圆角'));
    await tester.scrollUntilVisible(cornerRow, 200, scrollable: scroll);
    tester
        .widget<HyperIconButton>(
          find.descendant(
            of: cornerRow,
            matching: find.byType(HyperIconButton),
          ),
        )
        .onPressed!();
    await tester.pumpAndSettle();
    expect(size().borderRadius, isNull);
    expect(size().margin.resolve(TextDirection.ltr).left, 18);
    expect(tester.takeException(), isNull);
  });
}
