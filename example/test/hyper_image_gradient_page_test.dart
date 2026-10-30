import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/gallery/gallery_registry.dart';
import 'package:lemon_ui_example/pages/pending/hyper_image_gradient_page.dart';

void main() {
  test('image gradient is listed under pending confirmation', () {
    final section = gallerySections.singleWhere(
      (section) =>
          section.items.any((item) => item.id == 'hyper-image-gradient'),
    );
    expect(section.title, '未确认');
  });
  testWidgets('offline demo exposes sources, direction and color stops', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: const Scaffold(body: HyperImageGradientPage()),
        ),
      ),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump();
    // The first pump attaches the encoded sample's image streams. Let native
    // codec work finish before settling the loading indicator's animation.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
    expect(find.text('选择本地图片'), findsOneWidget);
    expect(find.text('从链接取色'), findsOneWidget);
    final sliders = tester
        .widgetList<HyperSlider>(find.byType(HyperSlider))
        .toList();
    expect(sliders, hasLength(3));
    expect(sliders.first.value, .2);
    sliders[1].onChanged!(.2);
    sliders.last.onChanged!(.8);
    await tester.pumpAndSettle();
    final fills = tester
        .widgetList<HyperContainer>(find.byType(HyperContainer))
        .where((widget) => widget.background?.gradient is LinearGradient);
    expect(fills, hasLength(1));
    final gradient = fills.single.background!.gradient! as LinearGradient;
    expect(gradient.stops, [.2, .8]);
    expect(gradient.begin, Alignment.topCenter);
    expect(gradient.end, Alignment.bottomCenter);
    expect(tester.takeException(), isNull);
  });
}
