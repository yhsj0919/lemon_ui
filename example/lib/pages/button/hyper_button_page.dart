import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 展示按钮变体、图标文字、异步状态和明确尺寸。
class HyperButtonPage extends StatefulWidget {
  const HyperButtonPage({super.key});

  @override
  State<HyperButtonPage> createState() => _HyperButtonPageState();
}

class _HyperButtonPageState extends State<HyperButtonPage> {
  String _event = '尚未操作';
  HyperMaterialQuality _materialQuality = HyperMaterialQuality.advanced;
  HyperContrastMode _contrastMode = HyperContrastMode.adaptive;

  void _record(String value) => setState(() => _event = value);

  @override
  Widget build(BuildContext context) {
    final buttons = <Widget>[
      HyperButton.filled(
        onPressed: () => _record('filled'),
        child: const Text('Filled'),
      ),
      HyperButton.tonal(
        onPressed: () => _record('tonal'),
        child: const Text('Tonal'),
      ),
      HyperButton.outlined(
        onPressed: () => _record('outlined'),
        child: const Text('Outlined'),
      ),
      HyperButton.ghost(
        onPressed: () => _record('ghost'),
        child: const Text('Ghost'),
      ),
      HyperButton.text(
        onPressed: () => _record('text'),
        child: const Text('Text'),
      ),
      HyperButton.gradient(
        onPressed: () async {
          _record('异步执行中');
          await Future<void>.delayed(const Duration(milliseconds: 700));
          _record('异步完成');
        },
        icon: const Icon(Icons.auto_awesome),
        label: const Text('异步渐变'),
      ),
    ];
    final theme = HyperTheme.of(context);
    final buttonSizeDescription = switch (theme.sizes.deviceType) {
      HyperDeviceType.phone => '手机：最小 58×40，字号 16，图标 24',
      HyperDeviceType.tablet => '平板：最小 64×44，字号 16，图标 24',
      HyperDeviceType.desktop => '桌面：最小 52×36，字号 14，图标 18',
      HyperDeviceType.watch => '手表：最小 52×40，字号 16，图标 20',
    };
    return Material(
      color: theme.colors.background,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('HyperButton', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('六种命名变体共用一套交互、主题和异步状态。异步按钮切换进度时保持原尺寸。'),
          const SizedBox(height: 8),
          Text('当前设备规格：$buttonSizeDescription'),
          const SizedBox(height: 20),
          Wrap(spacing: 12, runSpacing: 12, children: buttons),
          const SizedBox(height: 20),
          Text('最近事件：$_event', key: const Key('hyper-button-event')),
          const SizedBox(height: 20),
          HyperButton.outlined(onPressed: null, child: const Text('禁用按钮')),
          const SizedBox(height: 28),
          Text('材质变化', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          SegmentedButton<HyperMaterialQuality>(
            segments: const [
              ButtonSegment(
                value: HyperMaterialQuality.standard,
                label: Text('普通材质'),
              ),
              ButtonSegment(
                value: HyperMaterialQuality.advanced,
                label: Text('高级材质'),
              ),
            ],
            selected: {_materialQuality},
            onSelectionChanged: (value) =>
                setState(() => _materialQuality = value.single),
          ),
          const SizedBox(height: 12),
          SegmentedButton<HyperContrastMode>(
            segments: const [
              ButtonSegment(
                value: HyperContrastMode.standard,
                label: Text('原色'),
              ),
              ButtonSegment(
                value: HyperContrastMode.adaptive,
                label: Text('自适应反色'),
              ),
              ButtonSegment(
                value: HyperContrastMode.inverted,
                label: Text('强制反色'),
              ),
            ],
            selected: {_contrastMode},
            onSelectionChanged: (value) =>
                setState(() => _contrastMode = value.single),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFF8A45),
                  Color(0xFF7E57C2),
                  Color(0xFF42A5F5),
                ],
              ),
            ),
            child: HyperContrastTheme(
              data: HyperContrastThemeData(mode: _contrastMode),
              child: HyperMaterialTheme(
                data: HyperMaterialThemeData(quality: _materialQuality),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HyperButton.filled(
                      key: const Key('button-frosted-material'),
                      onPressed: () => _record('毛玻璃'),
                      style: HyperButtonStyle(
                        width: 156,
                        material: const HyperSurfaceMaterial.frostedGlass(
                          background: HyperFill.color(Color(0x66FFFFFF)),
                          border: BorderSide(color: Color(0x99FFFFFF)),
                          fallback: HyperSurfaceMaterial.solid(
                            background: HyperFill.color(Color(0xFFF2F2F4)),
                          ),
                        ),
                      ),
                      child: const Text('毛玻璃按钮'),
                    ),
                    const SizedBox(height: 12),
                    HyperButton.filled(
                      key: const Key('button-soft-light-material'),
                      onPressed: () => _record('柔光玻璃'),
                      style: HyperButtonStyle(
                        width: 156,
                        material: const HyperSurfaceMaterial.softLightGlass(
                          background: HyperFill.gradient(
                            LinearGradient(
                              colors: [Color(0x88FFFFFF), Color(0x55FFE0C8)],
                            ),
                          ),
                          border: BorderSide(color: Color(0xAAFFFFFF)),
                          fallback: HyperSurfaceMaterial.solid(
                            background: HyperFill.color(Color(0xFFF7EEE8)),
                          ),
                        ),
                      ),
                      child: const Text('柔光玻璃按钮'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
