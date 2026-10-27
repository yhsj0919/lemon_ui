# 快速开始

[返回目录](README.md)

## 1. 添加依赖

在应用 pubspec.yaml 中添加本地路径（按应用实际位置修改），然后运行 flutter pub get：

    dependencies:
      flutter:
        sdk: flutter
      lemon_ui:
        path: ../lemon_ui

导入统一入口，无需逐个导入内部文件。

默认图标库为 `lucide_icons_flutter`，统一入口导出其完整常规图标类的别名
`HyperIcons`，例如 `const Icon(HyperIcons.search)`。图标名称沿用 Lucide 的
camelCase 命名；组件主题和实例仍可传入其他 `IconData`。

当前使用 Lucide 4.x。由于 `trina_grid 2.3.0` 的间接依赖仍限制 Lucide 3.x，
使用本包的应用暂需在自己的 pubspec.yaml 中添加以下覆盖（依赖包的覆盖不会传递）：

```yaml
dependency_overrides:
  lucide_icons_flutter: ^4.0.1
```

上游允许 Lucide 4.x 后可移除此覆盖。

## 2. 建立主题和设备作用域

自定义字体可直接写入 Hyper 主题，所有字阶及生成的 Material textTheme 同步使用：

```dart
final theme = HyperThemeData.light(
  fontFamily: 'SourceHanSansSC',
  fontFamilyFallback: const ['Microsoft YaHei', 'sans-serif'],
);
final updated = theme.copyWith(fontFamily: 'AnotherBrandFont');
```

`dark`、`fromSeed`、`fromMaterial` 同样支持这两个参数。
工厂未指定时保留系统默认字体；fromMaterial 未指定时保留传入主题字体。
copyWith 中 null 表示保留，空 fallback 列表显式清空回退列表；同时传入 textTheme
时，字体参数最后应用到其全部字阶，不改变字号、字重和行高。
自定义字体需由应用在 pubspec.yaml 的 flutter/fonts 中声明，fontFamily 与 family
名称一致；主题配置本身不包含或下载字体文件。

下面是可直接放入 main.dart 的最小应用。Detector 放在 MaterialApp.builder 中，
可获取窗口约束；主题放在其内部，使用稳定设备类别解析尺寸与字体。

~~~dart
import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    builder: (context, child) => HyperDeviceDetector(
      builder: (context, deviceType, child) => HyperTheme(
        data: HyperThemeData.light(),
        child: child!,
      ),
      child: child,
    ),
    home: const SettingsPage(),
  );
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _enabled = true;
  double _level = .4;
  Set<String> _view = {'list'};

  @override
  Widget build(BuildContext context) => HyperScaffold(
    appBar: const HyperAppBar(title: Text('设置')),
    body: ListView(
      padding: EdgeInsets.all(
        HyperTheme.sizesOf(context).pageHorizontalPadding,
      ),
      children: [
        HyperSwitchListTile(
          title: const Text('启用通知'),
          value: _enabled,
          onChanged: (value) => setState(() => _enabled = value),
        ),
        HyperSlider(
          value: _level,
          onChanged: (value) => setState(() => _level = value),
        ),
        HyperSegmentedButton<String>(
          segments: const [
            HyperSegment(value: 'list', label: '列表'),
            HyperSegment(value: 'grid', label: '网格'),
          ],
          selected: _view,
          onSelectionChanged: (value) => setState(() => _view = value),
        ),
      ],
    ),
  );
}
~~~

切换暗色使用 HyperThemeData.dark()，主题本身不是持久化设置存储。
预览指定设备时，在 HyperDeviceDetector 设置 deviceType: HyperDeviceType.phone；
不要给 HyperTheme 传 deviceType，它没有这个参数。

## 3. 全局、局部和实例样式

下面使用 Tag 展示三层配置；其他组件使用各自强类型 ThemeData / Style。

~~~dart
HyperTheme(
  data: HyperTheme.of(context).copyWith(
    tagTheme: const HyperTagThemeData(
      style: HyperTagStyle(radius: 8),
    ),
  ),
  child: const HyperTagTheme(
    data: HyperTagThemeData(
      style: HyperTagStyle(backgroundColor: Color(0xFFE8F3FF)),
    ),
    child: HyperTag(
      label: '文档',
      style: HyperTagStyle(foregroundColor: Color(0xFF2469C8)),
    ),
  ),
)
~~~

实例只覆盖文字颜色，仍继承局部背景和全局圆角。
不要用字符串 Map 或在业务控件中按设备 switch 重复尺寸。

## 4. 修改某端尺寸

在统一尺寸主题上 copyWith；未修改的三端保留原值。

~~~dart
HyperTheme(
  data: HyperTheme.of(context).copyWith(
    sizes: HyperTheme.of(context).sizes.copyWith(
      desktop: HyperTheme.of(context).sizes.desktop.copyWith(
        divider: HyperTheme.of(context).sizes.desktop.divider.copyWith(
          contentGap: 10,
        ),
      ),
    ),
  ),
  child: const HyperDivider(child: Text('内容')),
)
~~~

更多体系说明见 [主题架构](../theme-architecture.md)、
[尺寸规范](../size-specification.md) 和 [视觉来源基准](../hyperos-design-baseline.md)。
