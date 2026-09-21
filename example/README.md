# lemon_ui example

Lemon UI 的组件演示应用。

```sh
flutter run
```

## 目录结构

```text
lib/
├─ main.dart                     # 应用入口
├─ gallery/
│  ├─ gallery_item.dart          # 演示页与分类模型
│  ├─ gallery_registry.dart      # 所有演示页的统一注册表
│  └─ gallery_shell.dart         # 响应式菜单和页面承载壳
└─ pages/
   └─ foundation/
      └─ hyper_fill_page.dart    # 独立组件演示页
```

前期菜单使用 Flutter 原生 `ListView` 和 `ListTile`。窄屏使用 Drawer，宽屏显示固定侧栏。后期实现正式的 Hyper 菜单和侧栏组件后，只替换 `gallery_shell.dart`，不修改注册表与各演示页。

每实现一步，都必须新增或更新独立演示页和对应 Widget 测试。