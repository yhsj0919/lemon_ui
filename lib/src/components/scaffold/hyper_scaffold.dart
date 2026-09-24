import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../app_bar/hyper_app_bar.dart';
import '../app_bar/hyper_app_bar_variant.dart';
import 'hyper_scaffold_style.dart';
import 'hyper_scaffold_theme.dart';

/// 页面骨架，提供顶栏、主体、抽屉和底部区域。
///
/// 内容布局由插槽自行决定；页面背景统一从 Hyper 主题解析。
class HyperScaffold extends StatelessWidget {
  const HyperScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.drawer,
    this.endDrawer,
    this.bottomBar,
    this.floatingActionButton,
    this.style,
    this.resizeToAvoidBottomInset,
    this.extendBodyBehindAppBar = false,
  });

  final Widget? appBar;
  final Widget body;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomBar;
  final Widget? floatingActionButton;
  final HyperScaffoldStyle? style;
  final bool? resizeToAvoidBottomInset;
  final bool extendBodyBehindAppBar;

  /// 打开当前页面的起始侧抽屉。
  static void openDrawer(BuildContext context) =>
      Scaffold.of(context).openDrawer();

  /// 打开当前页面的结束侧抽屉。
  static void openEndDrawer(BuildContext context) =>
      Scaffold.of(context).openEndDrawer();

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final themedStyle = HyperScaffoldTheme.of(context).style;
    final resolved = HyperScaffoldStyle(
      backgroundColor: theme.colors.background,
    ).merge(themedStyle).merge(style);
    // 顶栏实际高度由当前设备尺寸主题决定，不依赖 Widget 的静态 preferredSize。
    final scrollingAppBar =
        appBar is HyperAppBar &&
        (appBar! as HyperAppBar).variant != HyperAppBarVariant.small;
    final preferredAppBar = appBar == null || scrollingAppBar
        ? null
        : PreferredSize(
            preferredSize:
                appBar is PreferredSizeWidget && appBar is! HyperAppBar
                ? (appBar! as PreferredSizeWidget).preferredSize
                : Size.fromHeight(
                    HyperTheme.sizesOf(context).appBar.collapsedHeight,
                  ),
            child: appBar!,
          );
    return Scaffold(
      backgroundColor: resolved.backgroundColor,
      appBar: preferredAppBar,
      body: scrollingAppBar
          ? NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                (appBar! as HyperAppBar).toSliver(),
              ],
              // 内层视口会随展开顶栏收起而上移，自动滚动条的轨道也会跟着移动。
              // NestedScrollView 无法为两段滚动位置提供一条准确的滚动条。
              body: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context)
                    .copyWith(scrollbars: false),
                child: body,
              ),
            )
          : body,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomNavigationBar: bottomBar,
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }
}
