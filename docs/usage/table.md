# 数据表格

`HyperTable<T>` 基于 TrinaGrid 2.3.0，公开接口只使用 Hyper 与 Flutter 类型。旧版 AppDataGrid 仅用于核对功能；新实现没有复制旧悬停缩放、滚动条覆盖及历史补丁。2026-10-22 用户明确确认表格，Gallery 入口移至「文字与内容 → HyperTable」，主题编辑器同步归入「内容」，页面 id 保持 `hyper-table`。此确认不替代四端实机逐项视觉验收。

## 基本用法

父布局提供有限宽高。列 id 和 `rowKey` 必须稳定且唯一；不要原地修改 columns 或 rows 列表，更新时传入新列表。

```dart
Expanded(
  child: HyperTable<Order>(
    columns: [
      HyperTableColumn(
        id: 'name',
        title: '名称',
        value: (row) => row.name,
        pin: HyperTableColumnPin.start,
        editable: true,
      ),
      HyperTableColumn(
        id: 'amount',
        title: '数量',
        value: (row) => row.amount,
        type: HyperTableColumnType.number,
      ),
    ],
    rows: orders,
    rowKey: (row) => row.id,
    onCellChanged: (change) {
      // 将 change.value 写回业务数据并传入新的 rows。
    },
  ),
)
```

## 审核功能

| 功能 | 当前入口与规则 |
| --- | --- |
| 固定列 | 列的 `pin`、表头右键菜单、controller.pinColumn；start/end 随文字方向解析 |
| 列拖动 | 列默认允许拖动，`reorderable` 可关闭；回调 `onColumnsReordered` |
| 行拖动 | `reorderableRows` 和 `onRowsReordered`；限本地、未分页、未排序的平面数据 |
| 多选 | `selectionMode`、`selectedKeys`、`onSelectionChanged`；复选框受控，全选只作用于当前可见行，跨页已选 key 保留 |
| 隐藏列 | 表头右键菜单或 controller.setColumnVisible；隐藏后可从其他表头恢复，至少保留一列数据 |
| 排序 | 点击表头或右键菜单；本地比较数值或文本，远程通过 query.sort 请求服务端 |
| 无限加载 | `dataMode: infinite` 与 loader；接近底部自动请求，也可点击加载更多 |
| 分页 | 本地使用 `paginateLocalRows`；远程使用 `dataMode: paginated`，loader 返回 total |
| 就地编辑 | 文本、数字列设置 editable 并提供 onCellChanged；编辑器复用 HyperTextField，键盘提交/取消沿用 Trina 编辑生命周期 |
| 斑马色 | `striped`；配色由主题管理 |
| 右键菜单 | 表头内建列操作；行菜单通过 rowContextMenuBuilder 提供 HyperMenuItem，支持长按与菜单键 |
| 调整列宽 | 拖动表头末尾的调整手柄，或 controller.setColumnWidth；用户宽度优先于随后更新的默认列宽 |
| 同步树形 | childrenBuilder；treeColumnId 指定展开列，默认第一列 |
| 异步子级 | childrenLoader、hasChildren；逐行加载、缓存、失败重试与请求过期保护 |

行拖动、排序后的顺序和服务端全量顺序是不同职责。当前不会把已排序或某一页的显示顺序误写为全量数据顺序。树形行拖动暂不开放。

## 分页与无限加载

loader 接收 page（从 1 开始）、pageSize、cursor 和 sort，返回 `HyperTablePage<T>`。分页模式必须返回总根节点数 total；无限模式使用 hasMore 和可选 nextCursor。业务请求和持久化由使用方实现。正在请求时不会并发追加相同页面，排序和刷新使旧请求失效；失败后保留已加载内容并显示重试入口。

分页和无限加载是不同数据模式。同一表格不同时启用；本地分页只用于 local 模式。

## 树形与异步子级

```dart
HyperTable<Node>(
  columns: columns,
  rows: roots,
  rowKey: (node) => node.id,
  treeColumnId: 'name',
  hasChildren: (node) => node.hasChildren,
  childrenLoader: (node) => repository.children(node.id),
)
```

同步树使用 childrenBuilder。异步结果按 rowKey 缓存，收起不会丢弃已加载子级；controller.reload 清理子级缓存，已展开节点重新请求。收起与卸载后的请求不会强制展开节点；刷新前的子级响应不会覆盖刷新结果。

expandedKeys 为 null 时由组件管理展开；传入集合时由调用方结合 onExpandedChanged 管理。树形排序只重排同级，子节点紧随父节点；远程根节点顺序以 loader 结果为准，子级在本地按当前 sort 比较。分页单位为根节点，展开子行不占用根节点页数。父子行独立选择，不隐式级联。

## 主题和尺寸

全局 `tableTheme`、局部 `HyperTableTheme` 与实例 `HyperTableStyle` 逐字段覆盖，文本深合并。尺寸集中在四端 `sizes.table`。单元格编辑器可通过 Style.editorStyle 覆盖，滚动条通过 Style.scrollbarTheme 覆盖。文字跟随系统 TextScaler，行与表头的实际高度至少容纳缩放后的单行文字及内边距；长文字单行省略，自定义单元格负责自己的内容布局。

