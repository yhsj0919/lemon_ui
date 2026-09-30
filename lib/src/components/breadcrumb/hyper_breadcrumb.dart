import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_breadcrumb_style.dart';
import 'hyper_breadcrumb_theme.dart';

/// 路径中的一个节点。label 为空时显示 path。
@immutable
final class HyperBreadcrumbItem {
  const HyperBreadcrumbItem({
    required this.path,
    this.label,
    this.enabled = true,
  });

  final String path;
  final String? label;
  final bool enabled;

  String get displayLabel => label ?? path;
}

/// 胶囊路径导航；路径过长时横向滚动并将当前节点保持在可见范围。
class HyperBreadcrumb extends StatefulWidget {
  const HyperBreadcrumb({
    super.key,
    required this.items,
    this.onItemTap,
    this.highlightIndex,
    this.enabled = true,
    this.style,
    this.controller,
    this.physics,
  });

  final List<HyperBreadcrumbItem> items;
  final ValueChanged<int>? onItemTap;

  /// 默认高亮末级。传入负数可关闭高亮。
  final int? highlightIndex;
  final bool enabled;
  final HyperBreadcrumbStyle? style;
  final ScrollController? controller;

  /// 横向拖动的物理效果；默认使用弹簧回弹。
  final ScrollPhysics? physics;

  @override
  State<HyperBreadcrumb> createState() => _HyperBreadcrumbState();
}

class _HyperBreadcrumbState extends State<HyperBreadcrumb> {
  final GlobalKey _highlightKey = GlobalKey();

  int get _highlightIndex => widget.highlightIndex ?? widget.items.length - 1;

  @override
  void initState() {
    super.initState();
    _scheduleReveal();
  }

  @override
  void didUpdateWidget(HyperBreadcrumb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.highlightIndex != widget.highlightIndex ||
        oldWidget.items != widget.items) {
      _scheduleReveal();
    }
  }

  void _scheduleReveal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = _highlightKey.currentContext;
      if (!mounted || target == null) return;
      Scrollable.ensureVisible(
        target,
        alignment: 1,
        duration: MediaQuery.maybeOf(context)?.disableAnimations == true
            ? Duration.zero
            : HyperTheme.of(context).motion.fastDuration,
        curve: HyperTheme.of(context).motion.fastCurve,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context).breadcrumb;
    final resolved = HyperBreadcrumbTheme.of(context).style.merge(widget.style);
    final textStyle = (theme.textTheme.bodyMedium ?? const TextStyle())
        .copyWith(fontSize: theme.typography.breadcrumb)
        .merge(resolved.textStyle);
    final normalBackground =
        resolved.backgroundColor ?? theme.colors.surfaceMuted;
    final highlightBackground =
        resolved.highlightBackgroundColor ??
        theme.colors.warning.withValues(alpha: .14);
    final disabledBackground =
        resolved.disabledBackgroundColor ?? normalBackground;
    final normalForeground =
        resolved.foregroundColor ?? theme.colors.textSecondary;
    final highlightForeground =
        resolved.highlightForegroundColor ?? theme.colors.warning;
    final separatorColor = resolved.separatorColor ?? theme.colors.textTertiary;
    final disabledColor = resolved.disabledColor ?? theme.colors.disabled;
    final radius = BorderRadius.circular(sizes.itemHeight / 2);

    return SizedBox(
      height: sizes.itemHeight,
      child: SingleChildScrollView(
        controller: widget.controller,
        scrollDirection: Axis.horizontal,
        physics: widget.physics ?? const BouncingScrollPhysics(),
        child: Row(
          children: [
            for (final (index, item) in widget.items.indexed) ...[
              if (index > 0)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: sizes.separatorSpacing,
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    size: sizes.separatorSize,
                    color: separatorColor,
                    textDirection: Directionality.of(context),
                  ),
                ),
              Builder(
                builder: (context) {
                  final highlighted = index == _highlightIndex;
                  final interactive =
                      widget.enabled &&
                      item.enabled &&
                      widget.onItemTap != null;
                  final foreground = widget.enabled && item.enabled
                      ? (highlighted ? highlightForeground : normalForeground)
                      : disabledColor;
                  return Semantics(
                    key: highlighted ? _highlightKey : null,
                    button: interactive,
                    enabled: widget.enabled && item.enabled,
                    selected: highlighted,
                    child: SizedBox(
                      height: sizes.itemHeight,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: sizes.itemMaxWidth,
                        ),
                        child: Material(
                          color: !widget.enabled || !item.enabled
                              ? disabledBackground
                              : highlighted
                              ? highlightBackground
                              : normalBackground,
                          borderRadius: radius,
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: interactive
                                ? () => widget.onItemTap!(index)
                                : null,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: sizes.itemHorizontalPadding,
                              ),
                              child: Center(
                                widthFactor: 1,
                                child: Text(
                                  item.displayLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyle.copyWith(color: foreground),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
