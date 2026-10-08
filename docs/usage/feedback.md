# 浮层与反馈

[返回目录](README.md)

对话框见 [HyperDialog 使用说明](dialog.md)。
底部面板见 [HyperBottomSheet 使用说明](bottom-sheet.md)。
轻提示与操作提示见 [Toast / Snackbar 使用说明](messages.md)。
内联提示和页面横幅见 [Alert / Banner 使用说明](notices.md)。
区域和整页加载见 [HyperLoadingOverlay 使用说明](loading-overlay.md)。

## HyperMenu 菜单内容

~~~dart
HyperMenu(
  groups: const [
    HyperMenuGroup(title: '文件', items: [
      HyperMenuItem(id: 'open', label: '打开', leading: Icon(Icons.folder_open)),
      HyperMenuItem(id: 'export', label: '导出', enabled: false),
    ]),
    HyperMenuGroup(items: [
      HyperMenuItem(id: 'more', label: '更多', children: [
        HyperMenuItem(id: 'copy', label: '复制'),
      ]),
    ]),
  ],
  selectedId: 'open',
  onSelected: (id) {},
)
~~~

HyperMenu 是菜单内容本身，不主动显示浮层。
items / groups 提供列表/分组，HyperMenuItem.children 提供子菜单；
selectedId 高亮指定项，enabled 禁用单项。id 用于回调和识别，应保持唯一。
全局 menuTheme、局部 HyperMenuTheme、实例 HyperMenuStyle。
[源码](../../lib/src/components/menu/hyper_menu.dart) ·
[模型](../../lib/src/components/menu/hyper_menu_model.dart)。

## HyperMenuButton 菜单按钮

~~~dart
HyperMenuButton(
  child: const Text('更多'),
  items: const [
    HyperMenuItem(id: 'rename', label: '重命名'),
    HyperMenuItem(id: 'copy', label: '复制'),
  ],
  onSelected: (id) {},
)
~~~

点击按钮展开菜单；variant/size/buttonStyle 管理按钮，menuStyle 管理菜单。
placement 设置首选方向，空间不足会调整；transitionBuilder 替换过渡。
[源码](../../lib/src/components/menu/hyper_menu_button.dart)。

## HyperContextMenu 右键/上下文菜单

~~~dart
HyperContextMenu(
  items: const [
    HyperMenuItem(id: 'copy', label: '复制'),
    HyperMenuItem(id: 'delete', label: '删除'),
  ],
  onSelected: (id) {},
  child: const SizedBox(
    width: 240, height: 80,
    child: Center(child: Text('右键或长按')),
  ),
)
~~~

包住目标区域，桌面右键或触摸长按展开；enabled 可关闭触发。
菜单处理动作由应用回调负责。
[源码](../../lib/src/components/menu/hyper_context_menu.dart)。

## HyperDropdownMenu 下拉选择

~~~dart
HyperDropdownMenu<String>(
  options: const [
    HyperDropdownOption(value: 'auto', label: '自动'),
    HyperDropdownOption(value: 'manual', label: '手动'),
  ],
  value: 'auto',
  onChanged: (value) {},
  placeholder: '选择模式',
)
~~~

value 与 options 的泛型一致，空值显示 placeholder；
单项 enabled 控制禁用，整体 enabled / 空回调控制交互。
buttonStyle、menuStyle 配置两部分；style 使用 HyperDropdownMenuStyle，
全局 dropdownMenuTheme、局部 HyperDropdownMenuTheme。
[源码](../../lib/src/components/menu/hyper_dropdown_menu.dart)。

## HyperTooltip 提示

~~~dart
HyperTooltip(
  message: '这里显示帮助说明',
  child: HyperIconButton.ghost(
    icon: const Icon(Icons.help_outline),
    onPressed: () {},
  ),
)
~~~

通过锚定浮层显示提示；placement、waitDuration/exitDuration/showDuration
控制位置和时机，transitionBuilder 控制过渡。当前没有独立 Tooltip Style/Theme；
需要完全自定义内容使用 HyperAnchoredOverlay。
[源码](../../lib/src/components/tooltip/hyper_tooltip.dart)。

## HyperProgress 进度

~~~dart
Column(
  children: const [
    HyperProgress.linear(value: .4, variant: HyperProgressVariant.wide),
    SizedBox(height: 16),
    HyperProgress.circular(value: .6),
    SizedBox(height: 16),
    HyperProgress.infinite(),
  ],
)
~~~

.linear/.circular 的 value 为 0..1；null 表示不确定进度。
.infinite 是循环加载形态，不提供确定进度值。
宽条 wide 与同端 Slider 轨道高度一致，thin 为细条。
radius 控制轨道外轮廓，fillRadius 控制填充末端，默认圆角，0 为直边。
直接尺寸参数：HyperProgress.linear.size 表示长度，circular/infinite.size 表示整体大小。

下层入口 HyperLinearProgress / HyperCircularProgress / HyperInfiniteProgress 可直接使用；
其中 HyperLinearProgress 使用 length 参数：

~~~dart
HyperLinearProgress(
  value: .25,
  length: 240,
  thickness: 8,
  fillRadius: 0,
  semanticsLabel: '下载进度',
)
~~~

color/trackColor、thickness、animationDuration/animationCurve 等覆盖视觉。
semanticsLabel/semanticsValue 提供可访问文本，excludeSemantics 隐藏装饰进度。
全局 progressTheme、局部 HyperProgressTheme、实例 HyperProgressStyle。
[统一入口](../../lib/src/components/progress/hyper_progress.dart) ·
[Demo](../../example/lib/pages/feedback/hyper_progress_page.dart)。
旧 HyperProgressIndicator 名称已移除，没有兼容别名。

## HyperSkeleton 骨架占位

~~~dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: const [
    HyperSkeleton.circle(size: 40),
    SizedBox(height: 12),
    HyperSkeleton.text(width: 160),
    SizedBox(height: 12),
    HyperSkeleton(width: 240, height: 96, effect: HyperSkeletonEffect.pulse),
  ],
)
~~~

默认矩形；.text 为文本条，.circle 为圆形。
loading: false 时展示 child，无 child 时隐藏占位。
effect 为 shimmer/pulse/none；effectBuilder 替换循环效果，
transitionBuilder 替换加载完成过渡。循环遵守减少动画和 TickerMode。
默认占位不创建朗读条目，可设置 semanticsLabel。
全局 skeletonTheme、局部 HyperSkeletonTheme、实例 HyperSkeletonStyle。
[源码](../../lib/src/components/skeleton/hyper_skeleton.dart)。

## HyperEmptyState 空状态

~~~dart
HyperEmptyState(
  title: '暂无文档',
  description: '创建第一个文档后会显示在这里',
  icon: Icons.description_outlined,
  actions: [
    HyperButton.filled(label: const Text('新建文档'), onPressed: () {}),
  ],
)
~~~

title/description 是默认文字；titleWidget/descriptionWidget 替换文字组件。
illustration 优先于 icon，showIllustration: false 隐藏插图；
content 添加任意内容，actions 自动换行。父级决定可用范围。
空状态不管理网络、加载、重试与路由。
全局 emptyStateTheme、局部 HyperEmptyStateTheme、实例 HyperEmptyStateStyle。
[源码](../../lib/src/components/empty_state/hyper_empty_state.dart) ·
[Demo](../../example/lib/pages/feedback/hyper_empty_state_page.dart)。

## 通知卡片

参见[通知卡片使用文档](notification.md)，支持受控已读与显示状态、独立操作和统一材质。

## 通知中心

参见[通知中心使用文档](notification-center.md)。默认有限高度内滚动，也可嵌入外部列表。