表面复用 HyperMaterialSurface，材质质量、默认配方和降级继承统一材质主题。行状态过渡使用 Motion，固定列与主体共享同一悬停身份。菜单复用 HyperContextMenu 和公共菜单表面。分页复用 HyperPagination。

编辑器尺寸按设备、外观按亮暗保存，提供表头、单元格、列布局、树形缩进、行状态和表面分组。像素编辑写入整数，恢复继承、导入导出与其他组件使用同一文档机制。

## 当前审核边界

此版本供功能与默认外观审核，尚未经用户确认。没有进行实机截图对照，也没有宣称与旧版视觉一致。暂不提供树节点跨父级拖动、父子级联勾选、多列联合排序、编辑远程事务回滚或无限数据的「选择全部查询结果」。


## 自动验证记录

2026-10-21：组件回归 12 项、编辑器回归 3 项通过，覆盖主题复制/合并/插值、四端尺寸、局部与实例覆盖、受控多选、列布局保留、列宽拖动、文本编辑提交、树形排序和根节点分页、短视口无限加载、异步子级重试/缓存/加载中收起、过期根请求，以及配置导入恢复和整数像素写入。窄宽文字缩放覆盖 1.0、1.3、2.0 倍。这不表示用户已确认默认外观或四端实机效果。


### 表头与行状态审核修复（2026-10-21）

表头统一在网格背后绘制一次，覆盖选择列、拖动列、固定列与剩余区域；显式半透明背景不会被各列重复叠加。移除底层默认网格内缩和表头竖线，表头与内容共用水平内边距。选择及行拖动列固定在起始侧，拖动单元格不再显示内部空值。

默认斑马底色为 surface 与 surfaceMuted 的中间色；悬停色为 primary 按全局 Material 悬停层强度覆盖 surface，选中色仍使用 primaryContainer。这是 D 级语义推导配方，组件与编辑器共用解析；局部和实例覆盖保持优先。斑马背景固定绘制，悬停及选中层独立淡入淡出，避免透明黑色参与 RGB 插值造成中间帧变暗。

新增 4 项表面回归：表头跨区域背景一致及文字对齐、半透明表头单次混合、亮暗模式下悬停与斑马色区分、进入/跨固定列/换行/离开行的中间帧连续性。使用同一 1000×420 逻辑尺寸生成修复前后对照图；该对照确认上述缺陷，不表示已对用户截图的未知显示缩放精确还原。

表格选择框的可见尺寸跟随 table.iconSize（不超过控制列宽），标记、描边与圆角按同端 Checkbox 规格同比缩小；点击范围仍使用控制列宽，避免直接套用独立 Checkbox 的较大视觉尺寸。表头与行选择框共用此解析。

行排序从专用手柄启动，拖动预览在按下手柄时截取当前行的实际渲染结果，保留可见区域的固定列、横向滚动位置、列宽、文本对齐、自定义单元格及选择框样式，不再另行拼装一套预览单元格。截图按当前设备像素比生成，拖动结束或卸载后释放。预览阴影渐入，目标行显示落点提示过渡，松手后通过网格行移动接口提交顺序；过渡继承表格 Motion 并遵守减少动画设置。

启用 selectionMode 且提供 onSelectionChanged 时，普通单击数据单元格选择对应整行；multiple 模式支持 Ctrl 切换单行、Shift 按当前显示顺序连选。复选框仍可独立增减选中项；单元格焦点和就地编辑保持原有职责，整行高亮与复选框统一由 selectedKeys 驱动。

就地编辑直接继承 HyperTextField 的全局及局部输入框主题（背景、边框、圆角、阴影、字体与状态），表格仅提供行高约束和列文字对齐。table Style.editorStyle 继续作为显式实例覆盖入口。


### 自定义表格编辑器

表格编辑与独立就地编辑控件分别保留。列设置 editable: true，并提供 editorBuilder 即可替换表格编辑器；cellBuilder 仍只负责非编辑态展示。未指定 editorBuilder 时使用统一 HyperTextField 主题。

```dart
HyperTableColumn<Record>(
  id: 'name', title: '名称', value: (row) => row.name,
  editable: true,
  editorBuilder: (context, edit) => HyperTextField(
    controller: edit.controller,
    focusNode: edit.focusNode,
    onSubmitted: edit.commit,
  ),
)
```

HyperTableEditContext 提供行、稳定行标识、列标识、当前值、文本控制器、焦点节点及 commit(value)/cancel()。选择器等非文本控件可直接调用 commit(value)，仍通过 onCellChanged 通知业务保存；值遵守当前列的 text/number 转换。控制器和焦点节点由表格管理，自定义编辑器不可释放它们。显式取消恢复原值并退出编辑；异步编辑器应在会话仍有效时提交。

