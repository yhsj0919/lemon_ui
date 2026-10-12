import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:lemon_ui_example/editor/theme_editor.dart';
import 'package:lemon_ui_example/gallery/gallery_shell.dart';

void main() {
  testWidgets('手机默认打开完整 Demo，旋转后保留入口', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    expect(find.byType(GalleryShell), findsOneWidget);
    expect(find.byType(ThemeEditor), findsNothing);
    await tester.binding.setSurfaceSize(const Size(844, 390));
    await tester.pumpAndSettle();
    expect(find.byType(GalleryShell), findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('桌面窄窗口仍打开编辑器', (tester) async {
    SharedPreferences.setMockInitialValues({});
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    expect(find.byType(ThemeEditor), findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });
}
