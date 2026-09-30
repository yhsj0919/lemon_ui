# 基础内容

[返回目录](README.md) · 示例按目录约定导入包。

## HyperText 文字

~~~dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: const [
    HyperText('页面标题', variant: HyperTextVariant.pageTitle),
    HyperText('正文内容', maxLines: 2, overflow: TextOverflow.ellipsis),
  ],
)
~~~

variant 选择语义字阶；style 是 Flutter TextStyle，可改字重、颜色、字号。
默认 body 继承父级 DefaultTextStyle，便于跟随按钮或列表前景。
textAlign、strutStyle、textScaler、semanticsLabel 与原生 Text 对应。
全局入口 textComponentTheme，局部 HyperTextTheme。
[源码](../../lib/src/components/text/hyper_text.dart)。

## HyperIcon 图标

~~~dart
Row(
  children: const [
    HyperIcon(Icons.settings_outlined),
    HyperIcon.widget(Icon(Icons.star), color: Colors.amber, size: 20),
  ],
)
~~~

原生 IconData 用位置参数，自定义 Widget 用 .widget；后者通过 IconTheme 接收样式，
自己写死颜色的子组件不会自动跟随。states 可显式提供选中、禁用等状态。
全局 iconTheme、局部 HyperIconTheme、实例 HyperIconStyle；
color/size 等直接参数优先。
[源码](../../lib/src/components/icon/hyper_icon.dart)。

## HyperAvatar 头像

~~~dart
Row(
  children: const [
    HyperAvatar(text: '陈'),
    HyperAvatar(icon: Icon(Icons.person)),
    HyperAvatar(
      image: NetworkImage('https://example.com/avatar.png'),
      text: '陈',
      shape: HyperAvatarShape.rounded,
    ),
  ],
)
~~~

image 接受 ImageProvider；示例 URL 是占位地址，请替换实际图片。
可使用 AssetImage，资产由应用在 pubspec.yaml 声明。
图片失败时回退到文本/图标；child 用于完全自定义内容。
size 使用 HyperAvatarSizeVariant，实例 style.size 可指定逻辑尺寸。
[源码](../../lib/src/components/avatar/hyper_avatar.dart) ·
[Style](../../lib/src/components/avatar/hyper_avatar_style.dart)。

## HyperAvatarGroup 头像组

~~~dart
HyperAvatarGroup(
  avatars: const [
    HyperAvatar(text: '陈'),
    HyperAvatar(text: '李'),
    HyperAvatar(text: '王'),
    HyperAvatar(text: '赵'),
    HyperAvatar(text: '林'),
    HyperAvatar(text: '吴'),
  ],
  layout: HyperAvatarGroupLayout.circle5,
  maxVisible: 5,
  groupSize: const Size(120, 120),
)
~~~

| layout | 使用场景 |
| --- | --- |
| horizontal / vertical | 横向/纵向重叠，style.overlap 调整叠放程度 |
| row | 不重叠的一排，style.spacing 调整间隔 |
| circle5 / centered | 五角环形 / 中心加外围头像 |
| grid4 / grid9 | 四宫格 / 九宫格，不必提供满格数量 |
| mosaic | 自适应宫格，mosaicColumns 设置列数 |
| blended / windmill | 主色混合 / 水滴风车 |
| custom | layoutBuilder 返回 HyperAvatarGroupGeometry |

groupSize 调整整体大小，内部按参考几何等比适配；overflowBuilder 替换 +N。
自定义 slots 必须为画布内的有限正方形，画布尺寸也必须有限且为正。
[源码](../../lib/src/components/avatar/hyper_avatar_group.dart) ·
[Demo](../../example/lib/pages/content/hyper_avatar_page.dart)。

## HyperBlendedAvatar 混色与风车头像

