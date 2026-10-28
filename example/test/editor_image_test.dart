import 'package:lemon_ui_example/main.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:lemon_ui_example/pages/content/hyper_image_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/editor/editor_dimension_limits.dart';
import 'package:lemon_ui_example/gallery/gallery_registry.dart';

void main() {
  testWidgets(
    'image workspace writes integer pixels and updates linked bounds',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.binding.setSurfaceSize(const Size(1440, 5000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const LemonUiExampleApp());
      await tester.pumpAndSettle();
      tester
          .widget<EditorComponentNavigation>(
            find.byType(EditorComponentNavigation),
          )
          .onSelected('hyper-image');
      await tester.pump();
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 600));
      }
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      HyperSlider slider(String label) => tester.widget<HyperSlider>(
        find.descendant(
          of: find.descendant(
            of: find.byKey(const ValueKey('editor-image-workspace')),
            matching: find.byKey(ValueKey('editor-number-$label')),
          ),
          matching: find.byType(HyperSlider),
        ),
      );
      slider('进度描边').onChanged!(7.7);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      slider('进度尺寸').onChanged!(11.4);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(slider('进度描边').max, 5);
      expect(slider('进度描边').value, 5);
      final preview = find.byType(HyperImagePage);
      expect(
        HyperTheme.sizesOf(tester.element(preview)).image.progressSize,
        11,
      );
      expect(
        HyperTheme.sizesOf(tester.element(preview)).image.progressThickness,
        5,
      );
      slider('图标尺寸').onChanged!(27.6);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(HyperTheme.sizesOf(tester.element(preview)).image.iconSize, 28);
      final variant = find.descendant(
        of: find.byKey(const ValueKey('editor-select-外观变体')),
        matching: find.byType(HyperSelect<String>),
      );
      tester.widget<HyperSelect<String>>(variant).onChanged!('outlined');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('editor-image-workspace')),
          matching: find.byKey(const ValueKey('editor-number-图标尺寸')),
        ),
        findsNothing,
      );
      slider('表面圆角').onChanged!(1000);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(slider('表面圆角').value, editorSurfaceRadiusLimit);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
  test(
    'confirmed image gallery belongs to content and its page id is stable',
    () {
      final content = gallerySections.singleWhere(
        (section) => section.title == '文字与内容',
      );
      expect(content.items.any((item) => item.id == 'hyper-image'), isTrue);
    },
  );
  test(
    'image variants and states round trip with device and appearance isolation',
    () {
      final doc = EditorThemeDocument();
      doc.device(HyperDeviceType.desktop).reviews.image
        ..iconSize = 28
        ..circleSize = 36
        ..lineWidth = 3
        ..textStyleSize = 15;
      doc.device(HyperDeviceType.desktop).reviews.imageOutlinedFailed
        ..surfaceRadius = 9
        ..borderWidth = 2;
      doc.light.reviews.imageOutlinedFailed
        ..curve = 'linear'
        ..textStyleWeight = 600
        ..iconColor = const EditorColor(argb: 0xffff0000)
        ..textStyleColor = const EditorColor(argb: 0xff00ff00);
      final restored = EditorThemeDocument.decode(doc.encode());
      expect(restored.encode(), doc.encode());
      final desktop = restored.resolve(
        false,
        deviceType: HyperDeviceType.desktop,
      );
      expect(desktop.sizes.desktop.image.iconSize, 28);
      final state = desktop.imageTheme.resolve(
        HyperImageVariant.outlined,
        HyperImageLoadState.failed,
      );
      expect(state.iconColor, const Color(0xffff0000));
      expect(state.animationCurve, Curves.linear);
      expect(state.textStyle!.fontWeight, FontWeight.w600);
      expect(state.surfaceStyle!.border!.top.width, 2);
      expect(state.surfaceStyle!.borderRadius, BorderRadius.circular(9));
      expect(state.textStyle!.fontSize, 15);
      expect(
        desktop.imageTheme
            .resolve(HyperImageVariant.plain, HyperImageLoadState.failed)
            .iconColor,
        isNull,
      );
      expect(
        restored
            .resolve(true, deviceType: HyperDeviceType.desktop)
            .imageTheme
            .resolve(HyperImageVariant.outlined, HyperImageLoadState.failed)
            .iconColor,
        isNull,
      );
      final phone = restored.resolve(false, deviceType: HyperDeviceType.phone);
      expect(
        phone.sizes.phone.image.iconSize,
        HyperThemeData.light().sizes.phone.image.iconSize,
      );
      expect(
        phone.imageTheme
            .resolve(HyperImageVariant.outlined, HyperImageLoadState.failed)
            .surfaceStyle!
            .border,
        isNull,
      );
      restored.light.reviews.reset('imageOutlinedFailed');
      restored
          .device(HyperDeviceType.desktop)
          .reviews
          .reset('imageOutlinedFailed');
      final reset = restored
          .resolve(false, deviceType: HyperDeviceType.desktop)
          .imageTheme
          .resolve(HyperImageVariant.outlined, HyperImageLoadState.failed);
      expect(reset.iconColor, isNull);
      expect(reset.surfaceStyle!.border, isNull);
      expect(
        restored.device(HyperDeviceType.desktop).reviews.image.iconSize,
        28,
      );
    },
  );
  test('image progress range follows diameter and integer stroke geometry', () {
    expect(editorProgressStrokeLimit(11), 5);
    expect(editorProgressStrokeLimit(0), 0);
  });
  test('preview and editor entries, device metrics and crop colors round trip independently', () {
    final content = gallerySections.singleWhere(
      (section) => section.title == '文字与内容',
    );
    expect(
      content.items.any((item) => item.id == 'hyper-image-preview'),
      isTrue,
    );
    expect(
      content.items.any((item) => item.id == 'hyper-image-editor'),
      isTrue,
    );
    final document = EditorThemeDocument();
    final device = document.device(HyperDeviceType.desktop);
    device.reviews.imagePreview
      ..spacing = 17
      ..iconSize = 29;
    device.reviews.imageEditor
      ..nodeSize = 19
      ..lineWidth = 3
      ..lineHeight = 2;
    document.light.reviews.imageEditor
      ..separatorColor = const EditorColor(argb: 0xffff0000)
      ..foregroundColor = const EditorColor(argb: 0xff00ff00)
      ..duration = 180;
    document.light.reviews.imagePreview
      ..curve = 'linear'
      ..textStyleWeight = 600;
    final restored = EditorThemeDocument.decode(document.encode());
    expect(restored.encode(), document.encode());
    final light = restored.resolve(false, deviceType: HyperDeviceType.desktop);
    expect(light.sizes.desktop.imagePreview.spacing, 17);
    expect(light.sizes.desktop.imageEditor.handleLength, 19);
    expect(light.sizes.desktop.imageEditor.handleThickness, 3);
    expect(light.imageEditorTheme.style.cropLineColor, const Color(0xffff0000));
    expect(light.imageEditorTheme.style.surfaceStyle?.border, isNull);
    expect(light.imageEditorTheme.style.cropColor, const Color(0xff00ff00));
    expect(light.imagePreviewTheme.style.animationCurve, Curves.linear);
    expect(
      restored
          .resolve(true, deviceType: HyperDeviceType.desktop)
          .imageEditorTheme
          .style
          .cropColor,
      isNull,
    );
    expect(
      restored
          .resolve(false, deviceType: HyperDeviceType.phone)
          .sizes
          .phone
          .imagePreview
          .spacing,
      HyperThemeData.light().sizes.phone.imagePreview.spacing,
    );
    restored.light.reviews.reset('imageEditor');
    expect(
      restored
          .resolve(false, deviceType: HyperDeviceType.desktop)
          .imageEditorTheme
          .style
          .cropColor,
      isNull,
    );
  });
}
