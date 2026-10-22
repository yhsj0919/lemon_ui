part of 'theme_editor.dart';

extension _TableWorkspace on _ThemeEditorState {
  Widget _tablePanel() {
    final t = _resolveTheme(_dark), s = t.sizes.resolve(_device).table;
    final m = _spec.tableMetrics, v = _mode.tableVisual;
    final font = t.textTheme.bodyMedium!.fontSize!;
    Widget n(
      String label,
      double? value,
      double fallback,
      double min,
      double max,
      ValueChanged<double?> set,
    ) => _number(
      label,
      value ?? fallback,
      min,
      max,
      (x) {
        set(x);
        final limit = editorTableIconLimit(
          m.rowHeight ?? s.rowHeight,
          m.headerHeight ?? s.headerHeight,
          m.controlColumnWidth ?? s.controlColumnWidth,
        );
        if (m.iconSize != null && m.iconSize! > limit) m.iconSize = limit;
        final borderLimit = ((m.rowHeight ?? s.rowHeight) / 2).floorToDouble();
        if (m.borderWidth != null && m.borderWidth! > borderLimit) {
          m.borderWidth = borderLimit;
        }
      },
      () => set(null),
      value != null,
    );
    return _panel('数据表格', [
      const HyperText('尺寸按真实设备保存，外观按亮暗保存。默认继承；各审核示例不使用实例样式覆盖。'),
      _heading('表头'),
      n(
        '表头最小高度',
        m.headerHeight,
        s.headerHeight,
        1,
        editorTableRowExtentLimit,
        (x) => m.headerHeight = x,
      ),
      n(
        '表头字号',
        m.headerFontSize,
        s.headerFontSize,
        1,
        editorReviewFontSizeLimit(t.textTheme.displayLarge!.fontSize!),
        (x) => m.headerFontSize = x,
      ),
      _color(
        '表头文字颜色',
        v.headerForeground,
        (x) => v.headerForeground = x,
        inheritedColor: t.colors.textPrimary,
      ),
      _heading('单元格'),
      n(
        '单元格最小高度',
        m.rowHeight,
        s.rowHeight,
        1,
        editorTableRowExtentLimit,
        (x) => m.rowHeight = x,
      ),
      n(
        '单元格字号',
        m.fontSize,
        font,
        1,
        editorReviewFontSizeLimit(t.textTheme.displayLarge!.fontSize!),
        (x) => m.fontSize = x,
      ),
      n(
        '单元格水平内边距',
        m.horizontalPadding,
        s.horizontalPadding,
        0,
        editorContentSpacingLimit,
        (x) => m.horizontalPadding = x,
      ),
      n(
        '文字上下最小留白',
        m.verticalPadding,
        s.verticalPadding,
        0,
        editorContentSpacingLimit,
        (x) => m.verticalPadding = x,
      ),
      n(
        '图标与选择框尺寸',
        m.iconSize,
        s.iconSize,
        1,
        editorTableIconLimit(
          m.rowHeight ?? s.rowHeight,
          m.headerHeight ?? s.headerHeight,
          m.controlColumnWidth ?? s.controlColumnWidth,
        ),
        (x) => m.iconSize = x,
      ),
      _color(
        '单元格文字颜色',
        v.foreground,
        (x) => v.foreground = x,
        inheritedColor: t.colors.textPrimary,
      ),
      _heading('列布局'),
      n(
        '默认列宽',
        m.columnWidth,
        s.columnWidth,
        m.minimumColumnWidth ?? s.minimumColumnWidth,
        editorTableColumnWidthLimit,
        (x) => m.columnWidth = x,
      ),
      n(
        '最小列宽',
        m.minimumColumnWidth,
        s.minimumColumnWidth,
        1,
        m.columnWidth ?? s.columnWidth,
        (x) => m.minimumColumnWidth = x,
      ),
      n(
        '选择与拖动列宽',
        m.controlColumnWidth,
        s.controlColumnWidth,
        t.sizes.resolve(_device).minimumInteractiveDimension,
        editorTableColumnWidthLimit,
        (x) => m.controlColumnWidth = x,
      ),
      _heading('分页栏'),
      n(
        '分页栏水平留白',
        m.footerHorizontalPadding,
        m.horizontalPadding ?? s.horizontalPadding,
        0,
        editorContentSpacingLimit,
        (x) => m.footerHorizontalPadding = x,
      ),
      n(
        '分页栏垂直留白',
        m.footerVerticalPadding,
        m.horizontalPadding ?? s.horizontalPadding,
        0,
        editorContentSpacingLimit,
        (x) => m.footerVerticalPadding = x,
      ),
      _heading('树形层级'),
      n(
        '子级缩进',
        m.treeIndent,
        s.treeIndent,
        0,
        m.columnWidth ?? s.columnWidth,
        (x) => m.treeIndent = x,
      ),
      _heading('编辑器'),
      const HyperText('默认编辑器跟随统一输入框主题。自定义编辑器按各列配置。'),
      HyperButton.text(
        onPressed: () => _change(() {
          _page = 'hyper-text-field';
          _component = 'field';
        }),
        child: const Text('编辑统一输入框主题'),
      ),
      _heading('动效'),
      n(
        '行状态过渡（毫秒）',
        v.duration,
        t.motion.fastDuration.inMilliseconds.toDouble(),
        0,
        editorReviewDurationLimit,
        (x) => v.duration = x,
      ),
      n(
        '浮起 / 拖动过渡（毫秒）',
        v.liftDuration,
        t.motion.standardDuration.inMilliseconds.toDouble(),
        0,
        editorReviewDurationLimit,
        (x) => v.liftDuration = x,
      ),
      const HyperText('浮起通过 Demo 的“开启悬停浮起”开关预览；拖动预览共用浮起阴影与圆角。'),
      _heading('行状态'),
      _select<String>('状态覆盖', _tableState, const {
        'hover': '悬停',
        'selected': '选中',
      }, (x) => _change(() => _tableState = x)),
      switch (_tableState) {
        'hover' => _color(
          '当前状态背景',
          v.hoverBackground,
          (x) => v.hoverBackground = x,
          inheritedColor: tableHoverBackground(
            t.colors,
            t.toMaterialThemeData().hoverColor,
          ),
        ),
        'selected' => _color(
          '当前状态背景',
          v.selectedBackground,
          (x) => v.selectedBackground = x,
          inheritedColor: t.colors.primaryContainer,
        ),
        _ => const SizedBox.shrink(),
      },
      _heading('浮起表面'),
      _color(
        '浮起背景（默认保留原色）',
        v.liftBackground,
        (x) => v.liftBackground = x,
        inheritedColor: t.colors.surface,
      ),
      _color(
        '浮起边框颜色',
        v.liftBorderColor,
        (x) => v.liftBorderColor = x,
        inheritedColor: t.colors.outline,
      ),
      n(
        '浮起边框宽度',
        m.liftBorderWidth,
        0,
        0,
        ((m.rowHeight ?? s.rowHeight) / 2).floorToDouble(),
        (x) => m.liftBorderWidth = x,
      ),
      n(
        '浮起圆角',
        m.liftRadius,
        s.liftRadius,
        0,
        ((m.rowHeight ?? s.rowHeight) / 2).floorToDouble(),
        (x) => m.liftRadius = x,
      ),
      ..._focusedShadowProperties(
        _appearance,
        stateTarget: v.rowShadow,
        label: '浮起 / 拖动阴影',
        description: '默认四周阴影。支持继承、显式关闭或自定义多层；不会改变行位置。',
        maxExtent: m.rowHeight ?? s.rowHeight,
      ),
      _heading('表格表面'),
      _color(
        '表头背景',
        v.headerBackground,
        (x) => v.headerBackground = x,
        inheritedColor: t.colors.surfaceMuted,
      ),

      _color(
        '交替行背景',
        v.stripeBackground,
        (x) => v.stripeBackground = x,
        inheritedColor: tableStripeBackground(t.colors),
      ),
      _color(
        '表格背景',
        v.background,
        (x) => v.background = x,
        inheritedColor: t.colors.surface,
      ),
      n(
        '表格圆角',
        m.radius,
        s.radius,
        0,
        editorSurfaceRadiusLimit,
        (x) => m.radius = x,
      ),
      _color(
        '表格边框颜色',
        v.borderColor,
        (x) => v.borderColor = x,
        inheritedColor: t.colors.outline,
      ),
      n(
        '表格边框宽度',
        m.borderWidth,
        s.borderWidth,
        0,
        ((m.rowHeight ?? s.rowHeight) / 2).floorToDouble(),
        (x) => m.borderWidth = x,
      ),
      _color(
        '强调色（光标 / 列边界 / 拖动提示）',
        v.focusColor,
        (x) => v.focusColor = x,
        inheritedColor: t.colors.primary,
      ),
      HyperButton.text(
        onPressed: () => _change(() {
          _spec.tableMetrics = EditorTableMetrics();
          _mode.tableVisual = EditorTableVisual();
        }),
        child: const Text('恢复表格继承'),
      ),
    ]);
  }
}
