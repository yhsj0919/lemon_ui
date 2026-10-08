# 加载遮罩

[返回目录](README.md)

HyperLoadingOverlay 覆盖 child 的布局区域，不创建全局浮层、不执行任务。
loading 由业务持有；包裹页面正文即可用于整页加载，顶栏或系统返回仍由页面控制。

## 区域与整页加载

~~~dart
HyperLoadingOverlay(
  loading: true,
  message: const Text('正在读取数据…'),
  onCancel: () {},
  child: const SizedBox(height: 240, child: Center(child: Text('原有内容'))),
)
~~~

~~~dart
Scaffold(
  appBar: AppBar(title: const Text('页面加载')),
  body: const HyperLoadingOverlay(
    loading: true,
    message: Text('正在加载页面'),
    child: SizedBox.expand(child: Center(child: Text('页面正文'))),
  ),
)
~~~

遮罩不改变 child 的尺寸。child 必须能在父约束下确定宽高；在 Row/Column 中使用
Expanded、明确尺寸或原本有自然尺寸的内容。无限高度的列表仍需要父级给出滚动区域高度。
区域遮罩只管理 child 的点击、焦点和语义，不控制父级滚动、导航返回或区域外的控件。

## 点击拦截与取消

blockInteraction 默认 true，从 loading 为 true 时立即拦截 child，包括等待显示的时间。
最短显示期间及淡出结束前保持拦截，避免视觉上仍有遮罩却能误操作底层。
默认同时排除底层焦点和语义；blockInteraction: false 可让底层继续操作。
遮罩不支持点击背景取消，onCancel 非空时显示取消按钮。
取消仅调用业务回调，不自行修改 loading，也不取消网络请求。
业务应取消任务并更新 loading；任务已结束但视觉仍在保留期间，取消按钮禁用。
默认取消文字取 MaterialLocalizations，cancelLabel 可替换任意 Widget。
semanticLabel 可设置加载语义说明，默认“正在加载”。

## 延迟显示与最短显示时间

~~~dart
HyperLoadingOverlay(
  loading: true,
  style: const HyperLoadingOverlayStyle(
    showDelay: Duration(milliseconds: 150),
    minimumVisibleDuration: Duration(milliseconds: 300),
  ),
  child: const SizedBox(height: 200, child: Text('内容')),
)
~~~

showDelay 默认 Motion.fastDuration；minimumVisibleDuration 默认 Motion.standardDuration。
短请求在延迟内完成则不显示。最短显示时间从开始进入显示状态计算，包含进入动画时间。
等待期间重复更新不会重新开始计时；最短显示期间重新加载不会先隐藏再显示。
修改等待时间按原请求开始时刻重新计算，组件销毁取消内部计时器。
showDelay: Duration.zero 可立即显示，minimumVisibleDuration: Duration.zero 可取消保留时间。
这两个时间不受系统减少动画影响，淡入淡出动画则遵守 disableAnimations。

## 内容、主题与材质

~~~dart
HyperLoadingOverlayTheme(
  data: const HyperLoadingOverlayThemeData(
    style: HyperLoadingOverlayStyle(
      progressStyle: HyperProgressStyle(color: Colors.teal),
      textStyle: TextStyle(color: Colors.teal),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  child: const HyperLoadingOverlay(
    loading: true,
    message: Text('正在同步…'),
    child: SizedBox(height: 200, child: Text('内容')),
  ),
)
~~~

indicator 可替换默认 HyperCircularProgress；默认进度尺寸、颜色、轨道与动画继承进度主题，
通过 progressStyle 只覆盖指定字段。message 接受任意 Widget，不传时只显示进度组件。
没有取消入口时，展示内容不接收点击；自定义 indicator/message 应保持展示职责。
内容超出区域高度时提供滚动布局；无遮罩操作时滚动手势穿透到底层。

默认背景为 surface 的 80% 透明填充，contentBackground 默认无填充。
background/material 配置整个遮罩；contentBackground/contentBorder/contentBorderRadius/boxShadow 配置中央内容表面。
padding、maxContentWidth、spacing、textStyle、alignment 可配置中央内容的排版。
buttonTheme 只覆盖取消按钮，不影响底层按钮或全局按钮主题。
质量、默认材质与降级继承统一 HyperMaterialTheme；material、materialQuality、reduceTransparency 可显式局部覆盖。
材质存在时不额外叠加 background；渲染和降级统一使用 HyperMaterialSurface。

全局 loadingOverlayTheme、局部 HyperLoadingOverlayTheme、实例 Style 逐字段合并。
四端尺寸由 sizes.loadingOverlay 管理；布局尺寸不按窗口缩放重新选择设备类型。
copyWith、merge、lerp 和值相等齐备，嵌套进度、文字和按钮主题 merge 保留未覆盖字段。
duration/curve 默认 Motion.fast；transitionBuilder 可替换遮罩过渡，接收显示进度和遮罩内容。
自定义过渡需要自行处理越界曲线，不应改变 loading 状态或 child 的布局职责。

Demo：反馈与状态 → HyperLoadingOverlay。
源码：[组件](../../lib/src/components/loading_overlay/hyper_loading_overlay.dart)、
[样式](../../lib/src/components/loading_overlay/hyper_loading_overlay_style.dart)、
[计时模型](../../lib/src/components/loading_overlay/hyper_loading_visibility.dart)、
[Demo](../../example/lib/pages/feedback/hyper_loading_overlay_page.dart)。
当前验证为静态分析、纯计时与主题数据测试；未做设备或 Widget 运行验证。
