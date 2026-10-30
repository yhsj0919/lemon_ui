part of 'theme_editor.dart';

extension _MotionWorkspace on _ThemeEditorState {
  Widget _motionLiftPanel() {
    final theme = _resolveTheme(_dark), s = theme.sizes.resolve(_device);
    final state = const ['common', 'hovered', 'pressed'].contains(_reviewState)
        ? _reviewState
        : 'common';
    final slot = state == 'common'
        ? 'motionLift'
        : state == 'hovered'
        ? 'motionLiftHover'
        : 'motionLiftPressed';
    final v = _mode.reviews.object(slot), m = _spec.reviews.object(slot);
    final style = theme.motion.lift.style;
    final hovered = state == 'hovered';
    final offset = hovered
        ? s.motionLift.hoverOffset
        : s.motionLift.pressedOffset;
    final limit = editorMotionTranslationLimit(s);
    Widget n(
      String label,
      double? value,
      double base,
      double min,
      double max,
      void Function(double?) set, {
      bool pixels = true,
    }) => _number(
      label,
      value ?? base,
      min,
      max,
      (x) => _change(() => set(pixels ? x.roundToDouble() : x)),
      () => _change(() => set(null)),
      value != null,
      wholeNumbers: pixels,
      decimalPlaces: 3,
    );
    return _panel('悬停上浮 · 未确认', [
      _select('交互状态', state, const {
        'common': '通用（所有状态）',
        'hovered': '悬停 / 聚焦',
        'pressed': '按下',
      }, (value) => _updateState(() => _reviewState = value)),
      HyperButton.text(
        onPressed: () => _change(() {
          _mode.reviews.reset(slot);
          _spec.reviews.reset(slot);
        }),
        label: const Text('恢复当前范围继承'),
      ),
      const HyperText('只包装动效，不接管子控件点击。默认预览使用真实悬停与按下；可在页面中固定状态对照。'),
      if (state == 'common') ...[
        _heading('状态过渡'),
        n(
          '上浮时长',
          v.duration,
          theme.motion.standardDuration.inMilliseconds.toDouble(),
          0,
          editorMotionDurationLimit,
          (x) => v.duration = x,
        ),
        n(
          '回压时长',
          v.pressDuration,
          theme.motion.fastDuration.inMilliseconds.toDouble(),
          0,
          editorMotionDurationLimit,
          (x) => v.pressDuration = x,
        ),
        _select(
          '过渡曲线',
          v.curve ?? 'inherit',
          const {
            'inherit': '继承主题',
            'linear': '线性',
            'easeInOut': '缓入缓出',
            'fastOutSlowIn': '快出慢入',
          },
          (value) => _change(() => v.curve = value == 'inherit' ? null : value),
        ),
        _heading('阴影表面'),
        _select(
          '包装层阴影表面',
          v.liftSurface?.toString() ?? 'inherit',
          const {'inherit': '继承主题（默认开启）', 'true': '开启', 'false': '关闭（仅位移与缩放）'},
          (value) => _change(
            () => v.liftSurface = value == 'inherit' ? null : value == 'true',
          ),
        ),
        n(
          '阴影圆角',
          m.surfaceRadius,
          s.motionLift.shadowRadius,
          0,
          editorSurfaceRadiusLimit,
          (x) => m.surfaceRadius = x,
        ),
      ] else ...[
        _heading('内容变换'),
        n(
          '水平位移',
          m.translationX,
          offset.dx,
          -limit,
          limit,
          (x) => m.translationX = x,
        ),
        n(
          '垂直位移',
          m.translationY,
          offset.dy,
          -limit,
          limit,
          (x) => m.translationY = x,
        ),
        n(
          '缩放倍率',
          v.scale,
          (hovered ? style.hoverScale : style.pressedScale) ??
              (hovered ? 1.008 : .995),
          editorMotionMinimumScale,
          editorMotionMaximumScale,
          (x) => v.scale = x,
          pixels: false,
        ),
        _heading('阴影'),
        ..._focusedShadowProperties(
          EditorComponent(),
          stateTarget: v.shadow,
          maxExtent: s.minimumInteractiveDimension,
          label: '上浮阴影',
          description: '空列表关闭当前状态阴影；恢复继承使用主题配方。',
        ),
      ],
    ]);
  }
}
