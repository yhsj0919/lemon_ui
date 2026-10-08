# 底部面板

[返回目录](README.md)

## 打开与返回结果

~~~dart
HyperButton.filled(
  label: const Text('打开底部面板'),
  onPressed: () async {
    final result = await showHyperBottomSheet<bool>(
      context: context,
      builder: (sheetContext) => HyperBottomSheet(
        title: const Text('选择操作'),
        content: const Text('面板内容由使用方组合。'),
        actions: [
          HyperButton.tonal(
            label: const Text('取消'),
            onPressed: () => Navigator.of(sheetContext).pop(false),
          ),
          HyperButton.filled(
            label: const Text('完成'),
            onPressed: () => Navigator.of(sheetContext).pop(true),
          ),
        ],
      ),
    );
    if (!context.mounted) return;
    debugPrint('结果：$result');
  },
)
~~~

showHyperBottomSheet 使用原生 ModalBottomSheetRoute，默认开启拖动关闭与遮罩点击关闭。
从顶部拖动条或标题区域下拉可关闭；正文的滚动区域自行处理滚动手势。
这是拖动关闭面板，不是通过多个吸附档位改变高度的 DraggableScrollableSheet。

enableDrag: false 关闭拖动；barrierDismissible: false 关闭遮罩点击和 Escape 关闭。
系统返回仍可关闭，需要禁止返回时由业务用 PopScope 包住 HyperBottomSheet。
showCloseButton 默认 false；开启后可用 onClose 替换关闭行为。
无显式结果的关闭返回 null，按钮返回值由 Navigator.pop(result) 决定。
关闭时使用 builder 的 sheetContext，避免嵌套导航关闭错误的页面。

## 高度、边框与按钮

~~~dart
HyperButton.tonal(
  label: const Text('自定义面板'),
  onPressed: () => showHyperBottomSheet<void>(
    context: context,
    style: HyperBottomSheetStyle(
      height: 320,
      maxHeight: 420,
      maxWidth: 400,
      border: Border.all(color: Colors.teal),
      borderRadius: BorderRadius.circular(12),
      actionsDirection: Axis.vertical,
      buttonTheme: HyperButtonThemeData(
        style: HyperButtonStyle(borderRadius: BorderRadius.circular(6)),
      ),
    ),
    builder: (sheetContext) => HyperBottomSheet(
      title: const Text('固定高度'),
      showCloseButton: true,
      content: const Text('标题和按钮固定，正文占据剩余空间。'),
      actions: [
        HyperButton.filled(
          label: const Text('关闭'),
          onPressed: () => Navigator.of(sheetContext).pop(),
        ),
      ],
    ),
  ),
)
~~~

默认高度随内容增长，受当前窗口约束；height 指定期望表面高度，maxHeight 设置上限。
固定高度时正文填满剩余空间，操作区保留在底部；长正文默认独立滚动。
超出可用空间的高度会受父约束限制，组件不缩小字体。标题或按钮自身过大时，使用方应调整其布局。
width 与 maxWidth 控制期望宽度及上限；route 上限从 showHyperBottomSheet 的 style 解析，
不要只在 builder 内配置大于路由上限的实例宽度。大屏默认限制宽度并在底部居中。
桌面默认最大宽度为 640 逻辑像素，与 Material 3 对齐；可通过打开函数的
`style: const HyperBottomSheetStyle(maxWidth: 480)` 或全局、局部主题修改上限。

默认只设置上方圆角；borderRadius 可以显式配置四个角。背景 HyperFill、材质、
边框、阴影、padding、titleStyle、contentStyle 和关闭图标均由独立 Sheet 主题管理。
material 非空时采用其背景配方；否则使用 background。空阴影列表可关闭阴影，Border() 可明确无边框。

actions 接受任意 Widget。默认横向末端对齐，宽度不足时换行；actionsAlignment 可覆盖。
actionsDirection: Axis.vertical 改为纵向铺满宽度；actionSpacing 和 actionRunSpacing 控制间隔。
buttonTheme 只覆盖操作区里的 HyperButton，不影响正文或全局按钮主题。
按钮的业务、禁用、异步与实例 Style 仍由各自控件管理。

## 自带滚动与键盘

~~~dart
HyperButton.tonal(
  label: const Text('滚动列表'),
  onPressed: () => showHyperBottomSheet<void>(
    context: context,
    style: const HyperBottomSheetStyle(height: 360),
    builder: (sheetContext) => HyperBottomSheet(
      title: const Text('项目列表'),
      scrollable: false,
      content: ListView.builder(
        itemCount: 30,
        itemBuilder: (_, index) => HyperListTile(title: Text('项目 $index')),
      ),
    ),
  ),
)
~~~

默认正文放入 SingleChildScrollView；不要在其中使用需要有限高度的 Expanded。
自带 ListView 的正文可设 scrollable: false，接受剩余空间的有限高度。
键盘 viewInsets 会在面板下方留出避让区域，并压缩正文可用空间。
showHyperBottomSheet 的 useSafeArea 控制顶部及两侧避让；HyperBottomSheet 的 useBottomSafeArea
默认 true，在表面内保护底部内容。两者与键盘避让分别管理。
组件也可嵌入有合适高度约束的父布局；模态开合与拖动能力属于 showHyperBottomSheet，独立组件不持有路由状态。

## 拖动条、局部主题与动画

~~~dart
HyperBottomSheetTheme(
  data: const HyperBottomSheetThemeData(
    style: HyperBottomSheetStyle(
      dragHandleColor: Colors.teal,
      dragHandleSize: Size(40, 4),
      dragHandleBorderRadius: BorderRadius.all(Radius.circular(2)),
      dragHandlePadding: EdgeInsets.symmetric(vertical: 8),
      animationStyle: AnimationStyle(
        duration: Duration(milliseconds: 300),
        reverseDuration: Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    ),
  ),
  child: Builder(
    builder: (localContext) => HyperButton.tonal(
      label: const Text('局部主题面板'),
      onPressed: () => showHyperBottomSheet<void>(
        context: localContext,
        builder: (_) => const HyperBottomSheet(
          content: Text('调用处主题会跨路由保留。'),
        ),
      ),
    ),
  ),
)
~~~

showDragHandle 默认 true，可以隐藏；dragHandle 可替换为任意 Widget，自定义内容保留其语义和交互。
默认拖动条只是装饰，实际手势归原生面板；enableDrag: false 时可同时隐藏拖动条，避免误导。

配置顺序：默认 → 全局 bottomSheetTheme → 局部 HyperBottomSheetTheme → 打开函数 style → 实例 style。
animationStyle 和 buttonTheme 在 merge 时保留内部未显式覆盖的字段，copyWith 可整体替换它们。
animationStyle 支持进出时长与曲线，默认来自 Motion；系统减少动画时关闭过渡和键盘避让动画。
路由遮罩、宽度上限和进出场参数在打开时解析，需传给 showHyperBottomSheet；局部方向与减少动画设置一并保留。
useRootNavigator 默认 true；还可配置 requestFocus、routeSettings、anchorPoint 和 barrierLabel。

四端规格见 [尺寸说明](../size-specification.md)。当前验证包含主题/数据测试与静态分析，
未进行设备或 Widget 运行验证；尚无同状态截图对照。
后期 Form 可作为正文组合，字段校验与提交状态不进入面板职责。

[源码](../../lib/src/components/bottom_sheet/hyper_bottom_sheet.dart) ·
[Style](../../lib/src/components/bottom_sheet/hyper_bottom_sheet_style.dart) ·
[Demo](../../example/lib/pages/feedback/hyper_bottom_sheet_page.dart)
