import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 通用抽屉展示页，内容和开合由页面自由组合。
class HyperDrawerPage extends StatelessWidget {
  const HyperDrawerPage({super.key});

  @override
  Widget build(BuildContext context) => HyperScaffold(
    drawer: HyperDrawer(
      header: const SafeArea(
        bottom: false,
        child: Padding(padding: EdgeInsets.all(16), child: HyperText('固定头部')),
      ),
      footer: const SafeArea(
        top: false,
        child: Padding(padding: EdgeInsets.all(16), child: HyperText('固定尾部')),
      ),
      child: ListView(
        children: [
          HyperListTile(
            title: const HyperText('任意内容'),
            subtitle: const HyperText('中间内容可以独立滚动'),
            onTap: () => Navigator.of(context).pop(),
          ),
          for (var index = 1; index <= 12; index++)
            HyperListTile(title: HyperText('内容 $index')),
        ],
      ),
    ),
    endDrawer: const HyperDrawer(
      child: SafeArea(
        child: Padding(padding: EdgeInsets.all(16), child: HyperText('结束侧抽屉')),
      ),
    ),
    body: Builder(
      builder: (scaffoldContext) => Center(
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            HyperButton.tonal(
              onPressed: () => HyperScaffold.openDrawer(scaffoldContext),
              child: const HyperText('打开起始侧'),
            ),
            HyperButton.tonal(
              onPressed: () => HyperScaffold.openEndDrawer(scaffoldContext),
              child: const HyperText('打开结束侧'),
            ),
          ],
        ),
      ),
    ),
  );
}
