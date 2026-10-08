import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/main.dart';

void main() {
  for (final width in [400.0, 1000.0]) {
    testWidgets('公共页头在 $width 宽度显示大标题和说明', (tester) async {
      await tester.binding.setSurfaceSize(Size(width, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const LemonUiExampleApp());
      await tester.pumpAndSettle();
      expect(find.byType(HyperSliverAppBar), findsOneWidget);
      final expanded = tester.widget<FlexibleSpaceBarSettings>(
        find.byType(FlexibleSpaceBarSettings),
      );
      expect(expanded.currentExtent, expanded.maxExtent);
      expect(find.text('纯色、渐变和显式无填充。'), findsWidgets);
      expect(find.byType(HyperTitledCard), findsWidgets);
      await tester.drag(find.byType(HyperTitledCard).first, const Offset(0, -250));
      await tester.pumpAndSettle();
      final collapsed = tester.widget<FlexibleSpaceBarSettings>(
        find.byType(FlexibleSpaceBarSettings),
      );
      expect(collapsed.currentExtent, collapsed.minExtent);
      expect(tester.takeException(), isNull);
      if (width < 720) {
        await tester.tap(find.byTooltip('打开组件菜单'));
        await tester.pumpAndSettle();
        expect(find.text('Lemon UI 组件演示'), findsOneWidget);
      }
    });
  }
}
