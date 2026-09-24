import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_app_bar_resolved.dart';
import 'hyper_app_bar_style.dart';
import 'hyper_app_bar_variant.dart';

/// 可直接放入 CustomScrollView 的滚动顶栏。
class HyperSliverAppBar extends StatelessWidget {
  const HyperSliverAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.style,
    this.automaticallyImplyLeading = true,
    this.variant = HyperAppBarVariant.large,
  });

  final Widget title;
  final Widget? leading;
  final List<Widget>? actions;
  final HyperAppBarStyle? style;
  final bool automaticallyImplyLeading;
  final HyperAppBarVariant variant;

  @override
  Widget build(BuildContext context) {
    final resolved = HyperAppBarResolved(context, style, variant);
    final metrics = HyperTheme.sizesOf(context).appBar;
    final motion = HyperTheme.of(context).motion;
    final expandedHeight = switch (variant) {
      HyperAppBarVariant.small => metrics.collapsedHeight,
      HyperAppBarVariant.medium => metrics.mediumExpandedHeight,
      HyperAppBarVariant.large => metrics.expandedHeight,
    };
    final isExpandedVariant = variant != HyperAppBarVariant.small;
    return SliverAppBar(
      pinned: true,
      floating: false,
      expandedHeight: expandedHeight,
      toolbarHeight: metrics.collapsedHeight,
      leading: leading,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: isExpandedVariant
          ? Builder(
              builder: (context) {
                final settings = context
                    .dependOnInheritedWidgetOfExactType<
                      FlexibleSpaceBarSettings
                    >()!;
                final progress = _collapseProgress(settings);
                final visible = progress >= 1 / 3;
                return AnimatedOpacity(
                  opacity: visible ? 1 : 0,
                  duration: motion.fastDuration,
                  curve: motion.fastCurve,
                  child: AnimatedSlide(
                    offset: visible ? Offset.zero : const Offset(0, 0.5),
                    duration: motion.fastDuration,
                    curve: motion.fastCurve,
                    child: title,
                  ),
                );
              },
            )
          : title,
      titleTextStyle: resolved.titleTextStyle,
      centerTitle: resolved.style.centerTitle ?? true,
      foregroundColor: resolved.style.foregroundColor,
      iconTheme: IconThemeData(color: resolved.style.foregroundColor),
      actionsIconTheme: IconThemeData(color: resolved.style.foregroundColor),
      backgroundColor: isExpandedVariant
          ? Colors.transparent
          : resolved.backgroundColor,
      forceMaterialTransparency: isExpandedVariant || resolved.material != null,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: isExpandedVariant ? 0 : resolved.style.elevation,
      flexibleSpace: isExpandedVariant
          ? Builder(
              builder: (context) {
                final settings = context
                    .dependOnInheritedWidgetOfExactType<
                      FlexibleSpaceBarSettings
                    >()!;
                final progress = _collapseProgress(settings);
                final collapsed = progress >= 1;
                final scrolledDistance =
                    settings.maxExtent - settings.currentExtent;
                final background =
                    resolved.materialBackground ??
                    ColoredBox(color: resolved.backgroundColor);
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // 展开时直接露出页面背景；收起后才显示完整材质配方。
                    AnimatedOpacity(
                      opacity: collapsed ? 1 : 0,
                      duration: motion.fastDuration,
                      curve: motion.fastCurve,
                      child: background,
                    ),
                    ClipRect(
                      child: Stack(
                        children: [
                          // 大标题随滚动上移并渐隐，不在大小之间插值。
                          PositionedDirectional(
                            top: settings.minExtent - scrolledDistance,
                            start: metrics.titleHorizontalPadding,
                            end: metrics.titleHorizontalPadding,
                            child: Opacity(
                              opacity: (1 - progress * 3).clamp(0.0, 1.0),
                              child: DefaultTextStyle.merge(
                                style: resolved.expandedTitleTextStyle,
                                child: title,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            )
          : resolved.materialBackground,
    );
  }

  double _collapseProgress(FlexibleSpaceBarSettings settings) {
    final range = settings.maxExtent - settings.minExtent;
    if (range <= 0) return 1;
    return ((settings.maxExtent - settings.currentExtent) / range).clamp(
      0.0,
      1.0,
    );
  }
}
