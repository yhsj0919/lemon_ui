import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/overlay/hyper_backdrop_safe_opacity.dart';

void main() {
  testWidgets('material border changes preserve a mounted form and its input', (
    tester,
  ) async {
    final controller = HyperFormController();
    addTearDown(controller.dispose);
    var outlined = true;
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return HyperMaterialSurface(
                  material: const HyperSurfaceMaterial.solid(),
                  border: outlined ? Border.all(color: Colors.blue) : null,
                  child: HyperForm(
                    controller: controller,
                    child: HyperTextFormField(name: 'name'),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText), '保留内容');
    final form = tester.element(find.byType(HyperForm));
    final field = tester.element(find.byType(EditableText));
    for (final border in [false, true, false, true]) {
      update(() => outlined = border);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(tester.element(find.byType(HyperForm)), same(form));
      expect(tester.element(find.byType(EditableText)), same(field));
      expect(controller.value<String>('name'), '保留内容');
    }
    await tester.pumpWidget(const SizedBox.shrink());
  });
  test('过渡配置参与复制与插值，嵌套过渡不能提前恢复高级材质', () {
    const theme = HyperMaterialThemeData(
      transitionFadeFraction: .6,
      transitionProgress: .2,
    );
    final changed = theme.copyWith(transitionFadeFraction: .8);
    expect(changed, isNot(theme));
    expect(
      HyperMaterialThemeData.lerp(theme, changed, .5).transitionFadeFraction,
      closeTo(.7, .001),
    );
    expect(
      theme
          .merge(const HyperMaterialThemeData(transitionProgress: 1))
          .transitionProgress,
      .2,
    );
    expect(
      theme
          .merge(const HyperMaterialThemeData(transitionProgress: .1))
          .transitionProgress,
      .1,
    );
  });
  testWidgets('降级淡入后连续恢复模糊，逆向与重开保留内容状态', (tester) async {
    var progress = .3;
    late StateSetter update;
    const recipe = HyperSurfaceMaterial.frostedGlass(
      blurSigmaX: 20,
      blurSigmaY: 20,
      background: HyperFill.color(Color(0x70FFFFFF)),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          duration: Duration.zero,
          data: HyperThemeData.light().copyWith(
            materialTheme: const HyperMaterialThemeData(
              quality: HyperMaterialQuality.advanced,
              material: recipe,
            ),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return Center(
                child: HyperBackdropSafeOpacity(
                  opacity: progress,
                  child: const HyperMaterialSurface(
                    width: 100,
                    height: 100,
                    child: Text('保持内容'),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
    final content = tester.element(find.text('保持内容'));
    final fade = tester.widget<Opacity>(find.byType(Opacity).first);
    expect(fade.opacity, closeTo(.5, .001));
    expect(
      tester.widget<BackdropFilter>(find.byType(BackdropFilter)).enabled,
      isFalse,
    );
    for (final p in [.8, 1.0, .8, .3, .8]) {
      update(() => progress = p);
      await tester.pump();
      final filter = tester.widget<BackdropFilter>(find.byType(BackdropFilter));
      final context = tester.element(find.byType(HyperMaterialSurface));
      final material = HyperMaterialTheme.of(context).resolveMaterial()!;
      expect(
        material.blurSigmaX,
        closeTo(((p - .6) / .4).clamp(0, 1) * 20, .001),
      );
      expect(filter.enabled, p > .6);
      expect(tester.element(find.text('保持内容')), same(content));
      if (filter.enabled) {
        expect(tester.widget<Opacity>(find.byType(Opacity).first).opacity, 1);
      }
    }
    expect(tester.takeException(), isNull);
  });
}
