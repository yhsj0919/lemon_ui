# 图片

`HyperImage` 使用 extended_image 10.1.0 负责图片加载，默认提供加载指示、失败提示、点击重试和状态淡入。2026-10-28 用户明确确认图片、图片预览和图片编辑，Demo 归入“文字与内容”，主题编辑器归入“内容”，页面 id 保持不变。

```dart
HyperImage.network(
  url,
  width: 240,
  aspectRatio: 1.5,
  variant: HyperImageVariant.outlined,
  semanticLabel: '产品图片',
)
```

## 来源与状态

`network` 支持缓存开关、请求头、超时、自动重试次数与间隔、缓存键和有效期；`asset` 支持资源包与 AssetBundle；`memory` 接收编码字节；`file` 接收原生路径，在 Web 抛 UnsupportedError，浏览器选取文件后使用 memory。通用构造接收 ImageProvider。Web 请求遵守 CORS；网络磁盘缓存只在支持该能力的平台生效，不承诺六端完全相同。

`cacheWidth` / `cacheHeight` 是 Flutter 解码物理像素尺寸，与布局逻辑像素分开。支持栅格图片及底层解码器支持的动画格式，不增加 SVG 解码器。

加载中：有有效总字节数时展示确定进度，否则展示循环进度。失败后提供图标、说明、可聚焦按钮；重试复用原图源和加载配置。成功后保留图片语义标签。loadingBuilder 与 errorBuilder 可替换默认内容，后者接收异常和 retry 回调。

指定宽高、宽高比或父布局紧约束，可以在全部状态中预留相同空间；没有预留时保留图片加载后的固有尺寸，不猜测宽高比。失败内容在窄宽与大字约束中换行，固定容器空间不足时允许滚动，保留系统 TextScaler。

## 外观与主题

`plain` 默认无装饰；`outlined` 增加边框；`elevated` 增加背景与阴影。fit、宽高、对齐和解码配置独立于变体。

`HyperThemeData.imageTheme` 提供 appearance（全部变体）以及 plain / outlined / elevated；各自包含 style（全部状态）、loading、completed、failed。解析顺序为默认配方、通用 style、变体 style、通用状态、变体状态、实例 Style。局部 HyperImageTheme 逐字段合并同名槽位；具体变体或状态槽位优先于通用槽位。

`HyperImageStyle` 可配置占位、进度、失败图标与文字、提示和重试文案、内部尺寸、表面及动效；空字段继承。surfaceStyle 复用 HyperCardStyle，显式空阴影列表关闭阴影，Border() 关闭边框，透明背景与零圆角均可显式覆盖。内部复用公共非浮层表面，避免继承 Card 的组件尺寸或主题；材质质量及降级统一继承 HyperMaterialTheme。默认动画读取 Motion，减少动画设为零时长；transitionBuilder 可替换内容过渡，表面材质始终位于淡入层之外。

## 默认规格来源

来源级别 D，均为同端项目语义推导，逻辑像素；不是已验证的 HyperOS 或 HIUI 图片控件规格。

- 各端 image.iconSize 继承本端 iconSize；progressSize / progressThickness 继承本端圆形进度规格。
- spacing 继承通用 spaceSm；占位内边距与圆角分别继承本端 card.padding.left / card.radius。
- elevated 阴影模糊取 image.radius，纵向偏移取 image.spacing，scrim 透明度 .10 暂按既有轻阴影语义推导；outlined 使用主题 outline 与默认 Border.all 描边。均待视觉确认。
- 文案使用 bodySmall，颜色复用 textSecondary，加载强调使用 primary，占位使用 surfaceMuted；不新增字体和跨端倍率。

已核对项目设计基准引用的官方 MiSans 资料（https://hyperos.mi.com/font/en/）；该资料没有图片表面数值。HIUI 的 image 源码入口未取得可用直接规格，故没有移植未经核实的 CSS 数值。后续仍需对应设备的官方资料或目标截图验证默认视觉。

编辑器按变体、加载状态选择覆盖；共用内容尺寸仅在“通用（所有变体）/通用（所有状态）”下展示。尺寸按设备、外观按亮暗保存，支持导入与当前槽位恢复继承。圆角使用父布局决定尺寸表面的公共操作边界；进度描边随进度直径收缩并写入整数。编辑范围不作为默认规格。


## 大图预览

```dart
await showHyperImagePreview(
  context: context,
  items: [
    HyperImagePreviewItem(image: NetworkImage(url), semanticLabel: '产品正面'),
    HyperImagePreviewItem(image: AssetImage('assets/detail.png')),
  ],
);
```

