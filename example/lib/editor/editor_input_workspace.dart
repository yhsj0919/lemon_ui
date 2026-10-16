part of 'theme_editor.dart';

extension _InputWorkspace on _ThemeEditorState {
  bool get _isInputControl => const {
    'sliderInput',
    'segmentedInput',
    'iconButtonInput',
  }.contains(_component);
  EditorComponent get _inputAppearance => switch (_component) {
    'sliderInput' => _mode.sliderInput,
    'segmentedInput' =>
      _inputObject == 'standard'
          ? _mode.segmentedGroupInput
          : _inputState == 'selected'
          ? _mode.segmentedSelectedInput
          : _mode.segmentedInput,
    'colorPickerInput' => _mode.colorPickerInput,
    _ => switch (_iconInputVariant) {
      'filled' => _mode.iconButtonFilledInput,
      'tonal' => _mode.iconButtonTonalInput,
      'outlined' => _mode.iconButtonOutlinedInput,
      'ghost' => _mode.iconButtonGhostInput,
      _ => _mode.iconButtonInput,
    },
  };
  Widget _inputPanel() {
    final theme = _resolveTheme(_dark), s = theme.sizes.resolve(_device);
    final a = _inputAppearance, v = a.input;
    final m = switch (_component) {
      'sliderInput' => _spec.sliderInput,
      'segmentedInput' => _spec.segmentedInput,
      'colorPickerInput' => _spec.colorPickerInput,
      _ => _spec.iconButtonInput,
    };
    void constrain() {
      double? cap(double? value, double limit) =>
          value?.clamp(0, limit.floorToDouble()).toDouble();
      if (_component == 'sliderInput') {
        final width = m.capsuleWidth ?? s.slider.capsuleWidth;
        m.capsuleCornerRadius = cap(m.capsuleCornerRadius, width / 2);
        m.capsuleIconInset = cap(m.capsuleIconInset, width / 2);
        m.capsuleIconSize = cap(
          m.capsuleIconSize,
          (width - 2 * (m.capsuleIconInset ?? s.slider.capsuleIconInset)).clamp(
            0,
            width,
          ),
        );
        m.thumbOutlineWidth = cap(
          m.thumbOutlineWidth,
          m.thumbRadius ?? s.slider.thumbRadius,
        );
        m.stepPointRadius = cap(
          m.stepPointRadius,
          (m.trackHeight ?? s.slider.trackHeight) / 2,
        );
      }
      if (_component == 'iconButtonInput') {
        final width = m.width ?? s.iconButton.size;
        m.iconSize = cap(m.iconSize, width);
        m.radius = cap(m.radius, width / 2);
        m.progressSize = cap(m.progressSize, width);
        m.progressThickness = cap(
          m.progressThickness,
          (m.progressSize ?? s.iconButton.progressSize) / 2,
        );
      }
      if (_component == 'colorPickerInput') {
        final side =
            (m.width ?? s.colorPicker.width) <
                (m.paletteHeight ?? s.colorPicker.paletteHeight)
            ? m.width ?? s.colorPicker.width
            : m.paletteHeight ?? s.colorPicker.paletteHeight;
        m.radius = cap(m.radius, side / 2);
        m.markerRadius = cap(m.markerRadius, side / 2);
        m.borderWidth = cap(m.borderWidth, side / 2);
      }
    }

    Widget n(
      String label,
      double? current,
      double fallback,
      double min,
      double max,
      void Function(double?) set, {
      bool decimal = false,
    }) => _number(
      label,
      current ?? fallback,
      decimal ? min : min.ceilToDouble(),
      decimal ? max : max.floorToDouble(),
      (x) {
        set(x);
        constrain();
      },
      () {
        set(null);
        constrain();
      },
      current != null,
      wholeNumbers: !decimal,
    );
    Widget color(
      String label,
      EditorColor? current,
      void Function(EditorColor?) set,
      Color fallback,
    ) => _color(label, current, set, inheritedColor: fallback);
    Widget weight() => _select(
      '文字字重',
      v.fontWeight?.toString() ?? 'inherit',
      const {
        'inherit': '继承',
        '300': '300',
        '400': '400 常规',
        '500': '500 中等',
        '600': '600 半粗',
        '700': '700 粗体',
      },
      (x) => _change(() => v.fontWeight = x == 'inherit' ? null : int.parse(x)),
    );
    List<Widget> motion() => [
      _heading('过渡'),
      n(
        '过渡时长（毫秒）',
        v.duration,
        theme.motion.fastDuration.inMilliseconds.toDouble(),
        0,
        5000,
        (x) => v.duration = x,
      ),
      _select('过渡曲线', v.curve ?? 'inherit', const {
        'inherit': '继承',
        'linear': '线性',
        'easeInOut': '缓入缓出',
        'fastOutSlowIn': '快出慢入',
      }, (x) => _change(() => v.curve = x == 'inherit' ? null : x)),
    ];
    return _panel(_ThemeEditorState._components[_component]!, [
      const HyperText('尺寸按当前设备保存，视觉按亮暗保存；局部和实例覆盖以 Demo 标记为准。'),
      if (_component == 'sliderInput')
        _select(
          '编辑对象',
          _inputObject,
          const {'standard': '普通 / 范围滑块', 'capsule': '胶囊滑块'},
          (x) => _updateState(() {
            _inputObject = x;
            _inputState = 'default';
          }),
        ),
      if (_component == 'sliderInput')
        _select(
          '状态覆盖',
          _inputState,
          _inputObject == 'capsule'
              ? const {'default': '通用（所有状态）'}
              : const {
                  'default': '通用（所有状态）',
                  'hovered': '悬停',
                  'pressed': '按下',
                  'disabled': '禁用',
                },
          (x) => _updateState(() => _inputState = x),
        ),
      if (_component == 'segmentedInput')
        _select(
          '编辑对象',
          _inputObject,
          const {'standard': '整体分组', 'item': '子项按钮'},
          (x) => _updateState(() {
            _inputObject = x;
            _inputState = 'default';
          }),
        ),
      if (_component == 'segmentedInput' && _inputObject == 'item')
        _select('状态覆盖', _inputState, const {
          'default': '通用（所有状态）',
          'selected': '选中',
        }, (x) => _updateState(() => _inputState = x)),
      if (_component == 'iconButtonInput')
        _select('外观变体', _iconInputVariant, const {
          'common': '通用（所有变体）',
          'filled': '实色',
          'tonal': '浅色',
          'outlined': '描边',
          'ghost': '无填充',
        }, (x) => _updateState(() => _iconInputVariant = x)),
      HyperButton.text(
        label: const Text('重置当前编辑范围'),
        onPressed: () => _change(() {
          if (_component == 'sliderInput') {
            if (_inputState == 'hovered') {
              v.hoverInactiveTrackColor = null;
            } else if (_inputState == 'pressed') {
              v.pressedThumbScale = null;
            } else if (_inputState == 'disabled') {
              v.disabledActiveTrackColor = v.disabledInactiveTrackColor =
                  v.disabledThumbColor = null;
            } else if (_inputObject == 'capsule') {
              v.capsuleBackgroundColor = v.capsuleFillColor =
                  v.capsuleBorderColor = v.capsuleTopIconColor =
                      v.capsuleBottomIconColor = null;
              v.capsuleAutoIconContrast = null;
              v.capsuleOverscrollScale = v.capsuleTopIconTurns =
                  v.capsuleBottomIconTurns = v.duration = null;
              v.curve = null;
              m.capsuleWidth = m.capsuleCornerRadius = m.capsuleIconInset =
                  m.capsuleIconSize = m.capsuleOverscrollExtent =
                      m.borderWidth = null;
            } else {
              v.activeTrackColor = v.inactiveTrackColor = v.thumbColor =
                  v.thumbOutlineColor = v.overlayColor = v.valueIndicatorColor =
                      v.activeStepPointColor = v.inactiveStepPointColor = null;
              m.thumbWidth = m.thumbHeight = null;
              a.shadows = null;
              v.bufferColor = null;
              v.fontWeight = null;
              v.foregroundColor = null;
              m.trackHeight = m.thumbRadius = m.thinTrackHeight =
                  m.thinThumbRadius = m.overlayRadius = m.thumbOutlineWidth =
                      m.stepPointRadius = m.fontSize = null;
            }
          } else {
            a.input = EditorInputFields();
            a.background = a.foreground = null;
            a.border = EditorBorder();
            a.shadows = null;
            if (_component == 'colorPickerInput') {
              _spec.colorPickerInput = EditorInputFields();
            }
            if (_component == 'iconButtonInput' &&
                _iconInputVariant == 'common') {
              _spec.iconButtonInput = EditorInputFields();
            }
            if (_component == 'segmentedInput' && _inputState == 'default') {
              if (_inputObject == 'standard') {
                m.height = m.spacing = m.padding = m.radius =
                    m.separatorExtent = m.separatorThickness = null;
              } else {
                m.fontSize = m.iconSize = m.minimumWidth = m.paddingHorizontal =
                    m.paddingVertical = m.itemRadius = null;
              }
            }
          }
        }),
      ),
      if (_component == 'sliderInput' &&
          _inputObject == 'standard' &&
          _inputState == 'default') ...[
        _heading('轨道'),
        n(
          '轨道粗细',
          m.trackHeight,
          s.slider.trackHeight,
          0,
          editorWideTrackThicknessLimit,
          (x) => m.trackHeight = x,
        ),
        n(
          '细轨道粗细',
          m.thinTrackHeight,
          s.slider.thinTrackHeight,
          0,
          editorWideTrackThicknessLimit,
          (x) => m.thinTrackHeight = x,
        ),
        color(
          '已选轨道颜色',
          v.activeTrackColor,
          (x) => v.activeTrackColor = x,
          theme.sliderTheme.style.activeTrackColor ?? theme.colors.primary,
        ),
        color(
          '未选轨道颜色',
          v.inactiveTrackColor,
          (x) => v.inactiveTrackColor = x,
          theme.sliderTheme.style.inactiveTrackColor ??
              theme.colors.surfaceMuted,
        ),
        color(
          '缓冲轨道颜色',
          v.bufferColor,
          (x) => v.bufferColor = x,
          theme.sliderTheme.style.bufferColor ?? theme.colors.primaryContainer,
        ),
        _heading('滑块'),
        n(
          '滑块宽度',
          m.thumbWidth,
          s.slider.thumbWidth ?? s.slider.thumbRadius * 2,
          1,
          editorTapTargetLimit,
          (x) => m.thumbWidth = x,
        ),
        n(
          '滑块高度',
          m.thumbHeight,
          s.slider.thumbHeight ?? s.slider.thumbRadius * 2,
          1,
          editorTapTargetLimit,
          (x) => m.thumbHeight = x,
        ),
        n(
          '滑块半径',
          m.thumbRadius,
          s.slider.thumbRadius,
          0,
          editorSelectionMarkLimit / 2,
          (x) => m.thumbRadius = x,
        ),
        n(
          '细轨道滑块半径',
          m.thinThumbRadius,
          s.slider.thinThumbRadius,
          0,
          editorSelectionMarkLimit / 2,
          (x) => m.thinThumbRadius = x,
        ),
        color(
          '滑块颜色',
          v.thumbColor,
          (x) => v.thumbColor = x,
          theme.sliderTheme.style.thumbColor ?? theme.colors.surfaceElevated,
        ),
        n(
          '滑块描边宽度',
          m.thumbOutlineWidth,
          theme.sliderTheme.style.thumbOutlineWidth ?? 0,
          0,
          m.thumbRadius ?? s.slider.thumbRadius,
          (x) => m.thumbOutlineWidth = x,
        ),
        color(
          '滑块描边颜色',
          v.thumbOutlineColor,
          (x) => v.thumbOutlineColor = x,
          theme.sliderTheme.style.thumbOutlineColor ??
              theme.sliderTheme.style.activeTrackColor ??
              theme.colors.primary,
        ),
        ..._controlShadows(a),
        _heading('步进点'),
        n(
          '步进点半径',
          m.stepPointRadius,
          s.slider.stepPointRadius,
          0,
          (m.trackHeight ?? s.slider.trackHeight) / 2,
          (x) => m.stepPointRadius = x,
        ),
        color(
          '已选步进点颜色',
          v.activeStepPointColor,
          (x) => v.activeStepPointColor = x,
          theme.sliderTheme.style.activeStepPointColor ??
              Colors.white.withValues(alpha: .64),
        ),
        color(
          '未选步进点颜色',
          v.inactiveStepPointColor,
          (x) => v.inactiveStepPointColor = x,
          theme.sliderTheme.style.inactiveStepPointColor ??
              theme.colors.textSecondary.withValues(alpha: .42),
        ),
        _heading('数值提示'),
        _select(
          '数值提示显示方式',
          v.valueIndicatorVisibility ?? 'inherit',
          const {
            'inherit': '继承（默认关闭）',
            'onDrag': '点击或拖动时显示',
            'alwaysVisible': '始终显示',
            'never': '不显示',
          },
          (x) => _change(
            () => v.valueIndicatorVisibility = x == 'inherit' ? null : x,
          ),
        ),
        n(
          '提示文字字号',
          m.fontSize,
          theme.typography.bodySmall,
          8,
          editorContentIconLimit,
          (x) => m.fontSize = x,
        ),
        weight(),
        color(
          '提示文字颜色',
          v.foregroundColor,
          (x) => v.foregroundColor = x,
          theme.sliderTheme.style.valueIndicatorTextStyle?.color ??
              theme.colors.onPrimary,
        ),
        color(
          '数值提示背景',
          v.valueIndicatorColor,
          (x) => v.valueIndicatorColor = x,
          theme.sliderTheme.style.valueIndicatorColor ?? theme.colors.primary,
        ),
        _heading('提示表面'),
        n(
          '提示水平内边距',
          m.indicatorPaddingHorizontal,
          s.menu.padding,
          0,
          editorContentSpacingLimit,
          (x) => m.indicatorPaddingHorizontal = x,
        ),
        n(
          '提示垂直内边距',
          m.indicatorPaddingVertical,
          s.menu.padding / 2,
          0,
          editorContentSpacingLimit,
          (x) => m.indicatorPaddingVertical = x,
        ),
        n(
          '提示圆角',
          m.indicatorRadius,
          s.menu.itemRadius,
          0,
          editorSurfaceRadiusLimit,
          (x) => m.indicatorRadius = x,
        ),
        n(
          '提示与滑块间距',
          m.indicatorGap,
          s.menu.descriptionGap,
          0,
          editorContentSpacingLimit,
          (x) => m.indicatorGap = x,
        ),
        ..._focusedShadowProperties(
          a,
          stateTarget: a.hoveredShadow,
          label: '提示阴影',
          description: '默认继承统一浮层阴影；空列表关闭阴影。',
        ),
        _heading('状态层'),
        n(
          '状态层半径',
          m.overlayRadius,
          theme.sliderTheme.style.overlayRadius ?? s.slider.thumbRadius * 1.5,
          0,
          editorSelectionMarkLimit,
          (x) => m.overlayRadius = x,
        ),
        color(
          '状态层颜色',
          v.overlayColor,
          (x) => v.overlayColor = x,
          theme.sliderTheme.style.overlayColor ?? Colors.transparent,
        ),
      ],
      if (_component == 'sliderInput' &&
          _inputObject == 'standard' &&
          _inputState == 'hovered') ...[
        _heading('轨道'),
        color(
          '悬停未选轨道颜色',
          v.hoverInactiveTrackColor,
          (x) => v.hoverInactiveTrackColor = x,
          theme.sliderTheme.style.hoverInactiveTrackColor ??
              Color.alphaBlend(
                theme.colors.stateLayer.withValues(alpha: .06),
                theme.sliderTheme.style.inactiveTrackColor ??
                    theme.colors.surfaceMuted,
              ),
        ),
      ],
      if (_component == 'sliderInput' &&
          _inputObject == 'standard' &&
          _inputState == 'pressed') ...[
        _heading('滑块'),
        n(
          '按下滑块缩放',
          v.pressedThumbScale,
          theme.sliderTheme.style.pressedThumbScale ?? 1.127,
          1,
          2,
          (x) => v.pressedThumbScale = x,
          decimal: true,
        ),
      ],
      if (_component == 'sliderInput' &&
          _inputObject == 'standard' &&
          _inputState == 'disabled') ...[
        _heading('禁用轨道与滑块'),
        color(
          '禁用已选轨道颜色',
          v.disabledActiveTrackColor,
          (x) => v.disabledActiveTrackColor = x,
          theme.sliderTheme.style.disabledActiveTrackColor ??
              theme.colors.disabled,
        ),
        color(
          '禁用未选轨道颜色',
          v.disabledInactiveTrackColor,
          (x) => v.disabledInactiveTrackColor = x,
          theme.sliderTheme.style.disabledInactiveTrackColor ??
              theme.colors.surfaceMuted,
        ),
        color(
          '禁用滑块颜色',
          v.disabledThumbColor,
          (x) => v.disabledThumbColor = x,
          theme.sliderTheme.style.disabledThumbColor ?? theme.colors.disabled,
        ),
      ],
      if (_component == 'sliderInput' && _inputObject == 'capsule') ...[
        _heading('胶囊布局'),
        n(
          '胶囊宽度',
          m.capsuleWidth,
          s.slider.capsuleWidth,
          (m.capsuleIconSize ?? s.slider.capsuleIconSize) +
              2 * (m.capsuleIconInset ?? s.slider.capsuleIconInset),
          editorCapsuleWidthLimit,
          (x) => m.capsuleWidth = x,
        ),
        n(
          '胶囊圆角',
          m.capsuleCornerRadius,
          s.slider.capsuleCornerRadius,
          0,
          (m.capsuleWidth ?? s.slider.capsuleWidth) / 2,
          (x) => m.capsuleCornerRadius = x,
        ),
        n(
          '图标内边距',
          m.capsuleIconInset,
          s.slider.capsuleIconInset,
          0,
          (m.capsuleWidth ?? s.slider.capsuleWidth) / 2,
          (x) => m.capsuleIconInset = x,
        ),
        n(
          '胶囊图标尺寸',
          m.capsuleIconSize,
          s.slider.capsuleIconSize,
          0,
          ((m.capsuleWidth ?? s.slider.capsuleWidth) -
                  2 * (m.capsuleIconInset ?? s.slider.capsuleIconInset))
              .clamp(0, editorCapsuleWidthLimit),
          (x) => m.capsuleIconSize = x,
        ),
        n(
          '边界弹性位移',
          m.capsuleOverscrollExtent,
          s.slider.capsuleOverscrollExtent,
          0,
          (m.capsuleWidth ?? s.slider.capsuleWidth) / 2,
          (x) => m.capsuleOverscrollExtent = x,
        ),
        n(
          '弹性缩放',
          v.capsuleOverscrollScale,
          theme.sliderTheme.style.capsuleOverscrollScale ?? 1.025,
          1,
          1.5,
          (x) => v.capsuleOverscrollScale = x,
          decimal: true,
        ),
        n(
          '顶部图标旋转（圈）',
          v.capsuleTopIconTurns,
          theme.sliderTheme.style.capsuleTopIconTurns ?? 0,
          -1,
          1,
          (x) => v.capsuleTopIconTurns = x,
          decimal: true,
        ),
        n(
          '底部图标旋转（圈）',
          v.capsuleBottomIconTurns,
          theme.sliderTheme.style.capsuleBottomIconTurns ?? 0,
          -1,
          1,
          (x) => v.capsuleBottomIconTurns = x,
          decimal: true,
        ),
        _select(
          '图标自动反色',
          v.capsuleAutoIconContrast == null
              ? 'inherit'
              : v.capsuleAutoIconContrast!
              ? 'yes'
              : 'no',
          const {'inherit': '继承', 'yes': '开启', 'no': '关闭'},
          (x) => _change(
            () =>
                v.capsuleAutoIconContrast = x == 'inherit' ? null : x == 'yes',
          ),
        ),
        ...motion(),
        _heading('胶囊表面'),
        color(
          '背景颜色',
          v.capsuleBackgroundColor,
          (x) => v.capsuleBackgroundColor = x,
          theme.colors.primary,
        ),
        color(
          '填充颜色',
          v.capsuleFillColor,
          (x) => v.capsuleFillColor = x,
          theme.colors.primary,
        ),
        color(
          '边框颜色',
          v.capsuleBorderColor,
          (x) => v.capsuleBorderColor = x,
          theme.colors.primary,
        ),
        color(
          '顶部图标颜色',
          v.capsuleTopIconColor,
          (x) => v.capsuleTopIconColor = x,
          theme.colors.primary,
        ),
        color(
          '底部图标颜色',
          v.capsuleBottomIconColor,
          (x) => v.capsuleBottomIconColor = x,
          theme.colors.primary,
        ),
        n(
          '胶囊边框宽度',
          m.borderWidth,
          theme.sliderTheme.style.capsuleBorderWidth ?? 0,
          0,
          (m.capsuleWidth ?? s.slider.capsuleWidth) / 2,
          (x) => m.borderWidth = x,
        ),
      ],
      if (_component == 'segmentedInput') ...[
        if (_inputObject == 'standard') ...[
          _heading('分组布局'),
          n(
            '子项高度',
            m.height,
            s.button.minimumSize.height,
            1,
            editorTapTargetLimit,
            (x) => m.height = x,
          ),
          n(
            '子项间距',
            m.spacing,
            s.widgetGroup.spacing,
            0,
            editorContentSpacingLimit,
            (x) => m.spacing = x,
          ),
          n(
            '分组内边距',
            m.padding,
            0,
            0,
            editorContentSpacingLimit,
            (x) => m.padding = x,
          ),
          n(
            '分隔线粗细',
            m.separatorThickness,
            s.widgetGroup.separatorThickness,
            0,
            (m.height ?? s.button.minimumSize.height) / 2,
            (x) => m.separatorThickness = x,
          ),
          n(
            '分隔线长度',
            m.separatorExtent,
            s.widgetGroup.separatorExtent,
            0,
            m.height ?? s.button.minimumSize.height,
            (x) => m.separatorExtent = x,
          ),
          color(
            '分隔线颜色',
            v.separatorColor,
            (x) => v.separatorColor = x,
            theme.colors.outline,
          ),
          ...motion(),
          _heading('分组表面'),
          color(
            '分组背景颜色',
            v.backgroundColor,
            (x) => v.backgroundColor = x,
            theme.colors.surfaceMuted,
          ),
          n(
            '分组圆角',
            m.radius,
            s.widgetGroup.radius,
            0,
            (m.height ?? s.button.minimumSize.height) / 2,
            (x) => m.radius = x,
          ),
          ..._borderProperties(a, label: '分组边框'),
          ..._controlShadows(a),
        ],
        if (_inputObject == 'item') ...[
          if (_inputState == 'default') ...[
            n(
              '子项字号',
              m.fontSize,
              theme.typography.control,
              8,
              editorContentIconLimit,
              (x) => m.fontSize = x,
            ),
            n(
              '子项图标尺寸',
              m.iconSize,
              s.button.iconSize,
              0,
              m.height ?? s.button.minimumSize.height,
              (x) => m.iconSize = x,
            ),
            n(
              '子项最小宽度',
              m.minimumWidth,
              s.button.minimumSize.width,
              0,
              editorContentWidthLimit,
              (x) => m.minimumWidth = x,
            ),
            n(
              '子项水平内边距',
              m.paddingHorizontal,
              s.button.padding.resolve(TextDirection.ltr).left,
              0,
              editorContentSpacingLimit,
              (x) => m.paddingHorizontal = x,
            ),
            n(
              '子项垂直内边距',
              m.paddingVertical,
              s.button.padding.resolve(TextDirection.ltr).top,
              0,
              (m.height ?? s.button.minimumSize.height) / 2,
              (x) => m.paddingVertical = x,
            ),
          ],
          weight(),
          color(
            '子项文字颜色',
            a.foreground,
            (x) => a.foreground = x,
            theme.colors.textPrimary,
          ),
          ...motion(),
          _heading('子项表面'),
          color(
            '子项背景颜色',
            a.background,
            (x) => a.background = x,
            theme.colors.surfaceMuted,
          ),
          if (_inputState == 'default')
            n(
              '子项圆角',
              m.itemRadius,
              s.widgetGroup.innerRadius,
              0,
              (m.height ?? s.button.minimumSize.height) / 2,
              (x) => m.itemRadius = x,
            ),
          ..._borderProperties(a, label: '子项边框'),
          ..._controlShadows(a),
        ],
      ],
      if (_component == 'iconButtonInput') ...[
        if (_iconInputVariant == 'common') ...[
          _heading('按钮与图标'),
          n(
            '按钮边长',
            m.width,
            s.iconButton.size,
            1,
            editorTapTargetLimit,
            (x) => m.width = x,
          ),
          n(
            '最小命中尺寸',
            m.minimumTapTargetSize,
            s.iconButton.size,
            1,
            editorTapTargetLimit,
            (x) => m.minimumTapTargetSize = x,
          ),
          n(
            '按钮图标尺寸',
            m.iconSize,
            s.iconButton.iconSize,
            0,
            m.width ?? s.iconButton.size,
            (x) => m.iconSize = x,
          ),
          n(
            '加载指示器尺寸',
            m.progressSize,
            s.iconButton.progressSize,
            1,
            m.width ?? s.iconButton.size,
            (x) => m.progressSize = x,
          ),
          n(
            '加载描边宽度',
            m.progressThickness,
            2,
            0,
            (m.progressSize ?? s.iconButton.progressSize) / 2,
            (x) => m.progressThickness = x,
          ),
        ],
        color(
          '图标颜色',
          a.foreground,
          (x) => a.foreground = x,
          theme.colors.textPrimary,
        ),
        color(
          '状态层颜色',
          v.overlayColor,
          (x) => v.overlayColor = x,
          theme.colors.primary,
        ),
        color(
          '加载指示器颜色',
          v.progressColor,
          (x) => v.progressColor = x,
          theme.colors.primary,
        ),
        color(
          '加载轨道颜色',
          v.progressTrackColor,
          (x) => v.progressTrackColor = x,
          theme.colors.surfaceMuted,
        ),
        _heading('按钮表面'),
        color(
          '按钮背景颜色',
          a.background,
          (x) => a.background = x,
          theme.colors.surfaceMuted,
        ),
        if (_iconInputVariant == 'common')
          n(
            '按钮圆角',
            m.radius,
            s.iconButton.radius,
            0,
            (m.width ?? s.iconButton.size) / 2,
            (x) => m.radius = x,
          ),
        _select(
          '按钮边框',
          a.border.kind?.name ?? 'inherit',
          const {'inherit': '继承', 'solid': '实线', 'none': '无边框'},
          (x) => _change(
            () => a.border.kind = x == 'inherit'
                ? null
                : EditorBorderKind.values.byName(x),
          ),
        ),
        n(
          '按钮边框宽度',
          a.border.width,
          1,
          0,
          (m.width ?? s.iconButton.size) / 2,
          (x) => a.border.width = x,
        ),
        color(
          '按钮边框颜色',
          a.border.color,
          (x) => a.border.color = x,
          theme.colors.outline,
        ),
        ..._controlShadows(a),
      ],
    ]);
  }
}
