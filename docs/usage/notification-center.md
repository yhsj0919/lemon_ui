# 通知中心

`HyperNotificationCenter` 组合通知卡片，提供页面内列表、分组、未读数量、空状态和批量操作。数据由页面管理；不持有全局通知仓库，不创建浮层。

~~~dart
SizedBox(
  height: 480,
  child: HyperNotificationCenter(
    entries: const [
      HyperNotificationEntry(
        id: 'sync', group: '今天', title: Text('同步完成'),
        time: Text('10:24'), content: Text('已同步 12 个文件。'),
      ),
      HyperNotificationEntry(
        id: 'update', group: '昨天', title: Text('更新完成'),
        content: Text('应用已更新。'), isRead: true,
      ),
    ],
    onMarkRead: (entry) {},
    onRemove: (entry) {},
    onMarkAllRead: () {},
    onClear: () {},
  ),
)
~~~

## 状态与操作

每条 `HyperNotificationEntry` 具有稳定且唯一的 `id`。重复 id 会抛出 ArgumentError，防止重排后交互与状态关联到错误条目。内容、标题、时间、图标和操作接受 Widget；时间格式和日期分组由调用方负责。

- `onTap`：整卡点击；默认不会自动标记已读。
- `onMarkRead`：默认卡片追加“标记已读”操作，只对未读项显示。
- `onRemove`：默认卡片显示关闭入口。
- `onMarkAllRead` / `onClear`：有回调才展示对应批量按钮。没有未读或列表为空时禁用对应按钮。
- 页面收到回调后更新 entries，例如通过 `entry.copyWith(isRead: true)`；没有内部乐观更新。
- `enabled` 禁用整个中心的交互；条目 enabled 禁用该条目，包括自定义内容。

`HyperNotificationSnapshot(entries).unreadCount` 可提供给 `HyperBadge.number`。计数包含所有未读项，禁用不等于已读。

~~~dart
HyperBadge.number(
  count: HyperNotificationSnapshot(const [
    HyperNotificationEntry(id: 1, content: Text('通知')),
  ]).unreadCount,
)
~~~

## 分组和滚动约束

`grouped` 默认 true。使用 entry.group 文案分组，按组别首次出现排序，组内保留输入顺序；group 为 null 的组不绘制标题。关闭分组后完全保留输入顺序。组件不自行按日期或类别排序。

默认需要有限宽高，工具栏固定在顶部，正文使用惰性 ListView。controller 和 physics 可接入父级需求。嵌入外部滚动布局时使用 shrinkWrap: true，此时默认不自行滚动；适合少量条目，不建议用于大型通知历史。

~~~dart
HyperNotificationCenter(
  shrinkWrap: true,
  showHeader: false,
  grouped: false,
  entries: const [HyperNotificationEntry(id: 1, content: Text('嵌入式通知'))],
)
~~~

## 自定义和主题

header、empty、groupBuilder 和 itemBuilder 可替换对应区域。itemBuilder 接管条目交互，需要自行连接回调；默认的已读按钮和关闭入口不会额外插入自定义条目。

~~~dart
HyperNotificationCenterTheme(
  data: const HyperNotificationCenterThemeData(
    style: HyperNotificationCenterStyle(
      title: '消息中心',
      titleStyle: TextStyle(fontWeight: FontWeight.bold),
      notificationTheme: HyperNotificationThemeData(
        unread: HyperNotificationStyle(unreadColor: Colors.orange),
      ),
    ),
  ),
  child: const HyperNotificationCenter(shrinkWrap: true, entries: []),
)
~~~

全局 notificationCenterTheme、局部 HyperNotificationCenterTheme 和实例 style 逐字段合并。中心主题配置标题、计数文字、组标题、间距、内边距、默认操作文案、操作按钮主题、卡片子主题、空状态样式及空/非空过渡。卡片背景、边框、圆角、状态和材质继续由 notificationTheme 管理；中心不叠加额外表面。

材质继承统一 HyperMaterialTheme，中心只组合已有卡片。已读、卡片内容和空/非空过渡复用现有 Motion；系统减少动画设置生效。当前普通列表插入、删除和重排遵循 ListView 行为，不提供独立列表编排动画。

默认尺寸为同端既有 Notification 与页面间距的 D 级推导；当前未运行设备、Widget 或截图对照验证。

- [Demo](../../example/lib/pages/feedback/hyper_notification_center_page.dart)
- [通知卡片](notification.md)
- [尺寸来源](../size-specification.md)
