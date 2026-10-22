part of 'theme_editor.dart';

extension _ReviewWorkspace on _ThemeEditorState {
  bool get _isReviewControl => _component.endsWith('Review');
  Widget _reviewPanel() {
    final theme = _resolveTheme(_dark), s = theme.sizes.resolve(_device);
    final objects = switch (_component) {
      'tooltipReview' => const {'tooltip': '文字提示'},
      'appBarReview' => const {'appBar': '应用顶栏'},
      'drawerReview' => const {'drawer': '抽屉'},
      'notificationReview' => const {'notification': '通知卡片'},
      'loadingOverlayReview' => const {'loadingOverlay': '加载遮罩'},
      'alertReview' => const {'alert': '内联提示', 'banner': '横幅提示'},
      'bottomSheetReview' => const {'bottomSheet': '底部弹窗'},
      'toastReview' => const {'toast': '轻提示', 'snackbar': '操作提示'},
      'dialogReview' => const {'dialog': '对话框'},
      'emptyStateReview' => const {'emptyState': '结果 · 空状态'},
      'skeletonReview' => const {'skeleton': '骨架屏'},
      'sidebarReview' => const {'sidebar': '侧边导航'},
      'tabBarReview' => const {'tabBar': '标签导航'},
      'stepIndicatorReview' => const {
        'stepIndicator': '步骤指示器',
        'stepperNavigation': '步骤导航',
      },
      'paginationReview' => const {'pagination': '分页'},
      'pageIndicatorReview' => const {'pageIndicator': '页面指示器'},
      'breadcrumbReview' => const {'breadcrumb': '面包屑'},
      'topNavigationReview' => const {
        'topNavigation': '顶部导航布局',
        'topNavigationItem': '顶部导航项',
        'topNavigationPanel': '下拉菜单面板',
        'topNavigationMenu': '下拉菜单项',
      },
      _ => const <String, String>{},
    };
    final selectedObject = objects.containsKey(_reviewObject)
        ? _reviewObject
        : objects.keys.first;
    final object = _component == 'topNavigationReview'
        ? 'topNavigation'
        : selectedObject;
    final activePart = _component == 'topNavigationReview'
        ? switch (selectedObject) {
            'topNavigationItem' => 'item',
            'topNavigationPanel' => 'panel',
            'topNavigationMenu' => 'menuItem',
            _ => 'group',
          }
        : _reviewPart;
    final states = switch (object) {
      'topNavigation' =>
        activePart == 'menuItem'
            ? const {
                'common': '通用（所有状态）',
                'selected': '选中',
                'active': '悬停 / 聚焦',
                'disabled': '禁用',
              }
            : const {'common': '通用（所有状态）'},
      'sidebar' =>
        _reviewPart == 'item'
            ? const {
                'common': '通用（所有状态）',
                'selected': '选中',
                'ancestor': '祖先选中',
                'disabled': '禁用',
              }
            : const {'common': '通用（所有状态）'},
      'breadcrumb' => const {
        'common': '通用（所有状态）',
        'highlight': '高亮',
        'disabled': '禁用',
      },
      'notification' => const {
        'common': '通用（所有状态）',
        'read': '已读',
        'unread': '未读',
        'hovered': '悬停',
        'focused': '聚焦',
        'pressed': '按下',
        'disabled': '禁用',
      },
      'alert' => const {
        'common': '通用（所有状态）',
        'info': '信息',
        'success': '成功',
        'warning': '警告',
        'error': '错误',
      },
      'banner' => const {
        'common': '通用（所有状态）',
        'info': '信息',
        'success': '成功',
        'warning': '警告',
        'error': '错误',
      },
      'stepIndicator' => const {
        'common': '通用（所有状态）',
        'pending': '未开始',
        'current': '当前',
        'completed': '已完成',
        'error': '错误',
        'disabled': '禁用',
      },
      'stepperNavigation' => const {
        'common': '通用（所有状态）',
        'pending': '未开始',
        'current': '当前',
        'completed': '已完成',
        'error': '错误',
        'disabled': '禁用',
      },
      _ => const {'common': '通用（所有状态）'},
    };
    final state = states.containsKey(_reviewState) ? _reviewState : 'common';
    final slot =
        object +
        (state == 'common' || object == 'sidebar' || object == 'topNavigation'
            ? ''
            : state[0].toUpperCase() + state.substring(1));
    final v = _mode.reviews.object(slot), m = _spec.reviews.object(object);
    Widget n(
      String label,
      double? value,
      double fallback,
      double min,
      double max,
      void Function(double?) set, {
      bool decimal = false,
    }) {
      final bounds = decimal
          ? (min: min, max: max)
          : editorReviewBounds(
              object,
              label,
              s,
              editorPreviewSize(_device, landscape: _landscape),
              min: min,
              max: max,
              typographyDisplaySize:
                  theme.textTheme.displayLarge?.fontSize ??
                  theme.typography.displayLarge,
            );
      final lower = bounds.min, upper = bounds.max;
      final shown = lower <= upper
          ? (value ?? fallback).clamp(lower, upper).toDouble()
          : (value ?? fallback);
      return _number(
        label,
        shown,
        decimal ? min : lower,
        decimal ? max : upper,
        (x) {
          set(x);
          constrainEditorReviewDimensions(object, m, s);
        },
        () => set(null),
        value != null,
        wholeNumbers: !decimal,
      );
    }

    List<Widget> material(EditorReviewFields target) {
      final recipe =
          resolveEditorReviewMaterial(target, theme) ??
          theme.materialTheme.material;
      return [
        _select(
          '表面材质',
          target.materialKind ?? 'inherit',
          const {
            'inherit': '继承全局材质',
            'solid': '实色',
            'translucent': '半透明',
            'frostedGlass': '磨砂玻璃',
            'softLightGlass': '柔光玻璃',
            'clearFrostedGlass': '高透毛玻璃',
          },
          (x) => _change(() => target.materialKind = x == 'inherit' ? null : x),
        ),
        if (target.materialKind != null && recipe?.usesBackdrop == true) ...[
          _select(
            '高光描边',
            target.materialEdgeEnabled?.toString() ?? 'inherit',
            const {'inherit': '按表面用途默认', 'true': '开启', 'false': '关闭'},
            (value) => _change(
              () => target.materialEdgeEnabled = value == 'inherit'
                  ? null
                  : value == 'true',
            ),
          ),

          n(
            '材质水平模糊',
            target.materialBlurX,
            recipe!.blurSigmaX,
            0,
            s.controlHeightXl,
            (x) => target.materialBlurX = x,
          ),
          n(
            '材质垂直模糊',
            target.materialBlurY,
            recipe.blurSigmaY,
            0,
            s.controlHeightXl,
            (x) => target.materialBlurY = x,
          ),
          const HyperText('材质质量与降级继承全局；高级质量下显示背景模糊。'),
        ],
      ];
    }

    final tabSlot =
        'tabBar${_reviewVariant == 'common' ? '' : _reviewVariant[0].toUpperCase() + _reviewVariant.substring(1)}';
    final parts = switch (object) {
      'sidebar' => const {'group': '侧栏表面与布局', 'item': '导航项', 'popup': '折叠子菜单'},
      'tabBar' => const {'group': '底槽与布局', 'item': '标签'},
      'pagination' => const {
        'group': '分页布局',
        'item': '页码按钮',
        'navigation': '首尾 / 前后按钮',
      },
      'topNavigation' => {activePart: objects[selectedObject]!},
      _ => const {'group': '整体'},
    };
    final part = parts.containsKey(activePart) ? activePart : 'group';
    final buttonState = _reviewState == 'selected' ? 'selected' : 'common';
    final buttonSlot = object == 'pagination'
        ? (part == 'navigation'
              ? 'paginationNavigation'
              : buttonState == 'selected'
              ? 'paginationSelected'
              : 'paginationDefault')
        : (buttonState == 'selected'
              ? 'topNavigationSelected'
              : 'topNavigationDefault');

    final isNavigationSurface =
        object == 'tabBar' ||
        object == 'sidebar' && part != 'group' ||
        object == 'topNavigation' && part == 'panel' ||
        object == 'breadcrumb' && state != 'common';
    final surfaceSlot = object == 'tabBar'
        ? (part == 'group'
              ? tabSlot
              : tabSlot + (buttonState == 'selected' ? 'Selected' : 'Item'))
        : object == 'sidebar'
        ? (part == 'popup'
              ? 'sidebarPopup'
              : switch (state) {
                  'selected' => 'sidebarSelected',
                  'ancestor' => 'sidebarAncestor',
                  'disabled' => 'sidebarDisabled',
                  _ => 'sidebarItem',
                })
        : object == 'topNavigation'
        ? 'topNavigationPanel'
        : slot;
    List<Widget> menuItems() {
      final mv = _mode.reviews.topNavigationMenu,
          mm = _spec.reviews.topNavigationMenu;
      final menu = theme.topNavigationTheme.style?.menuStyle;
      Widget weight(String label, double? value, void Function(double?) set) =>
          _select(
            label,
            value?.round().toString() ?? 'inherit',
            const {
              'inherit': '继承',
              '400': '400 常规',
              '500': '500 中等',
              '600': '600 半粗',
              '700': '700 粗体',
            },
            (x) => _change(() => set(x == 'inherit' ? null : double.parse(x))),
          );
      return [
        if (state == 'common') ...[
          _heading('菜单项布局'),
          n(
            '条目最小高度',
            mm.itemHeight,
            menu?.itemHeight ?? s.menu.itemHeight,
            1,
            s.controlHeightXl,
            (x) {
              mm.itemHeight = x;
              constrainEditorReviewDimensions('topNavigationMenu', mm, s);
            },
          ),
          n(
            '菜单项水平内边距',
            mm.paddingLeft,
            menu?.padding ?? s.menu.padding,
            0,
            s.minimumInteractiveDimension,
            (x) => mm.paddingLeft = x,
          ),
          n(
            '菜单项垂直内边距',
            mm.paddingTop,
            menu?.itemVerticalPadding ??
                s.menu.itemVerticalPadding ??
                s.menu.padding / 2,
            0,
            s.minimumInteractiveDimension,
            (x) => mm.paddingTop = x,
          ),
          n(
            '菜单项间距',
            mm.itemSpacing,
            menu?.itemSpacing ?? s.menu.itemSpacing ?? s.navigationItemSpacing,
            0,
            s.minimumInteractiveDimension,
            (x) => mm.itemSpacing = x,
          ),
          n(
            '分组间距',
            mm.groupSpacing,
            menu?.groupSpacing ?? s.menu.groupSpacing,
            0,
            s.minimumInteractiveDimension,
            (x) => mm.groupSpacing = x,
          ),
          _heading('菜单标题文字'),
          _color(
            '标题与图标颜色',
            mv.foregroundColor,
            (x) => mv.foregroundColor = x,
            inheritedColor: menu?.foregroundColor ?? theme.colors.textPrimary,
          ),
          n(
            '标题字号',
            mm.itemTextStyleSize,
            menu?.itemTextStyle?.fontSize ?? theme.typography.listTitle,
            1,
            editorContentIconLimit,
            (x) => mm.itemTextStyleSize = x,
          ),
          weight(
            '标题字重',
            mv.itemTextStyleWeight,
            (x) => mv.itemTextStyleWeight = x,
          ),
          _heading('描述文字'),
          n(
            '描述字号',
            mm.descriptionStyleSize,
            menu?.descriptionStyle?.fontSize ??
                theme.textTheme.bodySmall?.fontSize ??
                theme.typography.control,
            1,
            editorContentIconLimit,
            (x) => mm.descriptionStyleSize = x,
          ),
          weight(
            '描述字重',
            mv.descriptionStyleWeight,
            (x) => mv.descriptionStyleWeight = x,
          ),
          _color(
            '描述文字颜色',
            mv.descriptionStyleColor,
            (x) => mv.descriptionStyleColor = x,
            inheritedColor:
                menu?.descriptionStyle?.color ?? theme.colors.textSecondary,
          ),
          n(
            '标题与描述间距',
            mm.descriptionGap,
            menu?.descriptionGap ?? s.menu.descriptionGap,
            0,
            s.minimumInteractiveDimension,
            (x) => mm.descriptionGap = x,
          ),
          _heading('图标'),
          n(
            '菜单图标尺寸',
            mm.iconSize,
            menu?.iconSize ?? s.menu.iconSize,
            0,
            s.controlHeightLg,
            (x) => mm.iconSize = x,
          ),
          n(
            '菜单图标间距',
            mm.iconSpacing,
            menu?.iconSpacing ?? s.menu.iconSpacing,
            0,
            s.minimumInteractiveDimension,
            (x) => mm.iconSpacing = x,
          ),
          _heading('菜单项轮廓'),
          n(
            '菜单项圆角',
            mm.itemRadius,
            menu?.itemRadius ?? s.menu.itemRadius,
            0,
            editorRadiusLimit(
              mm.itemHeight ?? menu?.itemHeight ?? s.menu.itemHeight,
            ),
            (x) => mm.itemRadius = x,
          ),
        ],
        if (state == 'selected') ...[
          _color(
            '文字与图标颜色',
            mv.selectedForegroundColor,
            (x) => mv.selectedForegroundColor = x,
            inheritedColor:
                menu?.selectedForegroundColor ??
                menu?.foregroundColor ??
                theme.colors.textPrimary,
          ),
          _color(
            '选中背景',
            mv.selectedBackgroundColor,
            (x) => mv.selectedBackgroundColor = x,
            inheritedColor:
                menu?.selectedBackgroundColor ??
                theme.colors.primary.withValues(alpha: .08),
          ),
        ],
        if (state == 'active')
          _color(
            '悬停与聚焦背景',
            mv.overlayColor,
            (x) => mv.overlayColor = x,
            inheritedColor:
                menu?.activeBackgroundColor ??
                theme.colors.stateLayer.withValues(alpha: .06),
          ),
        if (state == 'disabled')
          _color(
            '文字与图标颜色',
            mv.disabledColor,
            (x) => mv.disabledColor = x,
            inheritedColor: menu?.disabledColor ?? theme.colors.disabled,
          ),
      ];
    }

    List<Widget> menuPanelLayout() {
      final pm = _spec.reviews.topNavigationPanel;
      final menu = theme.topNavigationTheme.style?.menuStyle;
      final viewport = editorPreviewSize(_device, landscape: _landscape);
      return [
        _heading('下拉面板布局'),
        n(
          '面板宽度',
          pm.width,
          menu?.width ?? s.menu.width,
          1,
          viewport.width - 2 * s.pageHorizontalPadding,
          (x) => pm.width = x,
        ),
        n(
          '面板最大高度',
          pm.height,
          menu?.maxHeight ?? viewport.height,
          1,
          viewport.height,
          (x) => pm.height = x,
        ),
        n(
          '面板内边距',
          pm.horizontalPadding,
          menu?.surfacePadding ?? s.menu.padding,
          0,
          s.minimumInteractiveDimension,
          (x) => pm.horizontalPadding = x,
        ),
      ];
    }

    List<Widget> navigationSurface() {
      final sv = _mode.reviews.object(surfaceSlot),
          sm = _spec.reviews.object(surfaceSlot);
      final item = part == 'item' || object == 'breadcrumb';
      final sidebar = theme.sidebarTheme.style ?? const HyperSidebarStyle();
      final sidebarForeground = switch (state) {
        'disabled' => sidebar.disabledColor ?? theme.colors.disabled,
        'selected' =>
          sidebar.selectedForegroundColor ??
              (sidebar.selectionStyle == HyperSidebarSelectionStyle.fill
                  ? theme.colors.onPrimary
                  : theme.colors.primary),
        'ancestor' =>
          sidebar.ancestorSelectedForegroundColor ?? theme.colors.primary,
        _ => sidebar.foregroundColor ?? theme.colors.textPrimary,
      };
      final leadingColor =
          (switch (state) {
            'disabled' => sidebar.disabledIconColor,
            'selected' => sidebar.selectedIconColor,
            'ancestor' => sidebar.ancestorSelectedIconColor,
            _ => sidebar.iconColor,
          }) ??
          sidebar.iconColor ??
          sidebarForeground;
      final expandColor =
          (switch (state) {
            'disabled' => sidebar.disabledExpandIconColor,
            'selected' => sidebar.selectedExpandIconColor,
            'ancestor' => sidebar.ancestorSelectedExpandIconColor,
            _ => sidebar.expandIconColor,
          }) ??
          sidebar.expandIconColor ??
          sidebarForeground;
      final extent = object == 'sidebar'
          ? s.sidebar.itemHeight
          : object == 'breadcrumb'
          ? s.breadcrumb.itemHeight
          : s.tabBar.height;
      final fallback = object == 'sidebar' && state == 'selected'
          ? theme.colors.primary.withValues(alpha: .08)
          : object == 'sidebar' && state == 'ancestor'
          ? theme.colors.primary.withValues(alpha: .05)
          : object == 'breadcrumb' && state == 'highlight'
          ? theme.colors.warning.withValues(alpha: .14)
          : object == 'tabBar' && part == 'group'
          ? theme.colors.surfaceMuted
          : theme.colors.surface;
      return [
        if (object == 'tabBar' && part == 'item') ...[
          _heading('标签文字'),
          if (buttonState == 'common')
            n(
              '文字字号',
              _spec.reviews.tabBar.textStyleSize,
              theme.typography.control,
              1,
              editorContentIconLimit,
              (x) => _spec.reviews.tabBar.textStyleSize = x,
            ),
          _select(
            '文字字重',
            sv.textStyleWeight?.round().toString() ?? 'inherit',
            const {
              'inherit': '继承',
              '400': '400 常规',
              '500': '500 中等',
              '600': '600 半粗',
              '700': '700 粗体',
            },
            (x) => _change(
              () =>
                  sv.textStyleWeight = x == 'inherit' ? null : double.parse(x),
            ),
          ),
        ],
        if (item)
          _color(
            object == 'sidebar' ? '条目文字颜色' : '文字与图标颜色',
            sv.foregroundColor,
            (x) => sv.foregroundColor = x,
            inheritedColor: state == 'disabled'
                ? theme.colors.disabled
                : state == 'highlight'
                ? theme.colors.warning
                : buttonState == 'selected' ||
                      state == 'selected' ||
                      state == 'ancestor'
                ? theme.colors.primary
                : theme.colors.textPrimary,
          ),
        if (object == 'sidebar' && part == 'item') ...[
          _heading('前置图标'),
          if (state == 'common')
            n(
              '前置图标尺寸',
              _spec.reviews.sidebar.iconSize,
              s.sidebar.iconSize,
              0,
              editorSidebarIconSizeLimit(s),
              (x) => _spec.reviews.sidebar.iconSize = x,
            ),
          _color(
            '前置图标颜色',
            sv.iconColor,
            (x) => sv.iconColor = x,
            inheritedColor: leadingColor,
          ),
          if (state == 'common')
            n(
              '折叠态图标尺寸',
              _spec.reviews.sidebar.collapsedIconSize,
              s.sidebar.collapsedIconSize ?? s.sidebar.iconSize,
              0,
              editorSidebarIconSizeLimit(s),
              (x) => _spec.reviews.sidebar.collapsedIconSize = x,
            ),
          if (state == 'common')
            n(
              '折叠态条目间距',
              _spec.reviews.sidebar.collapsedRowGap,
              s.sidebar.collapsedRowGap ??
                  s.sidebar.rowGap ??
                  s.navigationItemSpacing,
              0,
              editorContentSpacingLimit,
              (x) => _spec.reviews.sidebar.collapsedRowGap = x,
            ),
          _heading('展开 / 收起图标'),
          if (state == 'common')
            n(
              '展开收起图标尺寸',
              _spec.reviews.sidebar.expandIconSize,
              s.sidebar.expandIconSize ?? s.sidebar.iconSize,
              0,
              editorSidebarIconSizeLimit(s),
              (x) => _spec.reviews.sidebar.expandIconSize = x,
            ),
          _color(
            '展开收起图标颜色',
            sv.expandIconColor,
            (x) => sv.expandIconColor = x,
            inheritedColor: expandColor,
          ),
        ],
        _heading('当前对象表面'),
        _color(
          '背景',
          sv.backgroundColor,
          (x) => sv.backgroundColor = x,
          inheritedColor: fallback,
        ),
        ...material(sv),
        n(
          '表面圆角',
          sm.surfaceRadius,
          object == 'tabBar'
              ? (_reviewVariant == 'segmented'
                    ? s.tabBar.segmentedRadius
                    : s.tabBar.separatedRadius)
              : item
              ? extent / 2
              : object == 'topNavigation'
              ? s.menu.surfaceRadius
              : s.menu.itemRadius,
          0,
          item || object == 'tabBar'
              ? editorRadiusLimit(extent)
              : editorSurfaceRadiusLimit,
          (x) => sm.surfaceRadius = x,
        ),
        n(
          '边框宽度',
          sv.borderWidth,
          0,
          0,
          item ? editorSelectionStrokeLimit(extent) : editorLineThicknessLimit,
          (x) => sv.borderWidth = x,
        ),
        _color(
          '边框颜色',
          sv.borderColor,
          (x) => sv.borderColor = x,
          inheritedColor: theme.colors.outline,
        ),
        ..._focusedShadowProperties(
          maxExtent: s.controlHeightLg,
          EditorComponent(),
          stateTarget: sv.shadow,
          label: '表面阴影',
          description: '仅覆盖当前对象和状态；空列表关闭材质及普通表面阴影。',
        ),
        if (object == 'tabBar' && part == 'group') ...[
          _heading('下划线'),
          _color(
            '下划线颜色',
            sv.foregroundColor,
            (x) => sv.foregroundColor = x,
            inheritedColor: theme.colors.primary,
          ),
          _color(
            '分隔线颜色',
            sv.separatorColor,
            (x) => sv.separatorColor = x,
            inheritedColor: theme.colors.outline,
          ),
        ],
      ];
    }

    List<Widget> buttonBody() {
      final baseButton =
          (object == 'pagination'
              ? theme.paginationTheme.style.buttonStyle
              : theme.topNavigationTheme.style?.itemStyle) ??
          HyperButtonStyle();
      final inheritedButton = baseButton.merge(
        object == 'pagination'
            ? (part == 'navigation'
                  ? theme.paginationTheme.style.navigationStyle
                  : buttonState == 'selected'
                  ? theme.paginationTheme.style.selectedStyle
                  : null)
            : buttonState == 'selected'
            ? theme.topNavigationTheme.style?.selectedItemStyle
            : null,
      );
      final fallbackForeground =
          inheritedButton.foregroundColor ??
          (buttonState == 'selected'
              ? (object == 'pagination'
                    ? theme.colors.onPrimary
                    : theme.colors.primary)
              : theme.colors.textPrimary);
      final fallbackBackground =
          inheritedButton.background?.color ??
          (buttonState == 'selected' && object == 'pagination'
              ? theme.colors.primary
              : Colors.transparent);
      final bv = _mode.reviews.object(buttonSlot),
          bm = _spec.reviews.object(buttonSlot);
      return [
        _heading('按钮文字'),
        n(
          '按钮文字字号',
          bm.textStyleSize,
          theme.typography.control,
          1,
          editorContentIconLimit,
          (x) => bm.textStyleSize = x,
        ),
        _select(
          '按钮文字字重',
          bv.textStyleWeight?.round().toString() ?? 'inherit',
          const {
            'inherit': '继承',
            '400': '400 常规',
            '500': '500 中等',
            '600': '600 半粗',
            '700': '700 粗体',
          },
          (x) => _change(
            () => bv.textStyleWeight = x == 'inherit' ? null : double.parse(x),
          ),
        ),
        _color(
          '按钮文字与图标颜色',
          bv.foregroundColor,
          (x) => bv.foregroundColor = x,
          inheritedColor: fallbackForeground,
        ),
        _heading('按钮表面'),
        ...material(bv),
        n(
          '按钮圆角',
          bm.surfaceRadius,
          object == 'pagination' ? s.pagination.radius : s.topNavigation.radius,
          0,
          editorRadiusLimit(
            object == 'pagination'
                ? s.pagination.height
                : s.topNavigation.height,
          ),
          (x) => bm.surfaceRadius = x,
        ),
        _color(
          '按钮背景',
          bv.backgroundColor,
          (x) => bv.backgroundColor = x,
          inheritedColor: fallbackBackground,
        ),
        n(
          '按钮边框宽度',
          bv.borderWidth,
          0,
          0,
          editorSelectionStrokeLimit(
            object == 'pagination'
                ? s.pagination.height
                : s.topNavigation.height,
          ),
          (x) => bv.borderWidth = x,
        ),
        _color(
          '按钮边框颜色',
          bv.borderColor,
          (x) => bv.borderColor = x,
          inheritedColor: theme.colors.outline,
        ),
        ..._focusedShadowProperties(
          maxExtent: s.controlHeightLg,
          EditorComponent(),
          stateTarget: bv.shadow,
          label: '按钮阴影',
          description: '仅覆盖当前对象与状态；空列表关闭阴影。',
        ),
      ];
    }

    List<Widget> body() {
      switch (object) {
        case 'tooltip':
          final tipColors =
              theme.tooltipTheme.appearance == HyperTooltipAppearance.theme
              ? theme.colors
              : HyperColorScheme.dark(seedColor: theme.colors.primary);
          return [
            _heading('文字'),
            _color(
              '文字颜色',
              v.foregroundColor,
              (x) => v.foregroundColor = x,
              inheritedColor:
                  theme.tooltipTheme.foregroundColor ?? tipColors.textPrimary,
            ),
            _heading('提示表面'),
            ...material(v),
            ...[
              ('Left', '左'),
              ('Top', '上'),
              ('Right', '右'),
              ('Bottom', '下'),
            ].map(
              (axis) => switch (axis.$1) {
                'Left' => n(
                  '内容内边距 · 左',
                  m.paddingLeft,
                  s.menu.padding,
                  0,
                  editorContentSpacingLimit,
                  (x) => m.paddingLeft = x,
                ),
                'Top' => n(
                  '内容内边距 · 上',
                  m.paddingTop,
                  s.menu.padding / 2,
                  0,
                  editorContentSpacingLimit,
                  (x) => m.paddingTop = x,
                ),
                'Right' => n(
                  '内容内边距 · 右',
                  m.paddingRight,
                  s.menu.padding,
                  0,
                  editorContentSpacingLimit,
                  (x) => m.paddingRight = x,
                ),
                _ => n(
                  '内容内边距 · 下',
                  m.paddingBottom,
                  s.menu.padding / 2,
                  0,
                  editorContentSpacingLimit,
                  (x) => m.paddingBottom = x,
                ),
              },
            ),
            n(
              '表面圆角',
              m.surfaceRadius,
              s.menu.itemRadius,
              0,
              editorSurfaceRadiusLimit,
              (x) => m.surfaceRadius = x,
            ),
            _color(
              '背景',
              v.background,
              (x) => v.background = x,
              inheritedColor:
                  theme.tooltipTheme.style?.background?.color ??
                  tipColors.surfaceElevated,
            ),
            n(
              '边框宽度',
              v.borderWidth,
              0,
              0,
              editorLineThicknessLimit,
              (x) => v.borderWidth = x,
            ),
            _color(
              '边框颜色',
              v.borderColor,
              (x) => v.borderColor = x,
              inheritedColor: tipColors.outline,
            ),
            ..._focusedShadowProperties(
              maxExtent: s.controlHeightLg,
              EditorComponent(),
              stateTarget: v.shadow,
              label: '提示阴影',
              description: '继承公共提示表面；空列表关闭阴影。',
            ),
          ];
        case 'appBar':
          final native = theme.appBarTheme.style ?? const HyperAppBarStyle();
          return [
            _heading('标题'),
            _select('标题对齐', v.textAlign ?? 'inherit', const {
              'inherit': '继承',
              'center': '居中',
              'start': '起始',
            }, (x) => _change(() => v.textAlign = x == 'inherit' ? null : x)),
            if (state == 'common')
              n(
                '标题字号',
                m.titleTextStyleSize,
                native.titleTextStyle?.fontSize ??
                    theme.typography.subsectionTitle,
                1,
                editorContentIconLimit,
                (x) => m.titleTextStyleSize = x,
                decimal: false,
              ),
            _select(
              '标题字重',
              v.titleTextStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.titleTextStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '标题颜色',
              v.titleTextStyleColor,
              (x) => v.titleTextStyleColor = x,
              inheritedColor:
                  native.titleTextStyle?.color ?? theme.colors.textPrimary,
            ),
            _heading('展开标题'),
            HyperText(
              '继承时：中等展开 ${theme.textTheme.titleLarge?.fontSize?.round()}，大幅展开 ${theme.textTheme.headlineLarge?.fontSize?.round()}。下方以大幅展开为参考，显式设置同时覆盖两种展开形态。',
            ),
            if (state == 'common')
              n(
                '展开标题字号',
                m.expandedTitleTextStyleSize,
                native.expandedTitleTextStyle?.fontSize ??
                    theme.textTheme.headlineLarge?.fontSize ??
                    theme.typography.pageTitle,
                1,
                editorContentIconLimit,
                (x) => m.expandedTitleTextStyleSize = x,
                decimal: false,
              ),
            _select(
              '展开标题字重',
              v.expandedTitleTextStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.expandedTitleTextStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '展开标题颜色',
              v.expandedTitleTextStyleColor,
              (x) => v.expandedTitleTextStyleColor = x,
              inheritedColor:
                  native.expandedTitleTextStyle?.color ??
                  theme.colors.textPrimary,
            ),
            if (state == 'common') ...[
              _heading('布局'),
              n(
                '收起高度',
                m.collapsedHeight,
                s.appBar.collapsedHeight,
                0,
                editorLayoutInsetLimit,
                (x) => m.collapsedHeight = x,
                decimal: false,
              ),
              n(
                '中等展开高度',
                m.mediumExpandedHeight,
                s.appBar.mediumExpandedHeight,
                0,
                editorLayoutInsetLimit,
                (x) => m.mediumExpandedHeight = x,
                decimal: false,
              ),
              n(
                '完整展开高度',
                m.expandedHeight,
                s.appBar.expandedHeight,
                0,
                editorLayoutInsetLimit,
                (x) => m.expandedHeight = x,
                decimal: false,
              ),
              n(
                '标题水平留白',
                m.titleHorizontalPadding,
                s.appBar.titleHorizontalPadding,
                0,
                editorContentSpacingLimit,
                (x) => m.titleHorizontalPadding = x,
                decimal: false,
              ),
            ],
            _heading('交互与标记'),
            _color(
              '文字 / 图标颜色',
              v.foregroundColor,
              (x) => v.foregroundColor = x,
              inheritedColor:
                  native.foregroundColor ?? theme.colors.textPrimary,
            ),
            _heading('表面与留白'),
            ...material(v),
            _color(
              '背景',
              v.backgroundColor,
              (x) => v.backgroundColor = x,
              inheritedColor: native.backgroundColor ?? theme.colors.surface,
            ),
            n(
              '边框宽度',
              v.borderWidth,
              0,
              0,
              editorLineThicknessLimit,
              (x) => v.borderWidth = x,
            ),
            _color(
              '边框颜色',
              v.borderColor,
              (x) => v.borderColor = x,
              inheritedColor: theme.colors.outline,
            ),
            ..._focusedShadowProperties(
              maxExtent: s.controlHeightLg,
              EditorComponent(),
              stateTarget: v.shadow,
              label: '表面阴影',
              description: '显式空列表关闭阴影。',
            ),
          ];
        case 'drawer':
          final native = theme.drawerTheme.style ?? const HyperDrawerStyle();
          return [
            n(
              '表面圆角',
              m.radius,
              s.drawer.radius ?? 0,
              0,
              editorRadiusLimit(s.drawer.width),
              (x) => m.radius = x,
            ),
            if (state == 'common') ...[
              _heading('布局'),
              n(
                '展开宽度',
                m.width,
                s.drawer.width,
                0,
                editorContentWidthLimit,
                (x) => m.width = x,
                decimal: false,
              ),
            ],
            _color(
              '背景',
              v.backgroundColor,
              (x) => v.backgroundColor = x,
              inheritedColor: native.backgroundColor ?? theme.colors.surface,
            ),
            ...material(v),
            n(
              '边框宽度',
              v.borderWidth,
              0,
              0,
              editorLineThicknessLimit,
              (x) => v.borderWidth = x,
            ),
            _color(
              '边框颜色',
              v.borderColor,
              (x) => v.borderColor = x,
              inheritedColor: theme.colors.outline,
            ),
            ..._focusedShadowProperties(
              maxExtent: s.controlHeightLg,
              EditorComponent(),
              stateTarget: v.shadow,
              label: '表面阴影',
              description: '显式空列表关闭阴影。',
            ),
          ];
        case 'notification':
          final native =
              notificationDefaults(
                theme: theme,
                metrics: s.notification,
                materialTheme: theme.materialTheme,
                isRead: state == 'read',
              ).merge(
                theme.notificationTheme.resolve(
                  isRead: state == 'read',
                  states: {
                    if (state == 'hovered') HyperControlState.hovered,
                    if (state == 'focused') HyperControlState.focused,
                    if (state == 'pressed') HyperControlState.pressed,
                    if (state == 'disabled') HyperControlState.disabled,
                  },
                ),
              );
          return [
            _heading('标题'),
            if (state == 'common')
              n(
                '标题字号',
                m.titleStyleSize,
                native.titleStyle?.fontSize ??
                    theme.textTheme.titleSmall?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.titleStyleSize = x,
                decimal: false,
              ),
            _select(
              '标题字重',
              v.titleStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.titleStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '标题颜色',
              v.titleStyleColor,
              (x) => v.titleStyleColor = x,
              inheritedColor:
                  native.titleStyle?.color ?? theme.colors.textPrimary,
            ),
            _heading('正文'),
            if (state == 'common')
              n(
                '正文字号',
                m.contentStyleSize,
                native.contentStyle?.fontSize ??
                    theme.textTheme.bodyMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.contentStyleSize = x,
                decimal: false,
              ),
            _select(
              '正文字重',
              v.contentStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.contentStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '正文颜色',
              v.contentStyleColor,
              (x) => v.contentStyleColor = x,
              inheritedColor:
                  native.contentStyle?.color ?? theme.colors.textSecondary,
            ),
            _heading('时间'),
            if (state == 'common')
              n(
                '时间字号',
                m.timeStyleSize,
                native.timeStyle?.fontSize ??
                    theme.textTheme.bodyMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.timeStyleSize = x,
                decimal: false,
              ),
            _select(
              '时间字重',
              v.timeStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () =>
                    v.timeStyleWeight = x == 'inherit' ? null : double.parse(x),
              ),
            ),
            _color(
              '时间颜色',
              v.timeStyleColor,
              (x) => v.timeStyleColor = x,
              inheritedColor:
                  native.timeStyle?.color ?? theme.colors.textSecondary,
            ),
            if (state == 'common')
              n(
                '图标尺寸',
                m.iconSize,
                s.notification.iconSize,
                0,
                editorContentIconLimit,
                (x) => m.iconSize = x,
                decimal: false,
              ),
            _color(
              '图标颜色',
              v.iconColor,
              (x) => v.iconColor = x,
              inheritedColor: native.iconColor ?? theme.colors.primary,
            ),
            if (state == 'common')
              n(
                '未读标记尺寸',
                m.unreadSize,
                s.notification.unreadSize,
                0,
                editorContentIconLimit,
                (x) => m.unreadSize = x,
                decimal: false,
              ),
            _color(
              '未读标记颜色',
              v.unreadColor,
              (x) => v.unreadColor = x,
              inheritedColor: native.unreadColor ?? theme.colors.primary,
            ),
            if (state == 'common')
              n(
                '关闭按钮尺寸',
                m.closeButtonSize,
                s.notification.closeButtonSize,
                0,
                editorContentIconLimit,
                (x) => m.closeButtonSize = x,
                decimal: false,
              ),
            if (state == 'common') ...[
              _heading('操作区'),
              _select(
                '操作区对齐',
                v.actionsAlignment ?? 'inherit',
                const {
                  'inherit': '继承',
                  'start': '起始',
                  'center': '居中',
                  'end': '末尾',
                  'spaceBetween': '两端分布',
                  'spaceAround': '均匀环绕',
                  'spaceEvenly': '均匀分布',
                },
                (x) => _change(
                  () => v.actionsAlignment = x == 'inherit' ? null : x,
                ),
              ),
              _heading('布局'),
              n(
                '关闭图标尺寸',
                m.closeIconSize,
                s.notification.closeIconSize,
                0,
                editorContentIconLimit,
                (x) => m.closeIconSize = x,
                decimal: false,
              ),
              n(
                '图标与内容间距',
                m.spacing,
                s.notification.spacing,
                0,
                editorContentSpacingLimit,
                (x) => m.spacing = x,
                decimal: false,
              ),
              n(
                '标题与正文间距',
                m.titleSpacing,
                s.notification.titleSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.titleSpacing = x,
                decimal: false,
              ),
              n(
                '操作间距',
                m.actionSpacing,
                s.notification.actionSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.actionSpacing = x,
                decimal: false,
              ),
              n(
                '操作换行间距',
                m.actionRunSpacing,
                s.notification.actionRunSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.actionRunSpacing = x,
                decimal: false,
              ),
            ],
            _heading('交互与标记'),
            _color(
              '状态层颜色',
              v.overlayColor,
              (x) => v.overlayColor = x,
              inheritedColor: native.overlayColor ?? theme.colors.primary,
            ),
            if (state == 'common' || state == 'hovered')
              n(
                '悬停状态层透明度',
                v.hoverOpacity,
                native.hoverOpacity ?? .1,
                0,
                1,
                (x) => v.hoverOpacity = x,
                decimal: true,
              ),
            if (state == 'common' || state == 'focused')
              n(
                '聚焦状态层透明度',
                v.focusOpacity,
                native.focusOpacity ?? .1,
                0,
                1,
                (x) => v.focusOpacity = x,
                decimal: true,
              ),
            if (state == 'common' || state == 'pressed')
              n(
                '按下状态层透明度',
                v.pressedOpacity,
                native.pressedOpacity ?? .1,
                0,
                1,
                (x) => v.pressedOpacity = x,
                decimal: true,
              ),
            if (state == 'common' || state == 'disabled')
              n(
                '禁用透明度',
                v.disabledOpacity,
                native.disabledOpacity ?? .38,
                0,
                1,
                (x) => v.disabledOpacity = x,
                decimal: true,
              ),
            _heading('动画与显示时机'),
            n(
              '动画时长（毫秒）',
              v.duration,
              native.duration?.inMilliseconds.toDouble() ??
                  theme.motion.standardDuration.inMilliseconds.toDouble(),
              0,
              editorReviewDurationLimit,
              (x) => v.duration = x,
              decimal: false,
            ),
            _select('动画曲线', v.curve ?? 'inherit', const {
              'inherit': '继承',
              'linear': '线性',
              'easeInOut': '缓入缓出',
              'fastOutSlowIn': '快出慢入',
            }, (x) => _change(() => v.curve = x == 'inherit' ? null : x)),
            _heading('表面与留白'),
            ...material(v),
            if (state == 'common')
              n(
                '内容内边距 · 左',
                m.paddingLeft,
                s.notification.padding.resolve(TextDirection.ltr).left,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingLeft = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 上',
                m.paddingTop,
                s.notification.padding.resolve(TextDirection.ltr).top,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingTop = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 右',
                m.paddingRight,
                s.notification.padding.resolve(TextDirection.ltr).right,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingRight = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 下',
                m.paddingBottom,
                s.notification.padding.resolve(TextDirection.ltr).bottom,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingBottom = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '表面圆角',
                m.radius,
                s.notification.radius,
                0,
                editorSurfaceRadiusLimit,
                (x) => m.radius = x,
                decimal: false,
              ),
            _color(
              '背景',
              v.background,
              (x) => v.background = x,
              inheritedColor: native.background?.color ?? theme.colors.surface,
            ),
            n(
              '边框宽度',
              v.borderWidth,
              0,
              0,
              editorLineThicknessLimit,
              (x) => v.borderWidth = x,
              decimal: false,
            ),
            _color(
              '边框颜色',
              v.borderColor,
              (x) => v.borderColor = x,
              inheritedColor: theme.colors.outline,
            ),
            ..._focusedShadowProperties(
              maxExtent: s.controlHeightLg,
              EditorComponent(),
              stateTarget: v.shadow,
              label: '表面阴影',
              description: '默认继承组件与材质配方；显式空列表关闭阴影。',
            ),
          ];
        case 'loadingOverlay':
          final native = theme.loadingOverlayTheme.style;
          return [
            _heading('文字'),
            if (state == 'common')
              n(
                '文字字号',
                m.textStyleSize,
                native.textStyle?.fontSize ??
                    theme.textTheme.bodyMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.textStyleSize = x,
                decimal: false,
              ),
            _select(
              '文字字重',
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
                () =>
                    v.textStyleWeight = x == 'inherit' ? null : double.parse(x),
              ),
            ),
            _color(
              '文字颜色',
              v.textStyleColor,
              (x) => v.textStyleColor = x,
              inheritedColor:
                  native.textStyle?.color ?? theme.colors.textPrimary,
            ),
            if (state == 'common') ...[
              _heading('布局'),
              n(
                '内容最大宽度',
                m.maxContentWidth,
                s.loadingOverlay.maxContentWidth,
                0,
                editorContentWidthLimit,
                (x) => m.maxContentWidth = x,
                decimal: false,
              ),
              n(
                '图标与内容间距',
                m.spacing,
                s.loadingOverlay.spacing,
                0,
                editorContentSpacingLimit,
                (x) => m.spacing = x,
                decimal: false,
              ),
            ],
            _heading('动画与显示时机'),
            n(
              '延迟显示（毫秒）',
              v.showDelay,
              native.showDelay?.inMilliseconds.toDouble() ??
                  theme.motion.standardDuration.inMilliseconds.toDouble(),
              0,
              editorReviewDurationLimit,
              (x) => v.showDelay = x,
              decimal: false,
            ),
            n(
              '最短显示时长（毫秒）',
              v.minimumVisibleDuration,
              native.minimumVisibleDuration?.inMilliseconds.toDouble() ??
                  theme.motion.standardDuration.inMilliseconds.toDouble(),
              0,
              editorReviewDurationLimit,
              (x) => v.minimumVisibleDuration = x,
              decimal: false,
            ),
            n(
              '动画时长（毫秒）',
              v.duration,
              native.duration?.inMilliseconds.toDouble() ??
                  theme.motion.standardDuration.inMilliseconds.toDouble(),
              0,
              editorReviewDurationLimit,
              (x) => v.duration = x,
              decimal: false,
            ),
            _select('动画曲线', v.curve ?? 'inherit', const {
              'inherit': '继承',
              'linear': '线性',
              'easeInOut': '缓入缓出',
              'fastOutSlowIn': '快出慢入',
            }, (x) => _change(() => v.curve = x == 'inherit' ? null : x)),
            _heading('表面与留白'),
            ...material(v),
            if (state == 'common')
              n(
                '内容内边距 · 左',
                m.paddingLeft,
                s.loadingOverlay.padding.resolve(TextDirection.ltr).left,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingLeft = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 上',
                m.paddingTop,
                s.loadingOverlay.padding.resolve(TextDirection.ltr).top,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingTop = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 右',
                m.paddingRight,
                s.loadingOverlay.padding.resolve(TextDirection.ltr).right,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingRight = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 下',
                m.paddingBottom,
                s.loadingOverlay.padding.resolve(TextDirection.ltr).bottom,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingBottom = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '表面圆角',
                m.radius,
                s.loadingOverlay.radius,
                0,
                editorSurfaceRadiusLimit,
                (x) => m.radius = x,
                decimal: false,
              ),
            _color(
              '背景',
              v.background,
              (x) => v.background = x,
              inheritedColor: native.background?.color ?? theme.colors.surface,
            ),
            _color(
              '内容表面背景',
              v.contentBackground,
              (x) => v.contentBackground = x,
              inheritedColor:
                  native.contentBackground?.color ?? theme.colors.surface,
            ),
            n(
              '边框宽度',
              v.borderWidth,
              0,
              0,
              editorLineThicknessLimit,
              (x) => v.borderWidth = x,
              decimal: false,
            ),
            _color(
              '边框颜色',
              v.borderColor,
              (x) => v.borderColor = x,
              inheritedColor: theme.colors.outline,
            ),
            ..._focusedShadowProperties(
              maxExtent: s.controlHeightLg,
              EditorComponent(),
              stateTarget: v.shadow,
              label: '表面阴影',
              description: '默认继承组件与材质配方；显式空列表关闭阴影。',
            ),
          ];
        case 'alert':
          final severity = HyperNoticeSeverity.values.firstWhere(
            (value) => value.name == state,
            orElse: () => HyperNoticeSeverity.info,
          );
          final native = noticeDefaults(
            theme: theme,
            metrics: s.alert,
            materialTheme: theme.materialTheme,
            severity: severity,
            banner: false,
          ).merge(theme.alertTheme.styleFor(severity));
          return [
            _heading('标题'),
            if (state == 'common')
              n(
                '标题字号',
                m.titleStyleSize,
                native.titleStyle?.fontSize ??
                    theme.textTheme.titleSmall?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.titleStyleSize = x,
                decimal: false,
              ),
            _select(
              '标题字重',
              v.titleStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.titleStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '标题颜色',
              v.titleStyleColor,
              (x) => v.titleStyleColor = x,
              inheritedColor:
                  native.titleStyle?.color ?? theme.colors.textPrimary,
            ),
            _heading('正文'),
            if (state == 'common')
              n(
                '正文字号',
                m.contentStyleSize,
                native.contentStyle?.fontSize ??
                    theme.textTheme.bodyMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.contentStyleSize = x,
                decimal: false,
              ),
            _select(
              '正文字重',
              v.contentStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.contentStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '正文颜色',
              v.contentStyleColor,
              (x) => v.contentStyleColor = x,
              inheritedColor:
                  native.contentStyle?.color ?? theme.colors.textSecondary,
            ),
            if (state == 'common')
              n(
                '图标尺寸',
                m.iconSize,
                s.alert.iconSize,
                0,
                editorContentIconLimit,
                (x) => m.iconSize = x,
                decimal: false,
              ),
            _color(
              '图标颜色',
              v.iconColor,
              (x) => v.iconColor = x,
              inheritedColor: native.iconColor ?? theme.colors.primary,
            ),
            if (state == 'common')
              n(
                '关闭按钮尺寸',
                m.closeButtonSize,
                s.alert.closeButtonSize,
                0,
                editorContentIconLimit,
                (x) => m.closeButtonSize = x,
                decimal: false,
              ),
            if (state == 'common') ...[
              _heading('操作区'),
              _select(
                '操作区对齐',
                v.actionsAlignment ?? 'inherit',
                const {
                  'inherit': '继承',
                  'start': '起始',
                  'center': '居中',
                  'end': '末尾',
                  'spaceBetween': '两端分布',
                  'spaceAround': '均匀环绕',
                  'spaceEvenly': '均匀分布',
                },
                (x) => _change(
                  () => v.actionsAlignment = x == 'inherit' ? null : x,
                ),
              ),
              _heading('布局'),
              n(
                '关闭图标尺寸',
                m.closeIconSize,
                s.alert.closeIconSize,
                0,
                editorContentIconLimit,
                (x) => m.closeIconSize = x,
                decimal: false,
              ),
              n(
                '图标与内容间距',
                m.spacing,
                s.alert.spacing,
                0,
                editorContentSpacingLimit,
                (x) => m.spacing = x,
                decimal: false,
              ),
              n(
                '标题与正文间距',
                m.titleSpacing,
                s.alert.titleSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.titleSpacing = x,
                decimal: false,
              ),
              n(
                '操作间距',
                m.actionSpacing,
                s.alert.actionSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.actionSpacing = x,
                decimal: false,
              ),
              n(
                '操作换行间距',
                m.actionRunSpacing,
                s.alert.actionRunSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.actionRunSpacing = x,
                decimal: false,
              ),
            ],
            _heading('动画与显示时机'),
            n(
              '动画时长（毫秒）',
              v.duration,
              native.duration?.inMilliseconds.toDouble() ??
                  theme.motion.standardDuration.inMilliseconds.toDouble(),
              0,
              editorReviewDurationLimit,
              (x) => v.duration = x,
              decimal: false,
            ),
            _select('动画曲线', v.curve ?? 'inherit', const {
              'inherit': '继承',
              'linear': '线性',
              'easeInOut': '缓入缓出',
              'fastOutSlowIn': '快出慢入',
            }, (x) => _change(() => v.curve = x == 'inherit' ? null : x)),
            _heading('表面与留白'),
            ...material(v),
            if (state == 'common')
              n(
                '内容内边距 · 左',
                m.paddingLeft,
                s.alert.padding.resolve(TextDirection.ltr).left,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingLeft = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 上',
                m.paddingTop,
                s.alert.padding.resolve(TextDirection.ltr).top,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingTop = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 右',
                m.paddingRight,
                s.alert.padding.resolve(TextDirection.ltr).right,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingRight = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 下',
                m.paddingBottom,
                s.alert.padding.resolve(TextDirection.ltr).bottom,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingBottom = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '表面圆角',
                m.radius,
                s.alert.radius,
                0,
                editorSurfaceRadiusLimit,
                (x) => m.radius = x,
                decimal: false,
              ),
            _color(
              '背景',
              v.background,
              (x) => v.background = x,
              inheritedColor: native.background?.color ?? theme.colors.surface,
            ),
            n(
              '边框宽度',
              v.borderWidth,
              0,
              0,
              editorLineThicknessLimit,
              (x) => v.borderWidth = x,
              decimal: false,
            ),
            _color(
              '边框颜色',
              v.borderColor,
              (x) => v.borderColor = x,
              inheritedColor: theme.colors.outline,
            ),
            ..._focusedShadowProperties(
              maxExtent: s.controlHeightLg,
              EditorComponent(),
              stateTarget: v.shadow,
              label: '表面阴影',
              description: '默认继承组件与材质配方；显式空列表关闭阴影。',
            ),
          ];
        case 'banner':
          final severity = HyperNoticeSeverity.values.firstWhere(
            (value) => value.name == state,
            orElse: () => HyperNoticeSeverity.info,
          );
          final native = noticeDefaults(
            theme: theme,
            metrics: s.alert.banner,
            materialTheme: theme.materialTheme,
            severity: severity,
            banner: true,
          ).merge(theme.alertTheme.styleFor(severity, banner: true));
          return [
            _heading('标题'),
            if (state == 'common')
              n(
                '标题字号',
                m.titleStyleSize,
                native.titleStyle?.fontSize ??
                    theme.textTheme.titleSmall?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.titleStyleSize = x,
                decimal: false,
              ),
            _select(
              '标题字重',
              v.titleStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.titleStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '标题颜色',
              v.titleStyleColor,
              (x) => v.titleStyleColor = x,
              inheritedColor:
                  native.titleStyle?.color ?? theme.colors.textPrimary,
            ),
            _heading('正文'),
            if (state == 'common')
              n(
                '正文字号',
                m.contentStyleSize,
                native.contentStyle?.fontSize ??
                    theme.textTheme.bodyMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.contentStyleSize = x,
                decimal: false,
              ),
            _select(
              '正文字重',
              v.contentStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.contentStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '正文颜色',
              v.contentStyleColor,
              (x) => v.contentStyleColor = x,
              inheritedColor:
                  native.contentStyle?.color ?? theme.colors.textSecondary,
            ),
            if (state == 'common')
              n(
                '图标尺寸',
                m.iconSize,
                s.alert.banner.iconSize,
                0,
                editorContentIconLimit,
                (x) => m.iconSize = x,
                decimal: false,
              ),
            _color(
              '图标颜色',
              v.iconColor,
              (x) => v.iconColor = x,
              inheritedColor: native.iconColor ?? theme.colors.primary,
            ),
            if (state == 'common')
              n(
                '关闭按钮尺寸',
                m.closeButtonSize,
                s.alert.banner.closeButtonSize,
                0,
                editorContentIconLimit,
                (x) => m.closeButtonSize = x,
                decimal: false,
              ),
            if (state == 'common') ...[
              _heading('操作区'),
              _select(
                '操作区对齐',
                v.actionsAlignment ?? 'inherit',
                const {
                  'inherit': '继承',
                  'start': '起始',
                  'center': '居中',
                  'end': '末尾',
                  'spaceBetween': '两端分布',
                  'spaceAround': '均匀环绕',
                  'spaceEvenly': '均匀分布',
                },
                (x) => _change(
                  () => v.actionsAlignment = x == 'inherit' ? null : x,
                ),
              ),
              _heading('布局'),
              n(
                '关闭图标尺寸',
                m.closeIconSize,
                s.alert.banner.closeIconSize,
                0,
                editorContentIconLimit,
                (x) => m.closeIconSize = x,
                decimal: false,
              ),
              n(
                '图标与内容间距',
                m.spacing,
                s.alert.banner.spacing,
                0,
                editorContentSpacingLimit,
                (x) => m.spacing = x,
                decimal: false,
              ),
              n(
                '标题与正文间距',
                m.titleSpacing,
                s.alert.banner.titleSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.titleSpacing = x,
                decimal: false,
              ),
              n(
                '操作间距',
                m.actionSpacing,
                s.alert.banner.actionSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.actionSpacing = x,
                decimal: false,
              ),
              n(
                '操作换行间距',
                m.actionRunSpacing,
                s.alert.banner.actionRunSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.actionRunSpacing = x,
                decimal: false,
              ),
            ],
            _heading('动画与显示时机'),
            n(
              '动画时长（毫秒）',
              v.duration,
              native.duration?.inMilliseconds.toDouble() ??
                  theme.motion.standardDuration.inMilliseconds.toDouble(),
              0,
              editorReviewDurationLimit,
              (x) => v.duration = x,
              decimal: false,
            ),
            _select('动画曲线', v.curve ?? 'inherit', const {
              'inherit': '继承',
              'linear': '线性',
              'easeInOut': '缓入缓出',
              'fastOutSlowIn': '快出慢入',
            }, (x) => _change(() => v.curve = x == 'inherit' ? null : x)),
            _heading('表面与留白'),
            ...material(v),
            if (state == 'common')
              n(
                '内容内边距 · 左',
                m.paddingLeft,
                s.alert.banner.padding.resolve(TextDirection.ltr).left,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingLeft = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 上',
                m.paddingTop,
                s.alert.banner.padding.resolve(TextDirection.ltr).top,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingTop = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 右',
                m.paddingRight,
                s.alert.banner.padding.resolve(TextDirection.ltr).right,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingRight = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 下',
                m.paddingBottom,
                s.alert.banner.padding.resolve(TextDirection.ltr).bottom,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingBottom = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '表面圆角',
                m.radius,
                s.alert.banner.radius,
                0,
                editorSurfaceRadiusLimit,
                (x) => m.radius = x,
                decimal: false,
              ),
            _color(
              '背景',
              v.background,
              (x) => v.background = x,
              inheritedColor: native.background?.color ?? theme.colors.surface,
            ),
            n(
              '边框宽度',
              v.borderWidth,
              0,
              0,
              editorLineThicknessLimit,
              (x) => v.borderWidth = x,
              decimal: false,
            ),
            _color(
              '边框颜色',
              v.borderColor,
              (x) => v.borderColor = x,
              inheritedColor: theme.colors.outline,
            ),
            ..._focusedShadowProperties(
              maxExtent: s.controlHeightLg,
              EditorComponent(),
              stateTarget: v.shadow,
              label: '表面阴影',
              description: '默认继承组件与材质配方；显式空列表关闭阴影。',
            ),
          ];
        case 'bottomSheet':
          final native = theme.bottomSheetTheme.style;
          return [
            _heading('标题'),
            if (state == 'common')
              n(
                '标题字号',
                m.titleStyleSize,
                native.titleStyle?.fontSize ??
                    theme.textTheme.titleMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.titleStyleSize = x,
                decimal: false,
              ),
            _select(
              '标题字重',
              v.titleStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.titleStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '标题颜色',
              v.titleStyleColor,
              (x) => v.titleStyleColor = x,
              inheritedColor:
                  native.titleStyle?.color ?? theme.colors.textPrimary,
            ),
            _heading('正文'),
            if (state == 'common')
              n(
                '正文字号',
                m.contentStyleSize,
                native.contentStyle?.fontSize ??
                    theme.textTheme.bodyMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.contentStyleSize = x,
                decimal: false,
              ),
            _select(
              '正文字重',
              v.contentStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.contentStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '正文颜色',
              v.contentStyleColor,
              (x) => v.contentStyleColor = x,
              inheritedColor:
                  native.contentStyle?.color ?? theme.colors.textSecondary,
            ),
            if (state == 'common') ...[
              _heading('操作区'),
              _select(
                '操作区对齐',
                v.actionsAlignment ?? 'inherit',
                const {
                  'inherit': '继承',
                  'start': '起始',
                  'center': '居中',
                  'end': '末尾',
                  'spaceBetween': '两端分布',
                  'spaceAround': '均匀环绕',
                  'spaceEvenly': '均匀分布',
                },
                (x) => _change(
                  () => v.actionsAlignment = x == 'inherit' ? null : x,
                ),
              ),
              _heading('布局'),
              n(
                '最大宽度',
                m.maxWidth,
                s.bottomSheet.maxWidth,
                0,
                editorContentWidthLimit,
                (x) => m.maxWidth = x,
                decimal: false,
              ),
              n(
                '横屏最大宽度',
                m.landscapeMaxWidth,
                s.bottomSheet.landscapeMaxWidth ?? s.bottomSheet.maxWidth,
                0,
                editorContentWidthLimit,
                (x) => m.landscapeMaxWidth = x,
                decimal: false,
              ),
              n(
                '标题与正文间距',
                m.titleSpacing,
                s.bottomSheet.titleSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.titleSpacing = x,
                decimal: false,
              ),
              n(
                '操作间距',
                m.actionSpacing,
                s.bottomSheet.actionSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.actionSpacing = x,
                decimal: false,
              ),
              n(
                '操作换行间距',
                m.actionRunSpacing,
                s.bottomSheet.actionRunSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.actionRunSpacing = x,
                decimal: false,
              ),
              n(
                '关闭图标尺寸',
                m.closeIconSize,
                s.bottomSheet.closeIconSize,
                0,
                editorContentIconLimit,
                (x) => m.closeIconSize = x,
                decimal: false,
              ),
            ],
            _heading('交互与标记'),
            _color(
              '拖动条颜色',
              v.dragHandleColor,
              (x) => v.dragHandleColor = x,
              inheritedColor: native.dragHandleColor ?? theme.colors.primary,
            ),
            _color(
              '遮罩颜色',
              v.barrierColor,
              (x) => v.barrierColor = x,
              inheritedColor: native.barrierColor ?? theme.colors.surface,
            ),
            _heading('表面与留白'),
            ...material(v),
            if (state == 'common')
              n(
                '拖动条内边距 · 左',
                m.dragHandlePaddingLeft,
                s.bottomSheet.dragHandlePadding.resolve(TextDirection.ltr).left,
                0,
                editorContentSpacingLimit,
                (x) => m.dragHandlePaddingLeft = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '拖动条内边距 · 上',
                m.dragHandlePaddingTop,
                s.bottomSheet.dragHandlePadding.resolve(TextDirection.ltr).top,
                0,
                editorContentSpacingLimit,
                (x) => m.dragHandlePaddingTop = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '拖动条内边距 · 右',
                m.dragHandlePaddingRight,
                s.bottomSheet.dragHandlePadding
                    .resolve(TextDirection.ltr)
                    .right,
                0,
                editorContentSpacingLimit,
                (x) => m.dragHandlePaddingRight = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '拖动条内边距 · 下',
                m.dragHandlePaddingBottom,
                s.bottomSheet.dragHandlePadding
                    .resolve(TextDirection.ltr)
                    .bottom,
                0,
                editorContentSpacingLimit,
                (x) => m.dragHandlePaddingBottom = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 左',
                m.paddingLeft,
                s.bottomSheet.padding.resolve(TextDirection.ltr).left,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingLeft = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 上',
                m.paddingTop,
                s.bottomSheet.padding.resolve(TextDirection.ltr).top,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingTop = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 右',
                m.paddingRight,
                s.bottomSheet.padding.resolve(TextDirection.ltr).right,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingRight = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 下',
                m.paddingBottom,
                s.bottomSheet.padding.resolve(TextDirection.ltr).bottom,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingBottom = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '表面圆角',
                m.radius,
                s.bottomSheet.radius,
                0,
                editorSurfaceRadiusLimit,
                (x) => m.radius = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '拖动条圆角',
                m.dragHandleRadius,
                s.bottomSheet.dragHandleRadius,
                0,
                editorSurfaceRadiusLimit,
                (x) => m.dragHandleRadius = x,
                decimal: false,
              ),
            _color(
              '背景',
              v.background,
              (x) => v.background = x,
              inheritedColor: native.background?.color ?? theme.colors.surface,
            ),
            n(
              '边框宽度',
              v.borderWidth,
              0,
              0,
              editorLineThicknessLimit,
              (x) => v.borderWidth = x,
              decimal: false,
            ),
            _color(
              '边框颜色',
              v.borderColor,
              (x) => v.borderColor = x,
              inheritedColor: theme.colors.outline,
            ),
            ..._focusedShadowProperties(
              maxExtent: s.controlHeightLg,
              EditorComponent(),
              stateTarget: v.shadow,
              label: '表面阴影',
              description: '默认继承组件与材质配方；显式空列表关闭阴影。',
            ),
          ];
        case 'toast':
          final native = theme.toastTheme.style;
          return [
            _heading('文字'),
            if (state == 'common')
              n(
                '文字字号',
                m.textStyleSize,
                native.textStyle?.fontSize ??
                    theme.textTheme.bodyMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.textStyleSize = x,
                decimal: false,
              ),
            _select(
              '文字字重',
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
                () =>
                    v.textStyleWeight = x == 'inherit' ? null : double.parse(x),
              ),
            ),
            _color(
              '文字颜色',
              v.textStyleColor,
              (x) => v.textStyleColor = x,
              inheritedColor:
                  native.textStyle?.color ?? theme.colors.textPrimary,
            ),
            if (state == 'common')
              n(
                '图标尺寸',
                m.iconSize,
                s.toast.iconSize,
                0,
                editorContentIconLimit,
                (x) => m.iconSize = x,
                decimal: false,
              ),
            _color(
              '图标颜色',
              v.iconColor,
              (x) => v.iconColor = x,
              inheritedColor: native.iconColor ?? theme.colors.textSecondary,
            ),
            if (state == 'common') ...[
              _heading('布局'),
              n(
                '最大宽度',
                m.maxWidth,
                s.toast.maxWidth,
                0,
                editorContentWidthLimit,
                (x) => m.maxWidth = x,
                decimal: false,
              ),
              n(
                '图标与内容间距',
                m.spacing,
                s.toast.spacing,
                0,
                editorContentSpacingLimit,
                (x) => m.spacing = x,
                decimal: false,
              ),
            ],
            _heading('表面与留白'),
            ...material(v),
            if (state == 'common')
              n(
                '内容内边距 · 左',
                m.paddingLeft,
                s.toast.padding.resolve(TextDirection.ltr).left,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingLeft = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 上',
                m.paddingTop,
                s.toast.padding.resolve(TextDirection.ltr).top,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingTop = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 右',
                m.paddingRight,
                s.toast.padding.resolve(TextDirection.ltr).right,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingRight = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 下',
                m.paddingBottom,
                s.toast.padding.resolve(TextDirection.ltr).bottom,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingBottom = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '表面圆角',
                m.radius,
                s.toast.radius,
                0,
                editorSurfaceRadiusLimit,
                (x) => m.radius = x,
                decimal: false,
              ),
            _color(
              '背景',
              v.background,
              (x) => v.background = x,
              inheritedColor: native.background?.color ?? theme.colors.surface,
            ),
            n(
              '边框宽度',
              v.borderWidth,
              0,
              0,
              editorLineThicknessLimit,
              (x) => v.borderWidth = x,
              decimal: false,
            ),
            _color(
              '边框颜色',
              v.borderColor,
              (x) => v.borderColor = x,
              inheritedColor: theme.colors.outline,
            ),
            ..._focusedShadowProperties(
              maxExtent: s.controlHeightLg,
              EditorComponent(),
              stateTarget: v.shadow,
              label: '表面阴影',
              description: '默认继承组件与材质配方；显式空列表关闭阴影。',
            ),
          ];
        case 'snackbar':
          final native = theme.snackbarTheme.style;
          return [
            _heading('文字'),
            if (state == 'common')
              n(
                '文字字号',
                m.textStyleSize,
                native.textStyle?.fontSize ??
                    theme.textTheme.bodyMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.textStyleSize = x,
                decimal: false,
              ),
            _select(
              '文字字重',
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
                () =>
                    v.textStyleWeight = x == 'inherit' ? null : double.parse(x),
              ),
            ),
            _color(
              '文字颜色',
              v.textStyleColor,
              (x) => v.textStyleColor = x,
              inheritedColor:
                  native.textStyle?.color ?? theme.colors.textPrimary,
            ),
            if (state == 'common')
              n(
                '图标尺寸',
                m.iconSize,
                s.snackbar.iconSize,
                0,
                editorContentIconLimit,
                (x) => m.iconSize = x,
                decimal: false,
              ),
            _color(
              '图标颜色',
              v.iconColor,
              (x) => v.iconColor = x,
              inheritedColor: native.iconColor ?? theme.colors.textSecondary,
            ),
            if (state == 'common') ...[
              _heading('布局'),
              n(
                '最大宽度',
                m.maxWidth,
                s.snackbar.maxWidth,
                0,
                editorContentWidthLimit,
                (x) => m.maxWidth = x,
                decimal: false,
              ),
              n(
                '图标与内容间距',
                m.spacing,
                s.snackbar.spacing,
                0,
                editorContentSpacingLimit,
                (x) => m.spacing = x,
                decimal: false,
              ),
            ],
            _heading('表面与留白'),
            ...material(v),
            if (state == 'common')
              n(
                '内容内边距 · 左',
                m.paddingLeft,
                s.snackbar.padding.resolve(TextDirection.ltr).left,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingLeft = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 上',
                m.paddingTop,
                s.snackbar.padding.resolve(TextDirection.ltr).top,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingTop = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 右',
                m.paddingRight,
                s.snackbar.padding.resolve(TextDirection.ltr).right,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingRight = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 下',
                m.paddingBottom,
                s.snackbar.padding.resolve(TextDirection.ltr).bottom,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingBottom = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '表面圆角',
                m.radius,
                s.snackbar.radius,
                0,
                editorSurfaceRadiusLimit,
                (x) => m.radius = x,
                decimal: false,
              ),
            _color(
              '背景',
              v.background,
              (x) => v.background = x,
              inheritedColor: native.background?.color ?? theme.colors.surface,
            ),
            n(
              '边框宽度',
              v.borderWidth,
              0,
              0,
              editorLineThicknessLimit,
              (x) => v.borderWidth = x,
              decimal: false,
            ),
            _color(
              '边框颜色',
              v.borderColor,
              (x) => v.borderColor = x,
              inheritedColor: theme.colors.outline,
            ),
            ..._focusedShadowProperties(
              maxExtent: s.controlHeightLg,
              EditorComponent(),
              stateTarget: v.shadow,
              label: '表面阴影',
              description: '默认继承组件与材质配方；显式空列表关闭阴影。',
            ),
          ];
        case 'dialog':
          final native = theme.dialogTheme.style;
          return [
            _heading('标题'),
            if (state == 'common')
              n(
                '标题字号',
                m.titleStyleSize,
                native.titleStyle?.fontSize ??
                    theme.textTheme.titleMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.titleStyleSize = x,
                decimal: false,
              ),
            _select(
              '标题字重',
              v.titleStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.titleStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '标题颜色',
              v.titleStyleColor,
              (x) => v.titleStyleColor = x,
              inheritedColor:
                  native.titleStyle?.color ?? theme.colors.textPrimary,
            ),
            _heading('正文'),
            if (state == 'common')
              n(
                '正文字号',
                m.contentStyleSize,
                native.contentStyle?.fontSize ??
                    theme.textTheme.bodyMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.contentStyleSize = x,
                decimal: false,
              ),
            _select(
              '正文字重',
              v.contentStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.contentStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '正文颜色',
              v.contentStyleColor,
              (x) => v.contentStyleColor = x,
              inheritedColor:
                  native.contentStyle?.color ?? theme.colors.textSecondary,
            ),
            if (state == 'common') ...[
              _heading('操作区'),
              _select(
                '操作区对齐',
                v.actionsAlignment ?? 'inherit',
                const {
                  'inherit': '继承',
                  'start': '起始',
                  'center': '居中',
                  'end': '末尾',
                  'spaceBetween': '两端分布',
                  'spaceAround': '均匀环绕',
                  'spaceEvenly': '均匀分布',
                },
                (x) => _change(
                  () => v.actionsAlignment = x == 'inherit' ? null : x,
                ),
              ),
              _heading('布局'),
              n(
                '最大宽度',
                m.maxWidth,
                s.dialog.maxWidth,
                0,
                editorContentWidthLimit,
                (x) => m.maxWidth = x,
                decimal: false,
              ),
              n(
                '标题与正文间距',
                m.titleSpacing,
                s.dialog.titleSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.titleSpacing = x,
                decimal: false,
              ),
              n(
                '操作间距',
                m.actionSpacing,
                s.dialog.actionSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.actionSpacing = x,
                decimal: false,
              ),
              n(
                '操作换行间距',
                m.actionRunSpacing,
                s.dialog.actionRunSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.actionRunSpacing = x,
                decimal: false,
              ),
              n(
                '关闭图标尺寸',
                m.closeIconSize,
                s.dialog.closeIconSize,
                0,
                editorContentIconLimit,
                (x) => m.closeIconSize = x,
                decimal: false,
              ),
            ],
            _heading('交互与标记'),
            _color(
              '遮罩颜色',
              v.barrierColor,
              (x) => v.barrierColor = x,
              inheritedColor: native.barrierColor ?? theme.colors.surface,
            ),
            _heading('动画与显示时机'),
            n(
              '动画时长（毫秒）',
              v.duration,
              native.duration?.inMilliseconds.toDouble() ??
                  theme.motion.standardDuration.inMilliseconds.toDouble(),
              0,
              editorReviewDurationLimit,
              (x) => v.duration = x,
              decimal: false,
            ),
            _select('动画曲线', v.curve ?? 'inherit', const {
              'inherit': '继承',
              'linear': '线性',
              'easeInOut': '缓入缓出',
              'fastOutSlowIn': '快出慢入',
            }, (x) => _change(() => v.curve = x == 'inherit' ? null : x)),
            _heading('表面与留白'),
            ...material(v),
            if (state == 'common')
              n(
                '内容内边距 · 左',
                m.paddingLeft,
                s.dialog.padding.resolve(TextDirection.ltr).left,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingLeft = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 上',
                m.paddingTop,
                s.dialog.padding.resolve(TextDirection.ltr).top,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingTop = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 右',
                m.paddingRight,
                s.dialog.padding.resolve(TextDirection.ltr).right,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingRight = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 下',
                m.paddingBottom,
                s.dialog.padding.resolve(TextDirection.ltr).bottom,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingBottom = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '屏幕避让边距 · 左',
                m.insetPaddingLeft,
                s.dialog.insetPadding.resolve(TextDirection.ltr).left,
                0,
                editorContentSpacingLimit,
                (x) => m.insetPaddingLeft = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '屏幕避让边距 · 上',
                m.insetPaddingTop,
                s.dialog.insetPadding.resolve(TextDirection.ltr).top,
                0,
                editorContentSpacingLimit,
                (x) => m.insetPaddingTop = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '屏幕避让边距 · 右',
                m.insetPaddingRight,
                s.dialog.insetPadding.resolve(TextDirection.ltr).right,
                0,
                editorContentSpacingLimit,
                (x) => m.insetPaddingRight = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '屏幕避让边距 · 下',
                m.insetPaddingBottom,
                s.dialog.insetPadding.resolve(TextDirection.ltr).bottom,
                0,
                editorContentSpacingLimit,
                (x) => m.insetPaddingBottom = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '表面圆角',
                m.radius,
                s.dialog.radius,
                0,
                editorSurfaceRadiusLimit,
                (x) => m.radius = x,
                decimal: false,
              ),
            _color(
              '背景',
              v.background,
              (x) => v.background = x,
              inheritedColor: native.background?.color ?? theme.colors.surface,
            ),
            n(
              '边框宽度',
              v.borderWidth,
              0,
              0,
              editorLineThicknessLimit,
              (x) => v.borderWidth = x,
              decimal: false,
            ),
            _color(
              '边框颜色',
              v.borderColor,
              (x) => v.borderColor = x,
              inheritedColor: theme.colors.outline,
            ),
            ..._focusedShadowProperties(
              maxExtent: s.controlHeightLg,
              EditorComponent(),
              stateTarget: v.shadow,
              label: '表面阴影',
              description: '默认继承组件与材质配方；显式空列表关闭阴影。',
            ),
          ];
        case 'emptyState':
          final native = theme.resultTheme.resolve(HyperResultStatus.empty);
          return [
            _heading('标题'),
            if (state == 'common')
              n(
                '标题字号',
                m.titleStyleSize,
                native.titleStyle?.fontSize ??
                    theme.textTheme.titleSmall?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.titleStyleSize = x,
                decimal: false,
              ),
            _select(
              '标题字重',
              v.titleStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.titleStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '标题颜色',
              v.titleStyleColor,
              (x) => v.titleStyleColor = x,
              inheritedColor:
                  native.titleStyle?.color ?? theme.colors.textPrimary,
            ),
            _heading('描述'),
            if (state == 'common')
              n(
                '描述字号',
                m.descriptionStyleSize,
                native.descriptionStyle?.fontSize ??
                    theme.textTheme.bodyMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.descriptionStyleSize = x,
                decimal: false,
              ),
            _select(
              '描述字重',
              v.descriptionStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.descriptionStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '描述颜色',
              v.descriptionStyleColor,
              (x) => v.descriptionStyleColor = x,
              inheritedColor:
                  native.descriptionStyle?.color ?? theme.colors.textSecondary,
            ),
            if (state == 'common')
              n(
                '图标尺寸',
                m.iconSize,
                s.result.empty.iconSize,
                0,
                editorContentIconLimit,
                (x) => m.iconSize = x,
                decimal: false,
              ),
            _color(
              '图标颜色',
              v.iconColor,
              (x) => v.iconColor = x,
              inheritedColor: native.iconColor ?? theme.colors.textSecondary,
            ),
            if (state == 'common') ...[
              _select('文字对齐', v.textAlign ?? 'inherit', const {
                'inherit': '继承',
                'start': '起始',
                'center': '居中',
                'end': '末尾',
                'left': '左对齐',
                'right': '右对齐',
                'justify': '两端对齐',
              }, (x) => _change(() => v.textAlign = x == 'inherit' ? null : x)),
              _heading('操作区'),
              _select(
                '操作区对齐',
                v.actionsAlignment ?? 'inherit',
                const {
                  'inherit': '继承',
                  'start': '起始',
                  'center': '居中',
                  'end': '末尾',
                  'spaceBetween': '两端分布',
                  'spaceAround': '均匀环绕',
                  'spaceEvenly': '均匀分布',
                },
                (x) => _change(
                  () => v.actionsAlignment = x == 'inherit' ? null : x,
                ),
              ),
              _heading('布局'),
              n(
                '插图尺寸',
                m.illustrationSize,
                s.result.empty.illustrationSize,
                0,
                editorContentIllustrationLimit,
                (x) => m.illustrationSize = x,
                decimal: false,
              ),
              n(
                '最大宽度',
                m.maxWidth,
                s.result.empty.maxWidth,
                0,
                editorContentWidthLimit,
                (x) => m.maxWidth = x,
                decimal: false,
              ),
              n(
                '内容块间距',
                m.contentSpacing,
                s.result.empty.contentSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.contentSpacing = x,
                decimal: false,
              ),
              n(
                '标题与正文间距',
                m.titleSpacing,
                s.result.empty.titleSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.titleSpacing = x,
                decimal: false,
              ),
              n(
                '操作间距',
                m.actionSpacing,
                s.result.empty.actionSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.actionSpacing = x,
                decimal: false,
              ),
              n(
                '操作换行间距',
                m.actionRunSpacing,
                s.result.empty.actionRunSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.actionRunSpacing = x,
                decimal: false,
              ),
            ],
            _heading('动画与显示时机'),
            n(
              '动画时长（毫秒）',
              v.duration,
              native.duration?.inMilliseconds.toDouble() ??
                  theme.motion.standardDuration.inMilliseconds.toDouble(),
              0,
              editorReviewDurationLimit,
              (x) => v.duration = x,
              decimal: false,
            ),
            _select('动画曲线', v.curve ?? 'inherit', const {
              'inherit': '继承',
              'linear': '线性',
              'easeInOut': '缓入缓出',
              'fastOutSlowIn': '快出慢入',
            }, (x) => _change(() => v.curve = x == 'inherit' ? null : x)),
            _heading('表面与留白'),
            if (state == 'common')
              n(
                '内容内边距 · 左',
                m.paddingLeft,
                s.result.empty.padding.resolve(TextDirection.ltr).left,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingLeft = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 上',
                m.paddingTop,
                s.result.empty.padding.resolve(TextDirection.ltr).top,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingTop = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 右',
                m.paddingRight,
                s.result.empty.padding.resolve(TextDirection.ltr).right,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingRight = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 下',
                m.paddingBottom,
                s.result.empty.padding.resolve(TextDirection.ltr).bottom,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingBottom = x,
                decimal: false,
              ),
            _color(
              '背景',
              v.background,
              (x) => v.background = x,
              inheritedColor: native.background?.color ?? Colors.transparent,
            ),
            n(
              '边框宽度',
              v.borderWidth,
              0,
              0,
              editorLineThicknessLimit,
              (x) => v.borderWidth = x,
              decimal: false,
            ),
            _color(
              '边框颜色',
              v.borderColor,
              (x) => v.borderColor = x,
              inheritedColor: theme.colors.outline,
            ),
            if (state == 'common')
              n(
                '表面圆角',
                m.surfaceRadius,
                0,
                0,
                editorSurfaceRadiusLimit,
                (x) => m.surfaceRadius = x,
                decimal: false,
              ),
            ..._focusedShadowProperties(
              maxExtent: s.controlHeightLg,
              EditorComponent(),
              stateTarget: v.shadow,
              label: '表面阴影',
              description: '默认继承组件与材质配方；显式空列表关闭阴影。',
            ),
            ...material(v),
          ];
        case 'skeleton':
          final native = HyperSkeletonStyle(
            backgroundColor: theme.colors.surfaceMuted,
            highlightColor: theme.colors.surfaceElevated,
            duration: theme.motion.emphasizedDuration * 4,
            transitionDuration: theme.motion.fastDuration,
            shimmerWidth: .28,
            shimmerAngle: .18,
            pulseMinOpacity: .6,
          ).merge(theme.skeletonTheme.style);
          return [
            if (state == 'common') ...[
              _heading('布局'),
              n(
                '文字占位条高度',
                m.lineHeight,
                s.skeleton.lineHeight,
                0,
                editorLayoutInsetLimit,
                (x) => m.lineHeight = x,
                decimal: false,
              ),
              n(
                '文字占位条宽度',
                m.lineWidth,
                s.skeleton.lineWidth,
                0,
                editorContentWidthLimit,
                (x) => m.lineWidth = x,
                decimal: false,
              ),
              n(
                '圆形尺寸',
                m.circleSize,
                s.skeleton.circleSize,
                0,
                editorContentIllustrationLimit,
                (x) => m.circleSize = x,
                decimal: false,
              ),
              n(
                '矩形宽度',
                m.blockWidth,
                s.skeleton.blockWidth,
                0,
                editorContentWidthLimit,
                (x) => m.blockWidth = x,
                decimal: false,
              ),
              n(
                '矩形高度',
                m.blockHeight,
                s.skeleton.blockHeight,
                0,
                editorLayoutInsetLimit,
                (x) => m.blockHeight = x,
                decimal: false,
              ),
            ],
            _heading('交互与标记'),
            _color(
              '微光颜色',
              v.highlightColor,
              (x) => v.highlightColor = x,
              inheritedColor:
                  native.highlightColor ?? theme.colors.surfaceElevated,
            ),
            n(
              '微光宽度比例',
              v.shimmerWidth,
              native.shimmerWidth ?? .1,
              0,
              1,
              (x) => v.shimmerWidth = x,
              decimal: true,
            ),
            n(
              '微光倾斜比例',
              v.shimmerAngle,
              native.shimmerAngle ?? .18,
              -1,
              1,
              (x) => v.shimmerAngle = x,
              decimal: true,
            ),
            n(
              '呼吸最低透明度',
              v.pulseMinOpacity,
              native.pulseMinOpacity ?? .1,
              0,
              1,
              (x) => v.pulseMinOpacity = x,
              decimal: true,
            ),
            _heading('动画与显示时机'),
            n(
              '动画时长（毫秒）',
              v.duration,
              native.duration?.inMilliseconds.toDouble() ??
                  theme.motion.standardDuration.inMilliseconds.toDouble(),
              0,
              editorReviewDurationLimit,
              (x) => v.duration = x,
              decimal: false,
            ),
            n(
              '内容切换时长（毫秒）',
              v.transitionDuration,
              native.transitionDuration?.inMilliseconds.toDouble() ??
                  theme.motion.standardDuration.inMilliseconds.toDouble(),
              0,
              editorReviewDurationLimit,
              (x) => v.transitionDuration = x,
              decimal: false,
            ),
            _select('动画曲线', v.curve ?? 'inherit', const {
              'inherit': '继承',
              'linear': '线性',
              'easeInOut': '缓入缓出',
              'fastOutSlowIn': '快出慢入',
            }, (x) => _change(() => v.curve = x == 'inherit' ? null : x)),
            _select('骨架动画', v.effect ?? 'inherit', const {
              'inherit': '继承',
              'shimmer': '微光',
              'pulse': '呼吸',
              'none': '静态',
            }, (x) => _change(() => v.effect = x == 'inherit' ? null : x)),
            _heading('表面与留白'),
            n(
              '边框宽度',
              v.borderWidth,
              native.borderWidth ?? (native.borderColor != null ? 1 : 0),
              0,
              editorSelectionStrokeLimit(
                s.skeleton.blockHeight < s.skeleton.blockWidth
                    ? s.skeleton.blockHeight
                    : s.skeleton.blockWidth,
              ),
              (x) => v.borderWidth = x,
            ),
            if (state == 'common')
              n(
                '表面圆角',
                m.radius,
                s.skeleton.radius,
                0,
                (s.skeleton.blockHeight / 2),
                (x) => m.radius = x,
                decimal: false,
              ),
            _color(
              '背景',
              v.backgroundColor,
              (x) => v.backgroundColor = x,
              inheritedColor: native.backgroundColor ?? theme.colors.surface,
            ),
            _color(
              '边框颜色',
              v.borderColor,
              (x) => v.borderColor = x,
              inheritedColor: native.borderColor ?? theme.colors.outline,
            ),
            ..._focusedShadowProperties(
              maxExtent: s.controlHeightLg,
              EditorComponent(),
              stateTarget: v.shadow,
              label: '表面阴影',
              description: '默认继承组件与材质配方；显式空列表关闭阴影。',
            ),
          ];
        case 'sidebar':
          final native = theme.sidebarTheme.style ?? const HyperSidebarStyle();
          return [
            _heading('分组标题'),
            if (state == 'common')
              n(
                '分组标题字号',
                m.groupTitleStyleSize,
                native.groupTitleStyle?.fontSize ??
                    theme.textTheme.titleSmall?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.groupTitleStyleSize = x,
                decimal: false,
              ),
            if (state == 'common')
              _select(
                '分组标题字重',
                v.groupTitleStyleWeight?.round().toString() ?? 'inherit',
                const {
                  'inherit': '继承',
                  '300': '300',
                  '400': '400 常规',
                  '500': '500 中等',
                  '600': '600 半粗',
                  '700': '700 粗体',
                },
                (x) => _change(
                  () => v.groupTitleStyleWeight = x == 'inherit'
                      ? null
                      : double.parse(x),
                ),
              ),
            if (state == 'common')
              _color(
                '分组标题颜色',
                v.groupTitleStyleColor,
                (x) => v.groupTitleStyleColor = x,
                inheritedColor:
                    native.groupTitleStyle?.color ?? theme.colors.textPrimary,
              ),
            _heading('条目文字'),
            if (state == 'common')
              n(
                '条目文字字号',
                m.itemTextStyleSize,
                native.itemTextStyle?.fontSize ??
                    theme.textTheme.bodyMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.itemTextStyleSize = x,
                decimal: false,
              ),
            if (state == 'common')
              _select(
                '条目文字字重',
                v.itemTextStyleWeight?.round().toString() ?? 'inherit',
                const {
                  'inherit': '继承',
                  '300': '300',
                  '400': '400 常规',
                  '500': '500 中等',
                  '600': '600 半粗',
                  '700': '700 粗体',
                },
                (x) => _change(
                  () => v.itemTextStyleWeight = x == 'inherit'
                      ? null
                      : double.parse(x),
                ),
              ),

            _heading('条目描述'),
            if (state == 'common')
              n(
                '条目描述字号',
                m.descriptionTextStyleSize,
                native.descriptionTextStyle?.fontSize ??
                    theme.textTheme.bodyMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.descriptionTextStyleSize = x,
                decimal: false,
              ),
            if (state == 'common')
              _select(
                '条目描述字重',
                v.descriptionTextStyleWeight?.round().toString() ?? 'inherit',
                const {
                  'inherit': '继承',
                  '300': '300',
                  '400': '400 常规',
                  '500': '500 中等',
                  '600': '600 半粗',
                  '700': '700 粗体',
                },
                (x) => _change(
                  () => v.descriptionTextStyleWeight = x == 'inherit'
                      ? null
                      : double.parse(x),
                ),
              ),
            if (state == 'common')
              _color(
                '条目描述颜色',
                v.descriptionTextStyleColor,
                (x) => v.descriptionTextStyleColor = x,
                inheritedColor:
                    native.descriptionTextStyle?.color ??
                    theme.colors.textSecondary,
              ),

            if (state == 'common') ...[
              _heading('布局'),
              n(
                '展开宽度',
                m.width,
                s.sidebar.width,
                0,
                editorContentWidthLimit,
                (x) => m.width = x,
                decimal: false,
              ),
              n(
                '收起宽度',
                m.collapsedWidth,
                s.sidebar.collapsedWidth,
                0,
                editorContentWidthLimit,
                (x) => m.collapsedWidth = x,
                decimal: false,
              ),
              n(
                '条目最小高度',
                m.itemHeight,
                s.sidebar.itemHeight,
                0,
                editorLayoutInsetLimit,
                (x) => m.itemHeight = x,
                decimal: false,
              ),
              n(
                '条目间距',
                m.itemSpacing,
                s.sidebar.itemSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.itemSpacing = x,
                decimal: false,
              ),
              n(
                '行间距',
                m.rowGap,
                s.sidebar.rowGap ?? 0,
                0,
                editorContentSpacingLimit,
                (x) => m.rowGap = x,
                decimal: false,
              ),
              n(
                '层级缩进',
                m.indent,
                s.sidebar.indent,
                0,
                editorContentSpacingLimit,
                (x) => m.indent = x,
                decimal: false,
              ),
              n(
                '分组间距',
                m.sectionSpacing,
                s.sidebar.sectionSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.sectionSpacing = x,
                decimal: false,
              ),
              n(
                '水平内边距',
                m.horizontalPadding,
                s.sidebar.horizontalPadding,
                0,
                editorContentSpacingLimit,
                (x) => m.horizontalPadding = x,
                decimal: false,
              ),
              n(
                '子菜单宽度',
                m.popupWidth,
                s.sidebar.popupWidth,
                0,
                editorContentWidthLimit,
                (x) => m.popupWidth = x,
                decimal: false,
              ),
            ],
            _heading('交互与标记'),
            if (state == 'common')
              _color(
                '文字 / 图标颜色',
                v.foregroundColor,
                (x) => v.foregroundColor = x,
                inheritedColor:
                    native.foregroundColor ?? theme.colors.textPrimary,
              ),
            if (state == 'selected')
              _color(
                '选中文字颜色',
                v.selectedForegroundColor,
                (x) => v.selectedForegroundColor = x,
                inheritedColor:
                    native.selectedForegroundColor ?? theme.colors.primary,
              ),
            if (state == 'selected')
              _color(
                '选中背景',
                v.selectedBackgroundColor,
                (x) => v.selectedBackgroundColor = x,
                inheritedColor:
                    native.selectedBackgroundColor ??
                    theme.colors.primary.withValues(alpha: .08),
              ),
            if (state == 'ancestor')
              _color(
                '祖先选中文字颜色',
                v.ancestorSelectedForegroundColor,
                (x) => v.ancestorSelectedForegroundColor = x,
                inheritedColor:
                    native.ancestorSelectedForegroundColor ??
                    theme.colors.primary,
              ),
            if (state == 'ancestor')
              _color(
                '祖先选中背景',
                v.ancestorSelectedBackgroundColor,
                (x) => v.ancestorSelectedBackgroundColor = x,
                inheritedColor:
                    native.ancestorSelectedBackgroundColor ??
                    theme.colors.surface,
              ),
            if (state == 'disabled')
              _color(
                '禁用颜色',
                v.disabledColor,
                (x) => v.disabledColor = x,
                inheritedColor: native.disabledColor ?? theme.colors.disabled,
              ),
            _heading('表面与留白'),
            if (state == 'common')
              n(
                '条目圆角',
                m.itemRadius,
                s.sidebar.itemRadius,
                0,
                (s.sidebar.itemHeight / 2),
                (x) => m.itemRadius = x,
                decimal: false,
              ),
            if (state == 'common')
              _color(
                '背景',
                v.backgroundColor,
                (x) => v.backgroundColor = x,
                inheritedColor: native.backgroundColor ?? theme.colors.surface,
              ),
            if (state == 'common')
              _color(
                '边框颜色',
                v.borderColor,
                (x) => v.borderColor = x,
                inheritedColor: native.borderColor ?? theme.colors.primary,
              ),
            ...material(v),
            n(
              '边框宽度',
              v.borderWidth,
              0,
              0,
              editorLineThicknessLimit,
              (x) => v.borderWidth = x,
            ),
            ..._focusedShadowProperties(
              maxExtent: s.controlHeightLg,
              EditorComponent(),
              stateTarget: v.shadow,
              label: '表面阴影',
              description: '显式空列表关闭阴影。',
            ),
          ];
        case 'tabBar':
          return [
            if (_reviewVariant == 'common') ...[
              if (state == 'common') ...[
                _heading('布局'),
                n(
                  '最小高度',
                  m.height,
                  s.tabBar.height,
                  0,
                  editorLayoutInsetLimit,
                  (x) => m.height = x,
                  decimal: false,
                ),
                n(
                  '条目间距',
                  m.itemSpacing,
                  s.tabBar.itemSpacing,
                  0,
                  editorContentSpacingLimit,
                  (x) => m.itemSpacing = x,
                  decimal: false,
                ),
                n(
                  '下划线粗细',
                  m.underlineThickness,
                  s.tabBar.underlineThickness,
                  0,
                  s.tabBar.height / 2,
                  (x) => m.underlineThickness = x,
                  decimal: false,
                ),
              ],
              _heading('表面与留白'),
              if (state == 'common')
                n(
                  '内容内边距 · 左',
                  m.paddingLeft,
                  s.tabBar.padding.resolve(TextDirection.ltr).left,
                  0,
                  editorContentSpacingLimit,
                  (x) => m.paddingLeft = x,
                  decimal: false,
                ),
              if (state == 'common')
                n(
                  '内容内边距 · 上',
                  m.paddingTop,
                  s.tabBar.padding.resolve(TextDirection.ltr).top,
                  0,
                  editorContentSpacingLimit,
                  (x) => m.paddingTop = x,
                  decimal: false,
                ),
              if (state == 'common')
                n(
                  '内容内边距 · 右',
                  m.paddingRight,
                  s.tabBar.padding.resolve(TextDirection.ltr).right,
                  0,
                  editorContentSpacingLimit,
                  (x) => m.paddingRight = x,
                  decimal: false,
                ),
              if (state == 'common')
                n(
                  '内容内边距 · 下',
                  m.paddingBottom,
                  s.tabBar.padding.resolve(TextDirection.ltr).bottom,
                  0,
                  editorContentSpacingLimit,
                  (x) => m.paddingBottom = x,
                  decimal: false,
                ),
              if (state == 'common')
                n(
                  '底槽圆角',
                  m.segmentedRadius,
                  s.tabBar.segmentedRadius,
                  0,
                  (s.tabBar.height / 2),
                  (x) => m.segmentedRadius = x,
                  decimal: false,
                ),
              if (state == 'common')
                n(
                  '独立标签圆角',
                  m.separatedRadius,
                  s.tabBar.separatedRadius,
                  0,
                  (s.tabBar.height / 2),
                  (x) => m.separatedRadius = x,
                  decimal: false,
                ),
            ],
            ...navigationSurface(),
          ];
        case 'stepIndicator':
          final native = theme.stepIndicatorTheme.style;
          return [
            _heading('标题'),
            if (state == 'common')
              n(
                '标题字号',
                m.titleStyleSize,
                native.titleStyle?.fontSize ??
                    theme.textTheme.titleSmall?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.titleStyleSize = x,
                decimal: false,
              ),
            _select(
              '标题字重',
              v.titleStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.titleStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '标题颜色',
              v.titleStyleColor,
              (x) => v.titleStyleColor = x,
              inheritedColor:
                  native.titleStyle?.color ?? theme.colors.textPrimary,
            ),
            _heading('描述'),
            if (state == 'common')
              n(
                '描述字号',
                m.descriptionStyleSize,
                native.descriptionStyle?.fontSize ??
                    theme.textTheme.bodyMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.descriptionStyleSize = x,
                decimal: false,
              ),
            _select(
              '描述字重',
              v.descriptionStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.descriptionStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '描述颜色',
              v.descriptionStyleColor,
              (x) => v.descriptionStyleColor = x,
              inheritedColor:
                  native.descriptionStyle?.color ?? theme.colors.textSecondary,
            ),
            _heading('序号'),
            if (state == 'common')
              n(
                '序号字号',
                m.indexStyleSize,
                native.indexStyle?.fontSize ??
                    theme.textTheme.bodyMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.indexStyleSize = x,
                decimal: false,
              ),
            _select(
              '序号字重',
              v.indexStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.indexStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '序号颜色',
              v.indexStyleColor,
              (x) => v.indexStyleColor = x,
              inheritedColor:
                  native.indexStyle?.color ?? theme.colors.textPrimary,
            ),
            if (state == 'common')
              n(
                '图标尺寸',
                m.iconSize,
                s.stepIndicator.iconSize,
                0,
                s.stepIndicator.nodeSize,
                (x) => m.iconSize = x,
                decimal: false,
              ),
            if (state == 'common') ...[
              _heading('布局'),
              n(
                '节点尺寸',
                m.nodeSize,
                s.stepIndicator.nodeSize,
                0,
                editorContentIconLimit,
                (x) => m.nodeSize = x,
                decimal: false,
              ),
              n(
                '连接线粗细',
                m.connectorThickness,
                s.stepIndicator.connectorThickness,
                0,
                s.stepIndicator.nodeSize / 2,
                (x) => m.connectorThickness = x,
                decimal: false,
              ),
              n(
                '图标与内容间距',
                m.spacing,
                s.stepIndicator.spacing,
                0,
                editorContentSpacingLimit,
                (x) => m.spacing = x,
                decimal: false,
              ),
              n(
                '标题与正文间距',
                m.titleSpacing,
                s.stepIndicator.titleSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.titleSpacing = x,
                decimal: false,
              ),
              n(
                '条目间距',
                m.itemSpacing,
                s.stepIndicator.itemSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.itemSpacing = x,
                decimal: false,
              ),
            ],
            _heading('交互与标记'),
            _color(
              '文字 / 图标颜色',
              v.foregroundColor,
              (x) => v.foregroundColor = x,
              inheritedColor:
                  native.foregroundColor ?? theme.colors.textPrimary,
            ),
            _color(
              '连接线颜色',
              v.connectorColor,
              (x) => v.connectorColor = x,
              inheritedColor: native.connectorColor ?? theme.colors.outline,
            ),
            _color(
              '状态层颜色',
              v.overlayColor,
              (x) => v.overlayColor = x,
              inheritedColor: native.overlayColor ?? theme.colors.primary,
            ),
            if (state == 'common' || state == 'hovered')
              n(
                '悬停状态层透明度',
                v.hoverOpacity,
                native.hoverOpacity ?? .1,
                0,
                1,
                (x) => v.hoverOpacity = x,
                decimal: true,
              ),
            if (state == 'common' || state == 'focused')
              n(
                '聚焦状态层透明度',
                v.focusOpacity,
                native.focusOpacity ?? .1,
                0,
                1,
                (x) => v.focusOpacity = x,
                decimal: true,
              ),
            if (state == 'common' || state == 'pressed')
              n(
                '按下状态层透明度',
                v.pressedOpacity,
                native.pressedOpacity ?? .1,
                0,
                1,
                (x) => v.pressedOpacity = x,
                decimal: true,
              ),
            _heading('动画与显示时机'),
            n(
              '动画时长（毫秒）',
              v.duration,
              native.duration?.inMilliseconds.toDouble() ??
                  theme.motion.standardDuration.inMilliseconds.toDouble(),
              0,
              editorReviewDurationLimit,
              (x) => v.duration = x,
              decimal: false,
            ),
            _select('动画曲线', v.curve ?? 'inherit', const {
              'inherit': '继承',
              'linear': '线性',
              'easeInOut': '缓入缓出',
              'fastOutSlowIn': '快出慢入',
            }, (x) => _change(() => v.curve = x == 'inherit' ? null : x)),
            _heading('表面与留白'),
            ...material(v),
            if (state == 'common')
              n(
                '交互区域圆角',
                m.interactionRadius,
                s.stepIndicator.interactionRadius,
                0,
                (s.stepIndicator.nodeSize / 2),
                (x) => m.interactionRadius = x,
                decimal: false,
              ),
            _color(
              '节点填充',
              v.nodeFill,
              (x) => v.nodeFill = x,
              inheritedColor: native.nodeFill?.color ?? theme.colors.primary,
            ),
            _heading('节点轮廓与阴影'),
            n(
              '节点圆角',
              m.surfaceRadius,
              (s.stepIndicator.nodeSize / 2),
              0,
              s.stepIndicator.nodeSize / 2,
              (x) => m.surfaceRadius = x,
            ),
            n(
              '节点边框宽度',
              v.borderWidth,
              0,
              0,
              s.stepIndicator.nodeSize / 2,
              (x) => v.borderWidth = x,
            ),
            _color(
              '节点边框颜色',
              v.borderColor,
              (x) => v.borderColor = x,
              inheritedColor: theme.colors.outline,
            ),
            ..._focusedShadowProperties(
              maxExtent: s.controlHeightLg,
              EditorComponent(),
              stateTarget: v.shadow,
              label: '节点阴影',
              description: '显式空列表关闭节点阴影。',
            ),
          ];
        case 'stepperNavigation':
          final native = theme.stepIndicatorTheme.style.merge(
            theme.stepIndicatorTheme.navigationStyle,
          );
          return [
            _heading('标题'),
            if (state == 'common')
              n(
                '标题字号',
                m.titleStyleSize,
                native.titleStyle?.fontSize ??
                    theme.textTheme.titleSmall?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.titleStyleSize = x,
                decimal: false,
              ),
            _select(
              '标题字重',
              v.titleStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.titleStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '标题颜色',
              v.titleStyleColor,
              (x) => v.titleStyleColor = x,
              inheritedColor:
                  native.titleStyle?.color ?? theme.colors.textPrimary,
            ),
            _heading('描述'),
            if (state == 'common')
              n(
                '描述字号',
                m.descriptionStyleSize,
                native.descriptionStyle?.fontSize ??
                    theme.textTheme.bodyMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.descriptionStyleSize = x,
                decimal: false,
              ),
            _select(
              '描述字重',
              v.descriptionStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.descriptionStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '描述颜色',
              v.descriptionStyleColor,
              (x) => v.descriptionStyleColor = x,
              inheritedColor:
                  native.descriptionStyle?.color ?? theme.colors.textSecondary,
            ),
            _heading('序号'),
            if (state == 'common')
              n(
                '序号字号',
                m.indexStyleSize,
                native.indexStyle?.fontSize ??
                    theme.textTheme.bodyMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.indexStyleSize = x,
                decimal: false,
              ),
            _select(
              '序号字重',
              v.indexStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.indexStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '序号颜色',
              v.indexStyleColor,
              (x) => v.indexStyleColor = x,
              inheritedColor:
                  native.indexStyle?.color ?? theme.colors.textPrimary,
            ),
            if (state == 'common')
              n(
                '图标尺寸',
                m.iconSize,
                s.stepIndicator.navigation.iconSize,
                0,
                s.stepIndicator.navigation.nodeSize,
                (x) => m.iconSize = x,
                decimal: false,
              ),
            if (state == 'common') ...[
              _heading('布局'),
              n(
                '节点尺寸',
                m.nodeSize,
                s.stepIndicator.navigation.nodeSize,
                0,
                editorContentIconLimit,
                (x) => m.nodeSize = x,
                decimal: false,
              ),
              n(
                '连接线粗细',
                m.connectorThickness,
                s.stepIndicator.navigation.connectorThickness,
                0,
                s.stepIndicator.navigation.nodeSize / 2,
                (x) => m.connectorThickness = x,
                decimal: false,
              ),
              n(
                '图标与内容间距',
                m.spacing,
                s.stepIndicator.navigation.spacing,
                0,
                editorContentSpacingLimit,
                (x) => m.spacing = x,
                decimal: false,
              ),
              n(
                '标题与正文间距',
                m.titleSpacing,
                s.stepIndicator.navigation.titleSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.titleSpacing = x,
                decimal: false,
              ),
              n(
                '条目间距',
                m.itemSpacing,
                s.stepIndicator.navigation.itemSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.itemSpacing = x,
                decimal: false,
              ),
            ],
            _heading('交互与标记'),
            _color(
              '文字 / 图标颜色',
              v.foregroundColor,
              (x) => v.foregroundColor = x,
              inheritedColor:
                  native.foregroundColor ?? theme.colors.textPrimary,
            ),
            _color(
              '连接线颜色',
              v.connectorColor,
              (x) => v.connectorColor = x,
              inheritedColor: native.connectorColor ?? theme.colors.outline,
            ),
            _color(
              '状态层颜色',
              v.overlayColor,
              (x) => v.overlayColor = x,
              inheritedColor: native.overlayColor ?? theme.colors.primary,
            ),
            if (state == 'common' || state == 'hovered')
              n(
                '悬停状态层透明度',
                v.hoverOpacity,
                native.hoverOpacity ?? .1,
                0,
                1,
                (x) => v.hoverOpacity = x,
                decimal: true,
              ),
            if (state == 'common' || state == 'focused')
              n(
                '聚焦状态层透明度',
                v.focusOpacity,
                native.focusOpacity ?? .1,
                0,
                1,
                (x) => v.focusOpacity = x,
                decimal: true,
              ),
            if (state == 'common' || state == 'pressed')
              n(
                '按下状态层透明度',
                v.pressedOpacity,
                native.pressedOpacity ?? .1,
                0,
                1,
                (x) => v.pressedOpacity = x,
                decimal: true,
              ),
            _heading('动画与显示时机'),
            n(
              '动画时长（毫秒）',
              v.duration,
              native.duration?.inMilliseconds.toDouble() ??
                  theme.motion.standardDuration.inMilliseconds.toDouble(),
              0,
              editorReviewDurationLimit,
              (x) => v.duration = x,
              decimal: false,
            ),
            _select('动画曲线', v.curve ?? 'inherit', const {
              'inherit': '继承',
              'linear': '线性',
              'easeInOut': '缓入缓出',
              'fastOutSlowIn': '快出慢入',
            }, (x) => _change(() => v.curve = x == 'inherit' ? null : x)),
            _heading('表面与留白'),
            ...material(v),
            if (state == 'common')
              n(
                '交互区域圆角',
                m.interactionRadius,
                s.stepIndicator.navigation.interactionRadius,
                0,
                (s.stepIndicator.navigation.nodeSize / 2),
                (x) => m.interactionRadius = x,
                decimal: false,
              ),
            _color(
              '节点填充',
              v.nodeFill,
              (x) => v.nodeFill = x,
              inheritedColor: native.nodeFill?.color ?? theme.colors.primary,
            ),
            _heading('节点轮廓与阴影'),
            n(
              '节点圆角',
              m.surfaceRadius,
              (s.stepIndicator.navigation.nodeSize / 2),
              0,
              s.stepIndicator.navigation.nodeSize / 2,
              (x) => m.surfaceRadius = x,
            ),
            n(
              '节点边框宽度',
              v.borderWidth,
              0,
              0,
              s.stepIndicator.navigation.nodeSize / 2,
              (x) => v.borderWidth = x,
            ),
            _color(
              '节点边框颜色',
              v.borderColor,
              (x) => v.borderColor = x,
              inheritedColor: theme.colors.outline,
            ),
            ..._focusedShadowProperties(
              maxExtent: s.controlHeightLg,
              EditorComponent(),
              stateTarget: v.shadow,
              label: '节点阴影',
              description: '显式空列表关闭节点阴影。',
            ),
          ];
        case 'pagination':
          final native = theme.paginationTheme.style;
          return [
            _heading('省略号'),
            if (state == 'common')
              n(
                '省略号字号',
                m.ellipsisStyleSize,
                native.ellipsisStyle?.fontSize ??
                    theme.textTheme.bodyMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.ellipsisStyleSize = x,
                decimal: false,
              ),
            _select(
              '省略号字重',
              v.ellipsisStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.ellipsisStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '省略号颜色',
              v.ellipsisStyleColor,
              (x) => v.ellipsisStyleColor = x,
              inheritedColor:
                  native.ellipsisStyle?.color ?? theme.colors.textPrimary,
            ),
            if (state == 'common')
              n(
                '图标尺寸',
                m.iconSize,
                s.pagination.iconSize,
                0,
                editorContentIconLimit,
                (x) => m.iconSize = x,
                decimal: false,
              ),
            if (state == 'common') ...[
              _heading('布局'),
              n(
                '最小高度',
                m.height,
                s.pagination.height,
                0,
                editorLayoutInsetLimit,
                (x) => m.height = x,
                decimal: false,
              ),
              n(
                '最小宽度',
                m.minWidth,
                s.pagination.minWidth,
                0,
                editorContentWidthLimit,
                (x) => m.minWidth = x,
                decimal: false,
              ),
              n(
                '图标与内容间距',
                m.spacing,
                s.pagination.spacing,
                0,
                editorContentSpacingLimit,
                (x) => m.spacing = x,
                decimal: false,
              ),
              n(
                '换行间距',
                m.runSpacing,
                s.pagination.runSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.runSpacing = x,
                decimal: false,
              ),
            ],
            _heading('表面与留白'),
            if (state == 'common')
              n(
                '内容内边距 · 左',
                m.paddingLeft,
                s.pagination.padding.resolve(TextDirection.ltr).left,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingLeft = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 上',
                m.paddingTop,
                s.pagination.padding.resolve(TextDirection.ltr).top,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingTop = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 右',
                m.paddingRight,
                s.pagination.padding.resolve(TextDirection.ltr).right,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingRight = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 下',
                m.paddingBottom,
                s.pagination.padding.resolve(TextDirection.ltr).bottom,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingBottom = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '表面圆角',
                m.radius,
                s.pagination.radius,
                0,
                editorSurfaceRadiusLimit,
                (x) => m.radius = x,
                decimal: false,
              ),
          ];
        case 'pageIndicator':
          final native = theme.pageIndicatorTheme.style;
          return [
            _heading('页码文字'),
            if (state == 'common')
              n(
                '页码文字字号',
                m.counterStyleSize,
                native.counterStyle?.fontSize ??
                    theme.textTheme.bodyMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.counterStyleSize = x,
                decimal: false,
              ),
            _select(
              '页码文字字重',
              v.counterStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.counterStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '页码文字颜色',
              v.counterStyleColor,
              (x) => v.counterStyleColor = x,
              inheritedColor:
                  native.counterStyle?.color ?? theme.colors.textPrimary,
            ),
            if (state == 'common') ...[
              _heading('布局'),
              n(
                '圆点尺寸',
                m.dotSize,
                s.pageIndicator.dotSize,
                0,
                editorContentIconLimit,
                (x) => m.dotSize = x,
                decimal: false,
              ),
              n(
                '选中圆点宽度',
                m.selectedWidth,
                s.pageIndicator.selectedWidth,
                0,
                editorContentWidthLimit,
                (x) => m.selectedWidth = x,
                decimal: false,
              ),
              n(
                '图标与内容间距',
                m.spacing,
                s.pageIndicator.spacing,
                0,
                editorContentSpacingLimit,
                (x) => m.spacing = x,
                decimal: false,
              ),
            ],
            _heading('交互与标记'),
            _color(
              '焦点颜色',
              v.focusColor,
              (x) => v.focusColor = x,
              inheritedColor: native.focusColor ?? theme.colors.primary,
            ),
            if (state == 'common' || state == 'disabled')
              n(
                '禁用透明度',
                v.disabledOpacity,
                native.disabledOpacity ?? .38,
                0,
                1,
                (x) => v.disabledOpacity = x,
                decimal: true,
              ),
            _heading('动画与显示时机'),
            n(
              '动画时长（毫秒）',
              v.duration,
              native.duration?.inMilliseconds.toDouble() ??
                  theme.motion.standardDuration.inMilliseconds.toDouble(),
              0,
              editorReviewDurationLimit,
              (x) => v.duration = x,
              decimal: false,
            ),
            _select('动画曲线', v.curve ?? 'inherit', const {
              'inherit': '继承',
              'linear': '线性',
              'easeInOut': '缓入缓出',
              'fastOutSlowIn': '快出慢入',
            }, (x) => _change(() => v.curve = x == 'inherit' ? null : x)),
            _heading('圆点轮廓'),
            n(
              '圆点圆角',
              m.dotRadius,
              s.pageIndicator.dotSize / 2,
              0,
              editorRadiusLimit(s.pageIndicator.dotSize),
              (x) => m.dotRadius = x,
            ),
            n(
              '圆点边框宽度',
              v.dotBorderWidth,
              0,
              0,
              editorSelectionStrokeLimit(s.pageIndicator.dotSize),
              (x) => v.dotBorderWidth = x,
            ),
            _color(
              '圆点边框颜色',
              v.dotBorderColor,
              (x) => v.dotBorderColor = x,
              inheritedColor: theme.colors.outline,
            ),
            _heading('表面与留白'),
            ...material(v),
            if (state == 'common')
              n(
                '内容内边距 · 左',
                m.paddingLeft,
                s.pageIndicator.padding.resolve(TextDirection.ltr).left,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingLeft = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 上',
                m.paddingTop,
                s.pageIndicator.padding.resolve(TextDirection.ltr).top,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingTop = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 右',
                m.paddingRight,
                s.pageIndicator.padding.resolve(TextDirection.ltr).right,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingRight = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 下',
                m.paddingBottom,
                s.pageIndicator.padding.resolve(TextDirection.ltr).bottom,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingBottom = x,
                decimal: false,
              ),
            _color(
              '背景',
              v.background,
              (x) => v.background = x,
              inheritedColor: native.background?.color ?? Colors.transparent,
            ),
            _color(
              '普通圆点填充',
              v.dotFill,
              (x) => v.dotFill = x,
              inheritedColor: native.dotFill?.color ?? theme.colors.outline,
            ),
            _color(
              '选中圆点填充',
              v.selectedDotFill,
              (x) => v.selectedDotFill = x,
              inheritedColor:
                  native.selectedDotFill?.color ?? theme.colors.primary,
            ),
            n(
              '边框宽度',
              v.borderWidth,
              0,
              0,
              editorLineThicknessLimit,
              (x) => v.borderWidth = x,
              decimal: false,
            ),
            _color(
              '边框颜色',
              v.borderColor,
              (x) => v.borderColor = x,
              inheritedColor: theme.colors.outline,
            ),
            if (state == 'common')
              n(
                '表面圆角',
                m.surfaceRadius,
                0,
                0,
                editorSurfaceRadiusLimit,
                (x) => m.surfaceRadius = x,
                decimal: false,
              ),
            ..._focusedShadowProperties(
              maxExtent: s.controlHeightLg,
              EditorComponent(),
              stateTarget: v.shadow,
              label: '表面阴影',
              description: '默认继承组件与材质配方；显式空列表关闭阴影。',
            ),
          ];
        case 'breadcrumb':
          final native = theme.breadcrumbTheme.style;
          return [
            _heading('文字'),
            if (state == 'common')
              n(
                '文字字号',
                m.textStyleSize,
                native.textStyle?.fontSize ??
                    theme.textTheme.bodyMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.textStyleSize = x,
                decimal: false,
              ),
            if (state == 'common')
              _select(
                '文字字重',
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
                  () => v.textStyleWeight = x == 'inherit'
                      ? null
                      : double.parse(x),
                ),
              ),

            if (state == 'common') ...[
              _heading('布局'),
              n(
                '条目最小高度',
                m.itemHeight,
                s.breadcrumb.itemHeight,
                0,
                editorLayoutInsetLimit,
                (x) => m.itemHeight = x,
                decimal: false,
              ),
              n(
                '条目水平内边距',
                m.itemHorizontalPadding,
                s.breadcrumb.itemHorizontalPadding,
                0,
                editorContentSpacingLimit,
                (x) => m.itemHorizontalPadding = x,
                decimal: false,
              ),
              n(
                '条目最大宽度',
                m.itemMaxWidth,
                s.breadcrumb.itemMaxWidth,
                0,
                editorContentWidthLimit,
                (x) => m.itemMaxWidth = x,
                decimal: false,
              ),
              n(
                '分隔图标尺寸',
                m.separatorSize,
                s.breadcrumb.separatorSize,
                0,
                editorContentIconLimit,
                (x) => m.separatorSize = x,
                decimal: false,
              ),
              n(
                '分隔图标间距',
                m.separatorSpacing,
                s.breadcrumb.separatorSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.separatorSpacing = x,
                decimal: false,
              ),
            ],
            _heading('交互与标记'),
            if (state == 'highlight')
              _color(
                '高亮背景',
                v.highlightBackgroundColor,
                (x) => v.highlightBackgroundColor = x,
                inheritedColor:
                    native.highlightBackgroundColor ??
                    theme.colors.warning.withValues(alpha: .14),
              ),
            if (state == 'disabled')
              _color(
                '禁用背景',
                v.disabledBackgroundColor,
                (x) => v.disabledBackgroundColor = x,
                inheritedColor:
                    native.disabledBackgroundColor ?? theme.colors.disabled,
              ),
            if (state == 'common')
              _color(
                '文字 / 图标颜色',
                v.foregroundColor,
                (x) => v.foregroundColor = x,
                inheritedColor:
                    native.foregroundColor ?? theme.colors.textSecondary,
              ),
            if (state == 'highlight')
              _color(
                '高亮文字颜色',
                v.highlightForegroundColor,
                (x) => v.highlightForegroundColor = x,
                inheritedColor:
                    native.highlightForegroundColor ??
                    theme.colors.surfaceElevated,
              ),
            if (state == 'common')
              _color(
                '分隔图标颜色',
                v.separatorColor,
                (x) => v.separatorColor = x,
                inheritedColor:
                    native.separatorColor ?? theme.colors.textTertiary,
              ),
            if (state == 'disabled')
              _color(
                '禁用颜色',
                v.disabledColor,
                (x) => v.disabledColor = x,
                inheritedColor: native.disabledColor ?? theme.colors.disabled,
              ),
            _heading('表面与留白'),
            if (state == 'common')
              _color(
                '背景',
                v.backgroundColor,
                (x) => v.backgroundColor = x,
                inheritedColor:
                    native.backgroundColor ?? theme.colors.surfaceMuted,
              ),
          ];
        case 'topNavigation':
          final native =
              theme.topNavigationTheme.style ?? const HyperTopNavigationStyle();
          return [
            _heading('描述'),
            if (state == 'common')
              n(
                '描述字号',
                m.descriptionStyleSize,
                native.descriptionStyle?.fontSize ??
                    theme.textTheme.bodyMedium?.fontSize ??
                    theme.typography.control,
                1,
                editorContentIconLimit,
                (x) => m.descriptionStyleSize = x,
                decimal: false,
              ),
            _select(
              '描述字重',
              v.descriptionStyleWeight?.round().toString() ?? 'inherit',
              const {
                'inherit': '继承',
                '300': '300',
                '400': '400 常规',
                '500': '500 中等',
                '600': '600 半粗',
                '700': '700 粗体',
              },
              (x) => _change(
                () => v.descriptionStyleWeight = x == 'inherit'
                    ? null
                    : double.parse(x),
              ),
            ),
            _color(
              '描述颜色',
              v.descriptionStyleColor,
              (x) => v.descriptionStyleColor = x,
              inheritedColor:
                  native.descriptionStyle?.color ?? theme.colors.textSecondary,
            ),
            if (state == 'common')
              n(
                '图标尺寸',
                m.iconSize,
                s.topNavigation.iconSize,
                0,
                editorContentIconLimit,
                (x) => m.iconSize = x,
                decimal: false,
              ),
            if (state == 'common') ...[
              _heading('布局'),
              n(
                '最小高度',
                m.height,
                s.topNavigation.height,
                0,
                editorLayoutInsetLimit,
                (x) => m.height = x,
                decimal: false,
              ),
              n(
                '图标与文字间距',
                m.iconSpacing,
                s.topNavigation.iconSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.iconSpacing = x,
                decimal: false,
              ),
              n(
                '条目间距',
                m.itemSpacing,
                s.topNavigation.itemSpacing,
                0,
                editorContentSpacingLimit,
                (x) => m.itemSpacing = x,
                decimal: false,
              ),
              n(
                '描述间距',
                m.descriptionGap,
                s.topNavigation.descriptionGap,
                0,
                editorContentSpacingLimit,
                (x) => m.descriptionGap = x,
                decimal: false,
              ),
            ],
            _heading('表面与留白'),
            if (state == 'common')
              n(
                '内容内边距 · 左',
                m.paddingLeft,
                s.topNavigation.padding.resolve(TextDirection.ltr).left,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingLeft = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 上',
                m.paddingTop,
                s.topNavigation.padding.resolve(TextDirection.ltr).top,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingTop = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 右',
                m.paddingRight,
                s.topNavigation.padding.resolve(TextDirection.ltr).right,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingRight = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '内容内边距 · 下',
                m.paddingBottom,
                s.topNavigation.padding.resolve(TextDirection.ltr).bottom,
                0,
                editorContentSpacingLimit,
                (x) => m.paddingBottom = x,
                decimal: false,
              ),
            if (state == 'common')
              n(
                '表面圆角',
                m.radius,
                s.topNavigation.radius,
                0,
                editorSurfaceRadiusLimit,
                (x) => m.radius = x,
                decimal: false,
              ),
          ];
        default:
          return const [];
      }
    }

    return _panel(_ThemeEditorState._components[_component]!, [
      if (_page == 'hyper-notification-center')
        const HyperText('业务组合示例：设置只作用于单条通知，不提供通知中心主题。'),
      const HyperText('尺寸按设备保存，外观按亮暗保存；局部主题与实例覆盖以 Demo 标记为准。'),
      if (objects.length > 1)
        _select(
          '编辑对象',
          selectedObject,
          objects,
          (x) => _updateState(() {
            _reviewObject = x;
            _reviewState = 'common';
          }),
        ),
      if (object == 'tabBar')
        _select('外观变体', _reviewVariant, const {
          'common': '通用（所有变体）',
          'segmented': '底槽',
          'separated': '独立标签',
          'underline': '下划线',
        }, (x) => _updateState(() => _reviewVariant = x)),
      if (parts.length > 1)
        _select(
          '编辑范围',
          part,
          parts,
          (x) => _updateState(() {
            _reviewPart = x;
            _reviewState = 'common';
          }),
        ),
      if (part == 'item' && object != 'sidebar')
        _select('交互状态', buttonState, const {
          'common': '默认',
          'selected': '选中',
        }, (x) => _updateState(() => _reviewState = x)),
      if (states.length > 1)
        _select(
          object == 'alert' || object == 'banner'
              ? '提示状态'
              : object == 'stepIndicator' || object == 'stepperNavigation'
              ? '步骤状态'
              : '交互状态',
          state,
          states,
          (x) => _updateState(() => _reviewState = x),
        ),
      HyperButton.text(
        onPressed: () => _change(() {
          if (object == 'topNavigation' && part == 'menuItem') {
            final mv = _mode.reviews.topNavigationMenu;
            switch (state) {
              case 'common':
                _spec.reviews.reset('topNavigationMenu');
                mv.foregroundColor = null;
                mv.itemTextStyleWeight = null;
                mv.descriptionStyleWeight = null;
                mv.descriptionStyleColor = null;
                mv.groupTitleStyleWeight = null;
                mv.groupTitleStyleColor = null;
                break;
              case 'selected':
                mv.selectedForegroundColor = null;
                mv.selectedBackgroundColor = null;
                break;
              case 'active':
                mv.overlayColor = null;
                break;
              case 'disabled':
                mv.disabledColor = null;
                break;
            }
            return;
          }
          if (isNavigationSurface) {
            if (object == 'sidebar' && part == 'item' && state == 'common') {
              _spec.reviews.sidebar.iconSize = null;
              _spec.reviews.sidebar.expandIconSize = null;
              _spec.reviews.sidebar.collapsedIconSize = null;
              _spec.reviews.sidebar.collapsedRowGap = null;
            }
            _mode.reviews.reset(surfaceSlot);
            _spec.reviews.reset(surfaceSlot);
            return;
          }
          if (object == 'sidebar' && state != 'common') {
            switch (state) {
              case 'selected':
                v.selectedForegroundColor = null;
                v.selectedBackgroundColor = null;
                break;
              case 'ancestor':
                v.ancestorSelectedForegroundColor = null;
                v.ancestorSelectedBackgroundColor = null;
                break;
              case 'disabled':
                v.disabledColor = null;
                break;
            }
          } else if (object == 'breadcrumb' && state != 'common') {
            if (state == 'highlight') {
              v.highlightForegroundColor = null;
              v.highlightBackgroundColor = null;
            } else {
              v.disabledColor = null;
              v.disabledBackgroundColor = null;
            }
          } else {
            _mode.reviews.reset(part == 'group' ? slot : buttonSlot);
          }
          if (state == 'common') {
            _spec.reviews.reset(part == 'group' ? object : buttonSlot);
          }
        }),
        child: const Text('恢复当前对象 / 状态继承'),
      ),
      if (object == 'topNavigation' && part == 'menuItem')
        ...menuItems()
      else if (object == 'topNavigation' && part == 'panel') ...[
        ...menuPanelLayout(),
        ...navigationSurface(),
      ] else if (isNavigationSurface &&
          !(object == 'tabBar' && part == 'group'))
        ...navigationSurface()
      else if (part == 'group')
        ...body()
      else
        ...buttonBody(),
    ]);
  }
}
