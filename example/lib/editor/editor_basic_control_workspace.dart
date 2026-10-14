part of 'theme_editor.dart';

extension _BasicControlWorkspace on _ThemeEditorState {
  bool get _isBasicControl => const {
    'badge',
    'divider',
    'progress',
    'radio',
    'checkbox',
    'switch',
  }.contains(_component);
  EditorComponent get _basicAppearance => switch (_component) {
    'badge' => _mode.badge,
    'divider' => _mode.divider,
    'progress' => switch (_progressObject) {
      'linear' => _mode.progressLinear,
      'circular' => _mode.progressCircular,
      'infinite' => _mode.progressInfinite,
      _ => _mode.progress,
    },
    'radio' => switch (_radioVariant) {
      'checkmark' => _mode.radioCheckmark,
      'circle' => _mode.radioCircle,
      'filled' => _mode.radioFilled,
      _ => _mode.radio,
    },
    'checkbox' => switch (_checkboxVariant) {
      'circle' => _mode.checkboxCircle,
      'rounded' => _mode.checkboxRounded,
      _ => _mode.checkbox,
    },
    _ => _mode.switchControl,
  };
  Widget _basicControlPanel() {
    final theme = _resolveTheme(_dark), s = theme.sizes.resolve(_device);
    return _panel('组件工作区', [
      HyperText('${_ThemeEditorState._components[_component]} · 未确认'),
      HyperText(
        '${_ThemeEditorState._devices[_device]}尺寸 · ${_dark ? '暗色' : '亮色'}外观',
      ),
      const HyperText('未确认仅表示默认样式待确认；组件可正常交互和配置。未覆盖项继续继承。'),
      if (_component == 'progress')
        _select('编辑对象', _progressObject, const {
          'common': '通用（所有进度对象）',
          'linear': '线性进度',
          'circular': '圆形进度',
          'infinite': '无限进度',
        }, (value) => _updateState(() => _progressObject = value)),
      if (_component == 'radio')
        _select('外观变体', _radioVariant, const {
          'common': '通用（所有变体）',
          'checkmark': '对勾',
          'circle': '圆点',
          'filled': '弱背景对勾',
        }, (value) => _updateState(() => _radioVariant = value)),
      if (_component == 'checkbox')
        _select('外观变体', _checkboxVariant, const {
          'common': '通用（所有变体）',
          'circle': '圆形',
          'rounded': '圆角矩形',
        }, (value) => _updateState(() => _checkboxVariant = value)),
      if (const {'radio', 'checkbox', 'switch'}.contains(_component))
        _select('状态覆盖', _basicState, {
          'common': '通用（所有状态）',
          'selected': _component == 'switch' ? '开启' : '选中 / 半选中',
          'unselected': _component == 'switch' ? '关闭' : '未选中',
          if (_component != 'radio') 'hovered': '悬停',
          'pressed': '按下',
          'disabled': '禁用',
        }, (value) => _updateState(() => _basicState = value)),
      if (const {'checkbox', 'switch'}.contains(_component) &&
          (_basicState == 'hovered' || _basicState == 'pressed'))
        const HyperText('此控件公开 Style 的叠加色由悬停与按下共用；编辑后同时影响两种交互。'),
      HyperButton.ghost(
        onPressed: () => _change(_resetBasicControl),
        child: HyperText(
          _basicState != 'common' &&
                  const {'radio', 'checkbox', 'switch'}.contains(_component)
              ? '重置当前状态'
              : '重置当前编辑范围',
        ),
      ),
      ...switch (_component) {
        'badge' => _badgeControlProperties(theme, s),
        'divider' => _dividerControlProperties(theme, s),
        'progress' => _progressControlProperties(theme, s),
        'radio' => _radioControlProperties(theme, s),
        'checkbox' => _checkboxControlProperties(theme, s),
        _ => _switchControlProperties(theme, s),
      },
    ]);
  }

  List<Widget> _controlShadows(EditorComponent a) => [
    const HyperText('阴影由当前对象 / 变体的所有状态共用；空列表显式关闭。'),
    Wrap(
      spacing: 8,
      children: [
        HyperButton.ghost(
          onPressed: () => _change(() => a.shadows = null),
          child: const HyperText('恢复继承'),
        ),
        HyperButton.ghost(
          onPressed: () => _change(() => a.shadows = []),
          child: const HyperText('无阴影'),
        ),
        HyperButton.tonal(
          onPressed: () =>
              _change(() => a.shadows = [...?a.shadows, EditorShadow()]),
          child: const HyperText('添加阴影'),
        ),
      ],
    ),
    for (var i = 0; i < (a.shadows?.length ?? 0); i++) _shadow(i, target: a),
  ];

