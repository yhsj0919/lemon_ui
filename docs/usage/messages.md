# Toast 与 Snackbar

[返回目录](README.md)

## 宿主与轻提示

在页面或窗口外包一层 HyperSnackbarHost，使用其下方 Builder 的 context 打开提示。
宿主需要处于 Navigator 提供的 Overlay 下方。Toast 和 Snackbar 在宿主中各自管理显示名额与等待队列，
不使用全局静态 Overlay；多窗口各自创建宿主。

~~~dart
HyperSnackbarHost(
  child: Builder(
    builder: (context) => HyperButton.filled(
      label: const Text('保存'),
      onPressed: () => showHyperToast(
        context,
        content: const Text('保存成功'),
        icon: const Icon(Icons.check_circle_outline),
      ),
    ),
  ),
)
~~~

Toast 不接收点击，不拦截下方控件。内容与图标可替换为任意 Widget；需要操作时使用 Snackbar。
showHyperToast 默认停留 3 秒，showHyperSnackbar 默认 4 秒，均为 Lemon UI 暂定值。
计时从进入动画完成开始；duration: Duration.zero 表示常驻，使用返回句柄关闭。
Toast 默认实时堆叠，后来的提示立即显示；Snackbar 默认串行，同类提示一条完成退出后再显示下一条。

## 串行、实时堆叠与堆叠队列

~~~dart
HyperSnackbarHost(
  toastMode: HyperMessageMode.stack,
  snackbarMode: HyperMessageMode.queue,
  maxVisible: 3,
  stackSpacing: 8,
  child: Builder(
    builder: (context) => HyperButton.tonal(
      label: const Text('连续提示'),
      onPressed: () {
        for (var i = 1; i <= 6; i++) {
          showHyperToast(context, content: Text('提示 $i'));
        }
      },
    ),
  ),
)
~~~

| 模式 | 名额内 | 满额后 |
| --- | --- | --- |
| queue | 同类型仅显示一条 | 按 FIFO 等待 |
| stack | 同类型最多 maxVisible 条，每条独立计时 | 最旧项退出，新提示立即显示，不排队 |
| stackQueue | 同类型最多 maxVisible 条，每条独立计时 | 按 FIFO 等待任意一项退出后补位 |

默认 Toast 使用 stack，避免短暂操作反馈被历史提示延迟；Snackbar 保留 queue，避免带操作的信息被自动淘汰。
stackQueue 适合需要保留每一条提示的场景，满额时仍会存在排队延迟。
maxVisible 按 Toast / Snackbar 分别计算，两者互不阻塞、互不淘汰。
正在退出的项会短暂留在布局中，实时堆叠的有效提示始终不超过上限。
同一帧发送很多 Toast 时，只呈现最新 maxVisible 条；未绘制的旧项直接以 superseded 完成，不制造无用动画。

可以在 showHyperToast / showHyperSnackbar 中用 mode 覆盖单条请求；
例如 mode: HyperMessageMode.stackQueue。实时模式下常驻提示也可能被后续提示淘汰。
宿主模式变更只影响之后创建的请求；降低 maxVisible 会使已有超额项从最旧开始退出。
新项靠近指定边缘：底部布局在下方插入，顶部布局在上方插入；每项通过高度过渡平滑加入或离开。
stackSpacing 默认复用对应消息的主题 spacing，可在宿主覆盖。

## 操作、关闭结果和队列

~~~dart
HyperSnackbarHost(
  child: Builder(
    builder: (context) => HyperButton.tonal(
      label: const Text('删除'),
      onPressed: () {
        late HyperMessageHandle handle;
        handle = showHyperSnackbar(
          context,
          content: const Text('已删除一项'),
          action: HyperButton.text(
            label: const Text('撤销'),
            onPressed: () {
              // 在这里执行撤销业务。
              handle.close(HyperMessageCloseReason.action);
            },
          ),
        );
        handle.closed.then((reason) => debugPrint(reason.name));
      },
    ),
  ),
)
~~~

action 不绑定具体按钮类型，也不自动执行业务或关闭；由回调调用 handle.close。
closed 返回 timeout、dismissed、action、superseded 或 hostDisposed；正常关闭在退出动画结束后完成。
排队项可提前取消，其 closed 立即完成；第一次关闭原因生效，重复关闭不重复完成。
HyperSnackbarHost.of(context).clear() 清空队列，当前项保留退出过渡。
Snackbar 鼠标停留或操作区获得焦点时暂停自身倒计时，离开后继续剩余时间，不暂停其他堆叠项。
系统 accessibleNavigation 开启且有 action 时不自动关闭。

