import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('空状态四端尺寸独立解析，并参与全局尺寸值相等和插值', () {
    final schemes = [
      const HyperSizeScheme.phone(),
      const HyperSizeScheme.tablet(),
      const HyperSizeScheme.desktop(),
      const HyperSizeScheme.watch(),
    ];
    expect(schemes.map((e) => e.emptyState.iconSize), [48, 56, 40, 32]);
    for (final sizes in schemes) {
      final changed = sizes.copyWith(
        emptyState: sizes.emptyState.copyWith(
          contentSpacing: 24,
          maxWidth: 480,
        ),
      );
      expect(changed, isNot(sizes));
      expect(changed.emptyState.iconSize, sizes.emptyState.iconSize);
      expect(
        HyperSizeScheme.lerp(sizes, changed, .5).emptyState.maxWidth,
        (sizes.emptyState.maxWidth + 480) / 2,
      );
      expect(changed, sizes.copyWith(emptyState: changed.emptyState));
      expect(
        changed.hashCode,
        sizes.copyWith(emptyState: changed.emptyState).hashCode,
      );
    }
  });
  test('全局、局部和实例主题逐字段覆盖，文字使用强类型 TextStyle', () {
    final theme = HyperThemeData.light().copyWith(
      emptyStateTheme: const HyperEmptyStateThemeData(
        style: HyperEmptyStateStyle(
          iconColor: Colors.blue,
          titleStyle: TextStyle(fontSize: 18),
          contentSpacing: 16,
        ),
      ),
    );
    final local = theme.emptyStateTheme.merge(
      const HyperEmptyStateThemeData(
        style: HyperEmptyStateStyle(
          icon: Icons.search_off,
          descriptionStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
    final instance = local.style.copyWith(contentSpacing: 24);
    expect(instance.iconColor, Colors.blue);
    expect(instance.icon, Icons.search_off);
    expect(instance.titleStyle!.fontSize, 18);
    expect(instance.descriptionStyle!.color, Colors.grey);
    final changed = theme.copyWith(
      emptyStateTheme: local.copyWith(style: instance),
    );
    expect(changed, isNot(theme));
    expect(theme.lerp(changed, .5).emptyStateTheme.style.contentSpacing, 20);
    expect(changed.emptyStateTheme, local.copyWith(style: instance));
  });
  test('背景、边框、阴影、布局和过渡可覆盖并保留插值端点', () {
    Widget transition(Widget child, Animation<double> animation) => child;
    final start = HyperEmptyStateStyle(
      background: const HyperFill.color(Colors.blue),
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
      boxShadow: const [BoxShadow(blurRadius: 2)],
      padding: const EdgeInsets.all(8),
      actionSpacing: 8,
      alignment: AlignmentDirectional.centerStart,
      actionAlignment: WrapAlignment.start,
      transitionBuilder: transition,
      duration: const Duration(milliseconds: 120),
    );
    final end = start.copyWith(
      background: const HyperFill.none(),
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(16),
      actionSpacing: 16,
      duration: const Duration(milliseconds: 240),
    );
    final mid = HyperEmptyStateStyle.lerp(start, end, .5);
    expect(mid.actionSpacing, 12);
    expect(mid.padding, const EdgeInsets.all(12));
    expect(mid.duration, const Duration(milliseconds: 180));
    expect(mid.transitionBuilder, transition);
    expect(end.background!.isNone, true);
    expect(HyperEmptyStateStyle.lerp(start, end, 0), start);
    expect(HyperEmptyStateStyle.lerp(start, end, 1), end);
    expect(start, start.copyWith());
    expect(start.hashCode, start.copyWith().hashCode);
  });
}
