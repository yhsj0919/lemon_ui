# lemon_ui

A Flutter UI package under active redesign.

## Documentation

- [架构原则](docs/architecture.md)
- [编码规则](docs/coding-guidelines.md)
- [全量控件目录](docs/component-catalog.md)
- [前期实现计划](docs/initial-implementation-plan.md)

## Android 高刷新率

部分 Android 厂商系统会把没有声明应用类别的 Flutter 应用误判为游戏，并通过系统电源策略把应用限制在 60Hz 或 90Hz。此时即使屏幕已经设置为 120Hz，应用内请求高刷新率也可能无效。

非游戏类应用应在 `android/app/src/main/AndroidManifest.xml` 的 `<application>` 节点显式声明实际类别。例如工具或生产力应用：

```xml
<application
    android:label="My App"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher"
    android:appCategory="productivity">
```

可用类别包括 `productivity`、`image`、`audio`、`video`、`social`、`news` 和 `maps` 等，应按照应用的实际用途选择，不要为所有应用固定使用 `productivity`。

如果旧版本已经被 HyperOS 加入游戏加速器，还需要先从游戏加速器中移除该应用。建议卸载旧版本后重新安装，让系统根据新的 Manifest 重新识别应用类别。

该配置只负责纠正应用分类，不会强制锁定刷新率，系统仍可根据省电模式、温度和页面内容动态选择刷新率。相关问题可参考 [Flutter #192600](https://github.com/flutter/flutter/issues/192600)。
