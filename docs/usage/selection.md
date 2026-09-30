# 操作与选择

[返回目录](README.md) · 以下固定值展示结构，实际交互按快速开始更新 State。

## HyperButton 按钮

~~~dart
HyperButton.filled(
  label: const Text('保存'),
  icon: const Icon(Icons.save_outlined),
  onPressed: () async {
    // await 保存操作；返回 Future 时按钮会显示加载态。
  },
  onError: (error, stackTrace) {
    // 在应用中展示错误或记录日志。
  },
)
~~~

入口 filled/tonal/outlined/ghost/text/gradient。
label 和 child 必须二选一；icon 与 label 配合使用，iconAlignment 控制前后。
size 用 HyperButtonSizeVariant；onPressed: null 为禁用。
loading 可外部控制，progress 提供确定进度，loadingIndicator 替换加载内容。
异步操作应返回 Future<void>，按钮等待期间避免重复操作；onError 处理异常。
全局 buttonTheme、局部 HyperButtonTheme、实例 HyperButtonStyle；
支持 HyperFill、材质、字体、边框、状态层、圆角、尺寸和 Motion。
[源码](../../lib/src/components/button/hyper_button.dart) ·
[Style](../../lib/src/components/button/hyper_button_style.dart)。

## HyperIconButton 图标按钮

~~~dart
HyperIconButton.outlined(
  icon: const Icon(Icons.add),
  tooltip: '新建',
  onPressed: () {},
)
~~~

filled/tonal/outlined/ghost 四种入口；icon 是 Widget。
tooltip 提供说明，onPressed: null 禁用；支持异步、loading、loadingIndicator、onError。
全局 iconButtonTheme、局部 HyperIconButtonTheme、实例 HyperIconButtonStyle。
[源码](../../lib/src/components/icon_button/hyper_icon_button.dart)。

## HyperChip 交互标签

~~~dart
Wrap(
  spacing: 8,
  children: [
    HyperChip.action(label: '刷新', onPressed: () {}),
    HyperChip.choice(label: '文档', selected: true, onSelected: (value) {}),
    HyperChip.filter(label: '收藏', selected: false, onSelected: (value) {}),
    HyperChip.input(label: '附件', onDeleted: () {}),
  ],
)
~~~

| 入口 | 用途 |
| --- | --- |
| action | 执行操作，onPressed |
| choice | 单选选项，父级负责互斥 |
| filter | 多选过滤，父级负责集合 |
| input | 已输入值，支持独立删除和可选选择 |

selected 为受控值；onDeleted 只通知应用，不自行移除、不改变选中。
icon/avatar 互斥；showCheckmark 控制选中对勾。删除目标有独立焦点。
普通 HyperChip 可组合操作/删除，但 onPressed 与 onSelected 互斥。
enabled 禁用；没有对应回调的入口不产生有效交互。
全局 chipTheme、局部 HyperChipTheme、实例 HyperChipStyle，
支持普通、selected、hovered、focused、pressed、disabled 样式逐字段叠加。
[源码](../../lib/src/components/chip/hyper_chip.dart) ·
[Demo](../../example/lib/pages/selection/hyper_chip_page.dart)。

## HyperSegmentedButton 分段按钮

~~~dart
HyperSegmentedButton<String>(
  segments: const [
    HyperSegment(value: 'list', label: '列表', icon: Icon(Icons.view_list)),
    HyperSegment(value: 'grid', label: '网格'),
    HyperSegment(value: 'detail', label: '详情', enabled: false),
  ],
  selected: {'list'},
  onSelectionChanged: (values) {},
)
~~~

默认单选且不可清空；multiSelectionEnabled 多选，emptySelectionAllowed 允许清空。
值必须唯一、选中值须存在，默认需要至少一项选中。回调集合不可修改，应用保存新集合。
enabled 整体禁用；HyperSegment.enabled 禁用单项。
expanded 等分横向宽度（需有限宽度）；单项 width/flex 互斥。direction 支持纵向。
showSeparators 控制分隔线。默认中性选中背景，使用主题替换为品牌色。
全局 segmentedButtonTheme、局部 HyperSegmentedButtonTheme、
实例 HyperSegmentedButtonStyle.group / button / selectedButton 复用分组与按钮样式。
连接模式由组管理圆角和边框；页面导航请使用 Tab。
[源码](../../lib/src/components/segmented_button/hyper_segmented_button.dart) ·
[Demo](../../example/lib/pages/selection/hyper_segmented_button_page.dart)。

