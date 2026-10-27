import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/select/hyper_selection_tags.dart';

const options = [
  HyperSelectOption(value: 'one', label: '紧凑布局'),
  HyperSelectOption(value: 'two', label: '舒适布局'),
  HyperSelectOption(value: 'three', label: '宽屏布局'),
];
void main() {
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('多选布局与窄宽约束，文字倍率 $scale', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperDeviceDetector(
            deviceType: HyperDeviceType.desktop,
            builder: (context, device, child) =>
                HyperTheme(data: HyperThemeData.light(), child: child!),
            child: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: Scaffold(
                body: Column(
                  children: [
                    HyperSelect<String>(
                      key: const ValueKey('single'),
                      options: options,
                      value: null,
                      onChanged: (_) {},
                    ),
                    HyperSelect<String>.multiple(
                      key: const ValueKey('multi'),
                      options: options,
                      values: const {'one', 'two', 'three'},
                      onSelectionChanged: (_) {},
                    ),
                    HyperAutocomplete<String>.multiple(
                      key: const ValueKey('auto'),
                      selectionStyle: const HyperSelectionStyle(width: 220),
                      options: options,
                      values: const {'one', 'two', 'three'},
                      onSelectionChanged: (_) {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      if (scale == 1) {
        expect(
          tester.getSize(find.byKey(const ValueKey('multi'))).height,
          closeTo(
            tester.getSize(find.byKey(const ValueKey('single'))).height,
            1,
          ),
        );
      }
      final tags = find.descendant(
        of: find.byKey(const ValueKey('auto')),
        matching: find.byType(HyperSelectionTags),
      );
      expect(tester.getSize(tags).height, greaterThan(0));
      if (scale == 1.0) {
        final visible = <Object>[];
        tester.renderObject(tags).visitChildrenForSemantics(visible.add);
        expect(visible, hasLength(2));
        final firstChip = find
            .descendant(of: tags, matching: find.byType(HyperChip))
            .first;
        expect(visible.first, same(tester.renderObject(firstChip)));
        final selectChip = find
            .descendant(
              of: find.byKey(const ValueKey('multi')),
              matching: find.byType(HyperChip),
            )
            .first;
        expect(
          tester.widget<HyperChip>(firstChip).style!.height,
          tester.widget<HyperChip>(selectChip).style!.height,
        );
        expect(
          tester.getSize(firstChip).height,
          tester.getSize(selectChip).height,
        );
        final field = find.descendant(
          of: find.byKey(const ValueKey('auto')),
          matching: find.byType(HyperTextField),
        );
        final surface = find
            .descendant(
              of: field,
              matching: find.byWidgetPredicate(
                (w) => w is AnimatedContainer && w.decoration is BoxDecoration,
              ),
            )
            .first;
        expect(
          tester.getCenter(firstChip).dy,
          closeTo(tester.getCenter(surface).dy, .1),
        );
      }
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('嵌套 Navigator 的尾部弹窗跟随局部锚点', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 400,
            height: 400,
            child: HyperNavigatorScope(
              useRootNavigator: false,
              child: HyperDeviceDetector(
                deviceType: HyperDeviceType.desktop,
                builder: (context, device, child) =>
                    HyperTheme(data: HyperThemeData.light(), child: child!),
                child: Navigator(
                  onGenerateRoute: (_) => MaterialPageRoute<void>(
                    builder: (_) => Scaffold(
                      body: Center(
                        child: HyperPopupListTile<String>(
                          title: const Text('布局'),
                          options: options,
                          value: null,
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final arrow = find.byIcon(HyperIcons.chevronsUpDown);
    final rect = tester.getRect(arrow);
    await tester.tap(find.text('布局'));
    await tester.pumpAndSettle();
    final menu = tester.getRect(find.byType(HyperMenu));
    expect(menu.right, closeTo(rect.right, 1));
    expect(menu.left, greaterThanOrEqualTo(200));
    expect(tester.takeException(), isNull);
  });
}
