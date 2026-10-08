# 对话框

[返回目录](README.md)

## 打开、关闭和返回结果

~~~dart
HyperButton.filled(
  label: const Text('打开对话框'),
  onPressed: () async {
    final result = await showHyperDialog<bool>(
      context: context,
      builder: (dialogContext) => HyperDialog(
        title: const Text('确认操作'),
        content: const Text('是否继续？'),
        actions: [
          HyperButton.tonal(
            label: const Text('取消'),
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          HyperButton.filled(
            label: const Text('确认'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );
    if (!context.mounted) return;
    debugPrint('结果：$result');
  },
)
~~~

showHyperDialog 返回关闭结果；关闭图标、遮罩或系统返回通常得到 null。
默认使用根 Navigator，关闭时使用 builder 的 dialogContext，避免关闭错误的页面。
useRootNavigator: false 可使用最近的嵌套 Navigator。

barrierDismissible 控制遮罩点击和 Escape 关闭，不限制系统返回；业务需要禁止返回时，
使用 PopScope 包住 HyperDialog。关闭按钮独立由 showCloseButton 和 onClose 控制。
默认请求焦点，Tab 焦点循环由 Flutter 模态路由负责；requestFocus 可显式覆盖。
routeSettings、anchorPoint 和 barrierLabel 分别配置路由信息、折叠屏分区参考点和遮罩语义。

## 弹出位置、边框、圆角和按钮

~~~dart
HyperButton.tonal(
  label: const Text('右下角对话框'),
  onPressed: () => showHyperDialog<void>(
    context: context,
    style: HyperDialogStyle(
      alignment: AlignmentDirectional.bottomEnd,
      maxWidth: 420,
      border: Border.all(color: Colors.teal, width: 1),
      borderRadius: BorderRadius.circular(12),
      insetPadding: const EdgeInsets.all(16),
      actionsDirection: Axis.vertical,
      buttonTheme: HyperButtonThemeData(
        style: HyperButtonStyle(borderRadius: BorderRadius.circular(6)),
      ),
    ),
    builder: (dialogContext) => HyperDialog(
      title: const Text('自定义对话框'),
      content: const Text('位置、边框、圆角、按钮样式均可配置。'),
      actions: [
        HyperButton.filled(
          label: const Text('完成'),
          onPressed: () => Navigator.of(dialogContext).pop(),
        ),
      ],
    ),
  ),
)
~~~

alignment 默认居中；可以选择九宫格中的任意位置，Directional 对齐随 RTL 镜像。
width 是期望宽度，maxWidth 是上限，两者还受当前窗口与 insetPadding 约束。
insetPadding 是对话框到安全区域边界的留白，键盘 viewInsets 会额外避让；
useSafeArea 默认 true。布局不按窗口宽度改变真实设备类别。

actions 接受任意 Widget；按钮业务、禁用、异步等待和返回结果由调用方管理。
默认横向 Wrap 末端对齐，空间不足时换行；actionsAlignment 可改变对齐，
actionsDirection: Axis.vertical 使用铺满可用宽度的纵向排列。
actionSpacing / actionRunSpacing 控制按钮之间及换行间距，titleSpacing 控制标题和操作区与正文的间距。
buttonTheme 只作用于操作区里的 HyperButton，正文按钮不受影响；每个按钮的实例 Style 最后覆盖。

## 正文、主题和动效

~~~dart
HyperDialogTheme(
  data: const HyperDialogThemeData(
    style: HyperDialogStyle(
      background: HyperFill.color(Colors.white),
      closeIcon: Icons.cancel_outlined,
      closeIconColor: Colors.teal,
      contentStyle: TextStyle(fontSize: 16),
    ),
  ),
  child: Builder(
    builder: (localContext) => HyperButton.tonal(
      label: const Text('局部主题'),
      onPressed: () => showHyperDialog<void>(
        context: localContext,
        builder: (_) => const HyperDialog(
          title: Text('继承局部主题'),
          content: Text('调用处的主题会跨路由捕获并保留。'),
        ),
      ),
    ),
  ),
)
~~~

默认正文置于 SingleChildScrollView 中，长内容滚动时标题和按钮保留。
自带 ListView 等滚动内容可设 scrollable: false，使其接受剩余空间的有限高度。
不要在默认滚动正文内使用需要有限主轴高度的 Expanded；正文内容、标题和任意操作 Widget 由使用方负责。
可隐藏标题或关闭入口；content 始终为自由内容，不预设表单结构。

background 支持纯色、渐变或 HyperFill.none；material 支持统一材质配方。
material 非空时由它管理背景，否则使用 background。border、borderRadius、boxShadow、
padding、titleStyle、contentStyle、closeIcon / closeIconColor / closeIconSize 均可覆盖。
空 boxShadow 列表明确关闭阴影，Border() 可明确无边框。

配置顺序：默认 → 全局 dialogTheme → 局部 HyperDialogTheme → showHyperDialog 的 style → HyperDialog 自身 style。
barrierColor、duration、curve、transitionBuilder 的路由配置在打开时从调用处解析；
需要设置遮罩或进出场时，将其传给 showHyperDialog，不能只写在 builder 内的实例 Style 上。
默认使用 Motion fast 时长与曲线，淡入并轻微缩放；transitionBuilder 可完整替换进出场动画。
系统减少动画时关闭路由及键盘避让动画。

四端数值位于 HyperSizeScheme.dialog，来源和未验证项见 [尺寸说明](../size-specification.md)。
当前已做主题与数据测试和静态分析，未做设备或 Widget 运行验证，不宣称精确还原。

## 后续表单弹窗

表单阶段将用 HyperDialog.content 承载 HyperForm，actions 承载提交/取消；
校验、字段状态和异步提交仍归表单与业务层。位置、表面、正文滚动和按钮主题继续复用 Dialog。

[源码](../../lib/src/components/dialog/hyper_dialog.dart) ·
[Style](../../lib/src/components/dialog/hyper_dialog_style.dart) ·
[Demo](../../example/lib/pages/feedback/hyper_dialog_page.dart)