## HyperCheckbox 复选框

~~~dart
HyperCheckbox.rounded(
  value: true,
  onChanged: (value) {},
  semanticLabel: '同意条款',
)
~~~

默认与 .circle 为圆形，.rounded 为圆角方形；tristate: true 允许 value: null。
onChanged: null 禁用；有可见标题时可使用 HyperCheckboxListTile 整行点击。
全局 checkboxTheme、局部 HyperCheckboxTheme、实例 HyperCheckboxStyle。
[源码](../../lib/src/components/checkbox/hyper_checkbox.dart)。

## HyperRadio 单选按钮

~~~dart
HyperRadio<String>.checkmark(
  value: 'auto',
  groupValue: 'auto',
  onChanged: (value) {},
  child: const Text('自动'),
)
~~~

.circle/.filled/.checkmark 提供不同选中视觉；默认构造器使用自身默认变体。
value 标识本项，groupValue 是当前值；应用统一更新 groupValue。
toggleable 可取消选中，回调可能为 null；onChanged: null 禁用。
child/spacing 可组合内容，也可使用整行 HyperRadioListTile。
全局 radioTheme、局部 HyperRadioTheme、实例 HyperRadioStyle。
[源码](../../lib/src/components/radio/hyper_radio.dart)。

## HyperSwitch 开关

~~~dart
HyperSwitch(
  value: true,
  onChanged: (value) {},
  semanticLabel: '开启同步',
)
~~~

value 为 bool，onChanged: null 禁用；整行使用 HyperSwitchListTile。
全局 switchTheme、局部 HyperSwitchTheme、实例 HyperSwitchStyle 管理轨道、滑块、
颜色和过渡，不需要叠加 Material Switch。
[源码](../../lib/src/components/switch/hyper_switch.dart)。

## HyperSlider 单值滑块

~~~dart
HyperSlider(
  value: .4,
  onChanged: (value) {},
  divisions: 10,
  showDivisionPoints: true,
)
~~~

默认 min/max 为 0/1，value 必须在范围内；onChanged: null 禁用。
variant: HyperSliderVariant.thin 为细轨道，默认 capsule 为宽轨道。
divisions 是区间数；snapToDivisions: true 吸附。
只显示刻度但连续滑动：divisions 设置区间数，showDivisionPoints: true，
snapToDivisions: false。onChangeStart/onChangeEnd 可开始/结束编辑或提交业务值。

## HyperRangeSlider 范围滑块

~~~dart
HyperRangeSlider(
  values: const RangeValues(.2, .8),
  onChanged: (values) {},
  variant: HyperSliderVariant.thin,
)
~~~

values 使用 Flutter RangeValues，start ≤ end 且均在 min/max 范围。
支持与单值相同的步进、点、细轨道和禁用配置。
拖动越过另一滑块时交换起止角色，回调仍保持有序范围。

## HyperVerticalSlider 垂直滑块

~~~dart
HyperVerticalSlider(
  height: 180,
  value: .6,
  onChanged: (value) {},
  divisions: 5,
  showDivisionPoints: true,
)
~~~

height 必填；默认向上增加，reverseDirection 可反转。
同样支持范围、步进、刻度和细轨道，但它是单值组件，不是垂直 RangeSlider。

## HyperCapsuleSlider 胶囊进度调节

~~~dart
HyperCapsuleSlider(
  height: 180,
  value: .6,
  onChanged: (value) {},
  topIcon: const Icon(Icons.more_horiz),
  bottomIcon: const Icon(Icons.brightness_6),
  onTopIconPressed: () {},
  onBottomIconPressed: () {},
  style: const HyperSliderStyle(
    capsuleCornerRadius: 20,
    capsuleAutoIconContrast: true,
    capsuleBottomIconTurns: .5,
  ),
)
~~~

适用于音量、亮度等；上下图标接受 Widget，并有独立点击回调。
拖动调节进度，点击轨道不直接跳变；越界反馈以阻尼偏移为主。
capsuleBottomIconTurns / TopIconTurns 控制跟随进度的旋转圈数；
自动反色作用于继承 IconTheme 的图标，自带固定颜色的子组件需自行配合。
四种滑块统一用 sliderTheme / HyperSliderTheme / HyperSliderStyle。
[滑块源码](../../lib/src/components/slider/hyper_slider.dart) ·
[胶囊源码](../../lib/src/components/slider/hyper_capsule_slider.dart) ·
[完整 Demo](../../example/lib/pages/selection/hyper_slider_page.dart)。