  Widget _controlBorder(String label, EditorControlBorder border) => Column(
    children: [
      _heading(label),
      _select(
        '$label显示',
        border.visible?.toString() ?? 'inherit',
        const {'inherit': '继承默认', 'true': '显示', 'false': '隐藏'},
        (value) => _change(
          () => border.visible = value == 'inherit' ? null : value == 'true',
        ),
      ),
      _color(
        '$label颜色',
        border.color,
        (value) => border.color = value,
        inheritedColor: _resolveTheme(_dark).colors.outline,
      ),
      _number(
        '$label宽度',
        border.width ?? 1,
        0,
        20,
        (value) => border.width = value,
        () => border.width = null,
        border.width != null,
        wholeNumbers: false,
      ),
    ],
  );
  List<Widget> _badgeControlProperties(
    HyperThemeData theme,
    HyperSizeScheme s,
  ) {
    final a = _basicAppearance,
        v = _basicAppearance.badgeStyle,
        m = _spec.badgeMetrics,
        colors = theme.colors;
    return [
      _heading('圆点'),
      _number(
        '圆点直径',
        m.dotSize ?? s.badge.dotSize,
        0,
        1000,
        (value) => m.dotSize = value,
        () => m.dotSize = null,
        m.dotSize != null,
        wholeNumbers: false,
      ),
      _heading('徽标内容'),
      _number(
        '内容最小高度',
        m.contentHeight ?? s.badge.contentHeight,
        0,
        1000,
        (value) => m.contentHeight = value,
        () => m.contentHeight = null,
        m.contentHeight != null,
        wholeNumbers: false,
      ),
      _number(
        '内容水平内边距',
        m.horizontalPadding ?? s.badge.horizontalPadding,
        0,
        1000,
        (value) => m.horizontalPadding = value,
        () => m.horizontalPadding = null,
        m.horizontalPadding != null,
        wholeNumbers: false,
      ),
      _number(
        '徽标字号',
        m.textSize ?? s.badge.textSize,
        0,
        1000,
        (value) => m.textSize = value,
        () => m.textSize = null,
        m.textSize != null,
        wholeNumbers: false,
      ),
      _heading('文字'),
      _number(
        '文字字重',
        v.fontWeight ?? 400,
        100,
        900,
        (value) => v.fontWeight = value,
        () => v.fontWeight = null,
        v.fontWeight != null,
        wholeNumbers: false,
      ),
      _number(
        '文字行高',
        v.lineHeight ?? 1.2,
        0.5,
        4,
        (value) => v.lineHeight = value,
        () => v.lineHeight = null,
        v.lineHeight != null,
        wholeNumbers: false,
      ),
      _color(
        '文字颜色',
        v.foregroundColor,
        (value) => v.foregroundColor = value,
        inheritedColor: colors.onPrimary,
      ),
      _heading('状态过渡'),
      _number(
        '过渡时长（毫秒）',
        v.durationMilliseconds ??
            theme.motion.fastDuration.inMilliseconds.toDouble(),
        0,
        5000,
        (value) => v.durationMilliseconds = value,
        () => v.durationMilliseconds = null,
        v.durationMilliseconds != null,
        wholeNumbers: false,
      ),
      _select('过渡曲线', v.curve ?? 'inherit', const {
        'inherit': '继承默认',
        'linear': '线性',
        'easeInOut': '缓入缓出',
        'fastOutSlowIn': '快出慢入',
      }, (value) => _change(() => v.curve = value == 'inherit' ? null : value)),
      _heading('徽标表面'),
      _number(
        '圆点圆角',
        m.dotRadius ?? s.badge.dotRadius,
        0,
        1000,
        (value) => m.dotRadius = value,
        () => m.dotRadius = null,
        m.dotRadius != null,
        wholeNumbers: false,
      ),
      _number(
        '内容圆角',
        m.contentRadius ?? s.badge.contentRadius,
        0,
        1000,
        (value) => m.contentRadius = value,
        () => m.contentRadius = null,
        m.contentRadius != null,
        wholeNumbers: false,
      ),
      _color(
        '默认背景',
        v.backgroundColor,
        (value) => v.backgroundColor = value,
        inheritedColor: theme.badgeTheme.backgroundColorFor(theme.brightness),
      ),
      _color(
        '边框颜色',
        v.borderColor,
        (value) => v.borderColor = value,
        inheritedColor: colors.outline,
      ),
      _number(
        '边框宽度',
        v.borderWidth ?? 0,
        0,
        20,
        (value) => v.borderWidth = value,
        () => v.borderWidth = null,
        v.borderWidth != null,
        wholeNumbers: false,
      ),
      ...[_heading('表面阴影'), ..._controlShadows(a)],
    ];
  }

