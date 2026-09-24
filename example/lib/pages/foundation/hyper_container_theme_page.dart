import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 用原生容器展示主题数据，后续由 HyperContainer 消费相同数据。
class HyperContainerThemePage extends StatefulWidget {
  const HyperContainerThemePage({super.key});

  @override
  State<HyperContainerThemePage> createState() =>
      _HyperContainerThemePageState();
}

class _HyperContainerThemePageState extends State<HyperContainerThemePage> {
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    final base = HyperContainerThemeData(
      background: const HyperFill.color(Color(0xFFFFD180)),
      border: Border.all(color: Colors.deepOrange, width: 2),
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.all(16),
      boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 8)],
    );
    final override = base.merge(
      HyperContainerThemeData(borderRadius: BorderRadius.circular(32)),
    );
    final cleared = base.copyWith(
      background: const HyperFill.none(),
      boxShadow: <BoxShadow>[],
    );
    final end = base.copyWith(
      background: const HyperFill.color(Color(0xFF90CAF9)),
      borderRadius: BorderRadius.circular(36),
      padding: const EdgeInsets.all(24),
    );
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: HyperTheme.sizesOf(context).pageHorizontalPadding,
        vertical: 24,
      ),
      children: [
        const HyperText('容器主题：逐项覆盖与清除', variant: HyperTextVariant.sectionTitle),
        const SizedBox(height: 16),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            _sample('基础主题', base),
            _sample('只覆盖圆角', override),
            _sample('取消背景和阴影', cleared),
          ],
        ),
        const SizedBox(height: 24),
        const Text('插值进度：拖动滑块检查颜色、圆角和内边距'),
        Slider(
          key: const ValueKey('theme-progress'),
          value: _progress,
          label: _progress.toStringAsFixed(2),
          onChanged: (value) => setState(() => _progress = value),
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: _sample(
            '插值 ${_progress.toStringAsFixed(2)}',
            HyperContainerThemeData.lerp(base, end, _progress),
            key: const ValueKey('interpolated-container'),
          ),
        ),
        const SizedBox(height: 16),
        const Text('预览外框固定为 180 × 100 逻辑像素；主题变化不改变该显式尺寸。'),
      ],
    );
  }

  Widget _sample(String title, HyperContainerThemeData data, {Key? key}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 12),
        Container(
          key: key,
          width: 180,
          height: 100,
          padding: data.padding,
          decoration: BoxDecoration(
            color: data.background?.color,
            gradient: data.background?.gradient,
            border: data.border,
            borderRadius: data.borderRadius,
            boxShadow: data.boxShadow,
          ),
          child: const Text('内容'),
        ),
      ],
    );
  }
}
