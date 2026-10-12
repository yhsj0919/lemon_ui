import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/select/hyper_selection_tags.dart';

void main() {
  test('输入法组合态不查询，提交组合文本后可查询', () {
    expect(
      hyperSelectCanQuery(
        const TextEditingValue(
          text: 'bei',
          composing: TextRange(start: 0, end: 3),
        ),
      ),
      isFalse,
    );
    expect(hyperSelectCanQuery(const TextEditingValue(text: '北')), isTrue);
    expect(
      hyperSelectCanQuery(
        const TextEditingValue(text: '北', composing: TextRange.collapsed(1)),
      ),
      isTrue,
    );
  });
  test('销毁之后异步结果不通知或提交', () async {
    final pending = Completer<HyperSelectPage<int>>();
    final controller = HyperSelectOptionsController(
      HyperSelectSource<int>.async(loader: (_) => pending.future),
    );
    final request = controller.load('');
    await Future<void>.delayed(Duration.zero);
    var notified = 0;
    controller.addListener(() => notified++);
    controller.dispose();
    pending.complete(
      const HyperSelectPage(options: [HyperSelectOption(value: 1, label: 'A')]),
    );
    await request;
    expect(notified, 0);
    expect(controller.options, isEmpty);
  });
  test('游标循环不能无限分页，缓存恢复游标历史', () async {
    final controller = HyperSelectOptionsController(
      HyperSelectSource<int>.async(
        pagination: HyperSelectPagination.cursor,
        loader: (query) async => HyperSelectPage(
          options: [HyperSelectOption(value: query.page, label: '项')],
          hasMore: true,
          nextCursor: query.page == 2 ? 'B' : 'A',
        ),
      ),
    );
    await controller.load('first');
    await controller.loadMore();
    await controller.load('other');
    await controller.load('first');
    await controller.loadMore();
    expect(controller.moreError, isStateError);
    expect(controller.options.length, 2);
    controller.dispose();
  });
  test('四端规格统一覆盖与插值', () {
    const profiles = [
      HyperSizeScheme.phone(),
      HyperSizeScheme.tablet(),
      HyperSizeScheme.desktop(),
      HyperSizeScheme.watch(),
    ];
    for (final sizes in profiles) {
      expect(sizes.selection.maxPanelHeight, sizes.menu.itemHeight * 6);
      expect(sizes.selection.minimumInputWidth, sizes.sidebar.collapsedWidth);
      final modified = sizes.copyWith(
        selection: sizes.selection.copyWith(chipSpacing: 8),
      );
      expect(modified.selection.chipSpacing, 8);
      expect(
        HyperSizeScheme.lerp(sizes, modified, .5).selection.chipSpacing,
        (sizes.selection.chipSpacing + 8) / 2,
      );
      expect(modified.copyWith(), modified);
    }
  });
  test('呈现默认按设备，显式选择与设备无关', () {
    for (final device in HyperDeviceType.values) {
      expect(
        hyperResolveSelectPresentation(
          HyperSelectPresentation.fullScreen,
          device,
        ),
        HyperSelectPresentation.fullScreen,
      );
      expect(
        hyperResolveSelectPresentation(
          HyperSelectPresentation.adaptive,
          device,
        ),
        device == HyperDeviceType.desktop
            ? HyperSelectPresentation.anchored
            : device == HyperDeviceType.watch
            ? HyperSelectPresentation.fullScreen
            : HyperSelectPresentation.bottomSheet,
      );
    }
  });
  test('静态搜索不区分大小写，值唯一但标签可以重复', () async {
    final controller = HyperSelectOptionsController(
      HyperSelectSource.static(const [
        HyperSelectOption(value: 1, label: 'Abc'),
        HyperSelectOption(value: 2, label: 'Abc'),
      ]),
    );
    await controller.load(' BC ');
    expect(controller.options.map((option) => option.value), [1, 2]);
    controller.dispose();
    expect(
      () => HyperSelectOptionsController(
        HyperSelectSource.static(const [
          HyperSelectOption(value: 1, label: 'A'),
          HyperSelectOption(value: 1, label: 'B'),
        ]),
      ),
      throwsArgumentError,
    );
  });
  test('重复请求合并，输入变化后旧结果无效', () async {
    final requests = <String, Completer<HyperSelectPage<int>>>{};
    final controller = HyperSelectOptionsController(
      HyperSelectSource<int>.async(
        loader: (query) {
          final pending = Completer<HyperSelectPage<int>>();
          requests[query.text] = pending;
          return pending.future;
        },
      ),
    );
    final old = controller.load('old');
    expect(identical(old, controller.load('old')), isTrue);
    await Future<void>.delayed(Duration.zero);
    final latest = controller.load('new');
    await Future<void>.delayed(Duration.zero);
    requests['old']!.complete(
      const HyperSelectPage(options: [HyperSelectOption(value: 1, label: '旧')]),
    );
    requests['new']!.complete(
      const HyperSelectPage(options: [HyperSelectOption(value: 2, label: '新')]),
    );
    await Future.wait([old, latest]);
    expect(controller.options.single.value, 2);
    controller.dispose();
  });
  test('分页失败保留旧项，重试相同页并跨页去重', () async {
    final pages = <int>[];
    var failed = false;
    final controller = HyperSelectOptionsController(
      HyperSelectSource<int>.async(
        pagination: HyperSelectPagination.page,
        loader: (query) async {
          pages.add(query.page);
          if (query.page == 2 && !failed) {
            failed = true;
            throw StateError('failed');
          }
          return HyperSelectPage(
            options: [
              const HyperSelectOption(value: 1, label: '更新'),
              if (query.page == 2)
                const HyperSelectOption(value: 2, label: '第二项'),
            ],
            hasMore: query.page == 1,
          );
        },
      ),
    );
    await controller.load('');
    await controller.loadMore();
    expect(controller.options.length, 1);
    expect(controller.moreError, isNotNull);
    await controller.retry();
    expect(pages, [1, 2, 2]);
    expect(controller.options.length, 2);
    expect(controller.hasMore, isFalse);
    controller.dispose();
  });
  test('游标不能停在原页，空页结束分页', () async {
    var calls = 0;
    final controller = HyperSelectOptionsController(
      HyperSelectSource<int>.async(
        pagination: HyperSelectPagination.cursor,
        loader: (query) async {
          calls++;
          return HyperSelectPage(
            options: calls == 1
                ? const [HyperSelectOption(value: 1, label: 'A')]
                : const [],
            hasMore: true,
            nextCursor: 'next',
          );
        },
      ),
    );
    await controller.load('');
    await controller.loadMore();
    expect(controller.hasMore, isFalse);
    controller.dispose();
    final invalid = HyperSelectOptionsController(
      HyperSelectSource<int>.async(
        pagination: HyperSelectPagination.cursor,
        loader: (query) async => const HyperSelectPage(
          options: [HyperSelectOption(value: 1, label: 'A')],
          hasMore: true,
        ),
      ),
    );
    await invalid.load('');
    expect(invalid.error, isStateError);
    invalid.dispose();
  });
  test('查询缓存与刷新', () async {
    var calls = 0;
    final controller = HyperSelectOptionsController(
      HyperSelectSource<int>.async(
        loader: (query) async {
          calls++;
          return const HyperSelectPage(
            options: [HyperSelectOption(value: 1, label: 'A')],
          );
        },
      ),
    );
    await controller.load('a');
    await controller.load('b');
    await controller.load('a');
    expect(calls, 2);
    await controller.load('a', refresh: true);
    expect(calls, 3);
    controller.dispose();
  });
  test('选择上限不阻止取消，禁用项不能修改', () {
    const first = HyperSelectOption(value: 1, label: 'A');
    const second = HyperSelectOption(value: 2, label: 'B');
    expect(hyperToggleSelect({1}, second, maximum: 1), {1});
    expect(hyperToggleSelect({1}, first, maximum: 1), isEmpty);
    expect(
      hyperToggleSelect({
        1,
      }, const HyperSelectOption(value: 1, label: 'A', enabled: false)),
      {1},
    );
  });
  test('标签溢出按实际宽度保留 +N', () {
    expect(
      hyperVisibleSelectionCount([30, 30, 30], {1: 20, 2: 20, 3: 20}, 60, 4),
      1,
    );
    expect(
      hyperVisibleSelectionCount([30, 30, 30], {1: 20, 2: 20, 3: 20}, 100, 4),
      3,
    );
    expect(hyperVisibleSelectionCount([30], {1: 20}, 20, 4), 0);
    expect(
      () => hyperVisibleSelectionCount([30], {1: 20}, 40, double.nan),
      throwsArgumentError,
    );
  });
  test('主题和四端尺寸保留覆盖、插值与相等', () {
    const style = HyperSelectionStyle(
      presentation: HyperSelectPresentation.fullScreen,
      chipSpacing: 6,
    );
    expect(style.copyWith(), style);
    expect(
      HyperSelectionStyle.lerp(
        style,
        style.copyWith(chipSpacing: 10),
        .5,
      ).chipSpacing,
      8,
    );
    final theme = HyperThemeData.light().copyWith(
      selectionTheme: const HyperSelectionThemeData(style: style),
    );
    expect(theme.selectionTheme.style, style);
    const auto = HyperAutocompleteThemeData(
      style: HyperSelectionStyle(width: 220),
    );
    final merged = auto.merge(
      const HyperAutocompleteThemeData(
        style: HyperSelectionStyle(chipSpacing: 9),
      ),
    );
    expect(merged.style.width, 220);
    expect(merged.style.chipSpacing, 9);
    expect(merged.copyWith(), merged);
    final changed = theme.copyWith(autocompleteTheme: merged);
    expect(changed.autocompleteTheme, merged);
    expect(changed.selectionTheme, theme.selectionTheme);
  });
}
