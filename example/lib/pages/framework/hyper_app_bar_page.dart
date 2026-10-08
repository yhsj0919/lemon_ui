import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

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
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final barStyle = _glass
        ? null
        : HyperAppBarStyle(
            material: HyperSurfaceMaterial.solid(
              background: HyperFill.color(theme.colors.background),
            ),
          );
    final bar = switch (_variant) {
      HyperAppBarVariant.small => HyperAppBar(
        title: const Text('普通顶栏'),
        automaticallyImplyLeading: false,
        style: barStyle,
      ),
      HyperAppBarVariant.medium => HyperAppBar.medium(
        title: const Text('展开顶栏'),
        automaticallyImplyLeading: false,
        style: barStyle,
      ),
      HyperAppBarVariant.large => HyperAppBar.large(
        title: const Text('展开顶栏'),
        automaticallyImplyLeading: false,
        style: barStyle,
      ),
    };
    return ListView(
      padding: EdgeInsets.all(sizes.pageHorizontalPadding),
      children: [
        DemoSection(
          title: '变体与材质',
          child: Wrap(
            spacing: sizes.compactSectionSpacing,
            runSpacing: sizes.compactSectionSpacing,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              HyperSegmentedButton<HyperAppBarVariant>(
                segments: const [
                  HyperSegment(value: HyperAppBarVariant.small, label: '普通'),
                  HyperSegment(value: HyperAppBarVariant.medium, label: '中等展开'),
                  HyperSegment(value: HyperAppBarVariant.large, label: '大幅展开'),
                ],
                selected: {_variant},
                onSelectionChanged: (values) =>
                    setState(() => _variant = values.single),
              ),
              HyperButton.tonal(
                onPressed: () => setState(() => _glass = !_glass),
                label: Text(_glass ? '关闭玻璃' : '开启玻璃'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: '滚动预览',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('在预览内滚动，观察顶栏收起与材质变化。'),
              SizedBox(height: sizes.compactSectionSpacing),
              SizedBox(
                height: sizes.controlHeightMd * 8,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(sizes.card.radius),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    removeBottom: true,
                    child: Stack(
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
                        CustomScrollView(
                          key: const ValueKey('app-bar-preview'),
                          primary: false,
                          slivers: [
                            bar.toSliver(),
                            SliverList.builder(
                              itemCount: 30,
                              itemBuilder: (context, index) => HyperListTile(
                                title: Text('列表项目 ${index + 1}'),
                                subtitle: const Text('上滑观察顶栏收起和背景透出'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
