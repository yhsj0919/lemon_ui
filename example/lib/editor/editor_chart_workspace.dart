part of 'theme_editor.dart';

extension _ChartWorkspace on _ThemeEditorState {
  Widget _chartPanel() {
    final theme = _resolveTheme(_dark);
    final size = theme.sizes.resolve(_device).chart;
    final m = _spec.chartMetrics, v = _mode.chartVisual;
    final viewport = editorPreviewSize(_device, landscape: _landscape);
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
        set(x.roundToDouble());
        constrainEditorChartDimensions(m, size, viewport);
      },
      () => set(null),
      value != null,
    );
    Widget ratio(
      String label,
      double? value,
      double fallback,
      double max,
      ValueChanged<double?> set,
    ) => _number(
      label,
      value ?? fallback,
      0,
      max,
      set,
      () => set(null),
      value != null,
      wholeNumbers: false,
    );
    final radiusLimit = editorChartRadiusLimit(viewport, size.height, 0);
    return _panel('图表', [
      const HyperText('尺寸按设备保存，外观按亮暗保存。默认继承；图例实例覆盖示例优先于本页设置。'),
      _heading('绘图区'),
      n(
        '绘图区高度',
        m.height,
        size.height,
        1,
        viewport.height,
        (x) => m.height = x,
      ),
      _heading('坐标文字'),
      n(
        '坐标字号',
        m.labelFontSize,
        size.labelFontSize,
        1,
        editorReviewFontSizeLimit(theme.typography.displayLarge),
        (x) => m.labelFontSize = x,
      ),
      _heading('折线与数据点'),
      n(
        '线条宽度',
        m.lineWidth,
        size.lineWidth,
        1,
        radiusLimit,
        (x) => m.lineWidth = x,
      ),
      n(
        '数据点半径',
        m.pointRadius,
        size.pointRadius,
        1,
        radiusLimit,
        (x) => m.pointRadius = x,
      ),
      _heading('柱体'),
      n(
        '柱体宽度',
        m.barWidth,
        size.barWidth,
        1,
        viewport.width,
        (x) => m.barWidth = x,
      ),
      n(
        '分组间距',
        m.groupSpacing,
        size.groupSpacing,
        0,
        viewport.width,
        (x) => m.groupSpacing = x,
      ),
      n(
        '柱体圆角',
        m.radius,
        size.radius,
        0,
        editorRadiusLimit(size.barWidth),
        (x) => m.radius = x,
      ),
      _heading('饼图与环形图'),
      n(
        '扇区半径（环形图为环宽）',
        m.pieRadius,
        size.pieRadius,
        1,
        radiusLimit,
        (x) => m.pieRadius = x,
      ),
      n(
        '环形内半径',
        m.donutHoleRadius,
        size.donutHoleRadius,
        0,
        editorChartRadiusLimit(viewport, size.height, size.pieRadius),
        (x) => m.donutHoleRadius = x,
      ),
      n(
        '扇区间距',
        m.pieSectionSpacing,
        size.pieSectionSpacing,
        0,
        radiusLimit,
        (x) => m.pieSectionSpacing = x,
      ),
      ratio(
        '扇区标签最小百分比',
        v.pieLabelMinPercent,
        6,
        100,
        (x) => v.pieLabelMinPercent = x,
      ),
      _heading('图例'),
      n(
        '图例与绘图区间距',
        m.legendSpacing,
        size.legendSpacing,
        0,
        viewport.shortestSide,
        (x) => m.legendSpacing = x,
      ),
      _select('图例位置', v.legendPosition ?? HyperChartLegendPosition.top, const {
        HyperChartLegendPosition.top: '上方',
        HyperChartLegendPosition.bottom: '下方',
        HyperChartLegendPosition.left: '左侧',
        HyperChartLegendPosition.right: '右侧',
      }, (x) => v.legendPosition = x),
      HyperButton.text(
        onPressed: () => _updateState(() => v.legendPosition = null),
        child: const Text('图例位置恢复继承'),
      ),
      _heading('交互状态与网格'),
      ratio(
        '非活动数据透明度',
        v.inactiveOpacity,
        .32,
        1,
        (x) => v.inactiveOpacity = x,
      ),
      ratio('网格透明度', v.gridOpacity, .55, 1, (x) => v.gridOpacity = x),
      _heading('提示表面'),
      const HyperText(
        '提示表面继承公共菜单表面与材质；代码可通过 chartTheme.style.tooltipStyle 或实例 tooltipStyle 覆盖。',
      ),
    ]);
  }
}
