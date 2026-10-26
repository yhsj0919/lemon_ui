import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_review_fields.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';

void main() {
  test('分隔符保存导入，亮暗隔离及恢复继承', () {
    final document = EditorThemeDocument();
    document.light.reviews.breadcrumb.breadcrumbSeparator = 'chevron';
    document.dark.reviews.breadcrumb.breadcrumbSeparator = 'slash';
    final copy = EditorThemeDocument.decode(document.encode());
    expect(
      copy.resolve(false).breadcrumbTheme.style.separator,
      HyperBreadcrumbSeparator.chevron,
    );
    expect(
      copy.resolve(true).breadcrumbTheme.style.separator,
      HyperBreadcrumbSeparator.slash,
    );
    expect(copy.encode(), document.encode());
    copy.light.reviews.breadcrumb.breadcrumbSeparator = null;
    final restored = EditorThemeDocument.decode(copy.encode());
    expect(restored.resolve(false).breadcrumbTheme.style.separator, isNull);
    expect(
      restored.resolve(true).breadcrumbTheme.style.separator,
      HyperBreadcrumbSeparator.slash,
    );
  });

  test('旧配置继续继承，非法分隔符拒绝导入', () {
    expect(EditorReviewFields.fromJson({}).breadcrumbSeparator, isNull);
    expect(
      () => EditorReviewFields.fromJson({'breadcrumbSeparator': 'invalid'}),
      throwsFormatException,
    );
  });
}
