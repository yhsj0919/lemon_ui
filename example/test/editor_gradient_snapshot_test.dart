import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_button_fields.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';

void main() {
  test('单线渐变按节点描述配色，插入及重置不破坏顺序', () {
    final colors = HyperThemeData.light().colors;
    final model = EditorGradient(
      colors: [
        const EditorColor(argb: 0xffff0000),
        const EditorColor(argb: 0xff0000ff),
      ],
      stops: [0, 1],
    );
    final gradient = model.resolve(colors) as LinearGradient;
    expect(gradient.colors, [const Color(0xffff0000), const Color(0xff0000ff)]);
    expect(gradient.stops, [0, 1]);
    final restored = EditorGradient.fromJson(model.toJson());
    expect(restored.colors.length, 2);
    restored.appendStop();
    expect(restored.stops, [0, .5, 1]);
    expect(
      restored.colors.take(2).map((c) => c.toJson()).toList(),
      model.colors.map((c) => c.toJson()).toList(),
    );
    expect(restored.colors.last.toJson(), model.colors.last.toJson());
    restored.appendStop();
    expect(restored.stops, [0, .5, .75, 1]);
    restored.stops[1] = .45;
    restored.stops[2] = .46;
    restored.resetStop(1);
    expect(restored.stops[1], lessThanOrEqualTo(restored.stops[2]));
    expect(() => EditorGradient.fromJson(restored.toJson()), returnsNormally);
    restored.stops[restored.stops.length - 1] = .8;
    final resolved = restored.resolve(colors);
    expect(resolved.stops!.last, .8);
    expect(() => Gradient.lerp(gradient, resolved, .5), returnsNormally);
  });

  testWidgets('分割线节点增删在主题动画中保持有效快照', (tester) async {
    final doc = EditorThemeDocument();
    final model = EditorGradient(
      colors: [
        const EditorColor(argb: 0xffff0000),
        const EditorColor(argb: 0xff0000ff),
      ],
      stops: [0, 1],
    );
    doc.light.divider.dividerStyle.gradient = model;
    Widget app() => MaterialApp(
      theme: ThemeData(extensions: [doc.resolve(false)]),
      home: const Center(
        child: SizedBox(width: 200, child: HyperDivider(child: Text('分割线'))),
      ),
    );
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    model.colors.insert(1, const EditorColor(argb: 0xff00ff00));
    model.stops.insert(1, .5);
    await tester.pumpWidget(app());
    await tester.pump(const Duration(milliseconds: 50));
    expect(tester.takeException(), isNull);
    model.colors.removeAt(1);
    model.stops.removeAt(1);
    await tester.pumpWidget(app());
    await tester.pump(const Duration(milliseconds: 50));
    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  for (final kind in EditorGradientKind.values) {
    test('渐变 ${kind.name} 增删节点不修改旧主题快照', () {
      final colors = HyperThemeData.light().colors;
      final model = EditorGradient(
        kind: kind,
        colors: [
          const EditorColor(argb: 0xffff0000),
          const EditorColor(argb: 0xff0000ff),
        ],
        stops: [0, 1],
      );
      final first = model.resolve(colors);
      model.colors.insert(1, const EditorColor(argb: 0xff00ff00));
      model.stops.insert(1, .5);
      expect(first.stops, [0, 1]);
      final second = model.resolve(colors);
      expect(() => Gradient.lerp(first, second, .5), returnsNormally);
      model.colors.removeAt(1);
      model.stops.removeAt(1);
      expect(second.stops, [0, .5, 1]);
      expect(
        () => Gradient.lerp(second, model.resolve(colors), .5),
        returnsNormally,
      );
    });
  }
  test('从组件主题导入渐变时复制节点位置', () {
    final stops = [0.0, 1.0];
    final gradient = LinearGradient(
      colors: const [Colors.red, Colors.blue],
      stops: stops,
    );
    final model = EditorGradient.fromGradient(gradient);
    model.stops[0] = .2;
    expect(gradient.stops, [0, 1]);
  });
}
