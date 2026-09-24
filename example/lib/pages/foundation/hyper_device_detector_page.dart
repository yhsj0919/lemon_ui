import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 展示设备探测位于主题外层并驱动尺寸主题切换。
class HyperDeviceDetectorPage extends StatefulWidget {
  const HyperDeviceDetectorPage({super.key});

  @override
  State<HyperDeviceDetectorPage> createState() =>
      _HyperDeviceDetectorPageState();
}

class _HyperDeviceDetectorPageState extends State<HyperDeviceDetectorPage> {
  HyperDeviceType? _override;

  @override
  Widget build(BuildContext context) {
    return HyperDeviceDetector(
      deviceType: _override,
      builder: (context, deviceType, _) {
        final theme = HyperThemeData.light();
        final sizes = theme.sizes.resolve(deviceType);
        return HyperTheme(
          data: theme,
          child: Builder(
            builder: (context) => Material(
              color: theme.colors.background,
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: HyperTheme.sizesOf(context).pageHorizontalPadding,
                  vertical: 24,
                ),
                children: [
                  Text(
                    '设备自动探测',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text('探测器位于主题外层，只选择离散方案，不缩放实例尺寸。'),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<HyperDeviceType?>(
                    key: const Key('device-override'),
                    initialValue: _override,
                    decoration: const InputDecoration(labelText: '设备类型覆盖'),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('自动探测')),
                      DropdownMenuItem(
                        value: HyperDeviceType.phone,
                        child: Text('手机'),
                      ),
                      DropdownMenuItem(
                        value: HyperDeviceType.tablet,
                        child: Text('平板'),
                      ),
                      DropdownMenuItem(
                        value: HyperDeviceType.desktop,
                        child: Text('桌面'),
                      ),
                      DropdownMenuItem(
                        value: HyperDeviceType.watch,
                        child: Text('手表'),
                      ),
                    ],
                    onChanged: (value) => setState(() => _override = value),
                  ),
                  const SizedBox(height: 24),
                  _ResultCard(deviceType: deviceType, sizes: sizes),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.deviceType, required this.sizes});

  final HyperDeviceType deviceType;
  final HyperSizeScheme sizes;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final label = switch (deviceType) {
      HyperDeviceType.phone => '手机',
      HyperDeviceType.tablet => '平板',
      HyperDeviceType.desktop => '桌面',
      HyperDeviceType.watch => '手表',
    };
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colors.surface,
        borderRadius: BorderRadius.circular(sizes.surfaceRadius),
        border: Border.all(color: theme.colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('当前：$label', key: const Key('detected-device')),
          const SizedBox(height: 8),
          Text('默认高度：${sizes.controlHeightMd.toStringAsFixed(0)}'),
          Text('控件圆角：${sizes.controlRadius.toStringAsFixed(0)}'),
          Text('最小命中区：${sizes.minimumInteractiveDimension.toStringAsFixed(0)}'),
        ],
      ),
    );
  }
}
