import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../../foundation/hyper_fill.dart';
import '../card/hyper_card_style.dart';
import '../surface/hyper_navigation_surface.dart';
import 'hyper_tab_bar_style.dart';
import 'hyper_tab_bar_theme.dart';
import 'hyper_tab_selection_track.dart';
export 'hyper_tab_bar_style.dart';
export 'hyper_tab_bar_theme.dart';

/// 默认底槽、独立圆角标签与普通下划线标签。

/// 与 Flutter [TabController] 和 [DefaultTabController] 共用状态的标签项。
class HyperTab extends Tab {
  const HyperTab({
    super.key,
    super.text,
    super.icon,
    super.child,
    super.iconMargin,
  });
}

/// 水平标签栏；标签切换、键盘导航和滚动由 Flutter TabBar 负责。
class HyperTabBar extends StatelessWidget {
  const HyperTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.variant = HyperTabBarVariant.segmented,
    this.isScrollable = false,
    this.onTap,
    this.padding,
    this.style,
  });

  const HyperTabBar.separated({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.onTap,
    this.padding,
    this.style,
  }) : variant = HyperTabBarVariant.separated;

  const HyperTabBar.underline({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.onTap,
    this.padding,
    this.style,
  }) : variant = HyperTabBarVariant.underline;

  /// 覆盖主题中的标签栏边缘留白；EdgeInsets.zero 可关闭。
  final EdgeInsetsGeometry? padding;
  final HyperTabBarStyle? style;

  final List<Widget> tabs;
  final TabController? controller;
  final HyperTabBarVariant variant;
  final bool isScrollable;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final visual = HyperTabBarTheme.of(context).resolve(variant).merge(style);
    final segmented = variant == HyperTabBarVariant.segmented;
    final separated = variant == HyperTabBarVariant.separated;
    final effectiveController = controller ?? DefaultTabController.of(context);
    final radius = BorderRadius.circular(
      segmented ? sizes.tabBar.segmentedRadius : sizes.tabBar.separatedRadius,
    );
    final insets = (padding ?? sizes.tabBar.padding).resolve(
      Directionality.of(context),
    );
    final outerRadius = (visual.trackStyle?.borderRadius ?? radius).resolve(
      Directionality.of(context),
    );
    Radius innerCorner(Radius outer, double horizontal, double vertical) =>
        Radius.elliptical(
          (outer.x - horizontal).clamp(0, double.infinity),
          (outer.y - vertical).clamp(0, double.infinity),
        );
    final innerRadius = BorderRadius.only(
      topLeft: innerCorner(outerRadius.topLeft, insets.left, insets.top),
      topRight: innerCorner(outerRadius.topRight, insets.right, insets.top),
      bottomLeft: innerCorner(
        outerRadius.bottomLeft,
        insets.left,
        insets.bottom,
      ),
      bottomRight: innerCorner(
        outerRadius.bottomRight,
        insets.right,
        insets.bottom,
      ),
    );
    final textStyle = theme.textTheme.labelLarge
        ?.copyWith(fontSize: theme.typography.control)
        .merge(visual.textStyle);
    final painter = TextPainter(
      text: TextSpan(text: 'Hg', style: textStyle),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final scaledLineHeight = painter.height;
    painter.textScaler = TextScaler.noScaling;
    painter.layout();
    final extraHeight = (scaledLineHeight - painter.height).clamp(
      0.0,
      double.infinity,
    );
    painter.dispose();
    final height = sizes.tabBar.height + extraHeight;
    final tabContents = [
      for (final tab in tabs)
        if (tab is Tab)
          Tab(
            key: tab.key,
            text: tab.text,
            icon: tab.icon,
            iconMargin: tab.iconMargin,
            height: height,
            child: tab.child,
          )
        else
          SizedBox(
            height: height,
            child: Center(child: tab),
          ),
    ];
    Widget buildTabs(List<GlobalKey>? keys) => TabBar(
      controller: effectiveController,
      padding: padding ?? sizes.tabBar.padding,
      tabs: [
        for (final (index, tab) in tabContents.indexed)
          HyperTabSelectionMarker(
            key: keys?[index],
            child: SizedBox(
              width: isScrollable || variant == HyperTabBarVariant.underline
                  ? null
                  : double.infinity,
              child: _IndependentTabSurface(
                inset: segmented
                    ? EdgeInsets.zero
                    : separated
                    ? EdgeInsets.symmetric(
                        horizontal: sizes.tabBar.itemSpacing / 2,
                      )
                    : EdgeInsets.zero,
                controller: effectiveController,
                index: index,
                animateSelection: !segmented,
                color: separated
                    ? theme.colors.surfaceMuted
                    : Colors.transparent,
                selectedColor: separated
                    ? theme.colors.surface
                    : Colors.transparent,
                radius: radius,
                normalStyle: visual.itemStyle,
                selectedStyle: segmented ? null : visual.selectedItemStyle,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: separated
                        ? (sizes.controlPadding.horizontal +
                                  sizes.tabBar.itemSpacing) /
                              2
                        : segmented
                        ? sizes.controlPadding.horizontal / 2
                        : 0,
                  ),
                  child: tab,
                ),
              ),
            ),
          ),
      ],
      isScrollable: isScrollable,
      onTap: onTap,
      tabAlignment: isScrollable ? TabAlignment.start : TabAlignment.fill,
      labelPadding: variant == HyperTabBarVariant.underline
          ? EdgeInsets.symmetric(
              horizontal: sizes.controlPadding.horizontal / 2,
            )
          : EdgeInsets.zero,
      labelColor:
          visual.selectedForegroundColor ??
          (variant == HyperTabBarVariant.underline
              ? theme.colors.primary
              : theme.colors.textPrimary),
      unselectedLabelColor:
          visual.foregroundColor ?? theme.colors.textSecondary,
      labelStyle: textStyle
          ?.copyWith(fontWeight: FontWeight.w600)
          .merge(visual.selectedTextStyle),
      unselectedLabelStyle: textStyle,
      splashFactory: NoSplash.splashFactory,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      dividerColor: variant == HyperTabBarVariant.underline
          ? visual.dividerColor ?? theme.colors.outline
          : Colors.transparent,
      indicatorWeight: variant == HyperTabBarVariant.underline
          ? sizes.tabBar.underlineThickness
          : 0,
      indicatorSize: variant == HyperTabBarVariant.underline
          ? TabBarIndicatorSize.label
          : TabBarIndicatorSize.tab,
      indicatorPadding: EdgeInsets.zero,
      indicator: variant == HyperTabBarVariant.underline
          ? UnderlineTabIndicator(
              borderSide: BorderSide(
                color: visual.indicatorColor ?? theme.colors.primary,
                width: sizes.tabBar.underlineThickness,
              ),
            )
          : const BoxDecoration(),
      splashBorderRadius: radius,
    );
    return HyperNavigationSurface(
      style: HyperCardStyle(
        background: HyperFill.color(
          segmented ? theme.colors.surfaceMuted : Colors.transparent,
        ),
        borderRadius: radius,
        padding: EdgeInsets.zero,
      ).merge(visual.trackStyle),
      inheritMaterial: true,
      child: SizedBox(
        height: height,
        child: segmented
            ? HyperTabSelectionTrack(
                controller: effectiveController,
                count: tabs.length,
                inset: EdgeInsets.zero,
                style: HyperCardStyle(
                  background: HyperFill.color(theme.colors.surface),
                  borderRadius: innerRadius,
                  padding: EdgeInsets.zero,
                ).merge(visual.itemStyle).merge(visual.selectedItemStyle),
                builder: buildTabs,
              )
            : buildTabs(null),
      ),
    );
  }
}