  List<Widget> _dividerControlProperties(
    HyperThemeData theme,
    HyperSizeScheme s,
  ) {
    final v = _basicAppearance.dividerStyle,
        m = _spec.dividerMetrics,
        colors = theme.colors;
    return [
      const HyperText('线条长度未覆盖时按父布局伸展；长度数字是显式设置时的起始参考值。'),
      _heading('线条布局'),
      _number(
        '线条长度',
        m.length ?? s.divider.length ?? (s.select.width),
        0,
        1000,
        (value) => m.length = value,
        () => m.length = null,
        m.length != null,
        wholeNumbers: false,
      ),
      _number(
        '起点缩进',
        m.indent ?? s.divider.indent ?? (0),
        0,
        1000,
        (value) => m.indent = value,
        () => m.indent = null,
        m.indent != null,
        wholeNumbers: false,
      ),
      _number(
        '终点缩进',
        m.endIndent ?? s.divider.endIndent ?? (0),
        0,
        1000,
        (value) => m.endIndent = value,
        () => m.endIndent = null,
        m.endIndent != null,
        wholeNumbers: false,
      ),
      _number(
        '线条粗细',
        m.thickness ?? s.divider.thickness,
        0,
        1000,
        (value) => m.thickness = value,
        () => m.thickness = null,
        m.thickness != null,
        wholeNumbers: false,
      ),
      _heading('内容文字'),
      _number(
        '内容字号',
        v.fontSize ?? theme.typographyTheme.resolve(_device).caption,
        8,
        64,
        (value) => v.fontSize = value,
        () => v.fontSize = null,
        v.fontSize != null,
        wholeNumbers: false,
      ),
      _number(
        '文字字重',
        v.fontWeight ?? 400,
        100,
        900,
        (value) => v.fontWeight = value,
        () => v.fontWeight = null,
        v.fontWeight != null,
        wholeNumbers: false,
      ),
      _number(
        '文字行高',
        v.lineHeight ?? 1.2,
        0.5,
        4,
        (value) => v.lineHeight = value,
        () => v.lineHeight = null,
        v.lineHeight != null,
        wholeNumbers: false,
      ),
      _color(
        '内容文字颜色',
        v.textColor,
        (value) => v.textColor = value,
        inheritedColor: colors.textSecondary,
      ),
      _select(
        '内容位置',
        v.contentAlignment ?? 'inherit',
        const {'inherit': '继承默认', 'start': '起点', 'center': '居中', 'end': '终点'},
        (value) => _change(
          () => v.contentAlignment = value == 'inherit' ? null : value,
        ),
      ),
      _number(
        '内容与线条间距',
        m.contentGap ?? s.divider.contentGap,
        0,
        1000,
        (value) => m.contentGap = value,
        () => m.contentGap = null,
        m.contentGap != null,
        wholeNumbers: false,
      ),
      _number(
        '边缘线段长度',
        m.edgeExtent ?? s.divider.edgeExtent,
        0,
        1000,
        (value) => m.edgeExtent = value,
        () => m.edgeExtent = null,
        m.edgeExtent != null,
        wholeNumbers: false,
      ),
      _heading('内容图标'),
      _number(
        '内容图标尺寸',
        m.iconSize ?? s.divider.iconSize,
        0,
        1000,
        (value) => m.iconSize = value,
        () => m.iconSize = null,
        m.iconSize != null,
        wholeNumbers: false,
      ),
      _color(
        '内容图标颜色',
        v.iconColor,
        (value) => v.iconColor = value,
        inheritedColor: colors.textSecondary,
      ),
      _heading('状态过渡'),
      _number(
        '过渡时长（毫秒）',
        v.durationMilliseconds ??
            theme.motion.fastDuration.inMilliseconds.toDouble(),
        0,
        5000,
        (value) => v.durationMilliseconds = value,
        () => v.durationMilliseconds = null,
        v.durationMilliseconds != null,
        wholeNumbers: false,
      ),
      _select('过渡曲线', v.curve ?? 'inherit', const {
        'inherit': '继承默认',
        'linear': '线性',
        'easeInOut': '缓入缓出',
        'fastOutSlowIn': '快出慢入',
      }, (value) => _change(() => v.curve = value == 'inherit' ? null : value)),
      _heading('线条表面'),
      _select(
        '线型',
        v.pattern ?? 'inherit',
        const {
          'inherit': '继承默认',
          'solid': '实线',
          'dashed': '虚线',
          'dotted': '点线',
        },
        (value) => _change(() => v.pattern = value == 'inherit' ? null : value),
      ),
      _number(
        '虚线长度',
        m.dashLength ?? s.divider.dashLength,
        0,
        1000,
        (value) => m.dashLength = value,
        () => m.dashLength = null,
        m.dashLength != null,
        wholeNumbers: false,
      ),
      _number(
        '线段间隔',
        m.gap ?? s.divider.gap,
        0,
        1000,
        (value) => m.gap = value,
        () => m.gap = null,
        m.gap != null,
        wholeNumbers: false,
      ),
      _number(
        '圆角',
        m.radius ?? s.divider.radius ?? (0),
        0,
        1000,
        (value) => m.radius = value,
        () => m.radius = null,
        m.radius != null,
        wholeNumbers: false,
      ),
      _color(
        '线条颜色',
        v.color,
        (value) => v.color = value,
        inheritedColor: colors.outline,
      ),
      ..._dividerGradient(v),
    ];
  }

