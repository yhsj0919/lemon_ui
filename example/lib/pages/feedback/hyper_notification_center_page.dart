import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

class HyperNotificationCenterPage extends StatefulWidget {
  const HyperNotificationCenterPage({super.key});
  @override
  State<HyperNotificationCenterPage> createState() => _PageState();
}

class _PageState extends State<HyperNotificationCenterPage> {
  List<HyperNotificationEntry> _entries = [];
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
      const HyperNotificationEntry(
        id: 'sync',
        group: '今天',
        title: Text('同步完成'),
        time: Text('10:24'),
        content: Text('已同步 12 个文件。'),
        icon: Icon(Icons.cloud_done_outlined),
      ),
      const HyperNotificationEntry(
        id: 'invite',
        group: '今天',
        title: Text('协作邀请'),
        time: Text('09:15'),
        content: Text('有人邀请你加入工作空间。'),
      ),
      const HyperNotificationEntry(
        id: 'old',
        group: '昨天',
        title: Text('更新已安装'),
        time: Text('18:30'),
        content: Text('应用已经更新至最新版本。'),
        isRead: true,
      ),
      const HyperNotificationEntry(
        id: 'disabled',
        group: '昨天',
        title: Text('已归档通知'),
        content: Text('此条目已禁用。'),
        enabled: false,
        isRead: true,
      ),
    ];
  }

  void _read(HyperNotificationEntry entry) => setState(
    () => _entries = [
      for (final item in _entries)
        if (item.id == entry.id) item.copyWith(isRead: true) else item,
    ],
  );
  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    final unread = HyperNotificationSnapshot(_entries).unreadCount;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(sizes.pageHorizontalPadding),
          child: Wrap(
            spacing: sizes.notificationCenter.spacing,
            runSpacing: sizes.notificationCenter.spacing,
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
        Expanded(
          child: HyperMaterialTheme(
            data: HyperMaterialThemeData(
              material: _material
                  ? const HyperSurfaceMaterial.frostedGlass()
                  : const HyperSurfaceMaterial.solid(),
            ),
            child: HyperNotificationCenter(
              entries: _entries,
              grouped: _grouped,
              onTap: _read,
              onMarkRead: _read,
              onRemove: (entry) => setState(
                () => _entries = _entries
                    .where((item) => item.id != entry.id)
                    .toList(),
              ),
              onMarkAllRead: () => setState(
                () => _entries = _entries
                    .map((item) => item.copyWith(isRead: true))
                    .toList(),
              ),
              onClear: () => setState(() => _entries = []),
              itemBuilder: !_custom
                  ? null
                  : (context, entry) => HyperNotification(
                      title: entry.title,
                      content: entry.content,
                      time: entry.time,
                      icon: const Icon(Icons.mail_outline),
                      isRead: entry.isRead,
                      enabled: entry.enabled,
                      onTap: () => _read(entry),
                      style: const HyperNotificationStyle(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
              style: const HyperNotificationCenterStyle(
                notificationTheme: HyperNotificationThemeData(
                  unread: HyperNotificationStyle(
                    titleStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
