import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/editor/editor_wheel_fields.dart';
import 'package:lemon_ui_example/editor/editor_dimension_limits.dart';

void main() {
  test('wheel appearance and device metrics round trip independently', () {
    final doc = EditorThemeDocument();
    doc.device(HyperDeviceType.desktop).wheelMetrics
      ..width = 180
      ..itemExtent = 60
      ..horizontalPadding = 10
      ..selectionRadius = 20;
    doc.light.wheel
      ..fontSize = 18
      ..selectedFontSize = 20
      ..selection = const EditorColor(semantic: 'primary');
    final loaded = EditorThemeDocument.decode(doc.encode());
    expect(loaded.encode(), doc.encode());
    final light = loaded.resolve(false);
    expect(light.sizes.desktop.wheelPicker.itemExtent, 60);
    expect(
      light.sizes.phone.wheelPicker,
      const HyperSizeScheme.phone().wheelPicker,
    );
    expect(light.wheelPickerTheme.style.selectedTextStyle!.fontSize, 20);
    expect(light.wheelPickerTheme.style.selectionColor, light.colors.primary);
    expect(loaded.resolve(true).wheelPickerTheme.style.textStyle, isNull);
    loaded.device(HyperDeviceType.desktop).wheelMetrics.selectionRadius = null;
    expect(
      loaded.resolve(false).sizes.desktop.wheelPicker.selectionRadius,
      const HyperSizeScheme.desktop().wheelPicker.selectionRadius,
    );
  });
  test(
    'wheel invalid imported values rejected and geometry bounds follow size',
    () {
      expect(
        () => EditorWheelMetrics.fromJson({'width': double.nan}),
        throwsFormatException,
      );
      expect(
        () => EditorWheelVisual.fromJson({'duration': -1}),
        throwsFormatException,
      );
      expect(editorRadiusLimit(43), 21);
      expect(editorRadiusLimit(10), 5);
      // Historical fractional import is retained until this field is edited.
      expect(EditorWheelMetrics.fromJson({'width': 180.5}).width, 180.5);
    },
  );
}
