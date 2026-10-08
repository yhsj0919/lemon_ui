import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

HyperNotificationEntry entry(Object id, {String? group, bool read = false}) =>
    HyperNotificationEntry(
      id: id,
      group: group,
      content: const Text('内容'),
      isRead: read,
    );

void main() {
  test('分组按首次出现排序，组内顺序不变，未读不依赖分组', () {
    final source = [
      entry(1, group: '今天'),
      entry(2, group: '昨天', read: true),
      entry(3, group: '今天'),
      entry(4),
    ];
    final snapshot = HyperNotificationSnapshot(source);
    expect(snapshot.unreadCount, 3);
    expect(snapshot.groups.map((g) => g.label), ['今天', '昨天', null]);
    expect(snapshot.groups.first.entries.map((e) => e.id), [1, 3]);
    final ungrouped = HyperNotificationSnapshot(source, grouped: false);
    expect(ungrouped.groups.single.entries.map((e) => e.id), [1, 2, 3, 4]);
    expect(ungrouped.unreadCount, snapshot.unreadCount);
  });
  test('快照不随调用方列表修改，拒绝重复 id，支持空列表', () {
    final source = [entry('one')];
    final snapshot = HyperNotificationSnapshot(source);
    source.clear();
    expect(snapshot.entries.length, 1);
    expect(() => snapshot.entries.clear(), throwsUnsupportedError);
    expect(() => snapshot.groups.first.entries.clear(), throwsUnsupportedError);
    expect(
      () => HyperNotificationSnapshot([entry(1), entry(1)]),
      throwsArgumentError,
    );
    expect(HyperNotificationSnapshot([]).unreadCount, 0);
    expect(HyperNotificationSnapshot([]).groups, isEmpty);
  });
  test('已读复制保持 id 内容分组与原对象状态', () {
    final original = entry('a', group: '今天');
    final read = original.copyWith(isRead: true);
    expect(read.id, original.id);
    expect(read.content, same(original.content));
    expect(read.group, original.group);
    expect(original.isRead, false);
    expect(read.isRead, true);
    expect(HyperNotificationSnapshot([read]).unreadCount, 0);
  });
  test('中心主题字段合并保留嵌套卡片和文字规格', () {
    const base = HyperNotificationCenterThemeData(
      style: HyperNotificationCenterStyle(
        titleStyle: TextStyle(fontSize: 18),
        notificationTheme: HyperNotificationThemeData(
          unread: HyperNotificationStyle(iconSize: 20),
        ),
      ),
    );
    final merged = base.merge(
      const HyperNotificationCenterThemeData(
        style: HyperNotificationCenterStyle(
          titleStyle: TextStyle(color: Colors.blue),
          notificationTheme: HyperNotificationThemeData(
            unread: HyperNotificationStyle(unreadColor: Colors.orange),
          ),
        ),
      ),
    );
    expect(merged.style.titleStyle!.fontSize, 18);
    expect(merged.style.titleStyle!.color, Colors.blue);
    expect(merged.style.notificationTheme!.unread!.iconSize, 20);
    expect(merged.style.notificationTheme!.unread!.unreadColor, Colors.orange);
    expect(
      merged.style
          .merge(const HyperNotificationCenterStyle(spacing: 19))
          .spacing,
      19,
    );
  });
  test('样式动画文字与尺寸可复制插值和值相等', () {
    const base = HyperNotificationCenterStyle(
      padding: EdgeInsets.all(8),
      spacing: 8,
      groupSpacing: 12,
      markReadLabel: '阅读',
      duration: Duration(milliseconds: 100),
    );
    final updated = base.copyWith(
      spacing: 16,
      duration: const Duration(milliseconds: 200),
      markReadLabel: '已读',
    );
    final middle = HyperNotificationCenterStyle.lerp(base, updated, .5);
    expect(middle.spacing, 12);
    expect(middle.duration, const Duration(milliseconds: 150));
    expect(middle.markReadLabel, '已读');
    expect(base.copyWith(), base);
    expect(base.copyWith().hashCode, base.hashCode);
    expect(
      HyperNotificationCenterThemeData.lerp(
        const HyperNotificationCenterThemeData(style: base),
        HyperNotificationCenterThemeData(style: updated),
        .5,
      ).style,
      middle,
    );
  });
  test('四端尺寸与全局主题独立于通知卡片', () {
    final theme = HyperThemeData.light();
    for (final sizes in [
      theme.sizes.phone,
      theme.sizes.tablet,
      theme.sizes.desktop,
      theme.sizes.watch,
    ]) {
      final base = sizes.notificationCenter;
      expect(base.copyWith(), base);
      expect(base.copyWith().hashCode, base.hashCode);
      final other = base.copyWith(spacing: base.spacing + 4);
      expect(
        HyperNotificationCenterSize.lerp(base, other, .5).spacing,
        base.spacing + 2,
      );
      expect(
        sizes.copyWith(notificationCenter: other).notification,
        sizes.notification,
      );
    }
    const center = HyperNotificationCenterThemeData(
      style: HyperNotificationCenterStyle(title: '消息'),
    );
    final updated = theme.copyWith(notificationCenterTheme: center);
    expect(updated.notificationCenterTheme, center);
    expect(updated.notificationTheme, theme.notificationTheme);
    expect(theme.lerp(updated, 1), updated);
  });
}
