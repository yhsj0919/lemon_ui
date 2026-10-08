import 'dart:math' as math;

/// 纯页码计算。非空列表使用 1 起始页码；空列表的当前页必须为 0。
final class HyperPaginationModel {
  HyperPaginationModel({
    required this.pageCount,
    required this.currentPage,
    this.siblingCount = 1,
    this.boundaryCount = 1,
  }) {
    if (pageCount < 0) {
      throw ArgumentError.value(pageCount, 'pageCount', '不能为负数');
    }
    if (currentPage < (pageCount == 0 ? 0 : 1) || currentPage > pageCount) {
      throw RangeError.range(
        currentPage,
        pageCount == 0 ? 0 : 1,
        pageCount,
        'currentPage',
      );
    }
    if (siblingCount < 0 || boundaryCount < 0) {
      throw ArgumentError('siblingCount 和 boundaryCount 不能为负数');
    }
  }
  final int pageCount, currentPage, siblingCount, boundaryCount;
  bool get canPrevious => currentPage > 1;
  bool get canNext => currentPage > 0 && currentPage < pageCount;

  /// null 表示不可点击的省略号；只有单页缺口时直接绘制该页。
  List<int?> get pages {
    if (pageCount == 0) {
      return const [];
    }
    final selected = <int>{};
    for (var page = 1; page <= math.min(boundaryCount, pageCount); page++) {
      selected.add(page);
      selected.add(pageCount - page + 1);
    }
    var start = math.max(1, currentPage - siblingCount);
    final end = math.min(pageCount, start + siblingCount * 2);
    start = math.max(1, end - siblingCount * 2);
    for (var page = start; page <= end; page++) {
      selected.add(page);
    }
    final sorted = selected.toList()..sort();
    final output = <int?>[];
    for (final page in sorted) {
      if (output.isNotEmpty) {
        final previous = output.last!;
        if (page - previous == 2) {
          output.add(previous + 1);
        } else if (page - previous > 2) {
          output.add(null);
        }
      }
      output.add(page);
    }
    return List.unmodifiable(output);
  }
}
