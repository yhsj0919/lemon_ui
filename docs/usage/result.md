# 结果页

`HyperResult` 统一展示操作结果与空内容。空状态使用 `HyperResult.empty` 或 `HyperResultStatus.empty`。结果页不发起请求、不自动重试或导航，也不管理加载状态。

## 状态与操作

~~~dart
HyperResult(
  status: HyperResultStatus.success,
  title: '保存成功',
  description: '设置已更新。',
  actions: [
    HyperButton.filled(label: const Text('返回'), onPressed: () {}),
  ],
)
~~~

`status` 默认 neutral，也可为 success、error、warning、info。状态只决定默认图标与语义色，标题、描述和按钮由调用方提供。按钮使用普通 Widget，回调、禁用和导航由按钮及页面负责；操作区空间不足时自然换行。

## 自定义插图与详情

~~~dart
const HyperResult(
  status: HyperResultStatus.warning,
  title: '部分内容未保存',
  description: '请核对以下信息。',
  illustration: Icon(Icons.cloud_off_outlined),
  content: HyperDescriptionList(
    bordered: true,
    items: [
      HyperDescriptionItem(id: 'reason', label: Text('原因'), value: Text('网络不可用')),
    ],
  ),
)
~~~

`illustration` 优先于默认图标，按 illustrationSize 保持比例；`showIllustration: false` 移除整个插图区。插图为装饰性元素，不重复加入读屏语义，业务状态应在标题或描述中明确表达。

`titleWidget` / `descriptionWidget` 优先于字符串；null 或空字符串不占用对应文字区。`content` 为任意详情组件，置于描述之后、操作区之前。父布局负责滚动、安全区、外边距和页面定位。组件按父约束与 maxWidth 限宽，文字不缩放，行高随内容变化。

## 主题和动效

~~~dart
HyperResultTheme(
  data: const HyperResultThemeData(
    style: HyperResultStyle(titleStyle: TextStyle(fontWeight: FontWeight.w600)),
    error: HyperResultStyle(icon: Icons.cloud_off_outlined),
  ),
  child: const HyperResult(
    status: HyperResultStatus.error,
    title: '连接失败',
    description: '请稍后重试。',
    style: HyperResultStyle(background: HyperFill.none()),
  ),
)
~~~

全局主题为 `HyperThemeData.resultTheme`；局部主题为 `HyperResultTheme`。通用 style 与 neutral/success/error/warning/info/empty 状态 style 逐字段合并，实例 Style 最后覆盖。TextStyle 按显式字段深合并。

空状态配置顺序为当前端 `sizes.result.empty` → `resultTheme.style` → `resultTheme.empty` → 实例 `HyperResultStyle`。局部覆盖使用 `HyperResultThemeData(empty: HyperResultStyle(...))`。表面字段直接使用 `HyperResultStyle` 的背景、材质、边框、圆角、阴影和内边距。

Style 支持图标、颜色和尺寸、插图尺寸、最大宽度、内边距、各区间距、背景、边框、圆角、阴影、字体、对齐、材质与过渡配置。null 表示继承，HyperFill.none、Border.fromBorderSide(BorderSide.none)、空阴影列表等用于显式移除对应视觉。

材质继承统一 `HyperMaterialTheme`，Style 可局部覆盖配方、质量与减少透明度；绘制和降级使用 `HyperMaterialSurface`。

状态图标和文字变化默认淡入淡出，整体内容高度连续过渡；时长及曲线取 Motion，遵守减少动画设置。`transitionBuilder` 可由主题或实例 Style 替换。自定义文字/插图使用不同 Key 可触发内容变化过渡；无 Key 且相同类型时保留子组件状态。传入操作区组件的交互样式由其自身主题负责。

默认尺寸为 D 级同端语义推导，复用已确认的空状态尺寸，并独立存储以便之后核实调整。未获得可验证的同代 HyperOS 结果页截图；没有宣称官方精确还原。Gallery 的「文字与内容 → HyperResult」展示状态、减少动画、详情、自定义插图及材质。

