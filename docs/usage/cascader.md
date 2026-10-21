# 级联选择

`HyperCascader<T>` 是受控单选器，`value` 和 `onChanged` 使用从根到末级的完整值路径。
根节点通过 `nodes` 提供，每个 `HyperCascaderNode<T>` 包含 `value`、文字 `label`、
可选首部 `leading`、静态 `children`、动态分支标记 `hasChildren` 和 `enabled`。
节点值必须全树唯一且具有稳定的相等性；传入的数据列表应视为不可变配置。

```dart
HyperCascader<String>(
  nodes: const [
    HyperCascaderNode(value: 'zhejiang', label: '浙江省', children: [
      HyperCascaderNode(value: 'hangzhou', label: '杭州市', children: [
        HyperCascaderNode(value: 'xihu', label: '西湖区'),
      ]),
    ]),
  ],
  value: selectedPath,
  onChanged: (path) => setState(() => selectedPath = path),
)
```

锚定呈现复用菜单的多级浮层：悬停或点击分支在右侧展开子级，祖先选项保持可见，
切换同级分支会关闭旧后代；空间不足时沿用菜单的边界翻转。重新打开先展示根级，
已选路径保留高亮。手机的模态呈现使用多级联动滚轮，上一级变化时重建后续级别，
滚动只改变草稿，点“确定”才提交完整路径；取消不改变值。手机标题与清空同排，清空默认
使用主题主色且立即清空并关闭。平板及手表的模态呈现保留逐级页面和单个返回按钮，
不再把祖先路径排成可换行的按钮组；这些列表以及桌面菜单点击末级后直接提交。
关闭、返回和加载失败均不改变选择；清空发出空列表。`allowClear: false`
隐藏清空入口；`enabled: false` 或 `onChanged: null` 禁用组件。外部更新 `value`
会同步触发器及打开的面板，不在组件内部保存第二份已选值。无法解析的历史路径仍保留，
未知项通过 `labelBuilder` 或值的文字表示展示，不自动清空历史数据。

## 动态分支

设置 `hasChildren: true` 的节点在进入时调用 `loadChildren(path)`，参数包含父节点在内的
完整节点路径。静态 `children` 优先；已成功加载的结果在当前数据源生命周期内缓存，
空结果也缓存并展示空态，不自动把分支改成可选末级。没有提供 loader 的动态分支展示错误，
不会误提交。失败可重试，同一节点的进行中请求合并；切换分支时旧请求只填充自身缓存，
不会改变当前浏览位置。锚定呈现按展开的分支加载，加载、失败和重试留在该子面板内；
手机滚轮打开时沿已选路径加载缺失的祖先，未选择的级别展示首个启用项但不自动提交；
禁用项不进入滚轮，无可选末级或加载失败时不可确认。切换父级会忽略旧分支恢复请求，
返回的结果只进入对应缓存。其他模态列表重新打开会沿已选路径加载缺失的祖先。
手机滚轮的加载、失败重试及空态占据父级之后的下一列，与父级滚轮居中并排，
不放在整个滚轮区域下方；确认在子级尚未有效解析时保持禁用。

替换 `nodes` 或 `loadChildren` 会重建浏览模型并清除缓存；旧请求完成后被忽略。
关闭面板会停止异步路径恢复，但不取消调用方的网络请求。loader 不应在每次 build 中
创建新闭包；可使用稳定的方法引用。远程数据尚未读取时用 `labelBuilder` 提供已选项名称。

## 呈现、键盘和无障碍

复用 `HyperDropdown`、`hyperResolveSelectPresentation` 和统一选择面板呈现接口。
desktop 默认锚定浮层；phone/tablet 默认底部弹窗；watch 默认全屏页。设备类别不随
窗口宽度改变，实例 `presentation` 可使用 `HyperSelectPresentation` 显式替换。

菜单上下键移动，Enter/Space 激活；锚定菜单的右方向键展开子级，左方向键收回当前子级，
Escape 逐级关闭浮层。模态呈现向后方向键返回父级（LTR 为左，RTL 为右），
并沿用宿主返回与关闭行为。返回按钮、清空和重试可通过
Tab 访问。加载、错误和空态提供 live region。文字跟随系统 TextScaler，长文字换行；
内容由共同面板滚动，不固定文字容器高度。

触发器中的完整路径复用 `HyperScrollingText` 保持单行，超长内容在鼠标悬停时滚动，
移开后复位，避免路径换行撑高。仍跟随系统文字缩放，单行高度随字形自然增高；
减少动画时停止自动滚动，并保留横向拖动查看及完整无障碍文字。

## 主题与尺寸

全局 `HyperThemeData.cascaderTheme` → 局部 `HyperCascaderTheme` → 实例
`HyperCascaderStyle` 按显式字段合并，支持 `copyWith`、插值和值相等。

