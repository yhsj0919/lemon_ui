# 通知中心业务组合示例

通知中心属于业务层。组件库只提供单条通知 `HyperNotification`，不再公开 `HyperNotificationCenter`、通知列表数据模型、通知中心专属主题或设备尺寸。

示例位于 `example/lib/pages/feedback/hyper_notification_center_page.dart`，画廊页面 id 仍为 `hyper-notification-center`，现归入“业务组合示例”。

页面自行管理通知数据、已读状态、日期分组、未读统计、批量已读、删除和清空；界面由 `HyperNotification`、按钮、文字、列表和 `HyperResult.empty` 组合。每条通知负责自己的表面，列表外围不额外包装整块卡片。

编辑器在该页面编辑的是单条通知主题。旧编辑器文件中的通知中心覆盖仍接受导入，但已不再应用；页面布局由业务组合负责。

应用可直接参考该页面组织自己的列表与状态仓库。通知卡片的公开接口见 [Notification](notification.md)。
