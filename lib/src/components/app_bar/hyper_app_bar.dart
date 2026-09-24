import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_app_bar_resolved.dart';
import 'hyper_app_bar_style.dart';
import 'hyper_app_bar_variant.dart';
import 'hyper_sliver_app_bar.dart';

/// 普通页面的固定顶栏；medium 与 large 在 HyperScaffold 中自动随列表收起。
class HyperAppBar extends StatelessWidget {
  const HyperAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.style,
    this.automaticallyImplyLeading = true,
  }) : variant = HyperAppBarVariant.small;

  const HyperAppBar.medium({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.style,
    this.automaticallyImplyLeading = true,
  }) : variant = HyperAppBarVariant.medium;

  const HyperAppBar.large({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.style,
    this.automaticallyImplyLeading = true,
  }) : variant = HyperAppBarVariant.large;

  final Widget title;
  final Widget? leading;
  final List<Widget>? actions;
  final HyperAppBarStyle? style;
  final bool automaticallyImplyLeading;
  final HyperAppBarVariant variant;

  /// 供 HyperScaffold 把展开变体接到普通列表的滚动位置。
  HyperSliverAppBar toSliver() => HyperSliverAppBar(
    title: title,
    leading: leading,
    actions: actions,
    style: style,
    automaticallyImplyLeading: automaticallyImplyLeading,
    variant: variant,
  );

  @override
  Widget build(BuildContext context) {
    final resolved = HyperAppBarResolved(context, style, variant);
    final metrics = HyperTheme.sizesOf(context).appBar;
    return AppBar(
      title: title,
      leading: leading,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarHeight: metrics.collapsedHeight,
      titleSpacing: metrics.titleHorizontalPadding,
      titleTextStyle: resolved.titleTextStyle,
      centerTitle: resolved.style.centerTitle ?? true,
      foregroundColor: resolved.style.foregroundColor,
      iconTheme: IconThemeData(color: resolved.style.foregroundColor),
      actionsIconTheme: IconThemeData(color: resolved.style.foregroundColor),
      backgroundColor: resolved.backgroundColor,
      flexibleSpace: resolved.materialBackground,
      forceMaterialTransparency: resolved.material != null,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: resolved.material == null ? null : 0,
      elevation: resolved.style.elevation,
    );
  }
}
