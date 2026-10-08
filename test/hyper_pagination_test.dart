import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('首尾邻页、省略号和单页缺口', () {
    expect(HyperPaginationModel(pageCount: 20, currentPage: 1).pages, [
      1,
      2,
      3,
      null,
      20,
    ]);
    expect(HyperPaginationModel(pageCount: 20, currentPage: 10).pages, [
      1,
      null,
      9,
      10,
      11,
      null,
      20,
    ]);
    expect(HyperPaginationModel(pageCount: 20, currentPage: 20).pages, [
      1,
      null,
      18,
      19,
      20,
    ]);
    expect(HyperPaginationModel(pageCount: 5, currentPage: 3).pages, [
      1,
      2,
      3,
      4,
      5,
    ]);
    expect(HyperPaginationModel(pageCount: 1, currentPage: 1).pages, [1]);
    expect(HyperPaginationModel(pageCount: 0, currentPage: 0).pages, isEmpty);
  });
  test('边界导航和非法输入明确处理', () {
    final first = HyperPaginationModel(pageCount: 3, currentPage: 1);
    expect(first.canPrevious, false);
    expect(first.canNext, true);
    final last = HyperPaginationModel(pageCount: 3, currentPage: 3);
    expect(last.canPrevious, true);
    expect(last.canNext, false);
    final empty = HyperPaginationModel(pageCount: 0, currentPage: 0);
    expect(empty.canPrevious, false);
    expect(empty.canNext, false);
    expect(
      () => HyperPaginationModel(pageCount: 0, currentPage: 1),
      throwsRangeError,
    );
    expect(
      () => HyperPaginationModel(pageCount: 3, currentPage: 0),
      throwsRangeError,
    );
    expect(
      () => HyperPaginationModel(pageCount: 3, currentPage: 4),
      throwsRangeError,
    );
    expect(
      () => HyperPaginationModel(pageCount: -1, currentPage: 0),
      throwsArgumentError,
    );
    expect(
      () =>
          HyperPaginationModel(pageCount: 3, currentPage: 1, siblingCount: -1),
      throwsArgumentError,
    );
  });
  test('各种页数下输出有序、唯一、不越界，并包含当前页', () {
    for (var count = 1; count <= 60; count++) {
      for (var page = 1; page <= count; page++) {
        final values = HyperPaginationModel(
          pageCount: count,
          currentPage: page,
        ).pages;
        final pages = values.whereType<int>().toList();
        expect(pages, contains(page));
        expect(pages.toSet().length, pages.length);
        expect(pages.every((p) => p >= 1 && p <= count), true);
        expect(pages, [...pages]..sort());
        expect(values.first, isNotNull);
        expect(values.last, isNotNull);
        for (var i = 1; i < values.length; i++) {
          expect(values[i] == null && values[i - 1] == null, false);
        }
      }
    }
  });
  test('边界数量零与大数量，输出不可修改', () {
    expect(
      HyperPaginationModel(
        pageCount: 20,
        currentPage: 10,
        siblingCount: 0,
        boundaryCount: 0,
      ).pages,
      [10],
    );
    expect(
      HyperPaginationModel(
        pageCount: 3,
        currentPage: 2,
        boundaryCount: 10,
      ).pages,
      [1, 2, 3],
    );
    expect(
      () => HyperPaginationModel(pageCount: 3, currentPage: 2).pages.add(4),
      throwsUnsupportedError,
    );
  });
  test('主题深合并与样式复制插值和值相等', () {
    final base = HyperPaginationStyle(
      spacing: 8,
      buttonStyle: HyperButtonStyle(
        height: 36,
        textStyle: const TextStyle(fontSize: 14),
      ),
      selectedStyle: HyperButtonStyle(foregroundColor: Colors.white),
    );
    final merged = base.merge(
      HyperPaginationStyle(
        buttonStyle: HyperButtonStyle(
          textStyle: const TextStyle(color: Colors.blue),
        ),
      ),
    );
    expect(merged.buttonStyle!.height, 36);
    expect(merged.buttonStyle!.textStyle!.fontSize, isNull);
    expect(merged.buttonStyle!.textStyle!.color, Colors.blue);
    final other = base.copyWith(spacing: 16, previousLabel: 'Previous');
    expect(HyperPaginationStyle.lerp(base, other, .5).spacing, 12);
    expect(base.copyWith(), base);
    expect(base.copyWith().hashCode, base.hashCode);
    expect(
      HyperPaginationThemeData.lerp(
        HyperPaginationThemeData(style: base),
        HyperPaginationThemeData(style: other),
        .5,
      ).style.spacing,
      12,
    );
  });
  test('四端尺寸与全局主题复制互不污染', () {
    final theme = HyperThemeData.light();
    for (final sizes in [
      theme.sizes.phone,
      theme.sizes.tablet,
      theme.sizes.desktop,
      theme.sizes.watch,
    ]) {
      final base = sizes.pagination;
      expect(base.height, sizes.controlHeightSm);
      expect(base.radius, sizes.controlRadius);
      expect(base.copyWith(), base);
      expect(base.copyWith().hashCode, base.hashCode);
      expect(
        HyperPaginationSize.lerp(
          base,
          base.copyWith(height: base.height + 4),
          .5,
        ).height,
        base.height + 2,
      );
      expect(
        sizes.copyWith(pagination: base.copyWith(spacing: 19)).button,
        sizes.button,
      );
    }
    const pagination = HyperPaginationThemeData(
      style: HyperPaginationStyle(spacing: 19),
    );
    final updated = theme.copyWith(paginationTheme: pagination);
    expect(updated.paginationTheme, pagination);
    expect(updated.buttonTheme, theme.buttonTheme);
    expect(theme.lerp(updated, 1), updated);
  });
}
