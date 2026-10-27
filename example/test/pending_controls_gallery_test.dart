import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/gallery/gallery_registry.dart';
import 'package:lemon_ui_example/pages/pending/hyper_pending_controls_pages.dart';

void main() {
  test(
    'confirmed controls have formal categories and stable unique page ids',
    () {
      const categories = {
        'hyper-list-group': '容器与表面',
        'hyper-rating': '选择控件',
        'hyper-transfer': '选择控件',
        'hyper-resizable': '容器与表面',
        'hyper-movable-dialog': '反馈与状态',
        'hyper-navigation-bar': '标签导航',
      };
      for (final entry in categories.entries) {
        final section = gallerySections.singleWhere(
          (s) => s.title == entry.value,
        );
        expect(section.items.where((i) => i.id == entry.key), hasLength(1));
        expect(galleryItems.where((i) => i.id == entry.key), hasLength(1));
      }
      expect(
        gallerySections
            .singleWhere((s) => s.title == '未确认')
            .items
            .where((i) => categories.containsKey(i.id)),
        isEmpty,
      );
    },
  );
  test('editor extensions round trip dimensions per device and colors per appearance', () {
    final doc = EditorThemeDocument();
    doc.desktop.extendedControls.ratingIconSize = 22;
    doc.phone.extendedControls.resizableHandleExtent = 12;
    doc.desktop.extendedControls.navigationGap = 10;
    doc.desktop.extendedControls.transferWidth = 240;
    doc.light.extendedControls.ratingActive = const EditorColor(
      argb: 0xffff0000,
    );
    doc.dark.extendedControls.navigationSelectedText = const EditorColor(
      argb: 0xff0000ff,
    );
    final restored = EditorThemeDocument.decode(doc.encode());
    expect(restored.encode(), doc.encode());
    final desktop = restored.resolve(
      false,
      deviceType: HyperDeviceType.desktop,
    );
    final phone = restored.resolve(false, deviceType: HyperDeviceType.phone);
    expect(desktop.ratingTheme.style.iconSize, 22);
    expect(phone.ratingTheme.style.iconSize, isNull);
    expect(desktop.ratingTheme.style.activeColor, const Color(0xffff0000));
    expect(phone.resizableTheme.style.handleExtent, 12);
    expect(desktop.transferTheme.style.panelWidth, 240);
    expect(desktop.navigationBarTheme.style.gap, 10);
    expect(
      restored
          .resolve(true)
          .navigationBarTheme
          .style
          .selectedItemStyle
          ?.foregroundColor,
      const Color(0xff0000ff),
    );
    restored.desktop.extendedControls.ratingIconSize = null;
    expect(restored.resolve(false).ratingTheme.style.iconSize, isNull);
  });

  for (final scale in [1.0, 1.3, 2.0]) {
    for (final entry in <String, Widget>{
      'rating': const HyperRatingPage(),
      'transfer': const HyperTransferPage(),
      'resizable': const HyperResizablePage(),
      'movable-dialog': const HyperMovableDialogPage(),
      'navigation': const HyperNavigationBarPage(),
    }.entries) {
      testWidgets('${entry.key} narrow gallery at text scale $scale', (
        t,
      ) async {
        await t.pumpWidget(
          MaterialApp(
            home: HyperTheme(
              data: HyperThemeData.light(),
              child: MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                child: Scaffold(
                  body: SizedBox(width: 240, height: 700, child: entry.value),
                ),
              ),
            ),
          ),
        );
        await t.pumpAndSettle();
        expect(t.takeException(), isNull);
      });
    }
  }
}
