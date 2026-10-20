# Form 实施规范（已确认实施方向）

整理日期：2026-10-19。用户已确认实施方向；首阶段核心与 Demo 已实现，默认样式仍处于未确认。

## 参考来源

主要参照本地 E:/lemon_shadcn：
- lib/src/components/forms/app_form.dart：AppForm、AppFormController、AppFormFieldBinding、提交错误摘要。
- lib/src/components/forms/app_field.dart：字段作用域、横竖布局、标签、必填标识、说明与错误呈现。
- test/app_form_controller_test.dart：原生 Form 生命周期、异步结果失效、跨字段校验与修改状态。
- test/app_text_form_field_test.dart、app_select_form_field_test.dart、app_choice_form_fields_test.dart：现有控件的字段适配方式。

参考的是接口职责与交互规范；不直接移植 shadcn 的默认尺寸、颜色、密度倍率、固定错误高度或覆盖尾部内容的 Stack。

## 分类与实施范围

新建独立“表单”分类，用于 Form、Field、表单分组与各 FormField 的正式入口。
新控件的可交互 Demo 和主题编辑入口在用户确认前仍登记“未确认”，页面说明将目标类别标注为“表单”。用户确认后迁入“表单”，页面 id 不变。既有输入与选择控件保持当前分类，表单分类展示它们的表单适配，不重复实现基础控件。

第一阶段：HyperField、HyperFormField<T>、HyperFormController、HyperForm、表单错误摘要、完整组合 Demo。
第二阶段：文本、选择器、日期/时间/区间、Checkbox、Radio、Switch 等现有控件的薄适配；公共 builder 从第一阶段即支持任意自定义控件。
数字输入、上传、级联选择、表单弹窗和业务 schema 生成不是第一阶段前置条件。

## 布局

公开 HyperFieldLayout.vertical / horizontal / labelHidden 三种类型。
- vertical：标签在上、控件在下；说明与错误属于该字段，跟随其内容区域。
- horizontal：标签在行首，控件在其后；整张表单统一标签列宽、间距和对齐。说明及下方错误与控件起点对齐。
- labelHidden：不显示标签和必填星号，不保留标签占位；保留说明、错误与必填校验。标签或 semanticLabel 仍提供完整语义名称，占位文字不作为唯一名称。

此处横排指标签与控件横排，不表示所有字段挤进一行。多字段横排/多列由独立 HyperFormSection 布局组合，字段本身不持有整张表单的列数。
布局可在 Form 统一配置，字段实例可显式覆盖。默认 vertical；显式 horizontal 不因设备名称直接改变。可用宽度不足以保留标签列、间距和控件最小可用宽度时重排为 vertical，不改变真实设备类别。长标签、说明、错误允许换行；不固定字段高度、不截断 TextScaler。

“无标题”不等于 bare：字段不会擅自移除子控件背景、边框或圆角。是否需要无表面控件作为后续独立外观配置讨论。

## 单值与摘要文字

表单触发器中的单个已选值、日期时间及区间摘要、颜色值、列表尾部选择值和上传文件名，
默认复用 HyperScrollingText 的单行悬停滚动，超长内容不通过换行撑高；移开后复位。
减少动画时停止自动滚动，仍可横向拖动查看完整内容。此规则不固定控件高度、不关闭或
裁切系统文字缩放，行高随当前字形自然增高。表单适配层复用基础控件，不重复实现该行为。

多行文本输入、说明、校验错误、选项描述和多选标签保持各自的换行职责；通用下拉中
调用方传入的自定义 label Widget 保留明确指定的布局，包括多行内容，不被隐式改写。

## 组件职责与接口方向

HyperField 只处理字段外部呈现：label、semanticLabel、description、requiredIndicator、errorText、layout、Style、child；不持有值、触发校验或提交。
HyperFormField<T> 复用 Flutter FormField<T> 生命周期：initialValue、validator、onSaved、onReset、enabled、autovalidateMode，并提供 builder 中的 value、didChange、errorText、validation 状态。自定义控件通过 builder 接入，不要求继承特殊基类。
各具体 FormField 只组合现有 Hyper 控件与上述字段层，不复制绘制、日期范围计算、清空、焦点或浮层逻辑。
HyperForm 组合原生 Form 与配置作用域，不额外创建独立表面；表单分组和操作区由调用方组合。
HyperFormController 管理具名字段注册、值读取、校验、save/reset、dirty/touched、提交状态和提交错误；创建方负责 dispose。一个 controller 同时只挂载一张 Form，嵌套 Form 保持独立作用域。

name 为稳定唯一的字段标识，重复 name 抛出可定位错误；字段卸载时解除注册，卸载字段不再参与值集合和校验。未具名字段仍可参与原生 Form 生命周期，不进入具名取值与跨字段字典。
字段值保留 T；控制器提供 value<T>(name)。具名值快照可采用 Map<String,Object?>，它是表单数据而不是主题注册表；主题仍全部使用强类型字段。

## 值、清空与恢复

