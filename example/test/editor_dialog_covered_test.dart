import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui_example/editor/editor_review_fields.dart';

void main() {
  test('dialog coverage policy preserves inherit, enabled and disabled', () {
    for (final value in [null, false, true]) {
      final fields = EditorReviewFields()
        ..reduceTransparencyWhenCovered = value;
      final json = fields.toJson();
      expect(json.containsKey('reduceTransparencyWhenCovered'), value != null);
      expect(
        EditorReviewFields.fromJson(json).reduceTransparencyWhenCovered,
        value,
      );
    }
  });
}
