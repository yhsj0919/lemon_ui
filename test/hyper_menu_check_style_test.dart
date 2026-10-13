import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final placement in HyperMenuCheckPlacement.values) {
    testWidgets('选中图标位置与独立样式 $placement', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Scaffold(
              body: HyperMenu(
                items: const [HyperMenuItem(id: 'a', label: '选项')],
                selectedId: 'a',
                onSelected: (_) {},
                style: HyperMenuStyle(
                  checkPlacement: placement,
                  checkIcon: Icons.star,
                  checkColor: Colors.red,
                  checkSize: 22,
                  checkSpacing: 9,
                ),
              ),
            ),
          ),
        ),
      );
      final icon = find.byIcon(Icons.star);
      final text = find.text('选项');
      expect(tester.widget<Icon>(icon).color, Colors.red);
      expect(tester.widget<Icon>(icon).size, 22);
      if (placement == HyperMenuCheckPlacement.leading) {
        expect(tester.getCenter(icon).dx, lessThan(tester.getCenter(text).dx));
      } else {
        expect(
          tester.getCenter(icon).dx,
          greaterThan(tester.getCenter(text).dx),
        );
      }
      expect(tester.takeException(), isNull);
    });
  }
}