默认文本编辑器点击外部或失焦后提交并退出，恢复单元格展示；自定义编辑器自行通过 commit/cancel 结束会话，避免下拉浮层打开时被误判为结束编辑。Demo 的“部门 · 下拉编辑”列提供设计、研发、产品三个选项，选择后提交到数据源；名称和数量仍使用默认输入框。

可通过 hoverLift 开启整行悬停浮起（默认关闭），Demo 提供开关。悬停与拖动预览共用 HyperTableStyle.rowBoxShadow，可由全局、局部或实例覆盖，空列表显式关闭阴影。默认阴影复用公共菜单表面的语义阴影配方；浮起仅通过阴影表达层次，不改变行的位置、尺寸或缩放；过渡使用表格 Motion 并遵守减少动画设置。

悬停浮起阴影由表格顶层统一绘制，跨固定列与主体，避免列表相邻行的绘制顺序遮盖阴影。仅绘制行外阴影，不覆盖行内控件、不参与命中；滚动时清理旧位置，拖动期间关闭悬停阴影。

表格设置工作区已按表头、单元格、列布局、树形层级、编辑器、动效、行状态、浮起表面和表格表面重组。浮起圆角按设备保存，浮起颜色、阴影和动画时长按亮暗配置保存；历史 editingBackground 导入保留，但不再显示失效的编辑底色入口。编辑器外观通过统一输入框主题编辑。


### 列宽模式

列通过 widthMode 选择布局，所有模式均遵守 minWidth：

- fixed（默认）：使用 width，省略时继承主题默认列宽。
- content：按表头及当前已加载行的文本测量，计入内边距及表头操作图标；异步加载后重新计算。自定义 cellBuilder 的复杂内容仍按 value 文本估算，需要精确控制时指定固定宽度。
- flex：按 flex 权重分配固定列、内容列及控制列之外的剩余空间。相同权重平分，空间不足时保持各列最小宽度并横向滚动。

```dart
HyperTableColumn(id: 'id', title: '编号', value: (row) => row.id,
  width: 96, minWidth: 64),
HyperTableColumn(id: 'name', title: '名称', value: (row) => row.name,
  widthMode: HyperTableColumnWidthMode.content, minWidth: 120),
HyperTableColumn(id: 'summary', title: '说明', value: (row) => row.summary,
  widthMode: HyperTableColumnWidthMode.flex, flex: 1, minWidth: 160),
```

手动拖宽或 controller.setColumnWidth 后，该列保留用户宽度，其他 flex 列重新分配。隐藏列不占空间；窗口尺寸改变、显示隐藏列及数据更新后重新布局。自适应不额外请求未加载的远程数据。Demo 混合展示固定、内容自适应和 1:2 剩余空间分配。

Demo 提供正常数据、暂无数据、持续加载、加载失败/重试和业务自定义空态切换。加载与错误通过真实 loader 流程呈现，退出持续加载会释放等待请求；自定义空态使用 empty 参数，可包含“清除筛选”等可交互操作，空态区域不覆盖表头。

加载失败区分首屏与已有数据：无数据时在表头下方居中显示错误及重新加载；有数据时保留行内容，底部显示失败提示与重试。重试保留失败请求的刷新/追加语义，避免无限加载刷新失败后错误追加旧数据。

可设置 showPagination: false 隐藏内置分页栏，保留本地/远程分页行为，通过 HyperTableController.goToPage(page) 从外部分页器切页。外部分页器的当前页及业务总数由调用方管理。

外部分页同步可使用 onPageChanged(page)，页码从 1 开始，仅接受有效切页后通知；刷新回到第一页时也通知页码变化。onRefreshRequested 通知 reload 请求（初始化或排序触发 reload 时同样会通知），远程请求仍由 loader(query) 唯一执行；query.refresh 表示从第一页刷新，false 表示普通切页/追加。不要在通知回调和 loader 中重复发起同一请求。

无限加载返回 hasMore: false 且已存在数据时，底部显示“没有更多数据了”。可通过 noMore 参数传入自定义 Widget；传入 SizedBox.shrink() 可替换为无内容。加载中、失败及空数据时不显示该结束提示。

无限模式的加载更多、追加进度、追加失败重试及结束提示附在最后一行之后，随内容滚动，不固定占据表格底栏。空数据/首屏失败仍在内容区居中，分页模式的分页栏保持独立底栏。

列排序从表头拖动，预览包含该列的表头和当前视口内容，复用行拖动的实际渲染截图、浮起圆角、边框与阴影动画。插入线贯穿可见内容高度；松手提交并通知 onColumnsReordered。同一固定区域内可重排，不跨起始固定区、主体和末尾固定区；选择及行拖动控制列不作为重排入口。


2026-10-28：竖向滚动条通过 Trina 的公开配置关闭其固定尾部占位，改用绑定 `bodyRowsVertical` 的 Flutter 原生覆盖式滚动条。自适应列宽不再扣除滚动条宽度，短表格也不会留下尾部空槽；长表格仍支持滚动条拖动。滚动条绘制范围避开表头与横向滚动条，外观继续由 `scrollbarTheme` 配置；没有修改 Pub 缓存或引入底层包补丁。
