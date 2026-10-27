import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';

void main() {
  test(
    'number input layout round trips per device and resets to inheritance',
    () {
      final doc = EditorThemeDocument();
      doc.phone.numberInputLayout = HyperNumberInputLayout.leadingTrailing;
      final restored = EditorThemeDocument.decode(doc.encode());
      expect(restored.encode(), doc.encode());
      expect(
        restored
            .resolve(false, deviceType: HyperDeviceType.phone)
            .numberInputTheme
            .layout,
        HyperNumberInputLayout.leadingTrailing,
      );
      expect(
        restored
            .resolve(true, deviceType: HyperDeviceType.phone)
            .numberInputTheme
            .layout,
        HyperNumberInputLayout.leadingTrailing,
      );
      expect(
        restored
            .resolve(false, deviceType: HyperDeviceType.desktop)
            .numberInputTheme
            .layout,
        isNull,
      );
      restored.phone.numberInputLayout = null;
      expect(
        restored
            .resolve(false, deviceType: HyperDeviceType.phone)
            .numberInputTheme
            .layout,
        isNull,
      );
    },
  );
}
