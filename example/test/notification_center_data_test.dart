import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui_example/pages/feedback/notification_center_data.dart';

DemoNotificationEntry entry(Object id, {String? group, bool read = false}) =>
    DemoNotificationEntry(
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
    final snapshot = DemoNotificationSnapshot(source);
    expect(snapshot.unreadCount, 3);
    expect(snapshot.groups.map((g) => g.label), ['今天', '昨天', null]);
    expect(snapshot.groups.first.entries.map((e) => e.id), [1, 3]);
    final ungrouped = DemoNotificationSnapshot(source, grouped: false);
    expect(ungrouped.groups.single.entries.map((e) => e.id), [1, 2, 3, 4]);
    expect(ungrouped.unreadCount, snapshot.unreadCount);
  });
  test('快照不随调用方列表修改，拒绝重复 id，支持空列表', () {
    final source = [entry('one')];
    final snapshot = DemoNotificationSnapshot(source);
    source.clear();
    expect(snapshot.entries.length, 1);
    expect(() => snapshot.entries.clear(), throwsUnsupportedError);
    expect(() => snapshot.groups.first.entries.clear(), throwsUnsupportedError);
    expect(
      () => DemoNotificationSnapshot([entry(1), entry(1)]),
      throwsArgumentError,
    );
    expect(DemoNotificationSnapshot([]).unreadCount, 0);
    expect(DemoNotificationSnapshot([]).groups, isEmpty);
  });
  test('已读复制保持 id 内容分组与原对象状态', () {
    final original = entry('a', group: '今天');
    final read = original.copyWith(isRead: true);
    expect(read.id, original.id);
    expect(read.content, same(original.content));
    expect(read.group, original.group);
    expect(original.isRead, false);
    expect(read.isRead, true);
    expect(DemoNotificationSnapshot([read]).unreadCount, 0);
  });
}
