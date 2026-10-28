import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/gallery/gallery_registry.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:lemon_ui_example/pages/pending/hyper_motion_lift_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('lift is pending; offsets, visual states and resets round-trip independently', () {
    expect(
      gallerySections
          .singleWhere((s) => s.title == '未确认')
          .items
          .where((i) => i.id == 'hyper-motion-lift'),
      hasLength(1),
    );
    final document = EditorThemeDocument();
    document
            .device(HyperDeviceType.desktop)
            .reviews
            .motionLiftHover
            .translationY =
        -7;
    document.mode(false).reviews.motionLiftHover.scale = 1.008;
    document.mode(false).reviews.motionLiftPressed.scale = .99;
    document.mode(false).reviews.motionLift.duration = 310;
    document.mode(false).reviews.motionLift.pressDuration = 90;
    final restored = EditorThemeDocument.decode(document.encode());
    final theme = restored.resolve(false);
    expect(theme.sizes.desktop.motionLift.hoverOffset.dy, -7);
    expect(theme.sizes.phone.motionLift.hoverOffset.dy, -2);
    expect(theme.motion.lift.style.hoverScale, 1.008);
    expect(theme.motion.lift.style.pressedScale, .99);
    expect(theme.motion.lift.style.duration, const Duration(milliseconds: 310));
    expect(
      theme.motion.lift.style.pressDuration,
      const Duration(milliseconds: 90),
    );
    expect(restored.resolve(true).motion.lift.style.hoverScale, isNull);
    restored.mode(false).reviews.reset('motionLiftHover');
    expect(restored.mode(false).reviews.motionLiftHover.scale, isNull);
    expect(restored.mode(false).reviews.motionLiftPressed.scale, .99);
  });
  testWidgets(
    'lift workspace stores integer translation but retains fractional scale',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.binding.setSurfaceSize(const Size(1440, 3000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const LemonUiExampleApp());
      await tester.pumpAndSettle();
      tester
          .widget<EditorComponentNavigation>(
            find.byType(EditorComponentNavigation),
          )
          .onSelected('hyper-motion-lift');
      await tester.pumpAndSettle();
      final state = find.descendant(
        of: find.byKey(const ValueKey('editor-select-交互状态')),
        matching: find.byType(HyperSelect<String>),
      );
      tester.widget<HyperSelect<String>>(state).onChanged!('hovered');
      await tester.pumpAndSettle();
      HyperSlider slider(String label) => tester.widget<HyperSlider>(
        find.descendant(
          of: find.byKey(ValueKey('editor-number-$label')),
          matching: find.byType(HyperSlider),
        ),
      );
      slider('垂直位移').onChanged!(-5.7);
      await tester.pumpAndSettle();
      expect(slider('垂直位移').value, -6);
      slider('缩放倍率').onChanged!(1.008);
      await tester.pumpAndSettle();
      expect(slider('缩放倍率').value, 1.008);
      expect(find.text('缩放倍率  1.008'), findsOneWidget);
      final context = tester.element(find.byType(HyperMotionLiftPage));
      expect(HyperTheme.sizesOf(context).motionLift.hoverOffset.dy, -6);
      expect(HyperTheme.of(context).motion.lift.style.hoverScale, 1.008);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
