import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Widget app(Widget child) => MaterialApp(
  home: HyperDeviceDetector(
    deviceType: HyperDeviceType.desktop,
    builder: (context, device, _) => HyperTheme(
      data: HyperThemeData.light(),
      duration: Duration.zero,
      child: HyperCardTheme(
        data: HyperCardThemeData(
          style: HyperCardStyle(padding: const EdgeInsets.all(40)),
        ),
        child: Scaffold(body: Center(child: child)),
      ),
    ),
  ),
);

void main() {
  testWidgets('下拉面板只应用自身留白，显式覆盖不叠加 Card 主题', (tester) async {
    for (final padding in [null, 0.0, 12.0]) {
      await tester.pumpWidget(
        app(
          HyperDropdown(
            label: const Text('打开面板'),
            presentation: HyperSelectPresentation.anchored,
            surfaceStyle: padding == null
                ? null
                : HyperCardStyle(padding: EdgeInsets.all(padding)),
            panelBuilder: (context, close) =>
                const SizedBox(key: ValueKey('content'), width: 80, height: 24),
          ),
        ),
      );
      await tester.tap(find.text('打开面板'));
      await tester.pumpAndSettle();
      final surface = tester.getRect(find.byType(HyperCard));
      final content = tester.getRect(find.byKey(const ValueKey('content')));
      final expected =
          padding ??
          HyperTheme.sizesOf(tester.element(find.byType(HyperDropdown)))
              .menu
              .padding;
      expect(content.left - surface.left, expected);
      expect(content.top - surface.top, expected);
      expect(surface.bottom - content.bottom, expected);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    }
  });

  testWidgets('颜色选择浮层只有一层面板内边距', (tester) async {
    await tester.pumpWidget(
      app(
        HyperColorPickerField(
          value: Colors.blue,
          onChanged: (_) {},
          presentation: HyperSelectPresentation.anchored,
        ),
      ),
    );
    await tester.tap(find.byType(HyperColorPickerField));
    await tester.pumpAndSettle();
    final surface = tester.getRect(find.byType(HyperCard));
    final content = tester.getRect(find.byType(HyperColorPicker));
    final expected = HyperTheme.sizesOf(
      tester.element(find.byType(HyperColorPickerField)),
    ).menu.padding;
    expect(content.left - surface.left, expected);
    expect(surface.right - content.right, expected);
    expect(content.top - surface.top, expected);
    expect(surface.bottom - content.bottom, expected);
    expect(tester.takeException(), isNull);
  });

  testWidgets('对话框与底部弹窗的表面不额外增加正文内边距', (tester) async {
    for (final sheet in [false, true]) {
      const content = SizedBox(key: ValueKey('content'), width: 80, height: 24);
      await tester.pumpWidget(
        app(
          sheet
              ? const HyperBottomSheet(
                  showDragHandle: false,
                  useBottomSafeArea: false,
                  content: content,
                  style: HyperBottomSheetStyle(padding: EdgeInsets.all(12)),
                )
              : const HyperDialog(
                  showCloseButton: false,
                  content: content,
                  style: HyperDialogStyle(padding: EdgeInsets.all(12)),
                ),
        ),
      );
      await tester.pumpAndSettle();
      final root = find.byType(sheet ? HyperBottomSheet : HyperDialog);
      final surface = tester.getRect(
        find
            .descendant(of: root, matching: find.byType(AnimatedContainer))
            .first,
      );
      final body = tester.getRect(find.byKey(const ValueKey('content')));
      expect(body.left - surface.left, 12);
      expect(surface.right - body.right, 12);
      expect(body.top - surface.top, 12);
      expect(surface.bottom - body.bottom, 12);
      expect(tester.takeException(), isNull);
    }
  });
}
