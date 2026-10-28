import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';
import 'image_demo_data.dart';
import 'image_demo_provider.dart';

@Preview(name: '图片预览', group: '文字与内容', size: Size(360, 800))
Widget imagePreviewToolsPreview() => MaterialApp(
  home: HyperTheme(
    data: HyperThemeData.light(),
    child: const Scaffold(body: HyperImagePreviewPage()),
  ),
);
@Preview(name: '图片编辑', group: '文字与内容', size: Size(360, 800))
Widget imageEditorToolsPreview() => MaterialApp(
  home: HyperTheme(
    data: HyperThemeData.light(),
    child: const Scaffold(body: HyperImageEditorPage()),
  ),
);

List<HyperImagePreviewItem> _items() => [
  HyperImagePreviewItem(
    image: MemoryImage(imageDemoBytes),
    semanticLabel: '山景 · 第一张',
  ),
  HyperImagePreviewItem(
    image: MemoryImage(imageDemoBytes),
    semanticLabel: '山景 · 第二张',
  ),
  HyperImagePreviewItem(
    image: DemoImageProvider(failFirst: true),
    semanticLabel: '首次模拟失败 · 重试示例',
  ),
];

class HyperImagePreviewPage extends StatelessWidget {
  const HyperImagePreviewPage({super.key});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HyperText('图片预览', variant: HyperTextVariant.pageTitle),
        const HyperText('支持双击、滚轮、双指缩放，放大后拖动；方向键切换，0 重置，+ / - 缩放。第三张用于查看失败状态。'),
        DemoSection(
          title: '默认主题 · 嵌入预览（演示高度 360）',
          child: SizedBox(
            height: 360,
            child: HyperImagePreview(items: _items(), autofocus: false),
          ),
        ),
        DemoSection(
          title: '默认主题 · 弹窗预览',
          child: HyperButton.tonal(
            onPressed: () =>
                showHyperImagePreview(context: context, items: _items()),
            label: const Text('打开图片预览'),
          ),
        ),
        DemoSection(
          title: '默认主题 · Hero 预览（点击缩略图）',
          child: Wrap(
            spacing: HyperTheme.sizesOf(context).image.spacing,
            children: [
              for (var i = 0; i < 2; i++)
                GestureDetector(
                  onTap: () => showHyperImagePreview(
                    context: context,
                    initialIndex: i,
                    items: [
                      for (var j = 0; j < 2; j++)
                        HyperImagePreviewItem(
                          image: MemoryImage(imageDemoBytes),
                          heroTag: 'image-preview-demo-$j',
                          semanticLabel: '山景 · 第 ${j + 1} 张',
                        ),
                    ],
                  ),
                  child: HyperImage.memory(
                    imageDemoBytes,
                    width: 120,
                    height: 80,
                    heroTag: 'image-preview-demo-$i',
                    semanticLabel: '点击预览第 ${i + 1} 张图片',
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

class HyperImageEditorPage extends StatefulWidget {
  const HyperImageEditorPage({super.key});
  @override
  State<HyperImageEditorPage> createState() => _HyperImageEditorPageState();
}

class _HyperImageEditorPageState extends State<HyperImageEditorPage> {
  HyperImageEditResult? _result;
  final _controller = HyperImageEditorController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HyperText('图片编辑', variant: HyperTextVariant.pageTitle),
        const HyperText('拖动裁剪边角、移动图片或缩放，支持旋转、翻转、撤销和重做。导出返回 PNG 字节，不自动写入文件。'),
        DemoSection(
          title: '默认主题 · 编辑器（演示高度 400）',
          child: SizedBox(
            height: 400,
            child: HyperImageEditor(
              bytes: imageDemoBytes,
              controller: _controller,
              onExport: (result) => setState(() => _result = result),
            ),
          ),
        ),
        DemoSection(
          title: '裁剪比例',
          child: Wrap(
            children: [
              HyperButton.text(
                onPressed: () => _controller.setCropAspectRatio(null),
                label: const Text('自由'),
              ),
              HyperButton.text(
                onPressed: () => _controller.setCropAspectRatio(1),
                label: const Text('1:1'),
              ),
              HyperButton.text(
                onPressed: () => _controller.setCropAspectRatio(4 / 3),
                label: const Text('4:3'),
              ),
              HyperButton.text(
                onPressed: () => _controller.setCropAspectRatio(16 / 9),
                label: const Text('16:9'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: '默认主题 · 弹窗编辑',
          child: HyperButton.tonal(
            onPressed: () async {
              final result = await showHyperImageEditor(
                context: context,
                bytes: imageDemoBytes,
              );
              if (mounted && result != null) setState(() => _result = result);
            },
            label: const Text('打开图片编辑器'),
          ),
        ),
        if (_result case final result?)
          DemoSection(
            title: '导出结果 · ${result.width} × ${result.height} 像素',
            child: HyperImage.memory(
              result.bytes,
              width: 240,
              fit: BoxFit.contain,
            ),
          ),
      ],
    ),
  );
}