~~~dart
HyperBlendedAvatar(
  avatars: const [
    HyperAvatar(text: '陈'),
    HyperAvatar(text: '李'),
    HyperAvatar(text: '王'),
  ],
  colors: const [Colors.blue, Colors.teal, Colors.orange],
  groupSize: const Size(80, 80),
  style: const HyperAvatarStyle(
    blendVariant: HyperAvatarBlendVariant.windmill,
    blendPetalOpacity: .72,
  ),
)
~~~

colors 可直接给主色；不提供时从头像图片/背景提取候选颜色。
smooth 为环绕混色渐变，windmill 为相互叠放的水滴，无方形底板。
blendPetalRotation 单位为弧度，blendPetalOpacity 为不透明度；
描边、阴影、柔化、渐变、整体外形和内容均可覆盖。
头像和头像组统一使用 avatarTheme / HyperAvatarTheme / HyperAvatarStyle。
[源码](../../lib/src/components/avatar/hyper_blended_avatar.dart)。

## HyperBadge 与 HyperBadgeAnchor 徽标

~~~dart
HyperBadgeAnchor(
  child: const HyperIcon(Icons.notifications_outlined),
  badge: const HyperBadge.number(count: 128),
  position: HyperBadgePosition.topRight,
  offset: const Offset(2, -2),
)
~~~

- HyperBadge() 是圆点；label 是短文本；content 是完全自定义徽标内容，三者互斥。
- .number 默认最多显示 99+；使用 HyperBadge(count: ..., maxCount: 999) 改上限。
- 0 默认隐藏，showZero 可显示；visible 控制显示。
- Anchor 提供九宫格位置：topLeft/topCenter/topRight、centerLeft/center/centerRight、
  bottomLeft/bottomCenter/bottomRight；位置为物理方位，正偏移向右/下。
- 应包住实际图标，再把整体放进按钮；包住大点击容器会按容器边界定位。
- Anchor 中徽标忽略指针事件，不能用它承载独立点击操作；注意父级裁剪。

全局 badgeTheme、局部 HyperBadgeTheme、实例 HyperBadgeStyle 配置颜色、文本、圆角和尺寸。
[徽标源码](../../lib/src/components/badge/hyper_badge.dart) ·
[定位源码](../../lib/src/components/badge/hyper_badge_anchor.dart)。

## HyperTag 标签

~~~dart
Wrap(
  spacing: 8,
  children: const [
    HyperTag(label: '文档'),
    HyperTag(label: '重点', variant: HyperTagVariant.emphasized),
    HyperTag(label: '已归档', enabled: false),
  ],
)
~~~

Tag 是展示标签，不提供点击、选择或删除行为；需要交互使用 HyperChip。
可传 icon；颜色、字体、边框、圆角与尺寸用 tagTheme / HyperTagTheme / HyperTagStyle。
[源码](../../lib/src/components/tag/hyper_tag.dart)。

## HyperDivider 分隔线

~~~dart
Column(
  children: const [
    HyperDivider(),
    SizedBox(height: 16),
    HyperDivider(
      pattern: HyperDividerPattern.dashed,
      child: Text('更多内容'),
      style: HyperDividerStyle(
        contentAlignment: HyperDividerContentAlignment.start,
        contentGap: 8,
      ),
    ),
    SizedBox(height: 16),
    SizedBox(height: 64, child: HyperDivider.vertical()),
  ],
)
~~~

支持 solid/dashed/dotted，color 或 gradient、thickness、length、indent/endIndent、
radius、dashLength/gap；渐变优先于纯色。
带 child 时需要有限主轴空间或明确 length。横向 start/end 随 RTL，纵向为上/下。
contentGap 是内容两侧间隔，edgeExtent 是偏侧内容的短线长度；
textStyle、iconSize/iconColor 可配置。
全局 dividerTheme、局部 HyperDividerTheme、实例 HyperDividerStyle。
[源码](../../lib/src/components/divider/hyper_divider.dart) ·
[Demo](../../example/lib/pages/content/hyper_divider_page.dart)。