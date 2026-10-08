import '../tooltip/hyper_tooltip.dart';

import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../theme/core/hyper_theme.dart';
import '../button/hyper_button.dart';
import '../button/hyper_button_style.dart';
import 'hyper_pagination_model.dart';
import 'hyper_pagination_style.dart';
import 'hyper_pagination_theme.dart';

typedef HyperPageLabelBuilder = String Function(int page);
typedef HyperPaginationCounterBuilder = Widget Function(
  BuildContext context,
  int currentPage,
  int pageCount,
);

/// 受控分页导航；不管理数据加载、每页数量或页数变化后的业务修正。
class HyperPagination extends StatelessWidget {
  const HyperPagination({
    super.key,
    required this.pageCount,
    required this.currentPage,
    this.onPageChanged,
    this.siblingCount = 1,
    this.boundaryCount = 1,
    this.enabled = true,
    this.showPageNumbers = true,
    this.showBoundaryButtons = false,
    this.pageLabelBuilder,
    this.counterBuilder,
    this.style,
  });
  final int pageCount, currentPage, siblingCount, boundaryCount;
  final ValueChanged<int>? onPageChanged;
  final bool enabled, showPageNumbers, showBoundaryButtons;
  final HyperPageLabelBuilder? pageLabelBuilder;
  final HyperPaginationCounterBuilder? counterBuilder;
  final HyperPaginationStyle? style;
  @override
  Widget build(BuildContext context) {
    final model = HyperPaginationModel(
      pageCount: pageCount,
      currentPage: currentPage,
      siblingCount: siblingCount,
      boundaryCount: boundaryCount,
    );
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final metrics = sizes.pagination;
    final defaults = HyperButtonStyle(
      background: const HyperFill.none(),
      disabledBackground: const HyperFill.none(),
      foregroundColor: theme.colors.textPrimary,
      disabledForegroundColor: theme.colors.textTertiary,
      border: BorderSide.none,
      borderRadius: BorderRadius.circular(metrics.radius),
      boxShadow: const [],
      padding: metrics.padding,
      height: metrics.height,
      minimumSize: Size(metrics.minWidth, metrics.height),
      minimumTapTargetSize: Size.square(sizes.minimumInteractiveDimension),
      iconSize: metrics.iconSize,
      textStyle: theme.textTheme.bodyMedium,
      animationDuration: theme.motion.fastDuration,
      animationCurve: theme.motion.fastCurve,
    );
    final resolved = HyperPaginationStyle(
      buttonStyle: defaults,
      selectedStyle: HyperButtonStyle(
        background: HyperFill.color(theme.colors.primary),
        disabledBackground: HyperFill.color(theme.colors.primary),
        foregroundColor: theme.colors.onPrimary,
        disabledForegroundColor: theme.colors.onPrimary,
      ),
      spacing: metrics.spacing,
      runSpacing: metrics.runSpacing,
      ellipsis: '…',
      ellipsisStyle: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colors.textSecondary,
      ),
      previousLabel: '上一页',
      nextLabel: '下一页',
      firstLabel: '第一页',
      lastLabel: '最后一页',
      previousIcon: Icons.chevron_left,
      nextIcon: Icons.chevron_right,
      firstIcon: Icons.first_page,
      lastIcon: Icons.last_page,
    ).merge(HyperPaginationTheme.of(context).style).merge(style);
    final active = enabled && onPageChanged != null;
    Widget button(
      Widget child,
      int target, {
      required bool available,
      String? tooltip,
      bool selected = false,
      Object? key,
    }) {
      final callback = active && available
          ? () => onPageChanged!(target)
          : null;
      final visual = resolved.buttonStyle!
          .merge(selected ? resolved.selectedStyle : null)
          .merge(tooltip == null ? null : resolved.navigationStyle);
      Widget result = Semantics(
        key: key == null ? null : ValueKey(key),
        selected: selected,
        child: HyperButton.ghost(
          onPressed: callback,
          style: visual,
          child: child,
        ),
      );
      if (tooltip != null) {
        result = HyperTooltip(
          message: tooltip,
          child: Semantics(label: tooltip, child: result),
        );
      }
      return result;
    }

    Widget navigation(
      IconData icon,
      int target,
      bool available,
      String label,
    ) => button(
      Transform.flip(
        flipX: Directionality.of(context) == TextDirection.rtl,
        child: Icon(icon),
      ),
      target,
      available: available,
      tooltip: label,
    );
    return Wrap(
      spacing: resolved.spacing!,
      runSpacing: resolved.runSpacing!,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (showBoundaryButtons)
          navigation(
            resolved.firstIcon!,
            1,
            model.canPrevious,
            resolved.firstLabel!,
          ),
        navigation(
          resolved.previousIcon!,
          currentPage - 1,
          model.canPrevious,
          resolved.previousLabel!,
        ),
        if (showPageNumbers)
          for (final page in model.pages)
            if (page == null)
              SizedBox(
                width: resolved.buttonStyle!.minimumSize!.width,
                child: Center(
                  child: DefaultTextStyle(
                    style: resolved.ellipsisStyle!,
                    child: Text(resolved.ellipsis!),
                  ),
                ),
              )
            else
              button(
                Text(pageLabelBuilder?.call(page) ?? '$page'),
                page,
                available: page != currentPage,
                selected: page == currentPage,
                key: page,
              )
        else
          counterBuilder?.call(context, currentPage, pageCount) ??
              DefaultTextStyle(
                style: resolved.ellipsisStyle!,
                child: Text('$currentPage / $pageCount'),
              ),
        navigation(
          resolved.nextIcon!,
          currentPage + 1,
          model.canNext,
          resolved.nextLabel!,
        ),
        if (showBoundaryButtons)
          navigation(
            resolved.lastIcon!,
            pageCount,
            model.canNext,
            resolved.lastLabel!,
          ),
      ],
    );
  }
}
