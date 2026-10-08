import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperLoadingOverlayPage extends StatefulWidget {
  const HyperLoadingOverlayPage({super.key});
  @override
  State<HyperLoadingOverlayPage> createState() =>
      _HyperLoadingOverlayPageState();
}

class _HyperLoadingOverlayPageState extends State<HyperLoadingOverlayPage> {
  Timer? _timer;
  bool _loading = false;
  bool _blocking = true;
  bool _advanced = false;
  bool _glass = false;
  int _clicks = 0;
  String _result = '尚未加载';
  void _start(Duration duration) {
    _timer?.cancel();
    setState(() {
      _loading = true;
      _result = '正在加载';
    });
    _timer = Timer(duration, () {
      if (mounted) {
        setState(() {
          _loading = false;
          _result = '加载完成';
        });
      }
    });
  }

  void _cancel() {
    _timer?.cancel();
    setState(() {
      _loading = false;
      _result = '已取消';
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    final colors = HyperTheme.of(context).colors;
    final glass = HyperSurfaceMaterial.frostedGlass(
      background: HyperFill.color(colors.surfaceElevated.withValues(alpha: .6)),
      fallback: HyperSurfaceMaterial.solid(
        background: HyperFill.color(colors.surfaceElevated),
      ),
    );
    return HyperMaterialTheme(
      data: HyperMaterialThemeData(
        quality: _advanced
            ? HyperMaterialQuality.advanced
            : HyperMaterialQuality.standard,
      ),
      child: ListView(
        padding: EdgeInsets.all(sizes.pageHorizontalPadding),
        children: [
          const HyperText(
            'Loading Overlay',
            variant: HyperTextVariant.pageTitle,
          ),
          SizedBox(height: sizes.sectionSpacing),
          DemoSection(
            title: '区域加载与短请求防闪烁',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: sizes.loadingOverlay.spacing,
                  runSpacing: sizes.loadingOverlay.spacing,
                  children: [
                    HyperButton.filled(
                      label: const Text('加载 3 秒'),
                      onPressed: () => _start(const Duration(seconds: 3)),
                    ),
                    HyperButton.tonal(
                      label: const Text('短请求 60ms'),
                      onPressed: () => _start(const Duration(milliseconds: 60)),
                    ),
                    HyperButton.tonal(
                      label: const Text('快速重复请求'),
                      onPressed: () =>
                          _start(const Duration(milliseconds: 350)),
                    ),
                  ],
                ),
                SizedBox(height: sizes.compactSectionSpacing),
                HyperLoadingOverlay(
                  loading: _loading,
                  blockInteraction: _blocking,
                  message: const Text('正在读取数据…'),
                  onCancel: _cancel,
                  style: HyperLoadingOverlayStyle(
                    borderRadius: BorderRadius.circular(
                      sizes.loadingOverlay.radius,
                    ),
                    material: _glass
                        ? glass
                        : HyperSurfaceMaterial.translucent(
                            background: HyperFill.color(
                              colors.surface.withValues(alpha: .8),
                            ),
                          ),
                  ),
                  child: HyperCard(
                    height: 240,
                    alignment: Alignment.center,
                    style: HyperCardStyle(
                      padding: EdgeInsets.zero,
                      background: HyperFill.color(colors.primaryContainer),
                      borderRadius: BorderRadius.circular(
                        sizes.loadingOverlay.radius,
                      ),
                    ),
                    child: HyperButton.tonal(
                      label: Text('底层按钮：$_clicks 次'),
                      onPressed: () => setState(() => _clicks++),
                    ),
                  ),
                ),
                SizedBox(height: sizes.compactSectionSpacing),
                Text(_result),
                Row(
                  children: [
                    const Expanded(child: Text('阻止底层交互')),
                    HyperSwitch(
                      value: _blocking,
                      onChanged: (value) => setState(() => _blocking = value),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(child: Text('玻璃材质配方')),
                    HyperSwitch(
                      value: _glass,
                      onChanged: (value) => setState(() => _glass = value),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(child: Text('统一高级材质质量')),
                    HyperSwitch(
                      value: _advanced,
                      onChanged: (value) => setState(() => _advanced = value),
                    ),
                  ],
                ),
              ],
            ),
          ),
          DemoSection(
            title: '自定义加载内容与立即显示',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HyperLoadingOverlay(
                  loading: _loading,
                  blockInteraction: false,
                  indicator: const Icon(Icons.cloud_download_outlined),
                  message: const Text('后台同步中，可以继续浏览'),
                  style: HyperLoadingOverlayStyle(
                    showDelay: Duration.zero,
                    contentBackground: HyperFill.color(colors.surfaceElevated),
                    contentBorder: Border.all(color: colors.outline),
                  ),
                  child: Container(
                    height: 160,
                    color: colors.surfaceMuted,
                    child: Center(
                      child: HyperButton.text(
                        label: const Text('仍可操作'),
                        onPressed: () => setState(() => _result = '后台同步时的按钮点击'),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: sizes.sectionSpacing),
                HyperButton.tonal(
                  label: const Text('整页加载示例'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const _FullPageExample(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FullPageExample extends StatefulWidget {
  const _FullPageExample();
  @override
  State<_FullPageExample> createState() => _FullPageExampleState();
}

class _FullPageExampleState extends State<_FullPageExample> {
  bool _loading = false;
  Timer? _timer;
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('整页加载')),
    body: HyperLoadingOverlay(
      loading: _loading,
      message: const Text('正在加载页面'),
      onCancel: () {
        _timer?.cancel();
        setState(() => _loading = false);
      },
      child: SizedBox.expand(
        child: Center(
          child: HyperButton.filled(
            label: const Text('开始加载'),
            onPressed: () {
              _timer?.cancel();
              setState(() => _loading = true);
              _timer = Timer(const Duration(seconds: 3), () {
                if (mounted) setState(() => _loading = false);
              });
            },
          ),
        ),
      ),
    ),
  );
}
