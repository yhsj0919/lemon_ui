import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

class HyperCardPage extends StatefulWidget {
  const HyperCardPage({super.key});

  @override
  State<HyperCardPage> createState() => _HyperCardPageState();
}

class _HyperCardPageState extends State<HyperCardPage> {
  var _taps = 0;

  @override
  Widget build(BuildContext context) {
    final colors = HyperTheme.of(context).colors;
    return Material(
      color: colors.background,
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: HyperTheme.sizesOf(context).pageHorizontalPadding,
          vertical: 24,
        ),
        children: [
          const HyperText('HyperCard', variant: HyperTextVariant.pageTitle),
          const SizedBox(height: 8),
          const HyperText('基础表面保持零内边距；内容、媒体和操作区由调用方自由组合。'),
          const SizedBox(height: 24),
          const HyperText('基础卡片', variant: HyperTextVariant.sectionTitle),
          const SizedBox(height: 12),
          const HyperCard(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: HyperText('内容自行决定内部布局'),
            ),
          ),
          const SizedBox(height: 16),
          const HyperText('整卡交互', variant: HyperTextVariant.sectionTitle),
          const SizedBox(height: 12),
          HyperCard(
            onTap: () => setState(() => _taps++),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: HyperText('点击次数：$_taps'),
            ),
          ),
          const SizedBox(height: 16),
          const HyperText('局部覆盖', variant: HyperTextVariant.sectionTitle),
          const SizedBox(height: 12),
          HyperCard(
            style: HyperCardStyle(
              background: HyperFill.color(colors.primaryContainer),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: HyperText('实例只覆盖当前卡片'),
            ),
          ),
          const SizedBox(height: 16),
          const HyperText('表面材质', variant: HyperTextVariant.sectionTitle),
          const SizedBox(height: 12),
          // 材质示例放在渐变背景上，便于观察透明填充与色调叠加。
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
            child: HyperCard(
              style: HyperCardStyle(
                material: const HyperSurfaceMaterial.translucent(
                  background: HyperFill.color(Color(0xCCFFFFFF)),
                  tint: Color(0x143482FF),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: HyperText('Card 与 Button 使用相同的材质配方'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const HyperTitledCard(
            title: Text('标题在外'),
            action: Text('查看全部'),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('内容可放列表或其他控件'),
            ),
          ),
          const SizedBox(height: 16),
          const HyperTitledCard(
            titlePosition: HyperCardTitlePosition.inside,
            title: Text('标题在内'),
            action: Icon(Icons.refresh),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [Text('网格项 A'), Text('网格项 B'), Text('网格项 C')],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
