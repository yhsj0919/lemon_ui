import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';
import 'image_demo_data.dart';
import 'image_demo_provider.dart';

@Preview(name: '图片', group: '文字与内容', size: Size(360, 800))
Widget imagePreview() => MaterialApp(
  home: HyperTheme(
    data: HyperThemeData.light(),
    child: const Scaffold(body: HyperImagePage()),
  ),
);

class HyperImagePage extends StatefulWidget {
  const HyperImagePage({super.key});
  @override
  State<HyperImagePage> createState() => _HyperImagePageState();
}

class _HyperImagePageState extends State<HyperImagePage> {
  ImageProvider _loading = DemoImageProvider();
  final ImageProvider _retry = DemoImageProvider(failFirst: true);
  @override
  Widget build(BuildContext context) {
    final s = HyperTheme.sizesOf(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(s.pageHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HyperText('图片', variant: HyperTextVariant.pageTitle),
          const HyperText('默认封装加载、失败与重试。以下本地数据模拟状态，不依赖网络。'),
          DemoSection(
            title: '默认主题 · 外观变体',
            child: Wrap(
              spacing: s.image.spacing,
              runSpacing: s.image.spacing,
              children: [
                for (final variant in HyperImageVariant.values)
                  SizedBox(
                    width: 240,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HyperText(variant.name),
                        HyperImage.memory(
                          imageDemoBytes,
                          aspectRatio: 1.5,
                          variant: variant,
                          semanticLabel: '山景示例',
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          DemoSection(
            title: '默认主题 · 加载与成功',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HyperImage(image: _loading, width: 240, aspectRatio: 1.5),
                HyperButton.text(
                  onPressed: () =>
                      setState(() => _loading = DemoImageProvider()),
                  label: const Text('重新演示加载'),
                ),
              ],
            ),
          ),
          DemoSection(
            title: '默认主题 · 模拟首次失败，重试后恢复',
            child: HyperImage(image: _retry, width: 240, height: 180),
          ),
          DemoSection(
            title: '局部主题覆盖 · 方角边框',
            child: HyperImageTheme(
              data: HyperImageThemeData(
                outlined: HyperImageAppearance(
                  style: HyperImageStyle(
                    surfaceStyle: HyperCardStyle(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
              ),
              child: HyperImage.memory(
                imageDemoBytes,
                width: 240,
                aspectRatio: 1.5,
                variant: HyperImageVariant.outlined,
              ),
            ),
          ),
          DemoSection(
            title: '实例 Style 覆盖 · 关闭阴影',
            child: HyperImage.memory(
              imageDemoBytes,
              width: 240,
              aspectRatio: 1.5,
              variant: HyperImageVariant.elevated,
              style: HyperImageStyle(
                surfaceStyle: HyperCardStyle(boxShadow: const []),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
