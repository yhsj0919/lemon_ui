import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 只展示锚定和开合；浮层表面由内容自行组合。
class HyperAnchoredOverlayPage extends StatelessWidget {
  const HyperAnchoredOverlayPage({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: HyperTheme.sizesOf(context).pageHorizontalPadding,
      vertical: 24,
    ),
    child: Wrap(
      spacing: 32,
      runSpacing: 32,
      children: [
        HyperAnchoredOverlay(
          anchor: const HyperCard(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: HyperText('点击打开'),
            ),
          ),
          overlayBuilder: (context, close) => HyperCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: HyperButton.tonal(
                onPressed: close,
                child: const HyperText('关闭浮层'),
              ),
            ),
          ),
        ),
        HyperAnchoredOverlay.builder(
          placement: HyperOverlayPlacement.topStart,
          anchorBuilder: (context, toggle, isOpen) => HyperButton.tonal(
            onPressed: toggle,
            child: HyperText(isOpen ? '收起网格' : '上方网格'),
          ),
          overlayBuilder: (context, close) => HyperCard(
            child: SizedBox(
              width: 200,
              height: 120,
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  for (final label in ['一', '二', '三', '四'])
                    HyperButton.ghost(
                      onPressed: close,
                      child: HyperText(label),
                    ),
                ],
              ),
            ),
          ),
        ),
        HyperAnchoredOverlay(
          trigger: HyperOverlayTrigger.hover,
          placement: HyperOverlayPlacement.sideEnd,
          transition: HyperOverlayTransition.fade,
          anchor: const HyperCard(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: HyperText('悬停查看子项'),
            ),
          ),
          overlayBuilder: (context, close) => const HyperCard(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: HyperText('鼠标移入此处，浮层会保持打开'),
            ),
          ),
        ),
        HyperAnchoredOverlay(
          anchor: const HyperCard(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: HyperText('自定义过渡'),
            ),
          ),
          transitionBuilder: (context, animation, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, .08),
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          ),
          overlayBuilder: (context, close) => const HyperCard(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: HyperText('浮层过渡由使用端替换'),
            ),
          ),
        ),
      ],
    ),
  );
}
