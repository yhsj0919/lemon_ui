import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

const _height = TextHeightBehavior(
  leadingDistribution: TextLeadingDistribution.even,
  applyHeightToFirstAscent: false,
  applyHeightToLastDescent: false,
);
const _items = [
  HyperMenuItem(id: 'inspect', label: '查看 项目 1'),
  HyperMenuItem(id: 'delete', label: '删除此行'),
  HyperMenuItem(id: 'description', label: '菜单标题', description: '第一行说明\n第二行说明'),
];
const _style = HyperMenuStyle(
  itemTextStyle: TextStyle(fontSize: 14, height: 2),
  descriptionStyle: TextStyle(fontSize: 12, height: 2),
);

void checkText(WidgetTester tester, String text) {
  final paragraph = tester.renderObject<RenderParagraph>(find.text(text));
  final painter = TextPainter(
    text: paragraph.text,
    textDirection: paragraph.textDirection,
    textScaler: paragraph.textScaler,
    maxLines: paragraph.maxLines,
    textHeightBehavior: _height,
  )..layout(maxWidth: paragraph.size.width);
  expect(
    paragraph.size.height,
    closeTo(painter.height, 1e-6),
    reason: 'Outer line leading must not shift the visible menu text.',
  );
  painter.dispose();
}

void checkMenu(WidgetTester tester) {
  for (final item in _items) {
    checkText(tester, item.label);
    var block = tester.getRect(find.text(item.label));
    if (item.description != null) {
      checkText(tester, item.description!);
      block = block.expandToInclude(
        tester.getRect(find.text(item.description!)),
      );
    }
    final row = tester.getRect(
      find.byKey(ValueKey('hyper-menu-item-${item.id}')),
    );
    expect(block.center.dy, closeTo(row.center.dy, 1e-6));
  }
}

void main() {
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets(
      'menu title and description center without external line leading at $scale',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: HyperTheme(
              data: HyperThemeData.light(),
              child: MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                child: const Scaffold(
                  body: Center(
                    child: HyperMenu(items: _items, style: _style),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        checkMenu(tester);
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets('context menus use the same centered text layout', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: const Scaffold(
            body: Center(
              child: HyperContextMenu(
                items: _items,
                menuStyle: _style,
                child: SizedBox(width: 200, height: 80, child: Text('表格右键区域')),
              ),
            ),
          ),
        ),
      ),
    );
    final mouse = await tester.startGesture(
      tester.getCenter(find.text('表格右键区域')),
      kind: PointerDeviceKind.mouse,
      buttons: kSecondaryMouseButton,
    );
    await mouse.up();
    await tester.pumpAndSettle();
    checkMenu(tester);
    expect(tester.takeException(), isNull);
  });
}