第一阶段以原生 FormField 的 initialValue + didChange 管理本地编辑状态，onChanged 通知调用方；不同时引入 value 与 initialValue 两套可能竞争的真值。已有受控基础组件通过字段 builder 接入。
空值遵守具体字段类型：可空日期/选择器清空为 null，集合型字段为空集合，文本为空字符串；不统一强制转换，不把 false 或 0 判定为空。
initialValue 不是每次 rebuild 强行覆盖当前编辑值。reset 恢复当前字段配置的 initialValue，清除 touched、校验与提交错误，同时失效旧异步请求。
markClean 把当前值快照设为 dirty 比较基准，不改变 reset 的初始值。List/Map/Set 采用稳定快照比较；自定义值可提供 equality/snapshot 适配，不能假定任意业务对象可深复制。
禁用字段保留其值并正常出现在提交快照中，但默认跳过交互校验；只读字段保留校验。隐藏字段是否保留由挂载/卸载决定，不引入隐式数据删除策略。

## 校验与错误呈现

支持同步 validator、异步 asyncValidator、跨字段 crossValidators。
默认 AutovalidateMode.disabled，提交时完整校验；可显式设置 onUserInteraction/always。requiredIndicator 只是外观标识，不隐式推断任意 T 的空值规则，必填通过明确 validator 定义。
单字段优先显示同步错误，再显示异步错误，最后是跨字段/服务端错误；同一字段只显示一份错误。修改关联值时清理旧外部错误，所有异步结果按字段值版本与 Form 校验版本判断有效性。
一次校验使用一致的值快照；校验期间字段修改、reset、卸载或发起新校验，旧结果不写回，也不能让旧提交通过。异步校验抛异常按异常处理，不误当通过或伪装成业务校验文本。

错误策略参考 AppFieldErrorDisplay：auto / inline / trailingIcon / below。
- auto：竖排且有标签时优先标签旁 inline；横排、无标签时优先复用控件原生错误入口，控件没有入口则使用 below。
- inline：与标签组成可换行标题区，长错误不会挤没标签或控件。
- trailingIcon：通过基础控件已有 errorText/errorBuilder 等接口呈现；无可用插槽时降级 below，禁止用额外 Stack 覆盖清空、密码、下拉或日期箭头。
- below：错误放在控件下，横排时与控件起点对齐。

所有错误都有完整语义与实时提示，不能只依赖鼠标 Tooltip；触摸端必须可触达。字段错误不重复由基础控件和 HyperField 显示。
表单级提交错误摘要使用可增高的文本/现有反馈组件，支持自定义 builder，不沿用参考中的固定 28 高度与单行省略。

## 提交、焦点和状态

submit 顺序：同步校验 → 通过字段的异步校验 → 跨字段校验 → 确认版本仍有效 → save → 提交不可变值快照。
controller 暴露 isValidating、isSubmitting、isDirty、dirtyFields、touchedFields、submitError；重复提交合并或拒绝，不能重复发请求。底部按钮 loading 直接复用 HyperButton。
校验失败时滚动到并聚焦首个可聚焦错误字段；关闭动画时仍能定位。纯选择型字段可以聚焦其触发器，不自动打开编辑弹窗。
Tab/Shift+Tab 沿阅读顺序；Enter 的提交由 Form 显式配置，不抢占多行换行、输入法组合文本、选择器确认、数字增减键。
reset 与异步提交的业务取消不同；重置使校验失效，但不伪称已取消外部网络请求。提交异常保留用户输入，不默认重置、不弹业务成功提示。

## 主题与四端

集中加入 formTheme / fieldTheme 与 HyperSizeScheme 的对应四端规格；局部 Theme、实例 Style 逐字段合并，系统级覆盖为强类型 copyWith。
尺寸包含标签列宽、字段间距、标签/说明/错误间距及分组/操作区间距；排版走当前端 Typography，颜色走 textPrimary/textSecondary/error。第一版默认值优先复用同端已确认的表单输入与列表语义，来源记为 D 级，不直接把参考项目 labelWidth=120、gap=8 认作官方规格。
Field 不复制子控件尺寸、边框、表面与材质配置。仅表单分组明确拥有表面时才提供表面配置，复用统一材质，不默认嵌套卡片。
编辑器设置按标签、内容布局、说明、错误、交互、表面组织；像素写入整数，几何上限集中维护；不提供行高倍率编辑入口。

## 验收与 Demo

Demo 同时展示横排、竖排、无标题；包括文本、选择器、日期时间、布尔项与自定义字段，覆盖中文长标签、空值清空、重置、异步校验、跨字段校验、提交失败与 dirty 状态。
必须验证 1.0/1.3/2.0 倍和窄宽、四端主题解析、键盘遍历、错误触达、重复 name、动态卸载、异步旧结果、重复提交与重置竞争。
确认顺序：先确认本规范 → 实现最小完整表单与测试 → 用户审阅默认样式 → 正式分类迁移。测试通过不构成样式确认。