  List<Widget> _progressControlProperties(
    HyperThemeData theme,
    HyperSizeScheme s,
  ) {
    final v = _basicAppearance.progressStyle,
        m = _spec.progressMetrics,
        colors = theme.colors;
    return [
      const HyperText('线性长度未覆盖时按父布局伸展；长度数字是显式设置时的起始参考值。'),
      const HyperText('尺寸在通用范围按设备编辑；对象或变体只覆盖外观与动效。'),
      if ((_progressObject == 'common') || (_progressObject == 'linear'))
        _heading('线性轨道'),
      if (_progressObject == 'common')
        _number(
          '线性长度',
          m.linearSize ?? s.progress.linearSize ?? (s.select.width),
          0,
          1000,
          (value) => m.linearSize = value,
          () => m.linearSize = null,
          m.linearSize != null,
          wholeNumbers: false,
        ),
      if (_progressObject == 'common')
        _number(
          '细轨道高度',
          m.linearThickness ?? s.progress.linearThickness,
          0,
          1000,
          (value) => m.linearThickness = value,
          () => m.linearThickness = null,
          m.linearThickness != null,
          wholeNumbers: false,
        ),
      if (_progressObject == 'common')
        _number(
          '宽轨道高度',
          m.wideLinearThickness ?? s.progress.wideLinearThickness,
          0,
          1000,
          (value) => m.wideLinearThickness = value,
          () => m.wideLinearThickness = null,
          m.wideLinearThickness != null,
          wholeNumbers: false,
        ),
      if (_progressObject == 'linear')
        _select(
          '线性外观',
          v.variant ?? 'inherit',
          const {'inherit': '继承默认', 'thin': '细轨道', 'wide': '宽轨道'},
          (value) =>
              _change(() => v.variant = value == 'inherit' ? null : value),
        ),
      if ((_progressObject == 'common') || (_progressObject == 'circular'))
        _heading('圆形轨道'),
      if (_progressObject == 'common')
        _number(
          '圆形直径',
          m.circularSize ?? s.progress.circularSize,
          0,
          1000,
          (value) => m.circularSize = value,
          () => m.circularSize = null,
          m.circularSize != null,
          wholeNumbers: false,
        ),
      if (_progressObject == 'common')
        _number(
          '圆形线宽',
          m.circularThickness ?? s.progress.circularThickness,
          0,
          1000,
          (value) => m.circularThickness = value,
          () => m.circularThickness = null,
          m.circularThickness != null,
          wholeNumbers: false,
        ),
      if (_progressObject == 'circular')
        _select(
          '圆形端点',
          v.strokeCap ?? 'inherit',
          const {
            'inherit': '继承默认',
            'round': '圆头',
            'butt': '平头',
            'square': '方头',
          },
          (value) =>
              _change(() => v.strokeCap = value == 'inherit' ? null : value),
        ),
      if ((_progressObject == 'common')) _heading('无限进度'),
      if (_progressObject == 'common')
        _number(
          '无限进度直径',
          m.infiniteSize ?? s.progress.infiniteSize,
          0,
          1000,
          (value) => m.infiniteSize = value,
          () => m.infiniteSize = null,
          m.infiniteSize != null,
          wholeNumbers: false,
        ),
      if (_progressObject == 'common')
        _number(
          '轨道圆点半径',
          m.infiniteDotRadius ?? s.progress.infiniteDotRadius,
          0,
          1000,
          (value) => m.infiniteDotRadius = value,
          () => m.infiniteDotRadius = null,
          m.infiniteDotRadius != null,
          wholeNumbers: false,
        ),
      if (_progressObject == 'common')
        _number(
          '无限进度线宽',
          m.infiniteThickness ?? s.progress.infiniteThickness ?? (2),
          0,
          1000,
          (value) => m.infiniteThickness = value,
          () => m.infiniteThickness = null,
          m.infiniteThickness != null,
          wholeNumbers: false,
        ),
      _heading('进度变化'),
      _number(
        '过渡时长（毫秒）',
        v.durationMilliseconds ??
            (_progressObject == 'infinite'
                ? 800
                : theme.motion.standardDuration.inMilliseconds.toDouble()),
        0,
        5000,
        (value) => v.durationMilliseconds = value,
        () => v.durationMilliseconds = null,
        v.durationMilliseconds != null,
        wholeNumbers: false,
      ),
      _select('过渡曲线', v.curve ?? 'inherit', const {
        'inherit': '继承默认',
        'linear': '线性',
        'easeInOut': '缓入缓出',
        'fastOutSlowIn': '快出慢入',
      }, (value) => _change(() => v.curve = value == 'inherit' ? null : value)),
      _heading('轨道与填充表面'),
      if (_progressObject == 'common')
        _number(
          '圆角',
          m.radius ?? s.progress.radius ?? (s.progress.linearThickness / 2),
          0,
          1000,
          (value) => m.radius = value,
          () => m.radius = null,
          m.radius != null,
          wholeNumbers: false,
        ),
      if (_progressObject == 'common')
        _number(
          '填充端圆角',
          m.fillRadius ??
              s.progress.fillRadius ??
              (s.progress.linearThickness / 2),
          0,
          1000,
          (value) => m.fillRadius = value,
          () => m.fillRadius = null,
          m.fillRadius != null,
          wholeNumbers: false,
        ),
      _color(
        '进度颜色',
        v.color,
        (value) => v.color = value,
        inheritedColor: _progressObject == 'infinite'
            ? colors.textTertiary
            : colors.primary,
      ),
      _color(
        '轨道颜色',
        v.trackColor,
        (value) => v.trackColor = value,
        inheritedColor: colors.surfaceMuted,
      ),
    ];
  }

