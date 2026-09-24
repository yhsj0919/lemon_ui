import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 在普通列表中预览固定、展开和玻璃顶栏。
class HyperAppBarPage extends StatefulWidget {
  const HyperAppBarPage({super.key});

  @override
  State<HyperAppBarPage> createState() => _HyperAppBarPageState();
}

class _HyperAppBarPageState extends State<HyperAppBarPage> {
  HyperAppBarVariant _variant = HyperAppBarVariant.large;
  bool _glass = true;

  @override
  Widget build(BuildContext context) {
    final barStyle = _glass
        ? null
        : HyperAppBarStyle(
            material: HyperSurfaceMaterial.solid(
              background: HyperFill.color(
                HyperTheme.of(context).colors.background,
              ),
            ),
          );
    final bar = switch (_variant) {
      HyperAppBarVariant.small => HyperAppBar(
        title: const HyperText('普通顶栏'),
        leading: _menuButton(context),
        automaticallyImplyLeading: false,
        style: barStyle,
      ),
      HyperAppBarVariant.medium => HyperAppBar.medium(
        title: const HyperText('展开顶栏'),
        leading: _menuButton(context),
        automaticallyImplyLeading: false,
        style: barStyle,
      ),
      HyperAppBarVariant.large => HyperAppBar.large(
        title: const HyperText('展开顶栏'),
        leading: _menuButton(context),
        automaticallyImplyLeading: false,
        style: barStyle,
      ),
    };

    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFA06A),
                  Color(0xFF9C71D8),
                  Color(0xFF5E9DF0),
                ],
              ),
            ),
          ),
        ),
        // 顶栏和列表共用整屏视口，使状态栏也参与顶栏的展开与收起。
        CustomScrollView(
          slivers: [
            bar.toSliver(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    HyperButton.tonal(
                      onPressed: () =>
                          setState(() => _variant = HyperAppBarVariant.small),
                      child: const HyperText('普通'),
                    ),
                    HyperButton.tonal(
                      onPressed: () =>
                          setState(() => _variant = HyperAppBarVariant.medium),
                      child: const HyperText('中等展开'),
                    ),
                    HyperButton.tonal(
                      onPressed: () =>
                          setState(() => _variant = HyperAppBarVariant.large),
                      child: const HyperText('大幅展开'),
                    ),
                    HyperButton.tonal(
                      onPressed: () => setState(() => _glass = !_glass),
                      child: HyperText(_glass ? '关闭玻璃' : '开启玻璃'),
                    ),
                  ],
                ),
              ),
            ),
            SliverList.builder(itemCount: 30, itemBuilder: _buildItem),
          ],
        ),
      ],
    );
  }

  Widget? _menuButton(BuildContext context) => Scaffold.hasDrawer(context)
      ? HyperIconButton.ghost(
          tooltip: '打开组件菜单',
          onPressed: () => HyperScaffold.openDrawer(context),
          icon: const Icon(Icons.menu),
        )
      : null;

  Widget _buildItem(BuildContext context, int index) => HyperListTile(
    title: HyperText('列表项目 ${index + 1}'),
    subtitle: const HyperText('上滑观察顶栏收起和背景透出'),
  );
}
