import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 展示 HyperText 的语义层级和三层样式覆盖。
class HyperTextPage extends StatefulWidget {
  const HyperTextPage({super.key});

  @override
  State<HyperTextPage> createState() => _HyperTextPageState();
}

class _HyperTextPageState extends State<HyperTextPage> {
  bool _emphasizeBody = false;

  @override
  Widget build(BuildContext context) {
    final parent = HyperTheme.of(context);
    final textTheme = HyperTextThemeData(
      body: _emphasizeBody
          ? TextStyle(color: parent.colors.primary, fontWeight: FontWeight.w600)
          : null,
    );

    return HyperTheme(
      data: parent.copyWith(textComponentTheme: textTheme),
      child: Builder(
        builder: (context) => Material(
          color: HyperTheme.of(context).colors.background,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const HyperText('HyperText', variant: HyperTextVariant.pageTitle),
              const SizedBox(height: 8),
              const HyperText('直接使用系统字体和明确语义字号，不执行倍率缩放。'),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(child: HyperText('全局强调正文')),
                  HyperSwitch(
                    value: _emphasizeBody,
                    onChanged: (value) =>
                        setState(() => _emphasizeBody = value),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              for (final sample in _samples) ...[
                HyperText(sample.$2, variant: sample.$1),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 12),
              const HyperText('局部主题覆盖', variant: HyperTextVariant.sectionTitle),
              const SizedBox(height: 12),
              HyperTextTheme(
                data: const HyperTextThemeData(
                  label: TextStyle(
                    color: Color(0xFF7A4DFF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const HyperText(
                  '当前子树的标签样式',
                  variant: HyperTextVariant.label,
                ),
              ),
              const SizedBox(height: 12),
              const HyperText(
                '实例精确覆盖 · 17px',
                variant: HyperTextVariant.body,
                style: TextStyle(
                  fontSize: 17,
                  letterSpacing: .4,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 12),
              const SizedBox(
                width: 220,
                child: HyperText(
                  '最大两行和省略号由 Flutter Text 原生参数直接控制，内容不会改变控件 API。',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _samples = <(HyperTextVariant, String)>[
  (HyperTextVariant.displayLarge, '超大展示'),
  (HyperTextVariant.displayMedium, '大展示'),
  (HyperTextVariant.displaySmall, '小展示'),
  (HyperTextVariant.pageTitle, '页面标题'),
  (HyperTextVariant.sectionTitle, '分区标题'),
  (HyperTextVariant.subsectionTitle, '次级标题'),
  (HyperTextVariant.bodyLarge, '强调正文'),
  (HyperTextVariant.body, '默认正文'),
  (HyperTextVariant.bodySmall, '辅助正文'),
  (HyperTextVariant.control, '控件文字'),
  (HyperTextVariant.label, '标签文字'),
  (HyperTextVariant.caption, '说明文字'),
];
