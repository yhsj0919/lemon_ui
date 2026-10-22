import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

/// 展示基础进度控件的确定、不确定、主题和减少动画状态。
class HyperProgressPage extends StatefulWidget {
  const HyperProgressPage({super.key});

  @override
  State<HyperProgressPage> createState() => _HyperProgressPageState();
}

class _HyperProgressPageState extends State<HyperProgressPage> {
  double _value = .35;
  double _buffer = .65;
  bool _disableAnimations = false;

  @override
  Widget build(BuildContext context) {
    final parent = HyperTheme.of(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        disableAnimations:
            MediaQuery.of(context).disableAnimations || _disableAnimations,
      ),
      child: Material(
        color: HyperTheme.of(context).colors.background,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: HyperTheme.sizesOf(context).pageHorizontalPadding,
            vertical: 24,
          ),
          children: [
            const HyperText(
              '进度',
              variant: HyperTextVariant.pageTitle,
            ),
            const SizedBox(height: 8),
            const HyperText('统一入口连接线性和圆形进度，确定进度变化保持平滑。'),
            const SizedBox(height: 20),
            DemoSection(
              title: '动画设置',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const HyperText('减少动画'),
                      HyperSwitch(
                        value: _disableAnimations,
                        onChanged: (value) =>
                            setState(() => _disableAnimations = value),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            DemoSection(
              title: '默认主题预览 · 未确认',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HyperText('细线进度'),
                  const SizedBox(height: 8),
                  HyperProgress.linear(value: _value),
                  const SizedBox(height: 16),
                  const HyperText('宽条进度'),
                  const SizedBox(height: 8),
                  HyperProgress.linear(
                    value: _value,
                    variant: HyperProgressVariant.wide,
                  ),
                  const SizedBox(height: 16),
                  const HyperText('圆形进度与无限等待'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      HyperProgress.circular(value: _value),
                      const HyperProgress.infinite(),
                    ],
                  ),
                ],
              ),
            ),
            DemoSection(
              title: '确定进度（部分实例尺寸覆盖）',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HyperProgress.linear(
                    value: _value,
                    semanticsLabel: '下载进度',
                    semanticsValue: '${(_value * 100).round()}%',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      HyperProgress.circular(
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
                ],
              ),
            ),
            DemoSection(
              title: '二级缓冲进度',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HyperText(
                    '已完成 ${(_value * 100).round()}% · 已缓冲 ${(_buffer.clamp(_value, 1) * 100).round()}%',
                  ),
                  const SizedBox(height: 12),
                  HyperProgress.linear(
                    value: _value,
                    bufferValue: _buffer,
                    variant: HyperProgressVariant.wide,
                  ),
                  const SizedBox(height: 16),
                  HyperText('调整缓冲'),
                  HyperSlider(
                    value: _buffer.clamp(_value, 1).toDouble(),
                    min: _value,
                    max: 1,
                    onChanged: (value) => setState(() => _buffer = value),
                  ),
                ],
              ),
            ),
            DemoSection(
              title: '宽条与 Slider 对照',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HyperProgress.linear(
                    value: _value,
                    variant: HyperProgressVariant.wide,
                    semanticsLabel: '宽条进度',
                  ),
                  const SizedBox(height: 16),
                  HyperSlider(
                    value: _value,
                    onChanged: (value) => setState(() => _value = value),
                  ),
                  const SizedBox(height: 16),
                  const HyperProgress.linear(
                    variant: HyperProgressVariant.wide,
                    semanticsLabel: '宽条加载中',
                  ),
                  const SizedBox(height: 16),
                  HyperProgressTheme(
                    data: HyperProgressThemeData(
                      linearStyle: HyperProgressStyle(
                        variant: HyperProgressVariant.wide,
                        color: parent.colors.primary,
                        radius: 6,
                        fillRadius: 6,
                      ),
                    ),
                    child: HyperProgress.linear(value: _value),
                  ),
                ],
              ),
            ),
            DemoSection(
              title: '不确定进度',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HyperLinearProgress(semanticsLabel: '正在加载'),
                  const SizedBox(height: 20),
                  const Wrap(
                    spacing: 20,
                    runSpacing: 16,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      HyperCircularProgress(),
                      SizedBox(width: 20),
                      HyperCircularProgress(size: 40, thickness: 4),
                      SizedBox(width: 20),
                      HyperInfiniteProgress(semanticsLabel: '无限等待进度'),
                      SizedBox(width: 20),
                      HyperInfiniteProgress(
                        size: 40,
                        thickness: 3,
                        orbitingDotSize: 4,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            DemoSection(
              title: '按钮加载态对比',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HyperText('仅使用默认属性，对比普通圆环与按钮内部加载态。'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 20,
                    runSpacing: 16,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      const Column(
                        children: [
                          HyperCircularProgress(),
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
                ],
              ),
            ),
            const DemoSection(
              title: '渐变填充（实例 Style 覆盖）',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HyperProgress.linear(
                    value: .65,
                    gradient: LinearGradient(
                      colors: [Color(0xFF3482FF), Color(0xFF7A4DFF)],
                    ),
                  ),
                  SizedBox(height: 16),
                  HyperProgress.linear(
                    value: .65,
                    variant: HyperProgressVariant.wide,
                    gradient: LinearGradient(
                      colors: [Color(0xFF3482FF), Color(0xFF7A4DFF)],
                    ),
                  ),
                ],
              ),
            ),
            DemoSection(
              title: '局部主题与实例覆盖',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HyperProgressTheme(
                    data: const HyperProgressThemeData(
                      style: HyperProgressStyle(color: Color(0xFFFF9500)),
                    ),
                    child: Column(
                      children: [
                        HyperLinearProgress(value: _value),
                        const SizedBox(height: 20),
                        HyperCircularProgress(
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
          ],
        ),
      ),
    );
  }
}
