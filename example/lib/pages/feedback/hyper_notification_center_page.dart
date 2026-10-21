import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'notification_center_data.dart';

class HyperNotificationCenterPage extends StatefulWidget {
  const HyperNotificationCenterPage({super.key});
  @override
  State<HyperNotificationCenterPage> createState() => _PageState();
}

class _PageState extends State<HyperNotificationCenterPage> {
  List<DemoNotificationEntry> _entries = [];
  bool _grouped = true;
  bool _custom = false;
  bool _material = false;
  @override
  void initState() {
    super.initState();
    _restore();
  }

  void _restore() {
    _entries = [
      const DemoNotificationEntry(
        id: 'sync',
        group: '今天',
        title: Text('同步完成'),
        time: Text('10:24'),
        content: Text('已同步 12 个文件。'),
        icon: Icon(Icons.cloud_done_outlined),
      ),
      const DemoNotificationEntry(
        id: 'invite',
        group: '今天',
        title: Text('协作邀请'),
        time: Text('09:15'),
        content: Text('有人邀请你加入工作空间。'),
      ),
      const DemoNotificationEntry(
        id: 'old',
        group: '昨天',
        title: Text('更新已安装'),
        time: Text('18:30'),
        content: Text('应用已经更新至最新版本。'),
        isRead: true,
      ),
      const DemoNotificationEntry(
        id: 'disabled',
        group: '昨天',
        title: Text('已归档通知'),
        content: Text('此条目已禁用。'),
        enabled: false,
        isRead: true,
      ),
    ];
  }

  void _read(DemoNotificationEntry entry) => setState(
    () => _entries = [
      for (final item in _entries)
        if (item.id == entry.id) item.copyWith(isRead: true) else item,
    ],
  );
  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    final unread = DemoNotificationSnapshot(_entries).unreadCount;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(sizes.pageHorizontalPadding),
          child: Wrap(
            spacing: sizes.notification.spacing,
            runSpacing: sizes.notification.spacing,
            children: [
              HyperBadge.number(count: unread, showZero: true),
              HyperButton.text(
                label: const Text('恢复示例'),
                onPressed: () => setState(_restore),
              ),
              HyperButton.text(
                label: Text(_grouped ? '关闭分组' : '开启分组'),
                onPressed: () => setState(() => _grouped = !_grouped),
              ),
              HyperButton.text(
                label: Text(_custom ? '默认卡片' : '自定义条目'),
                onPressed: () => setState(() => _custom = !_custom),
              ),
              HyperButton.text(
                label: Text(_material ? '标准表面' : '统一磨砂材质'),
                onPressed: () => setState(() => _material = !_material),
              ),
            ],
          ),
        ),
        Expanded(child: _center(context)),
      ],
    );
  }

  // Business composition: grouping, counting and batch operations live here.
  Widget _center(BuildContext context) {
    final theme = HyperTheme.of(context), sizes = HyperTheme.sizesOf(context);
    final snapshot = DemoNotificationSnapshot(_entries, grouped: _grouped);
    final rows = <Object>[
      for (final group in snapshot.groups) ...[
        if (group.label != null) group,
        ...group.entries,
      ],
    ];
    void markAll() => setState(
      () => _entries = [for (final e in _entries) e.copyWith(isRead: true)],
    );
    Widget notification(DemoNotificationEntry entry) => HyperNotification(
      key: ValueKey(entry.id),
      title: entry.title,
      content: entry.content,
      time: entry.time,
      icon: _custom ? const Icon(Icons.mail_outline) : entry.icon,
      isRead: entry.isRead,
      enabled: entry.enabled,
      onTap: () => _read(entry),
      onClose: () => setState(
        () => _entries = _entries.where((e) => e.id != entry.id).toList(),
      ),
      actions: [
        ...entry.actions,
        if (!entry.isRead)
          HyperButton.text(
            label: const Text('标记已读'),
            onPressed: entry.enabled ? () => _read(entry) : null,
          ),
      ],
      style: entry.style,
    );
    return HyperMaterialTheme(
      data: HyperMaterialThemeData(
        material: _material ? const HyperSurfaceMaterial.frostedGlass() : null,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          sizes.pageHorizontalPadding,
          0,
          sizes.pageHorizontalPadding,
          sizes.pageHorizontalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: sizes.notification.spacing,
              runSpacing: sizes.notification.spacing,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('通知', style: theme.textTheme.titleMedium),
                Text(
                  '${snapshot.unreadCount} 未读',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colors.textSecondary,
                  ),
                ),
                HyperButton.text(
                  label: const Text('全部已读'),
                  onPressed: snapshot.unreadCount > 0 ? markAll : null,
                ),
                HyperButton.text(
                  label: const Text('清空'),
                  onPressed: _entries.isEmpty
                      ? null
                      : () => setState(() => _entries = []),
                ),
              ],
            ),
            SizedBox(height: sizes.compactSectionSpacing),
            Expanded(
              child: rows.isEmpty
                  ? const HyperResult.empty(
                      title: '暂无通知',
                      description: '新通知会显示在这里',
                      style: HyperResultStyle(icon: Icons.notifications_none),
                    )
                  : ListView.builder(
                      key: const ValueKey('notifications'),
                      padding: EdgeInsets.zero,
                      itemCount: rows.length,
                      itemBuilder: (context, index) {
                        final row = rows[index];
                        if (row is DemoNotificationGroup) {
                          return Padding(
                            padding: EdgeInsets.only(
                              top: index == 0 ? 0 : sizes.compactSectionSpacing,
                              bottom: sizes.notification.spacing,
                            ),
                            child: Text(
                              row.label!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colors.textSecondary,
                              ),
                            ),
                          );
                        }
                        final entry = row as DemoNotificationEntry;
                        return Padding(
                          key: ValueKey(entry.id),
                          padding: EdgeInsets.only(
                            bottom: sizes.notification.spacing,
                          ),
                          child: notification(entry),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