  List<Widget> _radioControlProperties(
    HyperThemeData theme,
    HyperSizeScheme s,
  ) {
    final a = _basicAppearance,
        v = _basicAppearance.radioStyle,
        m = _spec.radioMetrics,
        colors = theme.colors;
    return [
      const HyperText('尺寸在通用范围按设备编辑；对象或变体只覆盖外观与动效。'),
      if ((_basicState == 'common' && _radioVariant == 'common'))
        _heading('标记布局'),
      if (_basicState == 'common' && _radioVariant == 'common')
        _number(
          '标记尺寸',
          m.size ?? s.radio.size,
          0,
          1000,
          (value) => m.size = value,
          () => m.size = null,
          m.size != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'common' && _radioVariant == 'common')
        _number(
          '最小命中尺寸',
          m.minimumTapTargetSize ??
              s.radio.minimumTapTargetSize ??
              (s.minimumInteractiveDimension),
          0,
          1000,
          (value) => m.minimumTapTargetSize = value,
          () => m.minimumTapTargetSize = null,
          m.minimumTapTargetSize != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'common' && _radioVariant == 'common')
        _number(
          '内部圆点尺寸',
          m.indicatorSize ?? s.radio.indicatorSize ?? (s.radio.size * .46),
          0,
          1000,
          (value) => m.indicatorSize = value,
          () => m.indicatorSize = null,
          m.indicatorSize != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'common' && _radioVariant == 'common')
        _number(
          '对勾尺寸',
          m.markSize ?? s.radio.markSize ?? (s.radio.size),
          0,
          1000,
          (value) => m.markSize = value,
          () => m.markSize = null,
          m.markSize != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'common' && _radioVariant == 'common')
        _number(
          '对勾线宽',
          m.strokeWidth ?? s.radio.strokeWidth ?? (s.radio.size * (7 / 56)),
          0,
          1000,
          (value) => m.strokeWidth = value,
          () => m.strokeWidth = null,
          m.strokeWidth != null,
          wholeNumbers: false,
        ),
      if ((_basicState == 'pressed') || (_basicState == 'common'))
        _heading('标记交互'),
      if (_basicState == 'pressed')
        _number(
          '按下缩放',
          v.pressScale ?? .85,
          0.5,
          1.5,
          (value) => v.pressScale = value,
          () => v.pressScale = null,
          v.pressScale != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'common')
        _number(
          '过渡时长（毫秒）',
          v.durationMilliseconds ??
              theme.motion.standardDuration.inMilliseconds.toDouble(),
          0,
          5000,
          (value) => v.durationMilliseconds = value,
          () => v.durationMilliseconds = null,
          v.durationMilliseconds != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'common')
        _select(
          '过渡曲线',
          v.curve ?? 'inherit',
          const {
            'inherit': '继承默认',
            'linear': '线性',
            'easeInOut': '缓入缓出',
            'fastOutSlowIn': '快出慢入',
          },
          (value) => _change(() => v.curve = value == 'inherit' ? null : value),
        ),
      if ((_basicState == 'selected') || (_basicState == 'disabled'))
        _heading('标记颜色'),
      if (_basicState == 'selected')
        _color(
          '选中标记颜色',
          v.selectedColor,
          (value) => v.selectedColor = value,
          inheritedColor: colors.primary,
        ),
      if (_basicState == 'disabled')
        _color(
          '禁用标记颜色',
          v.disabledSelectedColor,
          (value) => v.disabledSelectedColor = value,
          inheritedColor: colors.disabled,
        ),
      if ((_basicState == 'common' && _radioVariant == 'common') ||
          (_basicState == 'unselected') ||
          (_basicState == 'selected'))
        _heading('标记表面'),
      if (_basicState == 'common' && _radioVariant == 'common')
        _number(
          '圆角',
          m.radius ?? s.radio.radius ?? (s.radio.size / 2),
          0,
          1000,
          (value) => m.radius = value,
          () => m.radius = null,
          m.radius != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'unselected')
        _color(
          '默认背景',
          v.backgroundColor,
          (value) => v.backgroundColor = value,
          inheritedColor: _radioVariant == 'filled'
              ? colors.surfaceMuted
              : Colors.transparent,
        ),
      if (_basicState == 'selected')
        _color(
          '选中背景',
          v.selectedBackgroundColor,
          (value) => v.selectedBackgroundColor = value,
          inheritedColor: _radioVariant == 'filled'
              ? colors.surfaceMuted
              : Colors.transparent,
        ),
      if (_basicState == 'unselected') _controlBorder('默认边框', v.border),
      if (_basicState == 'selected') _controlBorder('选中边框', v.selectedBorder),
      if (_basicState == 'common') ...[_heading('表面阴影'), ..._controlShadows(a)],
    ];
  }

