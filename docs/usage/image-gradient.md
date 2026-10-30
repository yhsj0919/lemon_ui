# 图片取色渐变（未确认）

`HyperContainer.imageGradient` 复用容器主题，以指定颜色为起点、Flutter 原生图片配色为终点。
默认是从上到下的线性渐变，不会把图片本身画进背景。宽高由父布局或实例指定，
圆角、边框、阴影、内边距、材质和过渡继续遵循 `HyperContainer` 的主题解析。

```dart
HyperContainer.imageGradient(
  image: NetworkImage(imageUrl),
  startColor: Colors.white,
  colorRole: HyperImageColorRole.primary, // 默认，可省略。
  colorStrength: 0.2, // 默认浅背景；1.0 使用原色。
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: const [0.2, 0.8],
  child: content,
)
```

图片源采用 Flutter 的 `ImageProvider`：链接使用 `NetworkImage`，资源使用
`AssetImage`，本地选择后读取的字节使用 `MemoryImage`；原生平台也可使用
`FileImage(File(path))`。无需为了图片取色引入其他图片库。

`begin`、`end` 可以改变方向，包括从下到上、左右或任意斜向。两种颜色的 `stops`
须为两个按顺序排列的 0～1 数值，默认省略等价于 `[0, 1]`。
例如 `[0.2, 0.8]` 表示前 20% 保持指定色，中间 60% 渐变，后 20% 保持图片主色；
`[0.3, 0.3]` 表示在 30% 位置直接分界。停靠位置沿所选方向计算。

取色直接调用 `ColorScheme.fromImageProvider`，默认使用其 `primary`；设置
`colorRole: HyperImageColorRole.primaryContainer` 可选择较浅的容器色。使用原生默认的
light 配色方案，取色结果本身不额外减淡或进行黑白过滤。
这些是生成的 Material 配色，不保证等于图片中的原始像素颜色。

背景默认以 20% 的图片色与 `startColor` 混合：
`Color.lerp(startColor, extractedColor, colorStrength)`。白色起点会得到浅色背景，
深色起点则向深色融合，不会固定混入白色。`colorStrength` 取 0～1，
`1` 使用原色，`0` 全部使用起点色。强度控制浓淡，`stops` 控制沿方向的颜色分布，
两者独立。20% 是当前待确认的背景预览配方，不是官方规格。
强度解析为实例 `colorStrength` → `HyperContainerThemeData.imageColorStrength` → 0.2，
支持主题 `copyWith`、合并与插值。`onColorExtracted` 仍返回未混合的原生颜色。

加载时或加载失败时，终点使用 `fallbackColor`，省略则使用
`startColor`。错误通过 `onImageError` 通知，主色通过 `onColorExtracted` 通知。
切换图片后旧请求的结果不会覆盖新图片。取色后的颜色过渡使用容器 Motion，
遵守系统减少动画设置，不隔离高级材质的背景采样。

`HyperImageColors.fromImageProvider(image, role: HyperImageColorRole.primary)`
可独立获取同样的原生颜色，再组合为 `HyperFill.gradient`，用于其他组件或自行减淡。

`HyperImageColors.dominant(image)` 是独立保留的像素统计工具，不再作为此变体的默认取色。
它从首帧最多采样 64×64 个解码像素，以透明度加权统计五位 RGB 颜色桶，
默认跳过近黑、近白颜色桶，再返回最大有效颜色桶的加权颜色，不是整张图片的平均色。
近黑定义为 RGB 三通道均不大于 32，近白为三通道均不小于 224；这些是取色启发式阈值，
不是视觉规格。若没有其他有效颜色，则回退到原始主色，纯黑白图不会因此取色失败；
全透明返回 null。独立调用时可用 `avoidBlackAndWhite: false` 恢复不筛选的频率统计。
64×64 是计算与内存预算，不是 UI 尺寸或官方视觉规格。动图取首帧，不会自动跳过黑帧。

Demo 与主题编辑器入口位于“未确认 → 图片取色渐变”，提供离线样图、本地文件、
图片链接、primary/primaryContainer 切换、图片色强度、起点颜色、线性方向和两端停靠百分比；
表面配置复用容器工作区。
