# 描述列表

`HyperDescriptionList` 展示标签和值，支持多列、跨列、表格边框及自定义内容。不持有业务数据，不承担编辑或表单校验。

## 基本用法

~~~dart
HyperDescriptionList(
  columns: 2,
  items: const [
    HyperDescriptionItem(id: 'name', label: Text('名称'), value: Text('Lemon UI')),
    HyperDescriptionItem(id: 'status', label: Text('状态'), value: Text('已启用')),
    HyperDescriptionItem(id: 'note', label: Text('说明'), span: 2, value: Text('长文字自然换行，不固定行高。')),
  ],
)
~~~

父级必须提供有限宽度。`columns` 是期望的最大列数，默认 1；`responsive` 默认 true，按可用宽度与 `minimumColumnWidth` 减少列数，不改变真实设备类别。关闭响应式后列数固定，窄容器需自行保证可读性。

`id` 必须唯一，`span` 为正整数。跨列超过当前列数时按当前列数布局，剩余列不足时整项换行；未用尾部列保持空白，不拉伸前面的项。调用方列表不会被修改。

## 边框和标签位置

~~~dart
HyperDescriptionList(
  bordered: true,
  columns: 3,
  labelPlacement: HyperDescriptionLabelPlacement.above,
  title: const Text('项目资料'),
  items: const [
    HyperDescriptionItem(id: 'owner', label: Text('负责人'), value: Text('陈')),
    HyperDescriptionItem(id: 'contact', label: Text('联系方式')),
  ],
)
~~~

标签默认在值的侧面，可改为上方。侧面默认按 `labelFlex: 1`、`valueFlex: 2` 分配空间；`labelWidth` 可指定标签区域宽度（包含内边距），窄容器中受可用宽度限制。值为 null 使用 `placeholder`，默认 `—`；空字符串不自动替换。

## 主题和自定义内容

~~~dart
HyperDescriptionListTheme(
  data: const HyperDescriptionListThemeData(
    style: HyperDescriptionListStyle(
      labelStyle: TextStyle(fontWeight: FontWeight.w600),
      labelBackground: HyperFill.none(),
      placeholder: '未填写',
    ),
  ),
  child: HyperDescriptionList(
    bordered: true,
    items: [
      HyperDescriptionItem(
        id: 'action', label: const Text('操作'),
        value: HyperButton.text(label: const Text('查看'), onPressed: () {}),
      ),
    ],
  ),
)
~~~

全局配置使用 `HyperThemeData.descriptionListTheme`，四端尺寸使用 `HyperSizeScheme.descriptionList`。覆盖顺序为默认 → 全局主题 → 局部主题 → 列表 Style → item Style。item Style 用于单项文字、填充、内边距与标签布局；整体圆角、背景、列宽、行列间距和外边框由列表 Style 控制。显式 Text.style 或自定义组件自身视觉由调用方负责。

Style 可配置背景、标签和值填充、边框颜色与粗细、圆角、单元格内边距、间距、最小列宽、标签宽度或比例、字体、占位文字及动效时长和曲线。材质继承统一 `HyperMaterialTheme`，实例 Style 可以覆盖配方、质量和减少透明度。

值变化默认淡入淡出；为不同值提供不同 Key 才触发 AnimatedSwitcher，Style 的 `transitionBuilder` 可通过主题替换默认过渡，组件的同名参数拥有最终优先级。文字与填充变化沿用 Motion，并遵守减少动画设置。大量数据应使用虚拟列表；本组件为少量描述字段采用自然行高布局。

默认规格目前为 D 级同端语义推导，没有可靠的同代 HyperOS 描述列表截图。Demo 在 Gallery 的「文字与内容」中；静态分析和纯布局测试不代表设备截图验证。
