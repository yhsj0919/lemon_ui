# Alert 与 Banner

[返回目录](README.md)

HyperAlert 用于正文内的说明、成功结果、警告或错误提示，默认圆角和浅状态底色。
HyperBanner 用于页面或区域顶部的提示，默认直角和中性背景。两者都属于父布局，
不创建 Overlay、不计时、不管理请求或表单校验，也不强制吸顶。

## 四种状态与内容

~~~dart
Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    const HyperAlert(
      severity: HyperNoticeSeverity.success,
      content: Text('保存成功'),
    ),
    const SizedBox(height: 16),
    HyperBanner(
      severity: HyperNoticeSeverity.warning,
      title: const Text('当前处于离线状态'),
      content: const Text('本地修改会保留，连接恢复后可同步。'),
      actions: [HyperButton.text(label: const Text('重新连接'), onPressed: () {})],
    ),
  ],
)
~~~

severity 支持 info、success、warning、error，默认 info。
默认图标颜色复用 primary、success、warning、error；正文和标题使用主题文字色。
title、content、icon、actions 和 closeButton 均接受 Widget；content 必填。
showIcon: false 隐藏图标；actions 在正文下方用 Wrap 排列，宽度不足时换行。
复杂内容的内部排版、业务行为和按钮状态由使用方管理。

组件占用父级提供的宽度，需要有限水平约束；在 Row 中使用 Expanded 或明确宽度。
高度随内容增长，不缩小字体，不增加固定错误提示位置。
父布局负责外边距、区域定位和吸顶；Banner 放到正文滚动区外即可随父布局固定在顶部。

## 受控关闭与显示

~~~dart
HyperAlert(
  title: const Text('温馨提示'),
  content: const Text('关闭回调由父级处理。'),
  onClose: () {},
  visible: true,
)
~~~

onClose 非空时显示默认关闭按钮；回调只通知使用方，不自行隐藏。
父级保留组件并把 visible 改为 false 可播放收起高度和淡出动画，
直接从 children 删除组件则由父布局负责移除动画。
closeButton 可替换整个关闭控件，其行为由该控件负责。
隐藏时屏蔽点击、焦点与语义，内部子树仍保留状态；外部留白仍由父级负责。
liveRegion 默认 true，可关闭播报；semanticLabel 提供额外语义说明。

## 独立主题与实例配置

~~~dart
HyperAlertTheme(
  data: const HyperAlertThemeData(
    style: HyperNoticeStyle(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      padding: EdgeInsets.all(12),
    ),
    warning: HyperNoticeStyle(iconColor: Colors.orange),
  ),
  child: const HyperAlert(
    severity: HyperNoticeSeverity.warning,
    title: Text('空间不足'),
    content: Text('请清理部分文件后重试。'),
    style: HyperNoticeStyle(titleStyle: TextStyle(fontWeight: FontWeight.bold)),
  ),
)
~~~

全局配置分别为 HyperThemeData.alertTheme / bannerTheme；
局部使用 HyperAlertTheme / HyperBannerTheme，互不继承对方主题。
两者共用 HyperNoticeStyle 字段结构，但各自存储主题和四端 sizes.alert / sizes.banner。
ThemeData.style 为通用覆盖；info / success / warning / error 为相应状态覆盖。
优先级：当前端默认 → 全局与局部组件主题的通用字段 → 对应状态字段 → 实例 Style。
局部通用字段不会移除已有状态覆盖，需要覆盖状态字段时使用对应 severity 配置。
文字和按钮主题 merge 保留未修改字段；copyWith 表示替换指定字段。

Style 可配置背景、边框、阴影、圆角、内边距、标题和正文字体、状态图标、
关闭图标及按钮尺寸、关闭说明、间距、操作排列和动作按钮主题。
buttonTheme 只包装 actions 内的 HyperButton，不改变正文或全局按钮主题。
关闭控件复用 HyperIconButton 的统一按压、焦点和最小交互尺寸。

## 统一高级材质与动画

~~~dart
HyperMaterialTheme(
  data: const HyperMaterialThemeData(
    quality: HyperMaterialQuality.advanced,
    material: HyperSurfaceMaterial.frostedGlass(
      background: HyperFill.color(Color(0xB3FFFFFF)),
      fallback: HyperSurfaceMaterial.solid(background: HyperFill.color(Colors.white)),
    ),
  ),
  child: const HyperBanner(
    title: Text('统一玻璃材质'),
    content: Text('材质配方、质量和透明度策略都从统一主题继承。'),
  ),
)
~~~

高级材质统一由 HyperMaterialTheme 管理配方、质量和透明度降级；组件默认继承。
实例 material、materialQuality、reduceTransparency 仅作显式局部覆盖。
材质存在时绘制其背景，不额外叠加 Style.background 的不透明底层。

默认显隐、布局和颜色过渡取 Motion.standard，遵守 disableAnimations。
Style.duration / curve 可覆盖；transitionBuilder 可替换整个显隐效果，value 为 0 至 1 的显示进度。
自定义过渡仍使用减少动画处理后的进度，需自行处理越界曲线和额外动画。

Demo：反馈与状态 → HyperAlert / HyperBanner。
源码：[Alert](../../lib/src/components/notice/hyper_alert.dart)、
[Banner](../../lib/src/components/notice/hyper_banner.dart)、
[样式](../../lib/src/components/notice/hyper_notice_style.dart)、
[Demo](../../example/lib/pages/feedback/hyper_notice_page.dart)。
验证范围为静态分析、纯主题与尺寸数据测试，尚未做设备或 Widget 运行验证。