也可以直接嵌入 `HyperImagePreview`，父布局须提供有限高度。`HyperImagePreviewController` 提供 `jumpTo`、`next`、`previous`、`zoomIn`、`zoomOut`、`resetZoom` 以及当前 index / scale；同一 controller 只能绑定一个控件，由创建方负责 dispose。

支持双击、双指和滚轮缩放，缩放范围为 1 到 maxScale（默认 5）；放大后先拖动图片，到达左右边缘后继续拖动会交接翻页；按钮与方向键也可切换。页面离开并停止滚动后清除缩放和平移，返回时恢复初始状态；替换图片列表时重建变换，列表缩短时索引收缩到合法范围。方向键切换，`=` 放大、`-` 缩小、`0` 重置；弹窗内 Escape 关闭。图片加载与失败重试复用 HyperImage。

`imagePreviewTheme` / `HyperImagePreviewTheme` / `HyperImagePreviewStyle` 依次覆盖。可配置工具栏、文字、按钮、图标尺寸、内部间距、图片 Style、工作区表面、缩放和切换的时长与曲线；`dialogStyle` 配置弹窗外表面，实例 helper 的 dialogStyle 最后合并。默认时长与曲线读取 Motion，减少动画时直接到目标状态。

## 图片编辑

```dart
final result = await showHyperImageEditor(
  context: context,
  bytes: encodedBytes,
  cropAspectRatio: 1,
);
if (result != null) {
  // result.bytes 为 PNG；width / height 为物理像素。
  // 保存文件、上传或更新业务数据由调用方执行。
}
```

`HyperImageEditor` 可直接嵌入有限高度的布局；输入为编码图片字节，原始字节不被改写。工具栏内置自由、1:1、4:3、16:9 比例选择，拖动裁剪角点调整范围，缩放和移动图片确定构图。`HyperImageEditorController` 支持顺 / 逆时针 90° 旋转、水平 / 垂直翻转、undo / redo / reset、任意正数比例与 exportPng；ready、exporting、canUndo、canRedo 可用于组合自定义操作。变换动画过程中暂不允许导出，避免输出中间状态。

导出对当前解码帧创建快照，按旋转后的坐标执行水平镜像和裁剪，再通过 dart:ui 编码 PNG；不新增原生编码插件。裁剪起点和尺寸分别取最邻近整数并限制于图像边界，避免两边向外取整破坏正方形比例。动画图片导出为当前帧静态 PNG；不保留 EXIF、动画或原文件格式。源图片更换或编辑器销毁后，不再触发旧导出的界面回调。

导出按钮忙碌时禁用编辑；导出失败默认在组件内显示提示，可通过 onExportError 接收异常，controller.exportPng 的异常仍交由调用者处理。onExport 接收结果；弹窗 helper 成功返回结果，取消、返回和关闭返回 null。

`imageEditorTheme` / `HyperImageEditorTheme` / `HyperImageEditorStyle` 提供工具栏、图标、文字、裁剪留白、手柄尺寸与命中范围、框线、遮罩、导出文案、图片状态 Style 和表面的强类型覆盖。裁剪、旋转和翻转时长读取 Motion，可由 animationDuration 覆盖；后端变换曲线由 extended_image 管理。外层弹窗继续走 HyperDialog，显式空阴影列表优先于材质配方，不将背景滤镜放入内容淡入层。

## 工具尺寸与待确认项

`sizes.imagePreview` 的图标、工具间距、内边距继承同端 image 语义。`sizes.imageEditor` 同样继承 image，手柄长度继承图标尺寸，手柄厚度继承进度描边，框线默认为 1 逻辑像素，命中范围继承 minimumInteractiveDimension；cropPadding 未指定时跟随工具内边距。这些均为 D 级项目推导，单位为逻辑像素，已由用户确认，不表示官方图片编辑器规格。

两种工作区在窄宽或大字下重排工具栏；工具栏最多占有限高度的一半，超出后滚动，保留图片操作区域。Demo 的嵌入预览高度 360、编辑高度 400 是明确的演示布局覆盖，不属于组件默认尺寸。主题编辑器按内容布局、图标、文字、裁剪框、动效、表面组织；裁剪线颜色与表面边框独立存储。

新增页面 id 为 `hyper-image-preview`、`hyper-image-editor`，均归入正式“文字与内容”分类。手机全屏浏览、桌面多窗口、超大图片的编码耗时和真实设备输入体验还需实机验证；当前弹窗入口在各端统一使用 HyperDialog，不依窗口宽度切换真实设备类别。


### 预览手势实现

