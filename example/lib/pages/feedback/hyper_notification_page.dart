import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperNotificationPage extends StatefulWidget {
  const HyperNotificationPage({super.key});
  @override
  State<HyperNotificationPage> createState() => _HyperNotificationPageState();
}

class _HyperNotificationPageState extends State<HyperNotificationPage> {
  bool _read = false;
  bool _visible = true;
  bool _advanced = false;
  String _result = '点击卡片标记已读，操作和关闭分别处理';
  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    Widget section(String title, List<Widget> children) => DemoSection(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final child in children) ...[
            child,
            SizedBox(height: sizes.notification.spacing),
          ],
        ],
      ),
    );
    return ListView(
      padding: EdgeInsets.all(sizes.pageHorizontalPadding),
      children: [
        const HyperText('Notification', variant: HyperTextVariant.pageTitle),
        SizedBox(height: sizes.sectionSpacing),
        section('受控状态与独立操作', [
          HyperNotification(
            title: const Text('文件同步完成'),
            time: const Text('今天 10:24'),
            content: const Text('已同步 12 个文件，点击卡片可标记已读。'),
            isRead: _read,
            visible: _visible,
            onTap: () => setState(() {
              _read = true;
              _result = '整卡点击：已读';
            }),
            onClose: () => setState(() {
              _visible = false;
              _result = '关闭：隐藏卡片';
            }),
            actions: [
              HyperButton.text(
                label: const Text('查看文件'),
                onPressed: () => setState(() => _result = '操作按钮：查看文件'),
              ),
            ],
          ),
          Text(_result),
          HyperButton.text(
            label: const Text('恢复未读通知'),
            onPressed: () => setState(() {
              _read = false;
              _visible = true;
            }),
          ),
        ]),
        section('内容与禁用', [
          const HyperNotification(
            title: Text('已读通知'),
            content: Text('已读时隐藏圆点，标题使用次级文字颜色。'),
            isRead: true,
          ),
          const HyperNotification(
            title: Text('一个较长的通知标题会根据可用宽度自然换行'),
            time: Text('昨天 18:30 · 工作空间'),
            icon: Icon(Icons.cloud_done_outlined),
            content: Text('正文也可以包含多行内容。时间由调用方格式化，卡片不持有日期或通知队列。'),
          ),
          const HyperNotification(
            content: Text('不带图标和未读标记的简洁通知'),
            showIcon: false,
            showUnreadIndicator: false,
          ),
          HyperNotification(
            title: const Text('禁用通知'),
            content: const Text('整卡及内部操作均不可交互。'),
            enabled: false,
            onTap: () {},
            onClose: () {},
          ),
        ]),
        section('局部主题与统一材质', [
          HyperNotificationTheme(
            data: const HyperNotificationThemeData(
              style: HyperNotificationStyle(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              unread: HyperNotificationStyle(
                titleStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            child: const HyperNotification(
              title: Text('局部主题'),
              content: Text('局部只覆盖圆角和未读标题字重。'),
            ),
          ),
          HyperMaterialTheme(
            data: HyperMaterialThemeData(
              material: const HyperSurfaceMaterial.frostedGlass(),
              quality: _advanced
                  ? HyperMaterialQuality.advanced
                  : HyperMaterialQuality.standard,
            ),
            child: const HyperNotification(
              title: Text('继承材质'),
              content: Text('配方、质量和降级均来自统一材质主题。'),
            ),
          ),
          HyperButton.text(
            label: Text(_advanced ? '切换标准材质' : '切换高级材质'),
            onPressed: () => setState(() => _advanced = !_advanced),
          ),
        ]),
      ],
    );
  }
}
