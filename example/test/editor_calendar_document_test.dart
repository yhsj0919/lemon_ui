import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';

void main() {
  test('calendar configuration round trip independent from wheel', () {
    final doc = EditorThemeDocument();
    doc.device(HyperDeviceType.desktop).calendarMetrics
      ..width = 350
      ..itemExtent = 40;
    doc.light.calendar
      ..fontSize = 18
      ..selection = const EditorColor(semantic: 'primary');
    final loaded = EditorThemeDocument.decode(doc.encode());
    expect(loaded.encode(), doc.encode());
    final theme = loaded.resolve(false);
    expect(theme.sizes.desktop.calendar.width, 350);
    expect(theme.sizes.desktop.calendar.dayMinHeight, 40);
    expect(theme.calendarTheme.style.textStyle!.fontSize, 18);
    expect(theme.calendarTheme.style.selectedColor, theme.colors.primary);
    expect(
      theme.sizes.desktop.wheelPicker,
      const HyperSizeScheme.desktop().wheelPicker,
    );
    expect(loaded.resolve(true).calendarTheme.style.textStyle, isNull);
  });
}
