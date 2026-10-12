import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 仅供 Demo 使用；尺寸是测试画布，不代表任何实体设备型号。
class GalleryDevicePreviewConfiguration {
  const GalleryDevicePreviewConfiguration(
    this.device,
    this.size,
    this.safeArea,
    this.keyboard,
    this.textScale,
  );
  final HyperDeviceType device;
  final Size size;
  final bool safeArea;
  final bool keyboard;
  final double textScale;

  MediaQueryData media(MediaQueryData original) {
    final insets =
        safeArea &&
            device != HyperDeviceType.desktop &&
            device != HyperDeviceType.watch
        ? const EdgeInsets.only(top: 24, bottom: 24)
        : EdgeInsets.zero;
    final keyboardInsets = keyboard
        ? EdgeInsets.only(bottom: size.height * .35)
        : EdgeInsets.zero;
    return original.copyWith(
      size: size,
      devicePixelRatio: 1,
      viewPadding: insets,
      padding: insets.copyWith(bottom: keyboard ? 0 : insets.bottom),
      viewInsets: keyboardInsets,
      textScaler: TextScaler.linear(textScale),
      displayFeatures: const [],
    );
  }
}

class GalleryDevicePreview extends StatefulWidget {
  const GalleryDevicePreview({super.key, required this.builder});
  final Widget Function(GalleryDevicePreviewConfiguration? configuration)
  builder;

  @override
  State<GalleryDevicePreview> createState() => _GalleryDevicePreviewState();
}

class _GalleryDevicePreviewState extends State<GalleryDevicePreview> {
  HyperDeviceType? _device;
  bool _landscape = false, _safeArea = true, _keyboard = false;
  double _textScale = 1;

  static const _presets = {
    HyperDeviceType.phone: Size(390, 844),
    HyperDeviceType.tablet: Size(834, 1194),
    HyperDeviceType.desktop: Size(1280, 800),
    HyperDeviceType.watch: Size(220, 220),
  };
  static const _labels = {
    HyperDeviceType.phone: '手机',
    HyperDeviceType.tablet: '平板',
    HyperDeviceType.desktop: '桌面',
    HyperDeviceType.watch: '手表',
  };

  @override
  Widget build(BuildContext context) {
    final preset = _presets[_device];
    final size = preset == null
        ? null
        : _landscape
        ? preset.flipped
        : preset;
    final configuration = size == null
        ? null
        : GalleryDevicePreviewConfiguration(
            _device!,
            size,
            _safeArea,
            _keyboard,
            _textScale,
          );
    return HyperScaffold(
      body: SafeArea(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 140),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Wrap(
                    spacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        child: HyperSelect<String>(
                          value: _device?.name ?? 'actual',
                          options: [
                            const HyperSelectOption(
                              value: 'actual',
                              label: '真实设备',
                            ),
                            for (final device in HyperDeviceType.values)
                              HyperSelectOption(
                                value: device.name,
                                label: _labels[device]!,
                              ),
                          ],
                          onChanged: (value) => setState(() {
                            _device = value == null || value == 'actual'
                                ? null
                                : HyperDeviceType.values.byName(value);
                          }),
                        ),
                      ),
                      if (configuration != null) ...[
                        HyperText(
                          '${size!.width.toInt()} × ${size.height.toInt()} 逻辑像素',
                        ),
                        HyperIconButton.ghost(
                          tooltip: '切换横竖屏',
                          onPressed: () =>
                              setState(() => _landscape = !_landscape),
                          icon: const HyperIcon(Icons.screen_rotation),
                        ),
                        SizedBox(
                          width: 140,
                          child: HyperSelect<double>(
                            value: _textScale,
                            options: [
                              for (final scale in [1.0, 1.3, 2.0])
                                HyperSelectOption(
                                  value: scale,
                                  label: '文字 ×$scale',
                                ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _textScale = value);
                              }
                            },
                          ),
                        ),
                        HyperChip.filter(
                          label: '安全区',
                          selected: _safeArea,
                          onSelected: (value) =>
                              setState(() => _safeArea = value),
                        ),
                        HyperChip.filter(
                          label: '键盘占位',
                          selected: _keyboard,
                          onSelected: (value) =>
                              setState(() => _keyboard = value),
                        ),
                        const HyperText('模拟预览 · 未审核'),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: configuration == null
                  ? widget.builder(null)
                  // Navigator 在画布内部；根浮层也受模拟尺寸约束。
                  : ColoredBox(
                      color: HyperTheme.of(context).colors.surfaceMuted,
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: SizedBox.fromSize(
                            size: configuration.size,
                            child: widget.builder(configuration),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