  List<Widget> _checkboxControlProperties(
    HyperThemeData theme,
    HyperSizeScheme s,
  ) {
    final a = _basicAppearance,
        v = _basicAppearance.checkboxStyle,
        m = _spec.checkboxMetrics,
        colors = theme.colors;
    return [
      const HyperText('尺寸在通用范围按设备编辑；对象或变体只覆盖外观与动效。'),
      if ((_basicState == 'common' && _checkboxVariant == 'common'))
        _heading('标记布局'),
      if (_basicState == 'common' && _checkboxVariant == 'common')
        _number(
          '标记尺寸',
          m.size ?? s.checkbox.size,
          0,
          1000,
          (value) => m.size = value,
          () => m.size = null,
          m.size != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'common' && _checkboxVariant == 'common')
        _number(
          '最小命中尺寸',
          m.minimumTapTargetSize ??
              s.checkbox.minimumTapTargetSize ??
              (s.minimumInteractiveDimension),
          0,
          1000,
          (value) => m.minimumTapTargetSize = value,
          () => m.minimumTapTargetSize = null,
          m.minimumTapTargetSize != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'common' && _checkboxVariant == 'common')
        _number(
          '标记线宽',
          m.markStrokeWidth ?? s.checkbox.markStrokeWidth,
          0,
          1000,
          (value) => m.markStrokeWidth = value,
          () => m.markStrokeWidth = null,
          m.markStrokeWidth != null,
          wholeNumbers: false,
        ),
      if ((_basicState == 'pressed') ||
          (_basicState == 'common') ||
          (_basicState == 'hovered' || _basicState == 'pressed'))
        _heading('标记交互'),
      if (_basicState == 'pressed')
        _number(
          '按下缩放',
          v.pressScale ?? .85,
          0.5,
          1.5,
          (value) => v.pressScale = value,
          () => v.pressScale = null,
          v.pressScale != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'common')
        _number(
          '过渡时长（毫秒）',
          v.durationMilliseconds ??
              theme.motion.standardDuration.inMilliseconds.toDouble(),
          0,
          5000,
          (value) => v.durationMilliseconds = value,
          () => v.durationMilliseconds = null,
          v.durationMilliseconds != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'common')
        _select(
          '过渡曲线',
          v.curve ?? 'inherit',
          const {
            'inherit': '继承默认',
            'linear': '线性',
            'easeInOut': '缓入缓出',
            'fastOutSlowIn': '快出慢入',
          },
          (value) => _change(() => v.curve = value == 'inherit' ? null : value),
        ),
      if (_basicState == 'hovered' || _basicState == 'pressed')
        _color(
          '交互叠加色',
          v.overlayColor,
          (value) => v.overlayColor = value,
          inheritedColor: colors.stateLayer,
        ),
      if ((_basicState == 'selected') || (_basicState == 'disabled'))
        _heading('标记颜色'),
      if (_basicState == 'selected')
        _color(
          '标记颜色',
          v.checkColor,
          (value) => v.checkColor = value,
          inheritedColor: colors.onPrimary,
        ),
      if (_basicState == 'disabled')
        _color(
          '禁用标记颜色',
          v.disabledCheckColor,
          (value) => v.disabledCheckColor = value,
          inheritedColor: colors.disabled,
        ),
      if ((_basicState == 'common' && _checkboxVariant == 'common') ||
          (_basicState == 'selected') ||
          (_basicState == 'unselected') ||
          (_basicState == 'disabled'))
        _heading('标记表面'),
      if (_basicState == 'common' && _checkboxVariant == 'common')
        _number(
          '矩形圆角',
          m.roundedRadius ?? s.checkbox.roundedRadius,
          0,
          1000,
          (value) => m.roundedRadius = value,
          () => m.roundedRadius = null,
          m.roundedRadius != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'common' && _checkboxVariant == 'common')
        _number(
          '圆形圆角',
          m.circleRadius ?? s.checkbox.circleRadius ?? (s.checkbox.size / 2),
          0,
          1000,
          (value) => m.circleRadius = value,
          () => m.circleRadius = null,
          m.circleRadius != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'selected')
        _color(
          '选中背景',
          v.activeColor,
          (value) => v.activeColor = value,
          inheritedColor: colors.primary,
        ),
      if (_basicState == 'unselected')
        _color(
          '未选中背景',
          v.inactiveColor,
          (value) => v.inactiveColor = value,
          inheritedColor: colors.surfaceMuted,
        ),
      if (_basicState == 'disabled')
        _color(
          '禁用背景',
          v.disabledColor,
          (value) => v.disabledColor = value,
          inheritedColor: colors.surfaceMuted,
        ),
      if (_basicState == 'common') _controlBorder('共用边框', v.border),
      if (_basicState == 'common') ...[_heading('表面阴影'), ..._controlShadows(a)],
    ];
  }

