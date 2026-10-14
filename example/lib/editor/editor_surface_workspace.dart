part of 'theme_editor.dart';

extension _SurfaceWorkspace on _ThemeEditorState {
  EditorSurfaceFields get _surfaceMetrics => switch (_component) {
    'card' => _spec.cardMetrics,
    'container' => _spec.containerMetrics,
    'collapsible' => _spec.collapsibleMetrics,
    _ => _spec.groupMetrics,
  };
  Widget _surfacePanel() {
    final a = _appearance, v = a.surface, m = _surfaceMetrics;
    final theme = _resolveTheme(_dark), s = theme.sizes.resolve(_device);
    Widget pixel(
      String label,
      double value,
      double max,
      void Function(double) write,
      void Function() reset,
      bool overridden,
    ) => _number(label, value, 0, max, write, reset, overridden);
    return _panel(_ThemeEditorState._components[_component]!, [
      const HyperText('布局按设备保存，外观按亮暗保存；未覆盖项继承主题。局部与实例覆盖以 Demo 标记为准。'),
      HyperButton.text(
        onPressed: () => _change(() {
          a.surface = EditorSurfaceFields();
          a.background = null;
          a.foreground = null;
          a.fillKind = null;
          a.gradient = null;
          a.border = EditorBorder();
          a.shadows = null;
          switch (_component) {
            case 'card':
              _spec.cardMetrics = EditorSurfaceFields();
              _spec.cardRadius = null;
            case 'container':
              _spec.containerMetrics = EditorSurfaceFields();
            case 'collapsible':
              _spec.collapsibleMetrics = EditorSurfaceFields();
            case 'group':
              _spec.groupMetrics = EditorSurfaceFields();
          }
        }),
        child: const Text('重置当前组件'),
      ),
      _heading('内容布局'),
      pixel(
        '内容内边距',
        m.padding ??
            (_component == 'collapsible'
                ? (s.collapsible.headerPadding.resolve(TextDirection.ltr).left)
                : _component == 'card'
                ? s.card.padding.resolve(TextDirection.ltr).left
                : 0),
        editorContentSpacingLimit,
        (x) => m.padding = x,
        () => m.padding = null,
        m.padding != null,
      ),
      if (_component == 'card') ...[
        pixel(
          '内容左边距',
          m.paddingLeft ?? m.padding ?? 0,
          editorContentSpacingLimit,
          (x) => m.paddingLeft = x,
          () => m.paddingLeft = null,
          m.paddingLeft != null,
        ),
        pixel(
          '内容上边距',
          m.paddingTop ?? m.padding ?? 0,
          editorContentSpacingLimit,
          (x) => m.paddingTop = x,
          () => m.paddingTop = null,
          m.paddingTop != null,
        ),
        pixel(
          '内容右边距',
          m.paddingRight ?? m.padding ?? 0,
          editorContentSpacingLimit,
          (x) => m.paddingRight = x,
          () => m.paddingRight = null,
          m.paddingRight != null,
        ),
        pixel(
          '内容下边距',
          m.paddingBottom ?? m.padding ?? 0,
          editorContentSpacingLimit,
          (x) => m.paddingBottom = x,
          () => m.paddingBottom = null,
          m.paddingBottom != null,
        ),
        pixel(
          '内部标题内边距',
          m.titlePadding ?? s.card.titlePadding.resolve(TextDirection.ltr).left,
          editorContentSpacingLimit,
          (x) => m.titlePadding = x,
          () => m.titlePadding = null,
          m.titlePadding != null,
        ),
        pixel(
          '外部标题内边距',
          m.outsideTitlePadding ??
              s.card.outsideTitlePadding.resolve(TextDirection.ltr).left,
          editorContentSpacingLimit,
          (x) => m.outsideTitlePadding = x,
          () => m.outsideTitlePadding = null,
          m.outsideTitlePadding != null,
        ),
        pixel(
          '内部标题内容间距',
          m.titleSpacing ?? s.card.titleSpacing,
          editorContentSpacingLimit,
          (x) => m.titleSpacing = x,
          () => m.titleSpacing = null,
          m.titleSpacing != null,
        ),
        pixel(
          '外部标题卡片间距',
          m.outsideTitleSpacing ?? s.card.outsideTitleSpacing,
          editorContentSpacingLimit,
          (x) => m.outsideTitleSpacing = x,
          () => m.outsideTitleSpacing = null,
          m.outsideTitleSpacing != null,
        ),
        pixel(
          '标题操作区间距',
          m.actionSpacing ?? s.card.actionSpacing,
          editorContentSpacingLimit,
          (x) => m.actionSpacing = x,
          () => m.actionSpacing = null,
          m.actionSpacing != null,
        ),
        pixel(
          '标题字号',
          m.titleFontSize ?? theme.typography.cardTitle,
          editorContentSpacingLimit,
          (x) => m.titleFontSize = x,
          () => m.titleFontSize = null,
          m.titleFontSize != null,
        ),
        pixel(
          '操作文字字号',
          m.actionFontSize ?? theme.typography.bodySmall,
          editorContentSpacingLimit,
          (x) => m.actionFontSize = x,
          () => m.actionFontSize = null,
          m.actionFontSize != null,
        ),
        _color(
          '标题颜色',
          v.titleColor,
          (x) => v.titleColor = x,
          inheritedColor: theme.colors.textPrimary,
        ),
        _color(
          '操作文字颜色',
          v.actionColor,
          (x) => v.actionColor = x,
          inheritedColor: theme.colors.primary,
        ),
      ],
      if (_component == 'collapsible') ...[
        pixel(
          '展开内容内边距',
          m.contentPadding ??
              s.collapsible.contentPadding.resolve(TextDirection.ltr).left,
          editorContentSpacingLimit,
          (x) => m.contentPadding = x,
          () => m.contentPadding = null,
          m.contentPadding != null,
        ),
        pixel(
          '标题最小高度',
          m.headerHeight ?? s.collapsible.headerMinHeight,
          editorLayoutInsetLimit,
          (x) => m.headerHeight = x,
          () => m.headerHeight = null,
          m.headerHeight != null,
        ),
        pixel(
          '标题内容间距',
          m.spacing ?? s.collapsible.spacing,
          editorContentSpacingLimit,
          (x) => m.spacing = x,
          () => m.spacing = null,
          m.spacing != null,
        ),
        _heading('标题文字'),
        pixel(
          '标题字号',
          m.fontSize ?? theme.typography.bodySmall,
          editorContentIconLimit,
          (x) => m.fontSize = x,
          () => m.fontSize = null,
          m.fontSize != null,
        ),
        _color(
          '标题颜色',
          v.textColor,
          (x) => v.textColor = x,
          inheritedColor: theme.colors.textPrimary,
        ),
        _number(
          '标题行高',
          v.lineHeight ?? 1.2,
          .5,
          3,
          (x) => v.lineHeight = x,
          () => v.lineHeight = null,
          v.lineHeight != null,
          wholeNumbers: false,
        ),
        _heading('展开图标'),
        pixel(
          '展开图标尺寸',
          m.iconSize ?? s.collapsible.iconSize,
          editorContentIconLimit,
          (x) => m.iconSize = x,
          () => m.iconSize = null,
          m.iconSize != null,
        ),
        _color(
          '展开图标颜色',
          v.iconColor,
          (x) => v.iconColor = x,
          inheritedColor: theme.colors.textSecondary,
        ),
      ],
      if (_component == 'group') ...[
        _heading('子项与分隔线'),
        pixel(
          '子项间距',
          m.spacing ?? s.widgetGroup.spacing,
          editorContentSpacingLimit,
          (x) => m.spacing = x,
          () => m.spacing = null,
          m.spacing != null,
        ),
        pixel(
          '分隔区域宽度',
          m.separatorExtent ?? s.widgetGroup.separatorExtent,
          editorContentSpacingLimit,
          (x) => m.separatorExtent = x,
          () => m.separatorExtent = null,
          m.separatorExtent != null,
        ),
        pixel(
          '分隔线粗细',
          m.separatorThickness ?? s.widgetGroup.separatorThickness,
          editorLineThicknessLimit,
          (x) => m.separatorThickness = x,
          () => m.separatorThickness = null,
          m.separatorThickness != null,
        ),
        _color(
          '分隔线颜色',
          v.separatorColor,
          (x) => v.separatorColor = x,
          inheritedColor: theme.colors.outline,
        ),
      ],
      if (_component == 'collapsible') ...[
        _heading('Accordion 分隔线'),
        _select(
          '显示分隔线',
          v.showDividers?.toString() ?? 'inherit',
          const {'inherit': '继承默认', 'true': '显示', 'false': '隐藏'},
          (x) => _change(
            () => v.showDividers = x == 'inherit' ? null : x == 'true',
          ),
        ),
        pixel(
          '分隔线粗细',
          m.separatorThickness ?? 1,
          editorLineThicknessLimit,
          (x) => m.separatorThickness = x,
          () => m.separatorThickness = null,
          m.separatorThickness != null,
        ),
        _color(
          '分隔线颜色',
          v.separatorColor,
          (x) => v.separatorColor = x,
          inheritedColor: theme.colors.outline,
        ),
      ],
      _heading('交互与过渡'),
      _number(
        '过渡时长（毫秒）',
        v.duration ?? theme.motion.standardDuration.inMilliseconds.toDouble(),
        0,
        5000,
        (x) => v.duration = x,
        () => v.duration = null,
        v.duration != null,
      ),
      _select('过渡曲线', v.curve ?? 'inherit', const {
        'inherit': '继承默认',
        'linear': '线性',
        'easeInOut': '缓入缓出',
        'fastOutSlowIn': '快出慢入',
      }, (x) => _change(() => v.curve = x == 'inherit' ? null : x)),
      if (_component == 'card') ...[
        _number(
          '按下缩放',
          v.pressedScale ?? .98,
          .5,
          1.5,
          (x) => v.pressedScale = x,
          () => v.pressedScale = null,
          v.pressedScale != null,
          wholeNumbers: false,
        ),
        _color(
          '交互叠加色',
          v.overlayColor,
          (x) => v.overlayColor = x,
          inheritedColor: theme.colors.stateLayer,
        ),
      ],
      if (_component == 'collapsible') ...[
        _color(
          '交互叠加色',
          v.overlayColor,
          (x) => v.overlayColor = x,
          inheritedColor: theme.colors.stateLayer,
        ),
        _number(
          '悬停透明度',
          v.hoverOpacity ?? .06,
          0,
          1,
          (x) => v.hoverOpacity = x,
          () => v.hoverOpacity = null,
          v.hoverOpacity != null,
          wholeNumbers: false,
        ),
        _number(
          '聚焦透明度',
          v.focusOpacity ?? .06,
          0,
          1,
          (x) => v.focusOpacity = x,
          () => v.focusOpacity = null,
          v.focusOpacity != null,
          wholeNumbers: false,
        ),
        _number(
          '按下透明度',
          v.pressedOpacity ?? .10,
          0,
          1,
          (x) => v.pressedOpacity = x,
          () => v.pressedOpacity = null,
          v.pressedOpacity != null,
          wholeNumbers: false,
        ),
        _number(
          '禁用透明度',
          v.disabledOpacity ?? .38,
          0,
          1,
          (x) => v.disabledOpacity = x,
          () => v.disabledOpacity = null,
          v.disabledOpacity != null,
          wholeNumbers: false,
        ),
      ],
      _heading('表面'),
      if (_component == 'card')
        _color(
          '前景颜色',
          a.foreground,
          (x) => a.foreground = x,
          inheritedColor: theme.colors.textPrimary,
        ),
      if (_component == 'group')
        _color(
          '背景',
          a.background,
          (x) => a.background = x,
          inheritedColor: theme.colors.surface,
        )
      else
        ..._backgroundProperties(a),
      _radiusNumber(
        '表面圆角',
        m.radius ??
            (_component == 'card'
                ? s.card.radius
                : _component == 'collapsible'
                ? s.collapsible.radius
                : _component == 'group'
                ? s.widgetGroup.radius
                : 0),
        0,
        editorSurfaceRadiusLimit,
        (x) => m.radius = x,
        () => m.radius = null,
        m.radius != null,
      ),
      if (_component == 'group')
        _radiusNumber(
          '子项圆角',
          m.itemRadius ?? s.widgetGroup.innerRadius,
          0,
          editorSurfaceRadiusLimit,
          (x) => m.itemRadius = x,
          () => m.itemRadius = null,
          m.itemRadius != null,
        ),
      if (_component == 'card' || _component == 'container')
        _select('内容裁切', v.clip ?? 'inherit', const {
          'inherit': '继承默认',
          'none': '不裁切',
          'hardEdge': '硬边裁切',
          'antiAlias': '抗锯齿裁切',
        }, (x) => _change(() => v.clip = x == 'inherit' ? null : x)),
      ..._borderProperties(a),
      if (_component != 'collapsible') ..._controlShadows(a),
    ]);
  }
}
