import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperMessagePage extends StatefulWidget {
  const HyperMessagePage({super.key});
  @override
  State<HyperMessagePage> createState() => _HyperMessagePageState();
}

class _HyperMessagePageState extends State<HyperMessagePage> {
  Alignment _alignment = Alignment.bottomCenter;
  bool _reduced = false;
  bool _advancedMaterial = true;
  HyperMessageMode _toastMode = HyperMessageMode.stack;
  String _result = '尚未操作';
  HyperMessageHandle? _last;
  void _track(HyperMessageHandle handle) {
    _last = handle;
    handle.closed.then((reason) {
      if (mounted) setState(() => _result = '关闭原因：${reason.name}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    final colors = HyperTheme.of(context).colors;
    final glass = HyperSurfaceMaterial.frostedGlass(
      background: HyperFill.color(
        colors.surfaceElevated.withValues(alpha: .65),
      ),
      tint: colors.primary.withValues(alpha: .04),
      border: BorderSide(color: colors.textPrimary.withValues(alpha: .08)),
      fallback: HyperSurfaceMaterial.solid(
        background: HyperFill.color(colors.surfaceElevated),
      ),
    );
    return HyperMaterialTheme(
      data: HyperMaterialThemeData(
        quality: _advancedMaterial
            ? HyperMaterialQuality.advanced
            : HyperMaterialQuality.standard,
      ),
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: _reduced),
        child: HyperSnackbarHost(
          alignment: _alignment,
          toastMode: _toastMode,
          child: Builder(
            builder: (context) {
              Widget section(String title, List<Widget> children) =>
                  DemoSection(
                    title: title,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: sizes.snackbar.spacing,
                          runSpacing: sizes.snackbar.spacing,
                          children: children,
                        ),
                      ],
                    ),
                  );
              return ListView(
                padding: EdgeInsets.all(sizes.pageHorizontalPadding),
                children: [
                  const HyperText(
                    'Toast / Snackbar',
                    variant: HyperTextVariant.pageTitle,
                  ),
                  SizedBox(height: sizes.sectionSpacing),
                  section('Toast 显示模式（最多 3 条）', [
                    for (final pair in <String, HyperMessageMode>{
                      '实时堆叠': HyperMessageMode.stack,
                      '堆叠队列': HyperMessageMode.stackQueue,
                      '串行队列': HyperMessageMode.queue,
                    }.entries)
                      HyperButton.tonal(
                        label: Text(pair.key),
                        onPressed: () {
                          HyperSnackbarHost.of(context).clear();
                          setState(() => _toastMode = pair.value);
                        },
                      ),
                    Text('当前：${_toastMode.name}'),
                    HyperButton.tonal(
                      label: const Text('持续发送（观察进出）'),
                      onPressed: () async {
                        for (var i = 1; i <= 6; i++) {
                          if (!context.mounted) return;
                          _track(
                            showHyperToast(context, content: Text('连续提示 $i')),
                          );
                          await Future<void>.delayed(
                            const Duration(milliseconds: 500),
                          );
                        }
                      },
                    ),
                  ]),
                  section('轻提示', [
                    HyperButton.filled(
                      label: const Text('普通提示'),
                      onPressed: () => _track(
                        showHyperToast(context, content: const Text('已保存')),
                      ),
                    ),
                    HyperButton.tonal(
                      label: const Text('带图标'),
                      onPressed: () => _track(
                        showHyperToast(
                          context,
                          content: const Text('复制成功'),
                          icon: const Icon(Icons.check_circle_outline),
                        ),
                      ),
                    ),
                    HyperButton.tonal(
                      label: const Text('长文本'),
                      onPressed: () => _track(
                        showHyperToast(
                          context,
                          content: const Text(
                            '这是一条较长的提示。内容会在主题最大宽度内换行，不会把字体压缩成更小的字号。',
                          ),
                        ),
                      ),
                    ),
                  ]),
                  section('操作与生命周期', [
                    HyperButton.filled(
                      label: const Text('撤销操作'),
                      onPressed: () {
                        late HyperMessageHandle handle;
                        handle = showHyperSnackbar(
                          context,
                          content: const Text('已删除一项'),
                          icon: const Icon(Icons.delete_outline),
                          action: HyperButton.text(
                            label: const Text('撤销'),
                            onPressed: () {
                              setState(() => _result = '已撤销');
                              handle.close(HyperMessageCloseReason.action);
                            },
                          ),
                        );
                        _track(handle);
                      },
                    ),
                    HyperButton.tonal(
                      label: const Text('连续六条（比较延迟）'),
                      onPressed: () {
                        for (var i = 1; i <= 6; i++) {
                          _track(
                            showHyperToast(
                              context,
                              content: Text('提示 $i：${_toastMode.name}'),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                    ),
                    HyperButton.tonal(
                      label: const Text('单次串行模式'),
                      onPressed: () => _track(
                        showHyperToast(
                          context,
                          content: const Text('这条指定为串行提示'),
                          mode: HyperMessageMode.queue,
                        ),
                      ),
                    ),
                    HyperButton.tonal(
                      label: const Text('常驻提示'),
                      onPressed: () => _track(
                        showHyperSnackbar(
                          context,
                          content: const Text('等待手动关闭'),
                          duration: Duration.zero,
                        ),
                      ),
                    ),
                    HyperButton.text(
                      label: const Text('关闭最后一条'),
                      onPressed: () => _last?.close(),
                    ),
                    HyperButton.text(
                      label: const Text('清空队列'),
                      onPressed: () => HyperSnackbarHost.of(context).clear(),
                    ),
                  ]),
                  section('显示位置', [
                    for (final pair in <String, Alignment>{
                      '上方': Alignment.topCenter,
                      '底部': Alignment.bottomCenter,
                      '左下': Alignment.bottomLeft,
                      '右上': Alignment.topRight,
                    }.entries)
                      HyperButton.tonal(
                        label: Text(pair.key),
                        onPressed: () {
                          setState(() => _alignment = pair.value);
                          _track(
                            showHyperToast(
                              context,
                              content: Text('${pair.key}提示'),
                            ),
                          );
                        },
                      ),
                  ]),
                  section('表面与局部主题', [
                    HyperButton.tonal(
                      label: const Text('自定义边框'),
                      onPressed: () => _track(
                        showHyperToast(
                          context,
                          content: const Text('自定义样式'),
                          style: HyperMessageStyle(
                            background: HyperFill.color(
                              HyperTheme.of(context).colors.surfaceMuted,
                            ),
                            border: Border.all(
                              color: HyperTheme.of(context).colors.primary,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            maxWidth: 280,
                          ),
                        ),
                      ),
                    ),
                    HyperToastTheme(
                      data: const HyperToastThemeData(
                        style: HyperMessageStyle(
                          iconColor: Colors.teal,
                          textStyle: TextStyle(color: Colors.teal),
                        ),
                      ),
                      child: Builder(
                        builder: (localContext) => HyperButton.tonal(
                          label: const Text('局部主题'),
                          onPressed: () => _track(
                            showHyperToast(
                              localContext,
                              content: const Text('保留调用位置的局部主题'),
                              icon: const Icon(Icons.info_outline),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                  Row(
                    children: [
                      const Expanded(child: Text('本页统一高级材质')),
                      HyperSwitch(
                        value: _advancedMaterial,
                        onChanged: (value) =>
                            setState(() => _advancedMaterial = value),
                      ),
                    ],
                  ),
                  section('高级材质', [
                    HyperButton.tonal(
                      label: const Text('磨砂玻璃 Toast'),
                      onPressed: () => _track(
                        showHyperToast(
                          context,
                          content: const Text('磨砂玻璃轻提示'),
                          style: HyperMessageStyle(
                            material: glass,
                            materialQuality: HyperMaterialQuality.advanced,
                          ),
                        ),
                      ),
                    ),
                    HyperButton.tonal(
                      label: const Text('柔光玻璃 Snackbar'),
                      onPressed: () {
                        late HyperMessageHandle handle;
                        handle = showHyperSnackbar(
                          context,
                          content: const Text('柔光玻璃操作提示'),
                          style: HyperMessageStyle(
                            material: glass.copyWith(
                              kind: HyperSurfaceMaterialKind.softLightGlass,
                            ),
                            materialQuality: HyperMaterialQuality.advanced,
                          ),
                          action: HyperButton.text(
                            label: const Text('关闭'),
                            onPressed: () => handle.close(),
                          ),
                        );
                        _track(handle);
                      },
                    ),
                    HyperButton.tonal(
                      label: const Text('减少透明度降级'),
                      onPressed: () => _track(
                        showHyperToast(
                          context,
                          content: const Text('不透明替代材质'),
                          style: HyperMessageStyle(
                            material: glass,
                            materialQuality: HyperMaterialQuality.advanced,
                            reduceTransparency: true,
                          ),
                        ),
                      ),
                    ),
                  ]),
                  Row(
                    children: [
                      const Expanded(child: Text('减少动画')),
                      HyperSwitch(
                        value: _reduced,
                        onChanged: (value) => setState(() => _reduced = value),
                      ),
                    ],
                  ),
                  SizedBox(height: sizes.compactSectionSpacing),
                  Text(_result),
                  DemoSection(
                    title: '独立表面',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: HyperToast(content: Text('静态 Toast 示例')),
                        ),
                        SizedBox(height: sizes.compactSectionSpacing),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: HyperSnackbar(
                            content: const Text('静态 Snackbar 示例'),
                            action: HyperButton.text(
                              label: const Text('操作'),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
