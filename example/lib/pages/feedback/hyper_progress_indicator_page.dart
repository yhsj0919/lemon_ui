import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 展示基础进度控件的确定、不确定、主题和减少动画状态。
class HyperProgressIndicatorPage extends StatefulWidget {
  const HyperProgressIndicatorPage({super.key});

  @override
  State<HyperProgressIndicatorPage> createState() =>
      _HyperProgressIndicatorPageState();
}

class _HyperProgressIndicatorPageState
    extends State<HyperProgressIndicatorPage> {
  double _value = .35;
  bool _disableAnimations = false;

  @override
  Widget build(BuildContext context) {
    final parent = HyperTheme.of(context);
    final themed = parent.copyWith(
      progressIndicatorTheme: HyperProgressIndicatorThemeData(
        style: HyperProgressIndicatorStyle(
          trackColor: parent.colors.surfaceMuted,
        ),
      ),
    );

    return HyperTheme(
      data: themed,
      child: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(disableAnimations: _disableAnimations),
          child: Material(
            color: HyperTheme.of(context).colors.background,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const HyperText(
                  'HyperProgressIndicator',
                  variant: HyperTextVariant.pageTitle,
                ),
                const SizedBox(height: 8),
                const HyperText('统一入口连接线性和圆形进度，确定进度变化保持平滑。'),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(child: HyperText('减少动画')),
                    HyperSwitch(
                      value: _disableAnimations,
                      onChanged: (value) =>
                          setState(() => _disableAnimations = value),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const HyperText('确定进度', variant: HyperTextVariant.sectionTitle),
                const SizedBox(height: 16),
                HyperProgressIndicator.linear(
                  value: _value,
                  semanticsLabel: '下载进度',
                  semanticsValue: '${(_value * 100).round()}%',
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    HyperProgressIndicator.circular(
                      value: _value,
                      size: 48,
                      thickness: 4,
                      semanticsLabel: '圆形下载进度',
                    ),
                    const SizedBox(width: 16),
                    HyperText('${(_value * 100).round()}%'),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    HyperButton.tonal(
                      onPressed: () =>
                          setState(() => _value = (_value - .2).clamp(0, 1)),
                      child: const HyperText('减少'),
                    ),
                    HyperButton.filled(
                      onPressed: () =>
                          setState(() => _value = (_value + .2).clamp(0, 1)),
                      child: const HyperText('增加'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const HyperText(
                  '不确定进度',
                  variant: HyperTextVariant.sectionTitle,
                ),
                const SizedBox(height: 16),
                const HyperLinearProgressIndicator(semanticsLabel: '正在加载'),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    HyperCircularProgressIndicator(),
                    SizedBox(width: 20),
                    HyperCircularProgressIndicator(size: 40, thickness: 4),
                    SizedBox(width: 20),
                    HyperInfiniteProgressIndicator(semanticsLabel: '无限等待进度'),
                    SizedBox(width: 20),
                    HyperInfiniteProgressIndicator(
                      size: 40,
                      thickness: 3,
                      orbitingDotSize: 4,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const HyperText(
                  '按钮加载态对比',
                  variant: HyperTextVariant.sectionTitle,
                ),
                const SizedBox(height: 8),
                const HyperText('仅使用默认属性，对比普通圆环与按钮内部加载态。'),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Column(
                      children: [
                        HyperCircularProgressIndicator(),
                        SizedBox(height: 8),
                        HyperText('普通圆环'),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        HyperButton.filled(
                          onPressed: () {},
                          loading: true,
                          child: const HyperText('加载'),
                        ),
                        const SizedBox(height: 8),
                        const HyperText('按钮加载态'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const HyperText(
                  '局部主题与实例覆盖',
                  variant: HyperTextVariant.sectionTitle,
                ),
                const SizedBox(height: 16),
                HyperProgressIndicatorTheme(
                  data: const HyperProgressIndicatorThemeData(
                    style: HyperProgressIndicatorStyle(
                      color: Color(0xFFFF9500),
                    ),
                  ),
                  child: Column(
                    children: [
                      HyperLinearProgressIndicator(value: _value),
                      const SizedBox(height: 20),
                      HyperCircularProgressIndicator(
                        value: _value,
                        color: parent.colors.primary,
                        size: 36,
                        thickness: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
