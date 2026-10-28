part of 'theme_editor.dart';

extension _ImageWorkspace on _ThemeEditorState {
  Widget _imagePanel() {
    final theme = _resolveTheme(_dark), s = theme.sizes.resolve(_device);
    final variant = _reviewVariant, state = _reviewState;
    String suffix(String x) =>
        x == 'common' ? '' : x[0].toUpperCase() + x.substring(1);
    final slot = 'image${suffix(variant)}${suffix(state)}';
    final v = _mode.reviews.object(slot),
        m = _spec.reviews.object(slot),
        metrics = _spec.reviews.image;
    final r = theme.imageTheme.resolve(
      variant == 'common'
          ? HyperImageVariant.plain
          : HyperImageVariant.values.byName(variant),
      state == 'common'
          ? HyperImageLoadState.loading
          : HyperImageLoadState.values.byName(state),
    );
    final common = variant == 'common' && state == 'common';
    Widget n(
      String label,
      double? value,
      double inherited,
      double min,
      double max,
      void Function(double?) set,
    ) => _number(
      label,
      value ?? inherited,
      min,
      max,
      (x) => _change(
        () => set(
          x.roundToDouble().clamp(min.ceilToDouble(), max.floorToDouble()),
        ),
      ),
      () => _change(() => set(null)),
      value != null,
    );
    return KeyedSubtree(
      key: const ValueKey('editor-image-workspace'),
      child: _panel('图片', [
        _select('外观变体', variant, const {
          'common': '通用（所有变体）',
          'plain': 'Plain · 无装饰',
          'outlined': 'Outlined · 边框',
          'elevated': 'Elevated · 阴影',
        }, (x) => _updateState(() => _reviewVariant = x)),
        _select('加载状态', state, const {
          'common': '通用（所有状态）',
          'loading': '加载中',
          'completed': '加载成功',
          'failed': '加载失败',
        }, (x) => _updateState(() => _reviewState = x)),
        const HyperText('尺寸按设备保存，配色与阴影按亮暗保存；Demo 保留所有状态对照。'),
        HyperButton.text(
          onPressed: () => _change(() {
            _mode.reviews.reset(slot);
            _spec.reviews.reset(slot);
          }),
          label: const Text('恢复当前变体 / 当前状态继承'),
        ),
        if (common) ...[
          _heading('占位内容布局'),
          n(
            '图标尺寸',
            metrics.iconSize,
            s.image.iconSize,
            0,
            editorContentIconLimit,
            (x) => metrics.iconSize = x,
          ),
          n(
            '进度尺寸',
            metrics.circleSize,
            s.image.progressSize,
            1,
            editorProgressDiameterLimit,
            (x) {
              metrics.circleSize = x;
              if (metrics.lineWidth != null) {
                metrics.lineWidth = metrics.lineWidth!.clamp(
                  0,
                  editorProgressStrokeLimit(x ?? s.image.progressSize),
                );
              }
            },
          ),
          n(
            '进度描边',
            metrics.lineWidth,
            s.image.progressThickness,
            0,
            editorProgressStrokeLimit(s.image.progressSize),
            (x) => metrics.lineWidth = x,
          ),
          n(
            '内容间距',
            metrics.spacing,
            s.image.spacing,
            0,
            editorContentSpacingLimit,
            (x) => metrics.spacing = x,
          ),
          n(
            '占位内边距',
            metrics.paddingLeft,
            s.image.padding,
            0,
            editorContentSpacingLimit,
            (x) => metrics.paddingLeft = x,
          ),
        ],
        if (state == 'common' || state == 'failed') ...[
          _heading('失败图标'),
          _color(
            '图标颜色',
            v.iconColor,
            (x) => v.iconColor = x,
            inheritedColor: r.iconColor ?? theme.colors.textSecondary,
          ),
          _heading('失败提示文字'),
          if (common) ...[
            n(
              '提示字号',
              metrics.textStyleSize,
              r.textStyle?.fontSize ?? theme.textTheme.bodySmall!.fontSize!,
              1,
              editorReviewFontSizeLimit(theme.typography.displayLarge),
              (x) => metrics.textStyleSize = x,
            ),
          ],
          _select(
            '提示字重',
            v.textStyleWeight?.round().toString() ?? 'inherit',
            const {
              'inherit': '继承',
              '300': '300',
              '400': '400 常规',
              '500': '500 中等',
              '600': '600 半粗',
              '700': '700 粗体',
            },
            (x) => _change(
              () => v.textStyleWeight = x == 'inherit' ? null : double.parse(x),
            ),
          ),
          _color(
            '文字颜色',
            v.textStyleColor,
            (x) => v.textStyleColor = x,
            inheritedColor: r.textStyle?.color ?? theme.colors.textSecondary,
          ),
        ],
        if (state == 'common' || state == 'loading') ...[
          _heading('加载指示'),
          _color(
            '进度颜色',
            v.foregroundColor,
            (x) => v.foregroundColor = x,
            inheritedColor: r.progressColor ?? theme.colors.primary,
          ),
          _color(
            '进度轨道',
            v.overlayColor,
            (x) => v.overlayColor = x,
            inheritedColor: r.progressTrackColor ?? theme.colors.outline,
          ),
        ],
        _heading('状态过渡'),
        n(
          '过渡时长（毫秒）',
          v.duration,
          (r.animationDuration ?? theme.motion.fastDuration).inMilliseconds
              .toDouble(),
          0,
          editorImageTransitionDurationLimit,
          (x) => v.duration = x,
        ),
        _select('过渡曲线', v.curve ?? 'inherit', const {
          'inherit': '继承 Motion',
          'linear': '线性',
          'easeInOut': '缓入缓出',
          'fastOutSlowIn': '快速进入缓慢结束',
        }, (x) => _change(() => v.curve = x == 'inherit' ? null : x)),
        _heading('图片表面'),
        _color(
          '占位背景',
          v.contentBackground,
          (x) => v.contentBackground = x,
          inheritedColor: r.placeholderColor ?? theme.colors.surfaceMuted,
        ),
        _color(
          '表面背景',
          v.background,
          (x) => v.background = x,
          inheritedColor:
              r.surfaceStyle?.background?.color ??
              (variant == 'plain' || variant == 'common'
                  ? Colors.transparent
                  : theme.colors.surface),
        ),
        _select('表面材质', v.materialKind ?? 'inherit', const {
          'inherit': '继承全局材质',
          'solid': '实色',
          'translucent': '半透明',
          'frostedGlass': '磨砂玻璃',
          'softLightGlass': '柔光玻璃',
          'clearFrostedGlass': '高透毛玻璃',
        }, (x) => _change(() => v.materialKind = x == 'inherit' ? null : x)),
        n(
          '表面圆角',
          m.surfaceRadius,
          r.surfaceStyle?.borderRadius?.resolve(TextDirection.ltr).topLeft.x ??
              (variant == 'plain' || variant == 'common' ? 0 : s.image.radius),
          0,
          editorSurfaceRadiusLimit,
          (x) => m.surfaceRadius = x,
        ),
        n(
          '边框宽度',
          m.borderWidth,
          r.surfaceStyle?.border?.top.width ?? (variant == 'outlined' ? 1 : 0),
          0,
          editorLineThicknessLimit,
          (x) => m.borderWidth = x,
        ),
        _color(
          '边框颜色',
          v.borderColor,
          (x) => v.borderColor = x,
          inheritedColor:
              r.surfaceStyle?.border?.top.color ?? theme.colors.outline,
        ),
        ..._focusedShadowProperties(
          EditorComponent(),
          stateTarget: v.shadow,
          maxExtent: s.controlHeightLg,
          label: '图片阴影',
          description: '空列表关闭阴影；恢复继承后使用当前变体配方。',
        ),
      ]),
    );
  }

