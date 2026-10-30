import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';

void main() {
  test(
    'lift surface round trips independently for light and dark appearance',
    () {
      final document = EditorThemeDocument();
      document.light.reviews.motionLift.liftSurface = false;
      document.light.reviews.motionLift.liftShowShadow = true;
      document.dark.reviews.motionLift.liftSurface = true;
      final restored = EditorThemeDocument.decode(document.encode());
      expect(restored.resolve(false).motion.lift.style.surface, isFalse);
      expect(restored.resolve(false).motion.lift.style.showShadow, isTrue);
      expect(restored.resolve(true).motion.lift.style.surface, isTrue);
      expect(restored.encode(), document.encode());
      restored.light.reviews.motionLift.liftSurface = null;
      expect(restored.resolve(false).motion.lift.style.surface, isNull);
    },
  );
}
