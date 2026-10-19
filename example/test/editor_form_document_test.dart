import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/editor/editor_form_fields.dart';
import 'package:lemon_ui_example/editor/editor_dimension_limits.dart';

void main() {
  test('form device geometry and light/dark appearance round trip', () {
    final doc = EditorThemeDocument();
    doc.device(HyperDeviceType.desktop).formMetrics
      ..labelWidth = 132
      ..gap = 10
      ..fieldSpacing = 18;
    doc.light.formFields
      ..labelFontSize = 18
      ..errorColor = const EditorColor(semantic: 'primary');
    final loaded = EditorThemeDocument.decode(doc.encode());
    expect(loaded.encode(), doc.encode());
    final theme = loaded.resolve(false);
    expect(theme.sizes.desktop.form.labelWidth, 132);
    expect(theme.sizes.phone.form, const HyperSizeScheme.phone().form);
    expect(theme.fieldTheme.style.labelStyle!.fontSize, 18);
    expect(theme.fieldTheme.style.errorStyle!.color, theme.colors.primary);
    expect(loaded.resolve(true).fieldTheme.style.labelStyle, isNull);
    loaded.device(HyperDeviceType.desktop).formMetrics.labelWidth = null;
    expect(
      loaded.resolve(false).sizes.desktop.form.labelWidth,
      const HyperSizeScheme.desktop().form.labelWidth,
    );
  });
  test('form import validates finite geometry and editor bounds follow available width', () {
    expect(
      () => EditorFormMetrics.fromJson({'gap': double.infinity}),
      throwsFormatException,
    );
    expect(
      () => EditorFormVisual.fromJson({'labelFontSize': -1}),
      throwsFormatException,
    );
    expect(editorFormLabelWidthLimit(300, 120, 8), 172);
    expect(editorFormLabelWidthLimit(100, 120, 8), 0);
    expect(EditorFormMetrics.fromJson({'gap': 8.5}).gap, 8.5);
  });
}
