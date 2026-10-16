import 'package:flutter/widgets.dart';

import 'package:lemon_ui/lemon_ui.dart';

/// 稳定 id 必须在同一列表内唯一；时间与分组文案由调用方提供。
@immutable
final class DemoNotificationEntry {
  const DemoNotificationEntry({
    required this.id,
    required this.content,
    this.title,
    this.time,
    this.icon,
    this.group,
    this.isRead = false,
    this.enabled = true,
    this.actions = const [],
    this.style,
  });
  final Object id;
  final Widget content;
  final Widget? title, time, icon;
  final String? group;
  final bool isRead, enabled;
  final List<Widget> actions;
  final HyperNotificationStyle? style;
  DemoNotificationEntry copyWith({
    Widget? content,
    Widget? title,
    Widget? time,
    Widget? icon,
    bool? isRead,
    bool? enabled,
    List<Widget>? actions,
    HyperNotificationStyle? style,
  }) => DemoNotificationEntry(
    id: id,
    content: content ?? this.content,
    title: title ?? this.title,
    time: time ?? this.time,
    icon: icon ?? this.icon,
    group: group,
    isRead: isRead ?? this.isRead,
    enabled: enabled ?? this.enabled,
    actions: actions ?? this.actions,
    style: style ?? this.style,
  );
}

@immutable
final class DemoNotificationGroup {
  DemoNotificationGroup({
    required this.label,
    required Iterable<DemoNotificationEntry> entries,
  }) : entries = List.unmodifiable(entries);
  final String? label;
  final List<DemoNotificationEntry> entries;
}

/// 固定输入快照；拒绝重复 id，避免条目状态和删除动作指向错误对象。
final class DemoNotificationSnapshot {
  DemoNotificationSnapshot(
    Iterable<DemoNotificationEntry> source, {
    bool grouped = true,
  }) : entries = List.unmodifiable(source) {
    final ids = <Object>{};
    final buckets = <String?, List<DemoNotificationEntry>>{};
    for (final entry in entries) {
      if (!ids.add(entry.id)) {
        throw ArgumentError.value(entry.id, 'id', '通知 id 必须唯一');
      }
      buckets.putIfAbsent(grouped ? entry.group : null, () => []).add(entry);
    }
    groups = List.unmodifiable(
      buckets.entries.map(
        (e) => DemoNotificationGroup(label: e.key, entries: e.value),
      ),
    );
  }
  final List<DemoNotificationEntry> entries;
  late final List<DemoNotificationGroup> groups;
  int get unreadCount => entries.where((entry) => !entry.isRead).length;
}