  List<Widget> _switchControlProperties(
    HyperThemeData theme,
    HyperSizeScheme s,
  ) {
    final a = _basicAppearance,
        v = _basicAppearance.switchStyle,
        m = _spec.switchMetrics,
        colors = theme.colors;
    return [
      if ((_basicState == 'common')) _heading('轨道布局'),
      if (_basicState == 'common')
        _number(
          '轨道宽度',
          m.width ?? s.switchSize.width,
          (s.switchSize.thumbSize + 2 * s.switchSize.thumbInset).clamp(
            s.switchSize.checkedThumbOffset == null
                ? 0
                : s.switchSize.checkedThumbOffset! + s.switchSize.thumbSize,
            1000,
          ),
          1000,
          (value) => m.width = value,
          () => m.width = null,
          m.width != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'common')
        _number(
          '轨道高度',
          m.height ?? s.switchSize.height,
          s.switchSize.thumbSize,
          1000,
          (value) => m.height = value,
          () => m.height = null,
          m.height != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'common')
        _number(
          '最小命中尺寸',
          m.minimumTapTargetSize ??
              s.switchSize.minimumTapTargetSize ??
              (s.minimumInteractiveDimension),
          0,
          1000,
          (value) => m.minimumTapTargetSize = value,
          () => m.minimumTapTargetSize = null,
          m.minimumTapTargetSize != null,
          wholeNumbers: false,
        ),
      if ((_basicState == 'common')) _heading('滑块布局'),
      if (_basicState == 'common')
        _number(
          '滑块尺寸',
          m.thumbSize ?? s.switchSize.thumbSize,
          0,
          (s.switchSize.width - 2 * s.switchSize.thumbInset).clamp(
            0,
            s.switchSize.height.clamp(
              0,
              s.switchSize.checkedThumbOffset == null
                  ? 1000
                  : s.switchSize.width - s.switchSize.checkedThumbOffset!,
            ),
          ),
          (value) => m.thumbSize = value,
          () => m.thumbSize = null,
          m.thumbSize != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'common')
        _number(
          '滑块边缘距离',
          m.thumbInset ?? s.switchSize.thumbInset,
          0,
          ((s.switchSize.width - s.switchSize.thumbSize) / 2).clamp(0, 1000),
          (value) => m.thumbInset = value,
          () => m.thumbInset = null,
          m.thumbInset != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'common')
        _number(
          '关闭时滑块偏移',
          m.uncheckedThumbOffset ??
              s.switchSize.uncheckedThumbOffset ??
              (s.switchSize.thumbInset),
          0,
          s.switchSize.checkedThumbOffset ??
              s.switchSize.width -
                  s.switchSize.thumbSize -
                  s.switchSize.thumbInset,
          (value) => m.uncheckedThumbOffset = value,
          () => m.uncheckedThumbOffset = null,
          m.uncheckedThumbOffset != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'common')
        _number(
          '开启时滑块偏移',
          m.checkedThumbOffset ??
              s.switchSize.checkedThumbOffset ??
              (s.switchSize.width -
                  s.switchSize.thumbSize -
                  s.switchSize.thumbInset),
          s.switchSize.uncheckedThumbOffset ?? s.switchSize.thumbInset,
          (s.switchSize.width - s.switchSize.thumbSize).clamp(0, 1000),
          (value) => m.checkedThumbOffset = value,
          () => m.checkedThumbOffset = null,
          m.checkedThumbOffset != null,
          wholeNumbers: false,
        ),
      if ((_basicState == 'hovered' || _basicState == 'pressed') ||
          (_basicState == 'common'))
        _heading('滑块交互'),
      if (_basicState == 'hovered' || _basicState == 'pressed')
        _number(
          '交互滑块缩放',
          v.interactionThumbScale ?? 1.127,
          0.5,
          2,
          (value) => v.interactionThumbScale = value,
          () => v.interactionThumbScale = null,
          v.interactionThumbScale != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'common')
        _number(
          '过渡时长（毫秒）',
          v.durationMilliseconds ??
              theme.motion.fastDuration.inMilliseconds.toDouble(),
          0,
          5000,
          (value) => v.durationMilliseconds = value,
          () => v.durationMilliseconds = null,
          v.durationMilliseconds != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'common')
        _select(
          '过渡曲线',
          v.curve ?? 'inherit',
          const {
            'inherit': '继承默认',
            'linear': '线性',
            'easeInOut': '缓入缓出',
            'fastOutSlowIn': '快出慢入',
          },
          (value) => _change(() => v.curve = value == 'inherit' ? null : value),
        ),
      if (_basicState == 'hovered' || _basicState == 'pressed')
        _color(
          '交互叠加色',
          v.overlayColor,
          (value) => v.overlayColor = value,
          inheritedColor: colors.stateLayer,
        ),
      if ((_basicState == 'common') ||
          (_basicState == 'selected') ||
          (_basicState == 'unselected') ||
          (_basicState == 'disabled'))
        _heading('轨道与滑块表面'),
      if (_basicState == 'common')
        _number(
          '圆角',
          m.radius ?? s.switchSize.radius ?? (s.switchSize.height / 2),
          0,
          1000,
          (value) => m.radius = value,
          () => m.radius = null,
          m.radius != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'common')
        _number(
          '滑块圆角',
          m.thumbRadius ??
              s.switchSize.thumbRadius ??
              (s.switchSize.thumbSize / 2),
          0,
          1000,
          (value) => m.thumbRadius = value,
          () => m.thumbRadius = null,
          m.thumbRadius != null,
          wholeNumbers: false,
        ),
      if (_basicState == 'selected')
        _color(
          '开启轨道颜色',
          v.activeTrackColor,
          (value) => v.activeTrackColor = value,
          inheritedColor: colors.primary,
        ),
      if (_basicState == 'unselected')
        _color(
          '关闭轨道颜色',
          v.inactiveTrackColor,
          (value) => v.inactiveTrackColor = value,
          inheritedColor: colors.surfaceMuted,
        ),
      if (_basicState == 'selected')
        _color(
          '开启滑块颜色',
          v.activeThumbColor,
          (value) => v.activeThumbColor = value,
          inheritedColor: colors.onPrimary,
        ),
      if (_basicState == 'unselected')
        _color(
          '关闭滑块颜色',
          v.inactiveThumbColor,
          (value) => v.inactiveThumbColor = value,
          inheritedColor: colors.surfaceElevated,
        ),
      if (_basicState == 'disabled')
        _color(
          '禁用轨道回退色',
          v.disabledTrackColor,
          (value) => v.disabledTrackColor = value,
          inheritedColor: colors.surfaceMuted,
        ),
      if (_basicState == 'disabled')
        _color(
          '禁用开启轨道色',
          v.disabledActiveTrackColor,
          (value) => v.disabledActiveTrackColor = value,
          inheritedColor: colors.primary.withValues(alpha: .35),
        ),
      if (_basicState == 'disabled')
        _color(
          '禁用关闭轨道色',
          v.disabledInactiveTrackColor,
          (value) => v.disabledInactiveTrackColor = value,
          inheritedColor: colors.surfaceMuted,
        ),
      if (_basicState == 'disabled')
        _color(
          '禁用滑块回退色',
          v.disabledThumbColor,
          (value) => v.disabledThumbColor = value,
          inheritedColor: colors.disabled,
        ),
      if (_basicState == 'disabled')
        _color(
          '禁用开启滑块色',
          v.disabledActiveThumbColor,
          (value) => v.disabledActiveThumbColor = value,
          inheritedColor: colors.surfaceElevated,
        ),
      if (_basicState == 'disabled')
        _color(
          '禁用关闭滑块色',
          v.disabledInactiveThumbColor,
          (value) => v.disabledInactiveThumbColor = value,
          inheritedColor: colors.surfaceElevated,
        ),
      if (_basicState == 'common') _controlBorder('共用边框', v.border),
      if (_basicState == 'common') ...[_heading('滑块阴影'), ..._controlShadows(a)],
    ];
  }

