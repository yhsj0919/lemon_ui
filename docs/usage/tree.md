# 树

`HyperTreeView<T>` 展示通用层级数据；`HyperSidebar` 则用于页面导航，不共享选中/展开数据。每个节点需要全树唯一的 id，可以附带泛型 data、图标、尾部内容、禁用状态和静态子项。

## 静态数据

~~~dart
const HyperTreeView<String>(
  nodes: [
    HyperTreeNode<String>(
      id: 'project', label: Text('项目'),
      children: [
        HyperTreeNode<String>(id: 'readme', label: Text('README.md'), data: 'readme'),
        HyperTreeNode<String>(id: 'disabled', label: Text('禁用节点'), enabled: false),
      ],
    ),
  ],
)
~~~

父级提供有限宽度与滚动区。树按可见节点自然增长，不内置虚拟滚动；适用于中小规模树。长标题自然换行，不压缩文字。点击行选择节点，分支同时切换展开；selectable 为 false 时只展开，不选中。enabled 为 false 时不响应点击、键盘或加载。

键盘 Enter/Space 激活，方向上/下移动可见节点焦点，左右展开/收起或进入子级/返回父级，Home/End 到首尾；左右方向遵循 RTL。itemBuilder 可包装或替换默认行；保留 defaultItem 能沿用默认焦点、交互与语义。

## 点击展开后动态请求

~~~dart
HyperTreeView<String>(
  nodes: const [
    HyperTreeNode<String>(id: 'remote', label: Text('远程目录'), hasChildren: true),
  ],
  loadChildren: (node) async {
    return [
      HyperTreeNode<String>(id: '${node.id}/child', label: const Text('加载的子节点')),
    ];
  },
  onNodeTap: (node) { debugPrint('点击 ${node.id}'); },
)
~~~

没有静态子项时，hasChildren 标记可动态展开；配合 loadChildren 发起请求。返回完整直接子节点列表，也可以含静态或动态的更深层节点。静态 children 优先，不再调用 loader。

同一节点正在进行的请求被合并，不同分支可并行。成功后保留子节点，收起再展开不重新请求；空结果使节点成为叶节点。失败在对应分支下展示重试入口，异常可从控制器读取，errorBuilder 可替换展示。原始错误内容不默认展示。

收起只隐藏分支，不取消网络；请求完成不会强行展开。数据替换与控制器销毁使旧请求结果失效，但不取消调用方网络传输。动态结果必须全树 id 唯一，冲突被作为加载错误处理，不部分写入树。onNodeTap 可处理详情请求等其他业务；子树 loader 仅在需要展开子节点时运行。

## 控制器与数据生命周期

可传入 `HyperTreeController<T>(nodes: ..., loadChildren: ..., expandedIds: ..., selectedId: ...)` 管理树。外部控制器与 nodes/loadChildren 参数互斥，控制器由调用方 dispose。接口包含 select、setExpanded、ensureLoaded、replaceNodes、visibleEntries、childrenOf、loadState、errorFor、expandedIds 和 selectedId。

没有外部控制器时树自动创建并销毁内部控制器。传入新的 nodes 列表视为数据替换：清空动态缓存与加载状态，保留仍存在的展开/选中 id；保持列表实例稳定以保留缓存，或用外部控制器显式管理更新。原始节点列表由控制器递归快照，不受外部后续修改影响。

ensureLoaded 也可预加载，不自行展开；预设 expandedIds 的动态分支在组件接入时加载。replaceNodes 支持重置/刷新全部子数据，旧请求结果不写回。控制器通知可监听；直接操作控制器不会额外触发组件的用户操作回调。

## 主题与统一间距

~~~dart
HyperTreeViewTheme(
  data: const HyperTreeViewThemeData(
    style: HyperTreeViewStyle(rowSpacing: 6, selectedForegroundColor: Colors.blue),
  ),
  child: const HyperTreeView<String>(
    nodes: [HyperTreeNode<String>(id: 'one', label: Text('节点'))],
  ),
)
~~~

全局 `HyperThemeData.treeViewTheme`、局部 `HyperTreeViewTheme`、实例 Style 按显式字段覆盖，文字深合并。四端默认尺寸由 HyperSizeScheme.treeView 管理；基础行间距继承 navigationItemSpacing（默认 4）。treeView.rowSpacing 或 Style.rowSpacing 可单独覆盖，0 表示紧贴。

Style 包含行高、缩进、图标尺寸、内容间距、内边距、圆角、各状态填充/文字色、焦点色、加载/错误图标及文字、空状态文字、背景、边框和材质。全局材质配方、质量及降级策略由统一 HyperMaterialTheme 管理，绘制复用 HyperMaterialSurface。

默认展开/收起为高度过渡，箭头、填充与文字遵守 Motion 和系统减少动画设置。duration、curve、transitionBuilder 和 expansionTransitionBuilder 可通过主题或实例覆盖。反馈加载图标复用统一 Progress 配置；retry 按钮可通过 Button 主题或 errorBuilder 调整。

Gallery「文字与内容 → HyperTreeView」提供静态树、嵌套请求、首次失败重试、空结果、请求次数、重置缓存、禁用、长标题、局部主题和减少动画示例。当前视觉为 D 级同端 Sidebar 语义推导，未获得可核对的同代 HyperOS 或 HIUI 树规格；没有进行设备或 Widget 运行验证。
