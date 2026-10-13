import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';

void main() {
  test('交互变换默认无覆盖，保存回读与变体独立', () {
    final doc = EditorThemeDocument();
    expect(doc.encode(), isNot(contains('hoveredOffsetX')));
    doc.light.button.buttonStyle
      ..hoveredOffsetY = -3
      ..pressedScale = .95;
    doc.light.buttonVariants.text.buttonStyle.hoveredOffsetY = 2;
    final restored = EditorThemeDocument.decode(doc.encode());
    expect(restored.encode(), doc.encode());
    final theme = restored.resolve(false);
    expect(
      theme.buttonTheme.resolve(HyperButtonVariant.filled).hoveredOffset,
      const Offset(0, -3),
    );
    expect(
      theme.buttonTheme.resolve(HyperButtonVariant.text).hoveredOffset,
      const Offset(0, 2),
    );
    expect(
      theme.buttonTheme.resolve(HyperButtonVariant.text).pressedScale,
      .95,
    );
    expect(
      restored
          .resolve(true)
          .buttonTheme
          .resolve(HyperButtonVariant.filled)
          .hoveredOffset,
      isNull,
    );
  });
}