图片缩放、平移与滚轮处理复用 extended_image 的 `ExtendedImageGesture`；分页使用配套 `ExtendedImageGesturePageView` 和 `ExtendedPageController`，不再将通用 InteractiveViewer 嵌套在普通 PageView 中。没有重写图片缩放或边界计算。内部适配层仅将 Flutter 的全局焦点转换为图片局部坐标，并在原始倍率下将被图片识别器接管的单指横移交还同一个原生分页器；双指缩放和放大后的图片移动继续由底层处理。滚轮上滚放大、下滚缩小。

缩放比例更新只重建工具栏，平移更新由图片自身处理，不再重建整个画廊。页面独立隔离重绘，相邻页允许隐式预加载；页面离开且翻页结束后调用底层 reset 清除变换，切回时恢复初始状态，不使用全局手势缓存。加载中与失败内容仍不进入缩放控件，重试按钮保持原尺寸。


2026-10-28：修复嵌入式预览中焦点坐标错位导致放大即贴边的问题；分页开始时显式将可见图片置为底层活动手势，避免相邻预加载页决定拖动优先级。没有增加等待时间或“翻页冷却”开关；连续手势测试不等待 pumpAndSettle 或一秒静默期就开始下一次拖动。


### 弹窗内的材质合成

图片预览弹窗默认由 HyperDialog 绘制唯一背景材质，内层预览工作区不再重复创建默认背景滤镜。嵌入式 HyperImagePreview 默认 showSurface 为 true，仍提供自己的表面；调用方可在已有公共表面中设置 false。显式配置预览 surfaceStyle 时，弹窗仍保留该独立表面及其材质、边框、圆角和空阴影列表。

单张图片的状态绘制默认复用工作区已经提供的背景材质；显式 imageStyle 或图片主题的材质仍会在该图片内生效。高级质量的默认预览弹窗从三层背景滤镜收敛到一层，避免缩放与翻页同时重复采样相同背景；质量、降级与安全过渡仍由统一材质和对话框基础设施管理。此为合成结构验证，实际帧时间仍需在目标设备 profile 模式测量。


Demo 的首次失败由示例专用图片流发出预期状态，点击重试后正常解码；没有消费者时停止后续模拟步骤。该预期事件仅在图片源内部处理，不使用 FlutterError.onError 等全局过滤，也不影响真实图片错误上报。


### 裁剪边界

`HyperImageEditor.constrainCropRect` 默认 true：裁剪手柄到真实图像边界时停止扩张。视口边缘不作为裁剪边界；放大后持续向外拖动会复用底层自动适配，逐步扩选至全图。自由裁剪的横向移动不改变上下边，纵向移动不改变左右边；固定比例继续采用底层的比例候选矩形，并在首次触及边界处停止。原生自动居中与缩放、图像平移、旋转、撤销重做、PNG 导出保持原职责。显式 false 可恢复底层的越界扩张与适配行为；弹窗 helper 同样支持该参数。

该选项通过项目内 `lemon_extended_image` 依赖的最小补丁实现，基于 extended_image 10.1.0 并保留 MIT 许可。补丁位于真正负责手柄几何的 crop_layer，不在 HyperImageEditor 外面叠加偏移或指针特判。命名隔离避免影响表格等其他库使用的原版 extended_image。维护与移除条件见 `third_party/extended_image/LEMON_PATCHES.md`；发布到 pub.dev 前需处理本地 path 依赖。


### Hero 预览

缩略图 `HyperImage`（包括 network / asset / memory / file 工厂）和对应的 `HyperImagePreviewItem` 设置相同的 `heroTag`，`showHyperImagePreview` 自动启用 Flutter 原生 Hero 动画。标签在同一路由内须唯一，打开和关闭均按当前图片匹配；找不到对应缩略图时保留弹窗过渡。可用 `enableHero: false` 关闭，系统减少动画设置同样生效。

```dart
final photo = NetworkImage(url);
const tag = 'photo-42';
GestureDetector(
  onTap: () => showHyperImagePreview(
    context: context,
    items: [HyperImagePreviewItem(image: photo, heroTag: tag)],
  ),
  child: HyperImage(image: photo, heroTag: tag, width: 120, height: 80),
);
```

两端必须属于同一 Navigator；嵌套导航时通过 `useRootNavigator` 选择与缩略图页面一致的导航器。Hero 仅搬运图片，不携带缩放手势、工具栏或高级材质。弹窗背景可见的原缩略图在打开、停留及关闭期间保持绘制，使用等尺寸且不接收指针的 Hero 占位内容，避免原位置变空。弹窗继续复用 HyperDialog 表面和统一安全材质过渡。
