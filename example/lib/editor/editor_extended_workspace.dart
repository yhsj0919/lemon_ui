part of 'theme_editor.dart';

extension _ExtendedWorkspace on _ThemeEditorState {
  bool get _isExtendedPage => const {
    'hyper-rating',
    'hyper-transfer',
    'hyper-resizable',
    'hyper-movable-dialog',
    'hyper-navigation-bar',
  }.contains(_page);
  Widget _extendedPanel() {
    final theme = _resolveTheme(_dark), s = theme.sizes.resolve(_device);
    final v = _mode.extendedControls, d = _spec.extendedControls;
    final viewport = editorPreviewSize(_device, landscape: _landscape);
    void constrainTransferRadius() {
      if (d.transferRadius != null) {
        d.transferRadius = d.transferRadius!
            .clamp(
              0,
              editorTransferRadiusLimit(
                d.transferWidth ?? s.menu.width,
                d.transferHeight ?? s.selection.maxPanelHeight,
              ),
            )
            .toDouble();
      }
    }

    Widget n(
      String label,
      double? value,
      double fallback,
      double min,
      double max,
      void Function(double?) set,
    ) => _number(
      label,
      value ?? fallback,
      min.ceilToDouble(),
      max.floorToDouble(),
      set,
      () => set(null),
      value != null,
    );
    Widget link(String label, String page, String component) =>
        HyperButton.text(
          onPressed: () => rxBatch(() {
            _page = page;
            _component = component;
          }),
          label: Text(label),
        );
    final spacingLimit = editorExtendedSpacingLimit(s);
    final widgets = <Widget>[const HyperText('尺寸按当前设备保存，颜色按当前亮暗外观保存。')];
    if (_page == 'hyper-rating') {
      final state =
          const {
            'common': '通用（所有状态）',
            'hovered': '悬停预览',
            'focused': '聚焦',
            'disabled': '禁用',
          }.containsKey(_extendedState)
          ? _extendedState
          : 'common';
      widgets.add(
        _select('状态覆盖', state, const {
          'common': '通用（所有状态）',
          'hovered': '悬停预览',
          'focused': '聚焦',
          'disabled': '禁用',
        }, (x) => _updateState(() => _extendedState = x)),
      );
      if (state == 'common') {
        widgets.addAll([
          _heading('星形与命中区域'),
          n(
            '星形尺寸',
            d.ratingIconSize,
            s.rating.iconSize,
            1,
            d.ratingHitExtent ?? s.rating.hitExtent,
            (x) => d.ratingIconSize = x,
          ),
          n(
            '垂直于评分方向的命中尺寸',
            d.ratingHitExtent,
            s.rating.hitExtent,
            d.ratingIconSize ?? s.rating.iconSize,
            editorExtendedHandleLimit(viewport),
            (x) {
              d.ratingHitExtent = x;
              if (x != null &&
                  d.ratingIconSize != null &&
                  d.ratingIconSize! > x) {
                d.ratingIconSize = x;
              }
            },
          ),
          n(
            '星形间距',
            d.ratingGap,
            s.button.iconSpacing,
            0,
            spacingLimit,
            (x) => d.ratingGap = x,
          ),
          _color(
            '已评分星形颜色',
            v.ratingActive,
            (x) => v.ratingActive = x,
            inheritedColor: theme.colors.primary,
          ),
          _color(
            '未评分星形颜色',
            v.ratingInactive,
            (x) => v.ratingInactive = x,
            inheritedColor: theme.colors.outline,
          ),
        ]);
      } else if (state == 'hovered') {
        widgets.add(
          _color(
            '预览星形颜色',
            v.ratingHover,
            (x) => v.ratingHover = x,
            inheritedColor:
                v.ratingActive?.resolve(theme.colors) ?? theme.colors.primary,
          ),
        );
      } else if (state == 'focused') {
        widgets.add(
          _color(
            '聚焦星形颜色',
            v.ratingFocus,
            (x) => v.ratingFocus = x,
            inheritedColor:
                v.ratingActive?.resolve(theme.colors) ?? theme.colors.primary,
          ),
        );
      } else {
        widgets.add(
          _color(
            '禁用星形颜色',
            v.ratingDisabled,
            (x) => v.ratingDisabled = x,
            inheritedColor: theme.colors.disabled,
          ),
        );
      }
    } else if (_page == 'hyper-transfer') {
      widgets.addAll([
        _heading('选项与内容'),
        _color(
          '面板标题颜色',
          v.transferTitle,
          (x) => v.transferTitle = x,
          inheritedColor: theme.colors.textPrimary,
        ),
        _color(
          '空结果文字颜色',
          v.transferEmpty,
          (x) => v.transferEmpty = x,
          inheritedColor: theme.colors.textPrimary,
        ),
        link('编辑选项行主题', 'hyper-list-tile', 'listTile'),
        link('编辑搜索框主题', 'hyper-text-field', 'field'),
        _heading('面板布局'),
        n(
          '面板期望宽度',
          d.transferWidth,
          s.menu.width,
          s.form.minimumControlWidth,
          viewport.width,
          (x) {
            d.transferWidth = x;
            constrainTransferRadius();
          },
        ),
        n(
          '面板最小高度',
          d.transferHeight,
          s.selection.maxPanelHeight,
          1,
          viewport.height,
          (x) {
            d.transferHeight = x;
            constrainTransferRadius();
          },
        ),
        n(
          '面板间距',
          d.transferGap,
          s.form.gap,
          0,
          spacingLimit,
          (x) => d.transferGap = x,
        ),
        _heading('移动操作'),
        link('编辑操作按钮主题', 'hyper-button', 'button'),
        _heading('面板表面'),
        n(
          '面板圆角',
          d.transferRadius,
          s.card.radius,
          0,
          editorTransferRadiusLimit(
            d.transferWidth ?? s.menu.width,
            d.transferHeight ?? s.selection.maxPanelHeight,
          ),
          (x) => d.transferRadius = x,
        ),
        _color(
          '面板背景',
          v.transferBackground,
          (x) => v.transferBackground = x,
          inheritedColor: theme.colors.surfaceElevated,
        ),
        _color(
          '面板边框颜色',
          v.transferBorder,
          (x) => v.transferBorder = x,
          inheritedColor: theme.colors.outline,
        ),
      ]);
    } else if (_page == 'hyper-resizable') {
      final state =
          const {
            'common': '通用（所有状态）',
            'hovered': '悬停 / 拖动',
            'focused': '聚焦',
          }.containsKey(_extendedState)
          ? _extendedState
          : 'common';
      widgets.add(
        _select('状态覆盖', state, const {
          'common': '通用（所有状态）',
          'hovered': '悬停 / 拖动',
          'focused': '聚焦',
        }, (x) => _updateState(() => _extendedState = x)),
      );
      widgets.add(_heading('分隔条'));
      if (state == 'common') {
        widgets.addAll([
          n(
            '命中区域宽度',
            d.resizableHandleExtent,
            s.form.gap,
            d.resizableThickness ?? s.divider.thickness,
            editorExtendedHandleLimit(viewport),
            (x) {
              d.resizableHandleExtent = x;
              if (x != null &&
                  d.resizableThickness != null &&
                  d.resizableThickness! > x) {
                d.resizableThickness = x;
              }
            },
          ),
          n(
            '分隔线粗细',
            d.resizableThickness,
            s.divider.thickness,
            0,
            d.resizableHandleExtent ?? s.form.gap,
            (x) => d.resizableThickness = x,
          ),
          _color(
            '分隔线颜色',
            v.resizableColor,
            (x) => v.resizableColor = x,
            inheritedColor: theme.colors.outline,
          ),
        ]);
      } else if (state == 'hovered') {
        widgets.add(
          _color(
            '交互分隔线颜色',
            v.resizableActive,
            (x) => v.resizableActive = x,
            inheritedColor: theme.colors.primary,
          ),
        );
      } else {
        widgets.add(
          _color(
            '聚焦分隔线颜色',
            v.resizableFocus,
            (x) => v.resizableFocus = x,
            inheritedColor: theme.colors.primary,
          ),
        );
      }
      widgets.add(const HyperText('面板最小/最大尺寸、折叠策略属于实例布局约束；默认颜色过渡继承 Motion。'));
    } else if (_page == 'hyper-movable-dialog') {
      widgets.addAll([
        _heading('标题与移动'),
        const HyperText(
          '只允许标题拖动；键盘方向键移动、Home 复位。窗口边界与键盘遮挡由公共对话框宿主约束。鼠标样式可通过强类型 Style 覆盖。',
        ),
        _heading('对话框内容与表面'),
        link('编辑公共对话框主题', 'hyper-dialog', 'dialogReview'),
        const HyperText(
          '复用 HyperDialog 的标题、正文、操作区、圆角、边框、阴影及统一材质；实例可通过 dialogStyle 显式覆盖。',
        ),
      ]);
    } else {
      final state =
          const {
            'common': '通用（所有状态）',
            'selected': '选中',
          }.containsKey(_extendedState)
          ? _extendedState
          : 'common';
      widgets.add(
        _select('状态覆盖', state, const {
          'common': '通用（所有状态）',
          'selected': '选中',
        }, (x) => _updateState(() => _extendedState = x)),
      );
      if (state == 'common') {
        widgets.addAll([
          _heading('导航项'),
          n(
            '图标尺寸',
            d.navigationIconSize,
            s.icon.size,
            1,
            s.controlHeightXl,
            (x) => d.navigationIconSize = x,
          ),
          _color(
            '默认文字与图标颜色',
            v.navigationText,
            (x) => v.navigationText = x,
            inheritedColor: theme.colors.textPrimary,
          ),
          const HyperText('侧向导航复用 Sidebar，底部导航沿用同一套图标、文字与尺寸规格。'),
          _heading('导航栏表面'),
          n(
            '表面圆角',
            d.navigationRadius,
            0,
            0,
            editorSurfaceRadiusLimit,
            (x) => d.navigationRadius = x,
          ),
          _color(
            '导航栏背景',
            v.navigationBackground,
            (x) => v.navigationBackground = x,
            inheritedColor: theme.colors.surfaceElevated,
          ),
          _color(
            '导航栏边框颜色',
            v.navigationBorder,
            (x) => v.navigationBorder = x,
            inheritedColor: theme.colors.outline,
          ),
        ]);
      } else {
        widgets.add(
          _color(
            '选中文字与图标颜色',
            v.navigationSelectedText,
            (x) => v.navigationSelectedText = x,
            inheritedColor: theme.colors.primary,
          ),
        );
      }
    }
    return _panel('组件工作区', widgets);
  }
}
