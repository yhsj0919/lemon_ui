import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

@Preview(name: '图片取色渐变', group: '未确认', size: Size(480, 900))
Widget imageGradientPreview() => MaterialApp(
  home: HyperTheme(
    data: HyperThemeData.light(),
    child: const Scaffold(body: HyperImageGradientPage()),
  ),
);

class HyperImageGradientPage extends StatefulWidget {
  const HyperImageGradientPage({super.key});
  @override
  State<HyperImageGradientPage> createState() => _ImageGradientPageState();
}

class _ImageGradientPageState extends State<HyperImageGradientPage> {
  final _url = TextEditingController();
  ImageProvider? _image;
  Color? _top, _dominant;
  String? _error;
  String _direction = 'down';
  HyperImageColorRole _colorRole = HyperImageColorRole.primary;
  double _startStop = 0, _endStop = 1;
  double? _colorStrength;

  @override
  void initState() {
    super.initState();
    _sample();
  }

  Future<void> _sample() async {
    // Offline illustration for the demo; these pixels are image content,
    // independent of theme/device geometry.
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawColor(const Color(0xFF308CD2), BlendMode.src);
    canvas.drawRect(
      const Rect.fromLTWH(42, 0, 22, 64),
      Paint()..color = const Color(0xFF62B48C),
    );
    final picture = recorder.endRecording();
    final image = await picture.toImage(64, 64);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    picture.dispose();
    if (!mounted || data == null) return;
    setState(() => _image = MemoryImage(data.buffer.asUint8List()));
  }

  Future<void> _pick() async {
    try {
      final files = await HyperFileDialog.pickFiles(
        multiple: false,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'webp', 'gif'],
      );
      if (files.isEmpty) return;
      final bytes = await files.first.readAsBytes();
      if (!mounted) return;
      setState(() {
        _image = MemoryImage(bytes);
        _error = null;
        _dominant = null;
      });
    } catch (error) {
      if (mounted) setState(() => _error = '$error');
    }
  }

  void _loadUrl() {
    final uri = Uri.tryParse(_url.text.trim());
    if (uri == null ||
        !['http', 'https'].contains(uri.scheme) ||
        uri.host.isEmpty) {
      setState(() => _error = '请输入 http 或 https 图片链接');
      return;
    }
    setState(() {
      _image = NetworkImage(uri.toString());
      _error = null;
      _dominant = null;
    });
  }

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context),
        colors = HyperTheme.of(context).colors;
    final top = _top ?? colors.surface;
    final strength =
        _colorStrength ??
        HyperTheme.of(context).containerTheme.imageColorStrength ??
        .2;
    final (begin, end) = switch (_direction) {
      'up' => (Alignment.bottomCenter, Alignment.topCenter),
      'right' => (Alignment.centerLeft, Alignment.centerRight),
      'left' => (Alignment.centerRight, Alignment.centerLeft),
      'diagonal' => (Alignment.topLeft, Alignment.bottomRight),
      _ => (Alignment.topCenter, Alignment.bottomCenter),
    };
    return ListView(
      padding: EdgeInsets.all(sizes.pageHorizontalPadding),
      children: [
        const HyperText('图片取色渐变 · 未确认'),
        const HyperText(
          '默认使用 Flutter 原生 primary 取色，并以 20% 强度混合为浅背景。可选 primaryContainer；强度设为 100% 可查看原色。初始使用离线示例图片。',
        ),
        DemoSection(
          title: '图片来源',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HyperButton.outlined(
                onPressed: _pick,
                label: const Text('选择本地图片'),
              ),
              HyperTextField(controller: _url, hintText: 'https://… 图片链接'),
              HyperButton.outlined(
                onPressed: _loadUrl,
                label: const Text('从链接取色'),
              ),
              if (_error != null)
                HyperText(_error!, style: TextStyle(color: colors.error)),
            ],
          ),
        ),
        DemoSection(
          title: '内容颜色 · 指定起点颜色（默认上方）',
          child: HyperColorPickerField(
            value: top,
            onChanged: (color) => setState(() => _top = color),
          ),
        ),
        DemoSection(
          title: '图片配色 · Flutter 原生',
          child: HyperSelect<HyperImageColorRole>(
            value: _colorRole,
            options: const [
              HyperSelectOption(
                value: HyperImageColorRole.primary,
                label: 'primary（默认）',
              ),
              HyperSelectOption(
                value: HyperImageColorRole.primaryContainer,
                label: 'primaryContainer',
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _colorRole = value;
                  _dominant = null;
                });
              }
            },
          ),
        ),
        DemoSection(
          title: '图片色强度 · 与颜色占比分开',
          child: Column(
            children: [
              HyperText('图片色强度：${(strength * 100).round()}%（100% 为原色）'),
              HyperSlider(
                value: strength,
                min: 0,
                max: 1,
                divisions: 100,
                onChanged: (value) => setState(() => _colorStrength = value),
              ),
              HyperButton.text(
                onPressed: () => setState(() => _colorStrength = null),
                label: const Text('恢复强度继承'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: '线性渐变方向',
          child: HyperSelect<String>(
            value: _direction,
            options: const [
              HyperSelectOption(value: 'down', label: '从上到下（默认）'),
              HyperSelectOption(value: 'up', label: '从下到上'),
              HyperSelectOption(value: 'right', label: '从左到右'),
              HyperSelectOption(value: 'left', label: '从右到左'),
              HyperSelectOption(value: 'diagonal', label: '左上到右下'),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _direction = value);
            },
          ),
        ),
        DemoSection(
          title: '颜色占比与过渡区间',
          child: Column(
            children: [
              HyperText('指定色停靠位置：${(_startStop * 100).round()}%'),
              HyperSlider(
                value: _startStop,
                min: 0,
                max: 1,
                divisions: 100,
                onChanged: (value) =>
                    setState(() => _startStop = value.clamp(0, _endStop)),
              ),
              HyperText('图片色停靠位置：${(_endStop * 100).round()}%'),
              HyperSlider(
                value: _endStop,
                min: 0,
                max: 1,
                divisions: 100,
                onChanged: (value) =>
                    setState(() => _endStop = value.clamp(_startStop, 1)),
              ),
              const HyperText('起点到第一个位置保持指定色，两位置之间渐变，第二个位置之后保持图片色。'),
            ],
          ),
        ),
        if (_image case final image?) ...[
          DemoSection(
            title: '图片预览',
            child: AspectRatio(
              aspectRatio: 3,
              child: HyperImage(image: image, fit: BoxFit.contain),
            ),
          ),
          DemoSection(
            title: '渐变预览 · 起点指定颜色，终点图片主色',
            child: AspectRatio(
              aspectRatio: 2,
              child: HyperContainer.imageGradient(
                image: image,
                startColor: top,
                colorRole: _colorRole,
                colorStrength: _colorStrength,
                begin: begin,
                end: end,
                stops: [_startStop, _endStop],
                onColorExtracted: (color) => setState(() => _dominant = color),
                onImageError: (error) => setState(() => _error = '$error'),
              ),
            ),
          ),
          if (_dominant case final color?)
            HyperText(
              '图片主色：#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}',
            ),
        ],
      ],
    );
  }
}
