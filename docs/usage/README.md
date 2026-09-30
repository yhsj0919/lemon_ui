# Lemon UI 使用手册

本文覆盖 [公开入口](../../lib/lemon_ui.dart) 当前已导出的组件；规划目录中的未实现控件不属于本手册。

## 从这里开始

- [快速开始、受控状态与主题配置](getting-started.md)
- [基础内容：文字、图标、头像、徽标、Tag、分隔线](content.md)
- [布局容器：页面、顶栏、卡片、抽屉、控件组](layout.md)
- [操作与选择：按钮、Chip、分段按钮、开关、单选、复选、滑块](selection.md)
- [导航与列表：Tab、面包屑、侧栏及列表行](navigation.md)
- [浮层与反馈：菜单、下拉、提示、进度、骨架与空状态](feedback.md)
- [交互与材质：锚定浮层、Pressable、越界弹性与材质表面](foundation.md)

## 示例约定

分类文档的 Dart 代码块是 **Widget 表达式**，放入 build 的返回值或 children 即可。
默认已导入以下包，涉及主题读取时使用当前 build 的 context：

    import 'package:flutter/material.dart';
    import 'package:lemon_ui/lemon_ui.dart';

示例中的空回调表示业务插槽；选择、开关、滑块示例用固定值展示 API，
实际使用必须将新值写入状态并触发重建，完整示例见快速开始。
列表/页面切换、删除、请求、路由均由应用管理，组件不替应用保存业务数据。

每页同时列出常见变体、关键配置、布局约束和对应源码/Demo。
各组件的完整字段以链接的 Style、ThemeData 和源码为准，避免手册复制整套签名后过期。

## 共通规则

- 四端默认尺寸来自 HyperThemeData.sizes；读当前规格使用 HyperTheme.sizesOf(context)。
- 设备类别由 HyperDeviceDetector 稳定解析；桌面窗口变窄不应切换手机规格。
- 配置优先级一般为内置默认 → 全局组件主题 → 局部组件主题 → 实例 Style；
  提供直接视觉参数的组件会在最后应用这些参数，具体例外见各页。
- Style 的 null 字段通常表示继承；零值、none、空阴影列表用于明确关闭效果。
- 外部留白、最大内容宽度、路由和业务状态通常由父级管理。
- 可见尺寸与点击区域可能不同；不要仅用外观高度推断触控命中区域。
- 控件遵守系统减少动画；字体由运行设备提供，库没有捆绑 MiSans。
- 示例通过 Dart 静态分析核对 API；文档整理不代表设备视觉或运行时交互验证。

## 文档维护

新增公开组件或修改接口时，同步更新对应分类页和示例，再执行：

    powershell -File tool/check_usage_docs.ps1 -DartPath dart

如果 dart 不在 PATH 中，将 DartPath 替换为 Flutter SDK 内 dart.exe 的完整路径。
该脚本检查本地链接，并将示例提取到 .dart_tool/usage_examples_check.dart 后静态分析；
不启动设备，不执行 Widget 测试，也不验证布局效果。需要交互和视觉对照时使用
[Example Gallery](../../example/lib/gallery/gallery_registry.dart) 中的对应页面。