  List<Widget> _dividerGradient(EditorDividerVisual visual) {
    final gradient = visual.gradient;
    return [
      _heading('线条渐变'),
      _select(
        '渐变类型',
        gradient?.kind.name ?? 'inherit',
        const {
          'inherit': '继承默认 / 纯色',
          'linear': '线性',
          'radial': '径向',
          'sweep': '扫描',
        },
        (value) => _change(() {
          if (value == 'inherit') {
            visual.gradient = null;
          } else {
            visual.gradient ??= EditorGradient(
              colors: [
                const EditorColor(semantic: 'primary'),
                const EditorColor(semantic: 'outline'),
              ],
              stops: [0, 1],
            );
            visual.gradient!.kind = EditorGradientKind.values.byName(value);
          }
        }),
      ),
      if (gradient != null) ...[
        if (gradient.kind == EditorGradientKind.linear)
          _number(
            '渐变方向（度）',
            gradient.angle,
            0,
            360,
            (value) => gradient.angle = value,
            () => gradient.angle = 0,
            true,
          ),
        if (gradient.kind != EditorGradientKind.linear) ...[
          _number(
            '渐变中心 X',
            gradient.centerX,
            -1,
            1,
            (value) => gradient.centerX = value,
            () => gradient.centerX = 0,
            true,
            wholeNumbers: false,
          ),
          _number(
            '渐变中心 Y',
            gradient.centerY,
            -1,
            1,
            (value) => gradient.centerY = value,
            () => gradient.centerY = 0,
            true,
            wholeNumbers: false,
          ),
        ],
        if (gradient.kind == EditorGradientKind.radial)
          _number(
            '渐变半径',
            gradient.radius,
            .01,
            2,
            (value) => gradient.radius = value,
            () => gradient.radius = .5,
            true,
            wholeNumbers: false,
          ),
        if (gradient.kind == EditorGradientKind.sweep) ...[
          _number(
            '扫描起始角（度）',
            gradient.startAngle,
            0,
            gradient.endAngle - .01,
            (value) => gradient.startAngle = value,
            () => gradient.startAngle = 0,
            true,
            wholeNumbers: false,
          ),
          _number(
            '扫描终止角（度）',
            gradient.endAngle,
            gradient.startAngle + .01,
            360,
            (value) => gradient.endAngle = value,
            () => gradient.endAngle = 360,
            true,
            wholeNumbers: false,
          ),
        ],
        for (var i = 0; i < gradient.colors.length; i++) ...[
          _color('渐变节点 ${i + 1}', gradient.colors[i], (value) {
            if (value != null) gradient.colors[i] = value;
          }),
          _number(
            '节点 ${i + 1} 位置',
            gradient.stops[i],
            i == 0 ? 0 : gradient.stops[i - 1],
            i == gradient.stops.length - 1 ? 1 : gradient.stops[i + 1],
            (value) => gradient.stops[i] = value,
            () => gradient.stops[i] = i / (gradient.stops.length - 1),
            true,
            wholeNumbers: false,
          ),
          if (gradient.colors.length > 2)
            HyperButton.ghost(
              onPressed: () => _change(() {
                gradient.colors.removeAt(i);
                gradient.stops.removeAt(i);
              }),
              child: const HyperText('删除节点'),
            ),
        ],
        HyperButton.tonal(
          onPressed: () => _change(() {
            gradient.colors.add(const EditorColor(semantic: 'primary'));
            gradient.stops.add(1);
          }),
          child: const HyperText('添加节点'),
        ),
      ],
    ];
  }

  void _resetBasicControl() {
    final a = _basicAppearance;
    switch (_component) {
      case 'badge':
        a.badgeStyle = EditorBadgeVisual();
        a.shadows = null;
        _spec.badgeMetrics = EditorBadgeMetrics();
      case 'divider':
        a.dividerStyle = EditorDividerVisual();
        a.shadows = null;
        _spec.dividerMetrics = EditorDividerMetrics();
      case 'progress':
        a.progressStyle = EditorProgressVisual();
        a.shadows = null;
        if (_progressObject == 'common') {
          _spec.progressMetrics = EditorProgressMetrics();
        }
      case 'radio':
        if (_basicState != 'common') {
          a.radioStyle.resetState(_basicState);
          return;
        }
        a.radioStyle = EditorRadioVisual();
        a.shadows = null;
        if (_radioVariant == 'common') {
          _spec.radioMetrics = EditorRadioMetrics();
        }
      case 'checkbox':
        if (_basicState != 'common') {
          a.checkboxStyle.resetState(_basicState);
          return;
        }
        a.checkboxStyle = EditorCheckboxVisual();
        a.shadows = null;
        if (_checkboxVariant == 'common') {
          _spec.checkboxMetrics = EditorCheckboxMetrics();
        }
      case 'switch':
        if (_basicState != 'common') {
          a.switchStyle.resetState(_basicState);
          return;
        }
        a.switchStyle = EditorSwitchVisual();
        a.shadows = null;
        _spec.switchMetrics = EditorSwitchMetrics();
    }
  }
}