  Widget _imageToolsPanel() {
    final editing = _component == 'imageEditorReview',
        object = editing ? 'imageEditor' : 'imagePreview';
    final theme = _resolveTheme(_dark), s = theme.sizes.resolve(_device);
    final v = _mode.reviews.object(object), m = _spec.reviews.object(object);
    final spacing = editing ? s.imageEditor.spacing : s.imagePreview.spacing,
        padding = editing ? s.imageEditor.padding : s.imagePreview.padding,
        iconSize = editing ? s.imageEditor.iconSize : s.imagePreview.iconSize;
    Widget n(
      String label,
      double? value,
      double inherited,
      double min,
      double max,
      void Function(double?) set,
    ) => _number(
      label,
      value ?? inherited,
      min,
      max,
      (x) => _change(
        () => set(
          x.roundToDouble().clamp(min.ceilToDouble(), max.floorToDouble()),
        ),
      ),
      () => _change(() => set(null)),
      value != null,
    );
    return _panel(editing ? '图片编辑' : '图片预览', [
      const HyperText('尺寸按设备保存，配色按亮暗保存。图片加载状态沿用“图片”工作区。'),
      HyperButton.text(
        onPressed: () => _change(() {
          _mode.reviews.reset(object);
          _spec.reviews.reset(object);
        }),
        label: const Text('恢复当前组件继承'),
      ),
      _heading('工具栏布局'),
      n(
        '工具间距',
        m.spacing,
        spacing,
        0,
        editorContentSpacingLimit,
        (x) => m.spacing = x,
      ),
      n(
        '工具栏内边距',
        m.paddingLeft,
        padding,
        0,
        editorContentSpacingLimit,
        (x) => m.paddingLeft = x,
      ),
      _heading('工具图标'),
      n(
        '工具图标尺寸',
        m.iconSize,
        iconSize,
        1,
        editorContentIconLimit,
        (x) => m.iconSize = x,
      ),
      _color(
        '工具图标颜色',
        v.iconColor,
        (x) => v.iconColor = x,
        inheritedColor: theme.colors.textPrimary,
      ),
      _heading('工具栏文字'),
      n(
        '工具栏字号',
        m.textStyleSize,
        theme.textTheme.bodySmall!.fontSize!,
        1,
        editorReviewFontSizeLimit(theme.typography.displayLarge),
        (x) => m.textStyleSize = x,
      ),
      _select(
        '工具栏字重',
        v.textStyleWeight?.round().toString() ?? 'inherit',
        const {
          'inherit': '继承',
          '400': '400 常规',
          '500': '500 中等',
          '600': '600 半粗',
          '700': '700 粗体',
        },
        (x) => _change(
          () => v.textStyleWeight = x == 'inherit' ? null : double.parse(x),
        ),
      ),
      _color(
        '工具栏文字颜色',
        v.textStyleColor,
        (x) => v.textStyleColor = x,
        inheritedColor: theme.colors.textPrimary,
      ),
      if (editing) ...[
        _heading('裁剪框'),
        n(
          '裁剪留白',
          m.paddingTop,
          s.imageEditor.cropPadding ?? s.imageEditor.padding,
          0,
          editorContentSpacingLimit,
          (x) => m.paddingTop = x,
        ),

        n(
          '裁剪手柄长度',
          m.nodeSize,
          s.imageEditor.handleLength,
          1,
          editorContentIconLimit,
          (x) {
            m.nodeSize = x;
            final max = editorImageCropStrokeLimit(
              x ?? s.imageEditor.handleLength,
            );
            if (m.lineWidth != null) m.lineWidth = m.lineWidth!.clamp(1, max);
          },
        ),
        n(
          '裁剪手柄粗细',
          m.lineWidth,
          s.imageEditor.handleThickness,
          1,
          editorImageCropStrokeLimit(s.imageEditor.handleLength),
          (x) => m.lineWidth = x,
        ),
        n(
          '裁剪框线宽',
          m.lineHeight,
          s.imageEditor.lineWidth,
          1,
          editorLineThicknessLimit,
          (x) => m.lineHeight = x,
        ),
        _color(
          '裁剪手柄颜色',
          v.foregroundColor,
          (x) => v.foregroundColor = x,
          inheritedColor: theme.colors.primary,
        ),
        _color(
          '裁剪线颜色',
          v.separatorColor,
          (x) => v.separatorColor = x,
          inheritedColor: theme.colors.outline,
        ),
        _color(
          '裁剪遮罩颜色',
          v.overlayColor,
          (x) => v.overlayColor = x,
          inheritedColor: theme.colors.scrim,
        ),
      ],
      _heading('动效'),
      n(
        '动效时长（毫秒）',
        v.duration,
        theme.motion.fastDuration.inMilliseconds.toDouble(),
        0,
        editorImageTransitionDurationLimit,
        (x) => v.duration = x,
      ),
      if (!editing)
        _select('动效曲线', v.curve ?? 'inherit', const {
          'inherit': '继承 Motion',
          'linear': '线性',
          'easeInOut': '缓入缓出',
          'fastOutSlowIn': '快速进入缓慢结束',
        }, (x) => _change(() => v.curve = x == 'inherit' ? null : x)),
      _heading('工作区表面'),
      _select('工作区材质', v.materialKind ?? 'inherit', const {
        'inherit': '继承全局材质',
        'solid': '实色',
        'translucent': '半透明',
        'frostedGlass': '磨砂玻璃',
        'softLightGlass': '柔光玻璃',
        'clearFrostedGlass': '高透毛玻璃',
      }, (x) => _change(() => v.materialKind = x == 'inherit' ? null : x)),

      _color(
        '工具栏背景',
        v.contentBackground,
        (x) => v.contentBackground = x,
        inheritedColor: theme.colors.surfaceMuted,
      ),
      _color(
        '工作区背景',
        v.background,
        (x) => v.background = x,
        inheritedColor: theme.colors.surface,
      ),
      n(
        '工作区圆角',
        m.surfaceRadius,
        0,
        0,
        editorSurfaceRadiusLimit,
        (x) => m.surfaceRadius = x,
      ),
      n(
        '工作区边框宽度',
        m.borderWidth,
        0,
        0,
        editorLineThicknessLimit,
        (x) => m.borderWidth = x,
      ),
      _color(
        '工作区边框颜色',
        v.borderColor,
        (x) => v.borderColor = x,
        inheritedColor: theme.colors.outline,
      ),
      ..._focusedShadowProperties(
        EditorComponent(),
        stateTarget: v.shadow,
        maxExtent: s.controlHeightLg,
        label: '工作区阴影',
        description: '恢复组件表面继承；空列表关闭阴影。',
      ),
    ]);
  }
}