/// 独立标签各自绘制表面，颜色随控制器连续切换。
class _IndependentTabSurface extends StatelessWidget {
  const _IndependentTabSurface({
    required this.controller,
    required this.index,
    required this.color,
    required this.selectedColor,
    required this.radius,
    this.normalStyle,
    this.inset = EdgeInsets.zero,
    this.selectedStyle,
    this.animateSelection = true,
    required this.child,
  });

  final TabController controller;
  final int index;
  final Color color;
  final Color selectedColor;
  final BorderRadius radius;
  final HyperCardStyle? normalStyle, selectedStyle;
  final EdgeInsetsGeometry inset;
  final Widget child;
  final bool animateSelection;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller.animation ?? controller,
    builder: (context, child) {
      final position =
          controller.animation?.value ?? controller.index.toDouble();
      final selected = animateSelection
          ? (1 - (position - index).abs()).clamp(0.0, 1.0)
          : 0.0;
      final normal = HyperCardStyle(
        background: HyperFill.color(color),
        borderRadius: radius,
        padding: EdgeInsets.zero,
      ).merge(normalStyle);
      final active = normal
          .merge(HyperCardStyle(background: HyperFill.color(selectedColor)))
          .merge(selectedStyle);
      final style = HyperCardStyle.lerp(normal, active, selected);
      return Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned.fill(
            child: Padding(
              padding: inset,
              child: HyperNavigationSurface(
                style: style.merge(HyperCardStyle(padding: EdgeInsets.zero)),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          Padding(padding: style.padding ?? EdgeInsets.zero, child: child!),
        ],
      );
    },
    child: child,
  );
}

/// 与 [HyperTabBar] 共用同一个 TabController 的内容区域。
class HyperTabBarView extends StatelessWidget {
  const HyperTabBarView({
    super.key,
    required this.children,
    this.controller,
    this.physics,
  });

  final List<Widget> children;
  final TabController? controller;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) =>
      TabBarView(controller: controller, physics: physics, children: children);
}
