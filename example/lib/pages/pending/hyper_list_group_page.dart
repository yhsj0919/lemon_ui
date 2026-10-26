import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

class HyperListGroupPage extends StatelessWidget {
  const HyperListGroupPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    children: [
      const HyperText('列表组 · 未确认', variant: HyperTextVariant.pageTitle),
      const HyperText('默认继承卡片和标题主题；内容无左右及底部内边距。'),
      const SizedBox(height: 24),
      HyperListGroup(
        children: [
          HyperListTile(title: const Text('无标题列表 · 账号信息'), onTap: () {}),
          HyperListTile(title: const Text('通知设置'), onTap: () {}),
          HyperListTile(
            title: const Text('版本'),
            trailing: const Text('1.0.0'),
            onTap: () {},
          ),
        ],
      ),
      const SizedBox(height: 24),
      for (final position in HyperCardTitlePosition.values) ...[
        HyperListGroup(
          titlePosition: position,
          title: Text(
            position == HyperCardTitlePosition.inside ? '标题在内' : '标题在外',
          ),
          action: HyperIconButton.ghost(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
          children: [
            HyperListTile(
              title: const Text('账号信息'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            HyperListTile(
              title: const Text('通知设置'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            HyperListTile(
              title: const Text('版本'),
              trailing: const Text('1.0.0'),
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    ],
  );
}
