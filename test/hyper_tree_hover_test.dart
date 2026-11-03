import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('独立展开区宽度跟随图标，间距不受行高影响', (tester) async {
    for (final rowHeight in [32.0, 48.0]) {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Center(
              child: SizedBox(
                width: 300,
                child: HyperTreeView<String>(
                  separateExpansion: true,
                  nodes: const [
                    HyperTreeNode<String>(
                      id: 'branch',
                      label: Text('branch'),
                      children: [
                        HyperTreeNode<String>(id: 'leaf', label: Text('leaf')),
                      ],
                    ),
                  ],
                  style: HyperTreeViewStyle(
                    rowHeight: rowHeight,
                    iconSize: 16,
                    contentSpacing: 6,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final arrow = find.byIcon(HyperIcons.chevronRight).first;
      expect(
        tester.getTopLeft(find.text('branch')).dx -
            tester.getTopRight(arrow).dx,
        6,
      );
      final target = find
          .ancestor(of: arrow, matching: find.byType(HyperPressable))
          .first;
      expect(tester.getSize(target), Size(16, rowHeight));
      await tester.tapAt(tester.getTopLeft(target) + const Offset(8, 2));
      await tester.pumpAndSettle();
      expect(find.text('leaf'), findsOneWidget);
      await tester.tap(arrow);
      await tester.pumpAndSettle();
      expect(find.text('leaf'), findsNothing);
    }
  });

  testWidgets('独立展开按钮不叠加一块与整行不同的悬停底色', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Material(
            child: Center(
              child: SizedBox(
                width: 300,
                child: HyperTreeView<String>(
                  nodes: const [
                    HyperTreeNode<String>(
                      id: 'branch',
                      label: Text('branch'),
                      children: [
                        HyperTreeNode<String>(id: 'leaf', label: Text('leaf')),
                      ],
                    ),
                  ],
                  separateExpansion: true,
                  style: const HyperTreeViewStyle(
                    hoverBackground: HyperFill.color(Colors.red),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    final arrow = find.byIcon(HyperIcons.chevronRight).first;
    await mouse.moveTo(tester.getCenter(arrow));
    await tester.pumpAndSettle();
    final arrowSurface = tester.widget<DecoratedBox>(
      find.ancestor(of: arrow, matching: find.byType(DecoratedBox)).first,
    );
    expect((arrowSurface.decoration as BoxDecoration).color, isNull);
    final row = tester.widget<AnimatedContainer>(
      find
          .ancestor(
            of: find.text('branch'),
            matching: find.byType(AnimatedContainer),
          )
          .first,
    );
    expect((row.decoration! as BoxDecoration).color, Colors.red);
    await mouse.removePointer();
  });

  testWidgets('树悬停移出清除高亮，选中背景独立保留', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Material(
            child: Center(
              child: SizedBox(
                width: 300,
                child: HyperTreeView<String>(
                  nodes: const [
                    HyperTreeNode<String>(id: 'a', label: Text('node')),
                  ],
                  style: const HyperTreeViewStyle(
                    hoverBackground: HyperFill.color(Colors.red),
                    selectedBackground: HyperFill.color(Colors.blue),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    AnimatedContainer row() => tester.widget<AnimatedContainer>(
      find
          .ancestor(
            of: find.text('node'),
            matching: find.byType(AnimatedContainer),
          )
          .first,
    );
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.text('node')));
    await tester.pumpAndSettle();
    expect((row().decoration! as BoxDecoration).color, Colors.red);
    await mouse.moveTo(Offset.zero);
    await tester.pumpAndSettle();
    expect((row().decoration! as BoxDecoration).color, isNot(Colors.red));
    expect((row().foregroundDecoration! as BoxDecoration).border, isNull);
    await tester.tap(find.text('node'));
    await mouse.moveTo(Offset.zero);
    await tester.pumpAndSettle();
    expect((row().decoration! as BoxDecoration).color, Colors.blue);
    await mouse.removePointer();
  });
}
