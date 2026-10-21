# 步骤指示与导航

`HyperStepIndicator` 只展示状态。`HyperStepIndicator.navigation` 额外提供受控点击导航。两种模式共享步骤模型、布局与 `HyperStepIndicatorTheme`。

~~~dart
const HyperStepIndicator(
  currentStep: 1,
  items: [
    HyperStepItem(id: 'info', title: Text('填写信息')),
    HyperStepItem(id: 'review', title: Text('确认内容'), description: Text('核对信息')),
    HyperStepItem(id: 'finish', title: Text('完成')),
  ],
)
~~~

## 状态规则

currentStep 从 0 开始，等于 items.length 表示全部完成；空列表使用 0。重复 id 或越界索引会抛出异常。id 需要稳定且唯一，以便外部重排数据时保持正确关联。

未指定单项 status 时，当前索引之前为 completed，当前项为 current，之后为 pending。显式 status 覆盖推导；enabled: false 优先解析为 disabled。错误状态由页面设置和清除，不自行判断校验结果；显式错误不会因为 currentStep 变化而自动消失。

~~~dart
const HyperStepIndicator(
  currentStep: 1,
  direction: Axis.vertical,
  items: [
    HyperStepItem(id: 1, title: Text('准备')),
    HyperStepItem(id: 2, title: Text('提交'), status: HyperStepStatus.error),
    HyperStepItem(id: 3, title: Text('后续'), enabled: false),
  ],
)
~~~

默认完成项显示勾选图标，错误项显示关闭图标，其他项显示序号。icon 可替换任意 Widget。title、description 可自定义组件。状态语义通过主题 statusLabel 配置，单项 semanticLabel 可提供额外描述。

## 受控导航

~~~dart
HyperStepIndicator.navigation(
  currentStep: 0,
  onStepChanged: (index) {},
  items: const [
    HyperStepItem(id: 'account', title: Text('账号')),
    HyperStepItem(id: 'confirm', title: Text('确认')),
    HyperStepItem(id: 'done', title: Text('完成')),
  ],
)
~~~

回调只给出请求进入的索引，页面负责更新 currentStep、切换内容、校验和提交。不会自动设置已完成或错误，也不会限制进入未来步骤；需要流程校验时由页面禁用项目或在回调中判断。

当前项不发出重复导航请求。单项禁用、整组 enabled 为 false 或没有回调时不提供导航动作。键盘和焦点复用 HyperPressable。完成所有步骤后可返回任意未禁用项。

## 主题与布局

统一使用全局 `stepIndicatorTheme` 和局部 `HyperStepIndicatorTheme`。通用样式与状态字段后叠加 `navigationStyle`、`navigationPending` / `navigationCurrent` / `navigationCompleted` / `navigationError` / `navigationDisabled`，再合并实例和单项 Style。

~~~dart
HyperStepIndicatorTheme(
  data: const HyperStepIndicatorThemeData(
    navigationCurrent: HyperStepStyle(
      nodeFill: HyperFill.color(Colors.blue),
      foregroundColor: Colors.white,
      nodeBorderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    navigationError: HyperStepStyle(statusLabel: '提交失败'),
  ),
  child: HyperStepIndicator.navigation(
    currentStep: 0,
    items: const [
      HyperStepItem(id: 1, title: Text('设置')),
      HyperStepItem(id: 2, title: Text('完成')),
    ],
    onStepChanged: (index) {},
  ),
)
~~~

节点填充、材质、边框、圆角、文字、序号、图标、连接线、间距和交互色层均可配置。连接线归前一节点所有；该节点完成时默认为强调色，其他状态使用 outline。修改颜色可通过相应状态主题的 connectorColor 实现。

默认横向布局需要有限宽度，各项均分空间，节点顶部对齐，标题与描述自然换行。步骤较多或空间较窄时建议显式使用 Axis.vertical；不根据窗口宽度改变设备类别。纵向布局需要有限宽度，内容高度自然增长；不内置滚动区或表单内容。

纵向连接线两端分别按相邻节点的 spacing 留白，避免线条顶住圆点；末项不绘制出线。整组轨道按最大 nodeSize 分配宽度，各节点与连接线共用中心线，自定义节点尺寸不同时仍保持对齐。

短内容也为连接线预留 itemSpacing 长度，两端留白不会吞掉线段。没有描述的标题在当前节点高度内垂直居中；有描述时文字块顶部对齐，长文字自然增加行高。

尺寸集中在 sizes.stepIndicator / sizes.stepIndicator.navigation。节点可见尺寸与导航触达下限区分。颜色、文字和符号切换有 Motion fast 过渡；transitionBuilder 可替换节点符号切换动画。遵守减少动画设置。

节点材质继承统一 HyperMaterialTheme，显式 Style 可覆盖配方、质量与减少透明度设置；复用 HyperMaterialSurface 渲染与降级。默认没有鼠标悬浮背景或阴影（hoverOpacity 为 0）；按下与键盘焦点反馈分别由 pressedOpacity、focusOpacity 配置。

默认视觉是同端既有语义规格的 D 级推导，未运行设备、Widget 或截图对照验证。

- [Demo](../../example/lib/pages/framework/hyper_steps_page.dart)
- [尺寸来源](../size-specification.md)
