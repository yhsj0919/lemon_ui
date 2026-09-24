import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';

/// 默认底槽、独立圆角标签与普通下划线标签。
enum HyperTabBarVariant { segmented, separated, underline }

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
  });

  const HyperTabBar.separated({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.onTap,
  }) : variant = HyperTabBarVariant.separated;

  const HyperTabBar.underline({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.onTap,
  }) : variant = HyperTabBarVariant.underline;

  final List<Widget> tabs;
  final TabController? controller;
  final HyperTabBarVariant variant;
  final bool isScrollable;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final segmented = variant == HyperTabBarVariant.segmented;
    final separated = variant == HyperTabBarVariant.separated;
    final effectiveController = controller ?? DefaultTabController.of(context);
    final height = sizes.tabBar.height;
    final radius = BorderRadius.circular(
      segmented ? sizes.tabBar.segmentedRadius : sizes.tabBar.separatedRadius,
    );
    final style = theme.textTheme.labelLarge?.copyWith(
      fontSize: theme.typography.control,
    );
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
    return DecoratedBox(
      decoration: BoxDecoration(
        // 独立标签各自绘制表面，只有底槽形态绘制整条背景。
        color: segmented ? theme.colors.surfaceMuted : Colors.transparent,
        borderRadius: radius,
      ),
      child: SizedBox(
        height: height,
        child: TabBar(
          controller: effectiveController,
          tabs: [
            for (final (index, tab) in tabContents.indexed)
              separated
                  ? _IndependentTabSurface(
                      controller: effectiveController,
                      index: index,
                      color: theme.colors.surfaceMuted,
                      selectedColor: theme.colors.surface,
                      radius: radius,
                      child: tab,
                    )
                  : tab,
          ],
          isScrollable: isScrollable,
          onTap: onTap,
          tabAlignment: isScrollable ? TabAlignment.start : TabAlignment.fill,
          labelPadding: EdgeInsets.symmetric(
            horizontal: separated
                ? sizes.tabBar.itemSpacing / 2
                : sizes.controlPadding.horizontal / 2,
          ),
          labelColor: variant == HyperTabBarVariant.underline
              ? theme.colors.primary
              : theme.colors.textPrimary,
          unselectedLabelColor: theme.colors.textSecondary,
          labelStyle: style?.copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle: style,
          splashFactory: NoSplash.splashFactory,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          dividerColor: variant == HyperTabBarVariant.underline
              ? theme.colors.outline
              : Colors.transparent,
          indicatorWeight: variant == HyperTabBarVariant.underline
              ? sizes.tabBar.underlineThickness
              : 0,
          indicatorSize: variant == HyperTabBarVariant.underline
              ? TabBarIndicatorSize.label
              : TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.all(
            segmented ? sizes.overlaySpacing : 0,
          ),
          indicator: variant == HyperTabBarVariant.underline
              ? UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: theme.colors.primary,
                    width: sizes.tabBar.underlineThickness,
                  ),
                )
              : BoxDecoration(
                  color: segmented ? theme.colors.surface : Colors.transparent,
                  borderRadius: radius,
                ),
          splashBorderRadius: radius,
        ),
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
    required this.child,
  });

  final TabController controller;
  final int index;
  final Color color;
  final Color selectedColor;
  final BorderRadius radius;
  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller.animation ?? controller,
    builder: (context, child) {
      final position =
          controller.animation?.value ?? controller.index.toDouble();
      final selected = (1 - (position - index).abs()).clamp(0.0, 1.0);
      return Container(
        // 固定标签栏中占满各自的分配宽度，滚动标签栏仍按内容自然宽度布局。
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color.lerp(color, selectedColor, selected),
          borderRadius: radius,
        ),
        child: child,
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
