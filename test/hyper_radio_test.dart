import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  Widget app(Widget child) => MaterialApp(
    home: HyperTheme(
      data: HyperThemeData.light(
        sizes: const HyperSizeThemeData(tablet: HyperSizeScheme.desktop()),
      ),
      duration: Duration.zero,
      child: Center(child: child),
    ),
  );

  testWidgets('点击后选择当前值', (tester) async {
    String? selected = 'a';
    await tester.pumpWidget(
      app(
        StatefulBuilder(
          builder: (context, setState) => HyperRadio<String>(
            value: 'b',
            groupValue: selected,
            onChanged: (value) => setState(() => selected = value),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(HyperRadio<String>));
    await tester.pump();
    expect(selected, 'b');
    expect(tester.hasRunningAnimations, isTrue);
  });

  testWidgets('默认勾线样式响应桌面鼠标点击', (tester) async {
    String? selected = 'a';
    await tester.pumpWidget(
      app(
        StatefulBuilder(
          builder: (context, setState) => HyperRadio<String>(
            value: 'b',
            groupValue: selected,
            onChanged: (value) => setState(() => selected = value),
          ),
        ),
      ),
    );

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(
      location: tester.getCenter(find.byType(HyperRadio<String>)),
    );
    await mouse.down(tester.getCenter(find.byType(HyperRadio<String>)));
    await mouse.up();
    await tester.pump();

    expect(selected, 'b');
  });

  testWidgets('toggleable允许取消已选值', (tester) async {
    String? result = 'a';
    await tester.pumpWidget(
      app(
        HyperRadio<String>(
          value: 'a',
          groupValue: 'a',
          toggleable: true,
          onChanged: (value) => result = value,
        ),
      ),
    );
    await tester.tap(find.byType(HyperRadio<String>));
    expect(result, isNull);
  });

  testWidgets('默认样式重复点击已选项仍触发回调', (tester) async {
    var count = 0;
    String? result;
    await tester.pumpWidget(
      app(
        HyperRadio<String>(
          value: 'a',
          groupValue: 'a',
          onChanged: (value) {
            count++;
            result = value;
          },
        ),
      ),
    );

    await tester.tap(find.byType(HyperRadio<String>));

    expect(count, 1);
    expect(result, 'a');
  });

  testWidgets('默认样式保持直接绘制结构', (tester) async {
    await tester.pumpWidget(
      app(const HyperRadio(value: 1, groupValue: 1, onChanged: null)),
    );

    final visual = find.byKey(const ValueKey('hyper_radio_visual'));
    expect(tester.widget(visual), isA<SizedBox>());
    expect(
      find.descendant(of: visual, matching: find.byType(CustomPaint)),
      findsOneWidget,
    );
  });

  testWidgets('桌面视觉尺寸为22', (tester) async {
    await tester.pumpWidget(
      app(const HyperRadio(value: 1, groupValue: 1, onChanged: null)),
    );
    final visual = find.descendant(
      of: find.byType(HyperRadio<int>),
      matching: find.byKey(const ValueKey('hyper_radio_visual')),
    );
    expect(tester.getSize(visual), const Size.square(22));
  });

  testWidgets('circle使用外圈圆点样式', (tester) async {
    await tester.pumpWidget(
      app(
        const HyperRadio<int>.circle(value: 1, groupValue: 1, onChanged: null),
      ),
    );
    await tester.pumpAndSettle();

    final outer = find.descendant(
      of: find.byType(HyperRadio<int>),
      matching: find.byKey(const ValueKey('hyper_radio_visual')),
    );
    expect(outer, findsOneWidget);
    expect(tester.getSize(outer), const Size.square(22));

    final decoration = tester.widget<AnimatedContainer>(outer).decoration;
    expect(decoration, isA<BoxDecoration>());
    expect((decoration! as BoxDecoration).border, isNotNull);
  });

  testWidgets('filled未选中也保留可见背景', (tester) async {
    await tester.pumpWidget(
      app(
        const HyperRadio<int>.filled(value: 1, groupValue: 2, onChanged: null),
      ),
    );

    final visual = find.byKey(const ValueKey('hyper_radio_visual'));
    final container = tester.widget<AnimatedContainer>(visual);
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, isNot(Colors.transparent));
    expect(tester.getSize(visual), const Size.square(22));
  });

  testWidgets('filled选中时使用光学居中的对勾尺寸', (tester) async {
    await tester.pumpWidget(
      app(
        const HyperRadio<int>.filled(value: 1, groupValue: 1, onChanged: null),
      ),
    );

    final visual = find.byKey(const ValueKey('hyper_radio_visual'));
    final paint = find.descendant(
      of: visual,
      matching: find.byType(CustomPaint),
    );
    expect(paint, findsOneWidget);
    expect(tester.getSize(paint), const Size.square(17.6));

    final container = tester.widget<AnimatedContainer>(visual);
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, isNot(HyperThemeData.light().colors.primary));
  });

  testWidgets('实例可覆盖背景边框和圆角', (tester) async {
    const radius = BorderRadius.all(Radius.circular(6));
    await tester.pumpWidget(
      app(
        const HyperRadio<int>.checkmark(
          value: 1,
          groupValue: 1,
          onChanged: null,
          style: HyperRadioStyle(
            selectedBackgroundColor: Colors.amber,
            selectedBorder: BorderSide(color: Colors.red, width: 2),
            borderRadius: radius,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final outer = find.descendant(
      of: find.byType(HyperRadio<int>),
      matching: find.byKey(const ValueKey('hyper_radio_visual')),
    );
    final decoration =
        tester.widget<AnimatedContainer>(outer).decoration! as BoxDecoration;
    expect(decoration.color, Colors.amber);
    expect(decoration.borderRadius, radius);
    expect(
      decoration.border,
      const Border.fromBorderSide(BorderSide(color: Colors.red, width: 2)),
    );
  });

  testWidgets('仅设置选中背景时切换前后保持装饰结构', (tester) async {
    String? selected;
    await tester.pumpWidget(
      app(
        StatefulBuilder(
          builder: (context, setState) => HyperRadio<String>.checkmark(
            value: 'a',
            groupValue: selected,
            onChanged: (value) => setState(() => selected = value),
            style: const HyperRadioStyle(selectedBackgroundColor: Colors.amber),
          ),
        ),
      ),
    );

    final visual = find.byKey(const ValueKey('hyper_radio_visual'));
    expect(tester.widget(visual), isA<AnimatedContainer>());
    await tester.tap(find.byType(HyperRadio<String>));
    await tester.pump();
    expect(tester.widget(visual), isA<AnimatedContainer>());
  });
}
