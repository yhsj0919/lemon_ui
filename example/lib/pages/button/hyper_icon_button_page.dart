import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 展示图标按钮变体、异步状态、材质和显式尺寸。
class HyperIconButtonPage extends StatefulWidget {
  const HyperIconButtonPage({super.key});

  @override
  State<HyperIconButtonPage> createState() => _HyperIconButtonPageState();
}

class _HyperIconButtonPageState extends State<HyperIconButtonPage> {
  String _event = '尚未操作';

  void _record(String value) => setState(() => _event = value);

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizeDescription = switch (theme.sizes.deviceType) {
      HyperDeviceType.phone => '手机：40×40，图标24',
      HyperDeviceType.tablet => '平板：44×44，图标24',
      HyperDeviceType.desktop => '桌面：36×36，图标18',
      HyperDeviceType.watch => '手表：40×40，图标20',
    };
    return ColoredBox(
      color: theme.colors.background,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'HyperIconButton',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('四种变体拥有独立主题，并支持 Tooltip、异步进度、材质和精确尺寸。'),
          const SizedBox(height: 8),
          Text('当前设备规格：$sizeDescription'),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              HyperIconButton.filled(
                tooltip: '收藏',
                icon: const Icon(Icons.favorite_outline),
                onPressed: () => _record('filled'),
              ),
              HyperIconButton.tonal(
                tooltip: '通知',
                icon: const Icon(Icons.notifications_none),
                onPressed: () => _record('tonal'),
              ),
              HyperIconButton.outlined(
                tooltip: '分享',
                icon: const Icon(Icons.share_outlined),
                onPressed: () => _record('outlined'),
              ),
              HyperIconButton.ghost(
                tooltip: '更多',
                icon: const Icon(Icons.more_horiz),
                onPressed: () => _record('ghost'),
              ),
              const HyperIconButton.outlined(
                tooltip: '不可用',
                icon: Icon(Icons.block),
                onPressed: null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('最近事件：$_event', key: const Key('hyper-icon-button-event')),
          const SizedBox(height: 28),
          Text('异步与明确尺寸', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          HyperIconButton.filled(
            key: const Key('async-icon-button'),
            tooltip: '异步刷新',
            style: HyperIconButtonStyle(
              size: 56,
              iconSize: 28,
              progressSize: 18,
            ),
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              _record('异步执行中');
              await Future<void>.delayed(const Duration(milliseconds: 700));
              _record('异步完成');
            },
          ),
          const SizedBox(height: 28),
          Text('高级材质', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Container(
            height: 120,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF8A45), Color(0xFF3482FF)],
              ),
            ),
            child: HyperMaterialTheme(
              data: const HyperMaterialThemeData(
                quality: HyperMaterialQuality.advanced,
              ),
              child: HyperIconButton.filled(
                tooltip: '毛玻璃设置',
                style: HyperIconButtonStyle(
                  size: 56,
                  material: const HyperSurfaceMaterial.frostedGlass(
                    background: HyperFill.color(Color(0x66FFFFFF)),
                    border: BorderSide(color: Color(0x99FFFFFF)),
                    fallback: HyperSurfaceMaterial.solid(
                      background: HyperFill.color(Color(0xFFF1F1F3)),
                    ),
                  ),
                ),
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => _record('毛玻璃'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
