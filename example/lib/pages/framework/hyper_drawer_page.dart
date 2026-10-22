import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 通用抽屉展示页，内容和开合由页面自由组合。
class HyperDrawerPage extends StatefulWidget {
  const HyperDrawerPage({super.key});

  @override
  State<HyperDrawerPage> createState() => _HyperDrawerPageState();
}

class _HyperDrawerPageState extends State<HyperDrawerPage> {
  bool _customGeometry = false;
  static final _exampleStyle = HyperDrawerStyle(
    margin: EdgeInsets.fromLTRB(16, 24, 12, 20),
    surfaceStyle: HyperCardStyle(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(28),
        bottomRight: Radius.circular(20),
        bottomLeft: Radius.circular(36),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => HyperScaffold(
    drawer: HyperDrawer(
      style: _customGeometry ? _exampleStyle : null,
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
    endDrawer: HyperDrawer(
      style: _customGeometry ? _exampleStyle : null,
      child: const SafeArea(
        child: Padding(padding: EdgeInsets.all(16), child: HyperText('结束侧抽屉')),
      ),
    ),
    body: Builder(
      builder: (scaffoldContext) => Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HyperText('实例 Style 覆盖：四边外边距与四角圆角（演示值）'),
              HyperSwitch(
                value: _customGeometry,
                onChanged: (value) => setState(() => _customGeometry = value),
              ),
              const HyperText('关闭时继承当前主题；开启后可分别打开两侧检查留白与四角。'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  HyperButton.tonal(
                    onPressed: () => HyperScaffold.openDrawer(scaffoldContext),
                    child: const HyperText('打开起始侧'),
                  ),
                  HyperButton.tonal(
                    onPressed: () =>
                        HyperScaffold.openEndDrawer(scaffoldContext),
                    child: const HyperText('打开结束侧'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