可向宿主传入 HyperSnackbarController，自行调用 show；一个 controller 同时只连接一个宿主。
显示模式与上限以宿主配置为准；直接使用控制器进行数据管理时也可在构造参数中配置。
宿主移除时完成所有 pending 请求并移除浮层。外部 controller 由创建者销毁，
须先移除宿主；默认内部 controller 由宿主销毁。
宿主放在页面内时生命周期随页面销毁；如放在应用壳中，跨页存续由应用决定。
隐藏但未销毁的页面不会自动取消队列，可由业务在离开时 clear。

## 位置和主题

~~~dart
HyperSnackbarHost(
  alignment: Alignment.topRight,
  padding: const EdgeInsets.all(24),
  child: HyperToastTheme(
    data: const HyperToastThemeData(
      style: HyperMessageStyle(
        maxWidth: 280,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        textStyle: TextStyle(color: Colors.teal),
        iconColor: Colors.teal,
        animationStyle: AnimationStyle(duration: Duration(milliseconds: 180)),
      ),
    ),
    child: Builder(
      builder: (context) => HyperButton.tonal(
        label: const Text('局部主题提示'),
        onPressed: () => showHyperToast(context, content: const Text('操作完成')),
      ),
    ),
  ),
)
~~~

位置由宿主 alignment、padding 控制。默认底部居中，外部留白使用当前端 pageHorizontalPadding。
宿主避让安全区与键盘，提示宽度受可用空间和 maxWidth 共同限制；文本换行，不缩小字体。
内容应保持简短；复杂布局或很长的操作组件需由业务控制尺寸。

HyperToastThemeData 和 HyperSnackbarThemeData 独立，通过同一个强类型 HyperMessageStyle
表达背景 HyperFill、材质、边框、阴影、圆角、最大宽度、留白、文字、图标、间距及动效。
四端规格分别存储在 sizes.toast / sizes.snackbar，互不耦合。
覆盖顺序为当前端默认 → 全局 toastTheme/snackbarTheme → 局部主题 → show 函数 Style。
show 函数捕获调用位置的视觉解析结果，局部主题位于宿主内部也能生效。
直接 controller.show 没有调用 context，使用宿主主题及请求 style。
由用户传入的内容布局、图标资源和操作行为仍由用户管理。

buttonTheme 仅作用于 Snackbar 的 action 子树，不修改正文或全局按钮主题。
animationStyle 支持时长、反向时长和曲线，entryOffset 表示进入时相对自身尺寸的偏移；
宿主 transitionBuilder 可替换整个过渡。默认遵守系统 disableAnimations，
自定义 transitionBuilder 应自行遵守减少动画设置。
视觉 ThemeData 和 Style 支持 copyWith、merge、lerp、值相等；merge 保留未覆盖的动画和按钮字段。

## 高级材质

~~~dart
HyperSnackbarHost(
  child: Builder(builder: (context) => HyperButton.tonal(
    label: const Text('玻璃轻提示'),
    onPressed: () => showHyperToast(context,
      content: const Text('保存成功'),
      style: const HyperMessageStyle(
        materialQuality: HyperMaterialQuality.advanced,
        material: HyperSurfaceMaterial.frostedGlass(
          background: HyperFill.color(Color(0xB3FFFFFF)),
          fallback: HyperSurfaceMaterial.solid(background: HyperFill.color(Colors.white)),
        ),
      ),
    ),
  )),
)
~~~

Toast 和 Snackbar 均支持 material、materialQuality、reduceTransparency，
可通过各自的全局、局部主题或单次 Style 配置。玻璃模糊需要 advanced 质量；
通常在 HyperThemeData.materialTheme 中统一配置质量、材质配方和减少透明度，
提示默认继承；组件 Style 只用于显式的局部开启或配方覆盖。
standard 或 reduceTransparency: true 时使用配方 fallback。
未显式覆盖的质量与透明度策略继承 HyperMaterialTheme，show 函数保留调用处的局部策略。
材质非空时使用材质背景，Style.background 不叠加成不透明底层。
Demo 提供磨砂玻璃 Toast、柔光玻璃 Snackbar 和透明度降级示例。
玻璃观感取决于背后内容，示例配方为项目演示值，未做设备视觉验证。

## 独立表面示例

~~~dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const HyperToast(content: Text('轻提示表面')),
    const SizedBox(height: 16),
    HyperSnackbar(
      content: const Text('带操作的提示表面'),
      action: HyperButton.text(label: const Text('查看'), onPressed: () {}),
    ),
  ],
)
~~~

HyperToast / HyperSnackbar 独立使用时仅绘制表面，不计时、不创建浮层。
Demo：反馈与状态 → HyperToast / HyperSnackbar。

源码：[宿主](../../lib/src/components/message/hyper_snackbar_host.dart)、
[队列](../../lib/src/components/message/hyper_snackbar_controller.dart)、
[样式](../../lib/src/components/message/hyper_message_style.dart)、
[Demo](../../example/lib/pages/feedback/hyper_message_page.dart)。

当前验证范围为静态分析与纯队列、主题数据测试，尚未进行设备或 Widget 运行验证。
