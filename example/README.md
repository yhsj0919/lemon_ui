# lemon_ui example

手机默认进入完整 Demo，桌面和平板默认进入主题编辑器。桌面端运行：

```sh
flutter run -d windows
```

编辑草稿只影响中间预览；编辑器自身使用启动主题。左侧配置设备、亮暗方案、主题色、字阶与材质；右侧编辑 Button、Card、TextField、Menu 的部分主题属性。中间可以选择已有组件页面或完整 Demo。

支持命名主题库、JSON 导入导出、撤销重做和下次启动主题配置。具体范围与文件约定见 [主题编辑器说明](../docs/theme-editor.md)。

- `lib/editor/`：主题草稿模型与编辑器工作区。
- `lib/gallery/`：完整 Demo 菜单、设备画布和页面注册表。
- `lib/pages/`：各组件演示页，继续作为主题预览内容。

主题编辑器测试覆盖保存恢复和预览隔离；各组件演示与组件测试分别维护。
