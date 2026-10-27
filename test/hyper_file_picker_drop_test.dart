import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets(
    'drop adapter uses window DPR while content retains preview DPR',
    (t) async {
      t.view.physicalSize = const Size(1600, 1600);
      t.view.devicePixelRatio = 2;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      await t.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: MediaQuery(
              data: const MediaQueryData(
                size: Size(800, 800),
                devicePixelRatio: 1,
              ),
              child: Scaffold(
                body: HyperFilePicker(files: const [], onChanged: (_) {}),
              ),
            ),
          ),
        ),
      );
      await t.pumpAndSettle();
      final target = find.byType(DropTarget).first;
      expect(MediaQuery.of(t.element(target)).devicePixelRatio, 2);
      final card = find
          .descendant(of: target, matching: find.byType(HyperCard))
          .first;
      expect(MediaQuery.of(t.element(card)).devicePixelRatio, 1);
      final position = t.getCenter(target);
      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
            'desktop_drop',
            const StandardMethodCodec().encodeMethodCall(
              MethodCall('entered', [position.dx * 2, position.dy * 2]),
            ),
            (_) {},
          );
      await t.pumpAndSettle();
      expect(find.text('松开以添加文件'), findsOneWidget);
      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
            'desktop_drop',
            const StandardMethodCodec().encodeMethodCall(
              const MethodCall('exited'),
            ),
            (_) {},
          );
      await t.pumpAndSettle();
      expect(find.text('松开以添加文件'), findsNothing);
      expect(t.takeException(), isNull);
    },
  );
}
