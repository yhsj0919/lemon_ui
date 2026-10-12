import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  HyperPageIndicatorModel model(int count, int index, {int max = 7}) =>
      HyperPageIndicatorModel(
        pageCount: count,
        currentIndex: index,
        maxVisibleDots: max,
      );
  test('有限窗口保留真实索引并覆盖首尾页', () {
    expect(model(30, 0).visibleIndices, [0, 1, 2, 3, 4, 5, 6]);
    expect(model(30, 15).visibleIndices, [12, 13, 14, 15, 16, 17, 18]);
    expect(model(30, 29).visibleIndices, [23, 24, 25, 26, 27, 28, 29]);
    expect(model(2, 1).visibleIndices, [0, 1]);
    expect(model(1000000, 900000).visibleIndices.length, 7);
    expect(() => model(3, 1).visibleIndices.clear(), throwsUnsupportedError);
  });
  test('窗口大小和任意合法页均保持当前页可见', () {
    for (var count = 1; count <= 12; count++) {
      for (var index = 0; index < count; index++) {
        for (final max in [1, 2, 4, 7]) {
          final indices = model(count, index, max: max).visibleIndices;
          expect(indices, contains(index));
          expect(indices.length, lessThanOrEqualTo(max));
          expect(indices.first, greaterThanOrEqualTo(0));
          expect(indices.last, lessThan(count));
          for (var i = 1; i < indices.length; i++) {
            expect(indices[i], indices[i - 1] + 1);
          }
        }
      }
    }
  });
  test('空页与索引边界有确定语义', () {
    expect(model(0, 0).visibleIndices, isEmpty);
    expect(model(0, 0).counter, '0 / 0');
    expect(model(5, 0).counter, '1 / 5');
    expect(model(5, 4).counter, '5 / 5');
    expect(() => model(0, 1), throwsRangeError);
    expect(() => model(2, 2), throwsRangeError);
    expect(() => model(2, -1), throwsRangeError);
    expect(() => model(-1, 0), throwsArgumentError);
    expect(() => model(2, 0, max: 0), throwsArgumentError);
  });
  test('主题和实例覆盖保留未显式修改的字段', () {
    const base = HyperPageIndicatorThemeData(
      style: HyperPageIndicatorStyle(
        dotSize: 6,
        counterStyle: TextStyle(fontSize: 12),
        selectedDotFill: HyperFill.color(Colors.blue),
      ),
    );
    final local = base.merge(
      const HyperPageIndicatorThemeData(
        style: HyperPageIndicatorStyle(
          counterStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
    final style = local.style.merge(
      const HyperPageIndicatorStyle(selectedWidth: 18),
    );
    expect(style.dotSize, 6);
    expect(style.counterStyle!.fontSize, 12);
    expect(style.counterStyle!.fontWeight, FontWeight.bold);
    expect(style.selectedWidth, 18);
    expect(local.copyWith(), local);
    expect(local.copyWith().hashCode, local.hashCode);
    final b = base.copyWith(style: base.style.copyWith(dotSize: 10));
    expect(HyperPageIndicatorThemeData.lerp(base, b, .5).style.dotSize, 8);
  });
  test('材质、边框、动效参与复制与插值', () {
    Widget transition(Widget child, Animation<double> animation) =>
        FadeTransition(opacity: animation, child: child);
    final a = HyperPageIndicatorStyle(
      material: const HyperSurfaceMaterial.frostedGlass(),
      materialQuality: HyperMaterialQuality.advanced,
      reduceTransparency: true,
      dotBorder: const BorderSide(color: Colors.blue),
      border: Border.all(),
      dotRadius: BorderRadius.circular(3),
      boxShadow: const [BoxShadow(blurRadius: 2)],
      duration: const Duration(milliseconds: 100),
      transitionBuilder: transition,
    );
    final b = a.copyWith(duration: const Duration(milliseconds: 200));
    expect(a.copyWith(), a);
    expect(a.copyWith().hashCode, a.hashCode);
    expect(
      HyperPageIndicatorStyle.lerp(a, b, .5).duration,
      const Duration(milliseconds: 150),
    );
    expect(HyperPageIndicatorStyle.lerp(a, b, 1), b);
    expect(b.material, a.material);
    expect(b.transitionBuilder, transition);
  });
  test('四端尺寸与全局主题独立保存、插值', () {
    const schemes = [
      HyperSizeScheme.phone(),
      HyperSizeScheme.tablet(),
      HyperSizeScheme.desktop(),
      HyperSizeScheme.watch(),
    ];
    expect(schemes.map((s) => s.pageIndicator.dotSize), [6, 6, 6, 5]);
    final changed = schemes[2].copyWith(
      pageIndicator: schemes[2].pageIndicator.copyWith(selectedWidth: 18),
    );
    expect(changed.deviceType, HyperDeviceType.desktop);
    expect(changed.pagination, schemes[2].pagination);
    expect(
      HyperSizeScheme.lerp(schemes[2], changed, .5).pageIndicator.selectedWidth,
      12,
    );
    final a = HyperThemeData.light();
    final b = a.copyWith(
      pageIndicatorTheme: const HyperPageIndicatorThemeData(
        style: HyperPageIndicatorStyle(spacing: 10),
      ),
    );
    expect(b.paginationTheme, a.paginationTheme);
    expect(b.copyWith(), b);
    expect(b.copyWith().hashCode, b.hashCode);
    expect(a.lerp(b, 1).pageIndicatorTheme, b.pageIndicatorTheme);
  });
}
