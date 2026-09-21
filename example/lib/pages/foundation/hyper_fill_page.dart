import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 展示 HyperFill 三种基础语义的独立页面。
class HyperFillPage extends StatelessWidget {
  const HyperFillPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: const [
        Text('填充', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Text('HyperFill 是首个实现的基础视觉类型。'),
        SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _FillPreview(label: '无填充', fill: HyperFill.none()),
            _FillPreview(label: '纯色', fill: HyperFill.color(Color(0xFFFFC107))),
            _FillPreview(
              label: '线性渐变',
              fill: HyperFill.gradient(
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFD54F), Color(0xFFFF7043)],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FillPreview extends StatelessWidget {
  const _FillPreview({required this.label, required this.fill});

  final String label;
  final HyperFill fill;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 96,
            decoration: BoxDecoration(
              color: fill.color,
              gradient: fill.gradient,
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: fill.isNone ? const Text('未绘制背景') : const SizedBox.shrink(),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