- `selectStyle` 覆盖触发器、面板和统一选择交互配置，基础继承 Select/Selection 主题。
- `navigationStyle` 覆盖回退、清空及模态重试文字按钮；锚定子菜单中的重试复用菜单项主题。
- `branchIcon` / `backIcon` 可替换分支和回退图标，尺寸及颜色继承菜单/按钮语义。
- `wheelStyle` 覆盖手机各级滚轮，未指定字段继承 HyperWheelPickerTheme。
- `clearButtonStyle` 最后覆盖清空按钮，默认前景为主题主色，可覆盖颜色及其他按钮样式。
  默认 `contrastMode: standard` 保留主色，避免自动反色将强调操作替换为黑白；
  实例或局部主题仍可显式覆盖该策略。
- 实例 `surfaceStyle` 最后覆盖面板背景、材质、边框、圆角和阴影；空阴影列表明确关闭阴影。
- 动效默认取全局 Motion，减少动画时关闭；`selectStyle.selectionStyle` 的
  `duration`、`curve`、`transitionBuilder` 和 `feedbackTransitionBuilder` 可替换过渡。

不增加一套重复的设备尺寸常量：触发器及面板复用 `HyperSizeScheme.select` /
`selection`，选项复用 `menu`，导航按钮复用 `button`，导航间距复用
`navigationItemSpacing`。手机滚轮复用 `sizes.wheelPicker`，列间距复用 `menu.padding`，
多列按可用宽度平分，过多列以同端最小交互尺寸约束后横向滚动，不引入设备像素常量。
四端尺寸继续由同一主题系统解析。锚定表面经过
`resolveHyperMenuSurface`，底部弹窗使用统一 BottomSheet 表面，不叠加 Card；
材质质量、默认配方、降级和开合安全动画均继承公共基础设施。

Gallery 和主题编辑器入口为“选择控件 → 级联选择 Cascader”，id 为 `hyper-cascader`。
编辑器提供默认 Demo 预览以及 Select、Menu、Button 现有设置入口，不建立另一份尺寸或
表面配置存储；这些设置继续使用原有四端/亮暗存储、继承恢复和保存导入机制。

## 视觉来源与验证边界

2026-10-20 核查了 [HyperOS 官方产品资料](https://hyperos.mi.com/)及
[官方选择组件资料](https://dev.mi.com/xiaomihyperos/documentation/detail?pId=1874)，
未取得可直接采用的同代级联选择器逻辑尺寸或目标截图。
desktop 的主要对照入口为 [HIUI Cascader 源码目录](https://github.com/XiaoMi/hiui/tree/master/packages/ui/cascader)，
本次未成功取得该目录源码，因此不声称已核实或移植其数值及多列外观。
当前菜单式逐级浮层及模态列表的视觉为 D 级既有语义规格组合，单位为 Flutter 逻辑像素。
2026-10-20 按用户对层级混排的反馈改为右侧子菜单；四端默认样式仍待用户审核，
未宣称精确还原。

测试覆盖路径提交、分支隔离、重试缓存、数据替换及销毁、四端默认呈现、主题优先级、
表面显式覆盖、普通/高级材质中间帧和结束帧，以及窄宽下 1.0/1.3/2.0 倍文字。
已进行三级展开的布局渲染检查，未进行目标设备截图精确对照或实机验收；
多选、搜索和任意层级提交不属于当前版本。

## Form 适配

`HyperCascaderFormField<T>` 继承 `HyperFormField<List<T>>`，只组合既有级联选择器，
支持具名值收集、同步/异步校验、`onChanged`、`onSaved`、`onReset`、禁用和重置。
初始值默认空列表，清空也写入空列表；初始、变更和提交路径均复制为不可变 `List<T>`，
重置恢复原始路径并清除错误及修改状态。浏览、悬停、滚轮草稿和加载子节点不触发表单值变化。

```dart
HyperCascaderFormField<String>(
  name: 'region',
  label: '地区',
  nodes: regions,
  initialValue: const [],
  requiredIndicator: true,
  validator: (path) => path == null || path.isEmpty ? '请选择地区' : null,
)
```

放入绑定 `HyperFormController` 的 `HyperForm` 后，使用
`controller.value<List<String>>('region')` 读取实时路径，
`controller.submit((values) { ... })` 校验并收集类型保留的路径快照，
`controller.reset()` 恢复初始值。必填标记只负责视觉，校验规则由 validator 定义；
历史导入路径不被静默改写，如需验证路径完整性或远程权限，使用 validator / asyncValidator。

字段 `style` 控制标签、布局和错误样式；`cascaderStyle` 控制级联触发器与菜单，
`surfaceStyle` 最后覆盖浮层表面。`loadChildren`、`labelBuilder`、`allowClear`、
呈现方式和路径文字选项均透传给底层控件，不建立第二套主题或设备常量。
禁用字段沿用公共表单的跳过校验行为，旧异步校验在值变更或重置后失效。
当前“选择控件 → 级联选择 Cascader”页面包含必填、提交和重置演示，已于 2026-10-21 经用户确认迁移至正式分类。
