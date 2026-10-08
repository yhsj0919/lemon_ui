# 通知卡片

`HyperNotification` 提供图标、标题、正文、时间、未读标记、操作区和关闭入口。卡片需要有限宽度，高度随内容变化；时间由调用方格式化并传入 Widget。

~~~dart
HyperNotification(
  title: const Text('同步完成'),
  time: const Text('今天 10:24'),
  content: const Text('已同步 12 个文件。'),
  onTap: () {},
  onClose: () {},
  actions: [HyperButton.text(label: const Text('查看'), onPressed: () {})],
)
~~~

## 状态由页面控制

`isRead` 控制已读外观，`visible` 控制显示。`onTap`、`onClose` 只通知调用方，不自动修改状态。已读时圆点隐藏、标题使用次级文字颜色。内部按钮保留独立回调；Demo 分别记录卡片、操作按钮和关闭入口的结果。

`enabled: false` 禁用整卡及内部交互。隐藏时退出指针、焦点和语义树。整卡点击复用 HyperPressable 的键盘交互。默认不增加悬停阴影，悬停、焦点与按压使用轻微状态色层。

~~~dart
const HyperNotification(
  title: Text('已读通知'),
  content: Text('通知内容'),
  isRead: true,
  showIcon: false,
)
~~~

`icon`、`unreadIndicator`、`closeButton` 和 `actions` 接受自定义组件。`showIcon`、`showUnreadIndicator` 可隐藏对应区域。操作区自动换行；时间位于标题下方。通知列表、历史、过期和队列由上层负责。

## 主题与材质

全局 `HyperThemeData.notificationTheme`、局部 `HyperNotificationTheme` 和实例 `style` 依次覆盖。组件默认值之后，主题按通用、已读/未读、悬停、焦点、按压、禁用顺序合并，实例字段最后覆盖。

~~~dart
HyperNotificationTheme(
  data: const HyperNotificationThemeData(
    style: HyperNotificationStyle(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      unreadColor: Colors.orange,
      unreadSize: 6,
    ),
    unread: HyperNotificationStyle(titleStyle: TextStyle(fontWeight: FontWeight.bold)),
  ),
  child: const HyperNotification(title: Text('未读通知'), content: Text('局部主题覆盖')),
)
~~~

背景、边框、圆角、阴影、文字、图标、间距、未读标记、状态色层、操作按钮主题及过渡均可配置。`transitionBuilder` 可替换显隐过渡；默认时长和曲线来自 Motion，遵守系统减少动画设置。

~~~dart
const HyperMaterialTheme(
  data: HyperMaterialThemeData(
    material: HyperSurfaceMaterial.frostedGlass(),
    quality: HyperMaterialQuality.advanced,
  ),
  child: HyperNotification(title: Text('材质通知'), content: Text('继承统一材质配置')),
)
~~~

材质默认配方、质量和透明度降级来自统一材质主题；实例 Style 可显式覆盖。四端尺寸集中在 `HyperSizeScheme.notification`。

默认视觉为同端既有语义规格的 D 级推导，未获得本组件的直接官方尺寸证据。当前验证为静态分析与纯主题数据测试，未运行设备、Widget 或截图对照。

- [Demo](../../example/lib/pages/feedback/hyper_notification_page.dart)
- [尺寸来源](../size-specification.md)
- [主题架构](../theme-architecture.md)
