import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../editor/editor_dimension_limits.dart';

/// 高透玻璃配方实验，确认后再考虑纳入公共材质接口。
class HyperClearGlassPage extends StatefulWidget {
  const HyperClearGlassPage({super.key});

  @override
  State<HyperClearGlassPage> createState() => _HyperClearGlassPageState();
}

class _HyperClearGlassPageState extends State<HyperClearGlassPage> {
  double _blur = const HyperSurfaceMaterial.clearFrostedGlass().blurSigmaX;
  double _spread = -2;
  double _transparency = 92;
  Color _tint = const Color(0xFF607080);
  double _tintStrength = 26;
  double _shadowStrength = 100;
  double _edgeStrength = 100;

  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    final material = HyperMaterialTheme.of(context);
    final advanced =
        material.quality == HyperMaterialQuality.advanced &&
        !(material.reduceTransparency ?? false);
    return ListView(
      padding: EdgeInsets.all(sizes.pageHorizontalPadding),
      children: [
        const HyperText('高透毛玻璃'),
        const SizedBox(height: 12),
        const HyperText(
          '内置配方：轻模糊、低透明度染色、渐变亮边与柔和暗边。'
          '两个场景使用相同配方；滚动背景观察通透与轻模糊效果。'
          '配方来自本项目视觉确认，不代表官方规格。',
        ),
        const SizedBox(height: 12),
        HyperText(
          advanced ? '当前：高级玻璃（跟随右侧材质设置）' : '当前：不透明降级；右侧开启高级质量并关闭减少透明度可查看玻璃',
        ),
        const SizedBox(height: 20),
        const HyperText('玻璃表面'),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: HyperButton.outlined(
            label: const Text('完全透明（保留文字）'),
            onPressed: () => setState(() {
              _transparency = 100;
              _blur = 0;
              _shadowStrength = 0;
              _edgeStrength = 0;
            }),
          ),
        ),
        const SizedBox(height: 8),
        const HyperText('表面暗部着色'),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: HyperColorPickerField(
            value: _tint,
            onChanged: (color) => setState(() => _tint = color),
          ),
        ),
        const SizedBox(height: 12),
        HyperText('着色强度：${_tintStrength.round()}%'),
        HyperSlider(
          value: _tintStrength,
          min: 0,
          max: 100,
          divisions: 100,
          onChanged: (value) =>
              setState(() => _tintStrength = value.roundToDouble()),
        ),
        const SizedBox(height: 12),
        HyperText('表面透明度：${_transparency.round()}%（越高越通透）'),
        HyperSlider(
          value: _transparency,
          min: 0,
          max: 100,
          divisions: 100,
          onChanged: (value) =>
              setState(() => _transparency = value.roundToDouble()),
        ),
        const SizedBox(height: 12),
        HyperText('背景模糊度：${_blur.round()}'),
        HyperSlider(
          value: _blur,
          min: 0,
          max: editorClearGlassBlurLimit,
          divisions: editorClearGlassBlurLimit.toInt(),
          onChanged: (value) => setState(() => _blur = value.roundToDouble()),
        ),
        const SizedBox(height: 12),
        const HyperText('高光与暗边'),
        HyperText('边缘强度：${_edgeStrength.round()}%'),
        HyperSlider(
          value: _edgeStrength,
          min: 0,
          max: 100,
          divisions: 100,
          onChanged: (value) =>
              setState(() => _edgeStrength = value.roundToDouble()),
        ),
        const SizedBox(height: 12),
        const HyperText('表面阴影'),
        HyperText('阴影强度：${_shadowStrength.round()}%'),
        HyperSlider(
          value: _shadowStrength,
          min: 0,
          max: 100,
          divisions: 100,
          onChanged: (value) =>
              setState(() => _shadowStrength = value.roundToDouble()),
        ),
        HyperText('阴影扩散度：${_spread.round()}'),
        HyperSlider(
          value: _spread,
          min: -editorClearGlassSpreadLimit,
          max: editorClearGlassSpreadLimit,
          divisions: (editorClearGlassSpreadLimit * 2).toInt(),
          onChanged: (value) => setState(() => _spread = value.roundToDouble()),
        ),
        const SizedBox(height: 24),
        const HyperText('彩色背景'),
        const SizedBox(height: 12),
        _scene(context, white: false, advanced: advanced),
        const SizedBox(height: 24),
        const HyperText('纯白背景'),
        const SizedBox(height: 12),
        _scene(context, white: true, advanced: advanced),
      ],
    );
  }

  Widget _scene(
    BuildContext context, {
    required bool white,
    required bool advanced,
  }) {
    final radius = BorderRadius.circular(
      HyperTheme.sizesOf(context).controlRadius,
    );
    return ClipRect(
      child: SizedBox(
        height: 360,
        child: Container(
          decoration: BoxDecoration(
            color: white ? Colors.white : null,
            gradient: white
                ? null
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFCB98),
                      Color(0xFF8DDBEB),
                      Color(0xFFBCA5EA),
                    ],
                  ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: ListView.builder(
                  primary: false,
                  itemCount: 30,
                  itemBuilder: (context, index) => Container(
                    constraints: const BoxConstraints(minHeight: 88),
                    padding: const EdgeInsets.all(20),
                    color: white
                        ? Colors.white
                        : const [
                            Color(0xFFFFCB98),
                            Color(0xFF8DDBEB),
                            Color(0xFFBCA5EA),
                          ][index % 3],
                    child: Text(
                      '背景 ${index + 1}   ━━━   ABC 0123456789',
                      style: TextStyle(
                        color: white
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF354050),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: HyperMaterialSurface(
                    borderRadius: radius,
                    material: HyperSurfaceMaterial.clearFrostedGlass(
                      edgeEnabled: true,
                      blurSigmaX: _blur,
                      blurSigmaY: _blur,
                      background: HyperFill.gradient(
                        LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(
                              alpha: 1 - _transparency / 100,
                            ),
                            _tint.withValues(
                              alpha:
                                  _tint.a *
                                  (1 - _transparency / 100) *
                                  _tintStrength /
                                  100,
                            ),
                          ],
                        ),
                      ),
                      edgeGradient: _edgeStrength == 0
                          ? null
                          : HyperSurfaceMaterial.clearGlassEdge.scale(
                              _edgeStrength / 100,
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0x140F2035,
                          ).withValues(alpha: 20 / 255 * _shadowStrength / 100),
                          blurRadius: 20,
                          spreadRadius: _spread,
                        ),
                        BoxShadow(
                          color: const Color(
                            0x080F2035,
                          ).withValues(alpha: 8 / 255 * _shadowStrength / 100),
                          blurRadius: 4,
                        ),
                      ],
                      fallback: HyperSurfaceMaterial.solid(
                        background: HyperFill.color(Color(0xFFF1F2F4)),
                        border: BorderSide(color: Color(0x220F2035)),
                      ),
                    ),
                    padding: const EdgeInsets.all(28),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '高透玻璃表面',
                          style: TextStyle(
                            color: Color(0xFF18212D),
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          '保持背景通透，通过高光与暗边呈现轮廓',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF354050)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
