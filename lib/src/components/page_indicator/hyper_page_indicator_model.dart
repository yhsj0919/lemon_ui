import 'dart:math' as math;

enum HyperPageIndicatorVariant { dots, number }

/// 对应 PageView 的零起始索引；窗口计算不修改当前页或业务数据。
final class HyperPageIndicatorModel {
  HyperPageIndicatorModel({
    required this.pageCount,
    required this.currentIndex,
    this.maxVisibleDots = 7,
  }) {
    if (pageCount < 0 || maxVisibleDots < 1) {
      throw ArgumentError('pageCount 不能为负，maxVisibleDots 必须为正。');
    }
    if (currentIndex < 0 || currentIndex >= math.max(1, pageCount)) {
      throw RangeError.range(
        currentIndex,
        0,
        math.max(0, pageCount - 1),
        'currentIndex',
      );
    }
  }
  final int pageCount, currentIndex, maxVisibleDots;
  List<int> get visibleIndices {
    final count = math.min(pageCount, maxVisibleDots);
    final start = (currentIndex - count ~/ 2).clamp(0, pageCount - count);
    return List.unmodifiable(List.generate(count, (i) => start + i));
  }

  String get counter => '${pageCount == 0 ? 0 : currentIndex + 1} / $pageCount';
}
