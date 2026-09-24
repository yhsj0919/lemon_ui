import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

class HyperTooltipPage extends StatelessWidget {
  const HyperTooltipPage({super.key});

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 320),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFFFF8A45), Color(0xFF7E57C2), Color(0xFF42A5F5)],
      ),
    ),
    padding: EdgeInsets.symmetric(
      horizontal: HyperTheme.sizesOf(context).pageHorizontalPadding,
      vertical: 80,
    ),
    child: Wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        HyperTooltip(
          message: '悬停、聚焦或长按后显示说明',
          child: HyperButton.tonal(
            onPressed: () {},
            child: const HyperText('默认提示'),
          ),
        ),
        HyperTooltip(
          message: '空间不足时自动调整位置',
          placement: HyperOverlayPlacement.bottomStart,
          child: HyperButton.outlined(
            onPressed: () {},
            child: const HyperText('下方提示'),
          ),
        ),
        HyperTooltip(
          message: '替换后的滑入动画',
          transitionBuilder: (context, animation, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, .12),
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: HyperButton.ghost(
            onPressed: () {},
            child: const HyperText('自定义动画'),
          ),
        ),
      ],
    ),
  );
}
