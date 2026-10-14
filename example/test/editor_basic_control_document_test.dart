import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_basic_control_fields.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/editor/editor_button_fields.dart';
import 'package:lemon_ui_example/gallery/gallery_registry.dart';

void main() {
  test('开关交互透明度与独立边框保存和重置', () {
    final visual = EditorSwitchVisual()
      ..hoverOpacity = .2
      ..pressedOpacity = .3
      ..activeBorder.width = 2
      ..inactiveBorder.visible = false
      ..disabledBorder.width = 1
      ..thumbBorder.width = 1;
    final restored = EditorSwitchVisual.fromJson(visual.toJson());
    expect(restored.toJson(), visual.toJson());
    restored.resetState('selected');
    expect(restored.activeBorder.toJson(), isEmpty);
    expect(restored.thumbBorder.width, 1);
    restored.resetState('hovered');
    expect(restored.hoverOpacity, isNull);
    expect(restored.pressedOpacity, .3);
  });
  test('复选新增交互和状态边框往返并按状态重置', () {
    final visual = EditorCheckboxVisual()
      ..hoverOpacity = .2
      ..pressedOpacity = .3
      ..glyphScale = 1
      ..selectedBorder.visible = false
      ..disabledBorder.width = 2;
    final restored = EditorCheckboxVisual.fromJson(visual.toJson());
    expect(restored.toJson(), visual.toJson());
    restored.resetState('hovered');
    expect(restored.hoverOpacity, isNull);
    expect(restored.pressedOpacity, .3);
    restored.resetState('selected');
    expect(restored.selectedBorder.toJson(), isEmpty);
    expect(restored.disabledBorder.width, 2);
  });
  test('单选新增间距及禁用未选中颜色可往返和重置', () {
    final visual = EditorRadioVisual()
      ..disabledUnselectedColor = const EditorColor(semantic: 'primary');
    final restored = EditorRadioVisual.fromJson(visual.toJson());
    expect(restored.disabledUnselectedColor, isNotNull);
    restored.resetState('disabled');
    expect(restored.disabledUnselectedColor, isNull);
    final metrics = EditorRadioMetrics()..spacing = 13;
    expect(EditorRadioMetrics.fromJson(metrics.toJson()).spacing, 13);
  });
  test('进度渐变按对象和亮暗保存，主题回读保留节点', () {
    final doc = EditorThemeDocument();
    doc.light.progressLinear.progressStyle.gradient = EditorGradient(
      colors: [
        const EditorColor(semantic: 'primary'),
        const EditorColor(semantic: 'outline'),
      ],
      stops: [0, 1],
    );
    doc.light.progressLinear.progressStyle.bufferColor = const EditorColor(
      semantic: 'primary',
    );
    doc.light.progressLinear.progressStyle.bufferGradient =
        doc.light.progressLinear.progressStyle.gradient;
    final loaded = EditorThemeDocument.decode(doc.encode());
    expect(loaded.encode(), doc.encode());
    expect(
      loaded.resolve(false).progressTheme.linearStyle.bufferGradient,
      isA<LinearGradient>(),
    );
    expect(
      loaded.resolve(false).progressTheme.linearStyle.gradient,
      isA<LinearGradient>(),
    );
    expect(loaded.resolve(true).progressTheme.linearStyle.gradient, isNull);
    expect(loaded.resolve(false).progressTheme.circularStyle.gradient, isNull);
  });

  test('Badge 全部外观字段可往返，未知字段拒绝', () {
    final json = <String, dynamic>{
      'borderWidth': 2,
      'durationMilliseconds': 600,
      'fontWeight': 600,
      'lineHeight': 1.2,
      'backgroundColor': {'semantic': 'primary'},
      'foregroundColor': {'semantic': 'primary'},
      'borderColor': {'semantic': 'primary'},
      'curve': 'linear',
    };
    final value = EditorBadgeVisual.fromJson(json);
    expect(value.toJson(), json);
    expect(EditorBadgeVisual.fromJson(value.toJson()).toJson(), json);
    expect(
      () => EditorBadgeVisual.fromJson({'unknown': 1}),
      throwsFormatException,
    );
  });
  test('Badge 全部尺寸字段可往返', () {
    final json = <String, dynamic>{
      'dotSize': 30,
      'dotRadius': 30,
      'contentHeight': 30,
      'textSize': 30,
      'contentRadius': 30,
      'horizontalPadding': 30,
    };
    final value = EditorBadgeMetrics.fromJson(json);
    expect(value.toJson(), json);
    expect(
      () => EditorBadgeMetrics.fromJson({'unknown': 1}),
      throwsFormatException,
    );
  });
  test('Divider 全部外观字段可往返，未知字段拒绝', () {
    final json = <String, dynamic>{
      'fontSize': 14,
      'fontWeight': 600,
      'lineHeight': 1.2,
      'durationMilliseconds': 600,
      'color': {'semantic': 'primary'},
      'textColor': {'semantic': 'primary'},
      'iconColor': {'semantic': 'primary'},
      'pattern': 'solid',
      'contentAlignment': 'start',
      'curve': 'linear',
      'gradient': {
        'angle': 0,
        'colors': [
          {'semantic': 'primary'},
          {'semantic': 'outline'},
        ],
        'stops': [0, 1],
      },
    };
    final value = EditorDividerVisual.fromJson(json);
    expect(value.toJson(), json);
    expect(EditorDividerVisual.fromJson(value.toJson()).toJson(), json);
    expect(
      () => EditorDividerVisual.fromJson({'unknown': 1}),
      throwsFormatException,
    );
  });
  test('Divider 全部尺寸字段可往返', () {
    final json = <String, dynamic>{
      'thickness': 30,
      'dashLength': 30,
      'contentGap': 30,
      'edgeExtent': 30,
      'iconSize': 30,
      'gap': 30,
      'length': 30,
      'indent': 30,
      'endIndent': 30,
      'radius': 30,
    };
    final value = EditorDividerMetrics.fromJson(json);
    expect(value.toJson(), json);
    expect(
      () => EditorDividerMetrics.fromJson({'unknown': 1}),
      throwsFormatException,
    );
  });
  test('Progress 全部外观字段可往返，未知字段拒绝', () {
    final json = <String, dynamic>{
      'durationMilliseconds': 600,
      'color': {'semantic': 'primary'},
      'trackColor': {'semantic': 'primary'},
      'variant': 'thin',
      'strokeCap': 'round',
      'curve': 'linear',
    };
    final value = EditorProgressVisual.fromJson(json);
    expect(value.toJson(), json);
    expect(EditorProgressVisual.fromJson(value.toJson()).toJson(), json);
    expect(
      () => EditorProgressVisual.fromJson({'unknown': 1}),
      throwsFormatException,
    );
  });
  test('Progress 全部尺寸字段可往返', () {
    final json = <String, dynamic>{
      'circularSize': 30,
      'circularThickness': 30,
      'linearThickness': 30,
      'wideLinearThickness': 30,
      'infiniteSize': 30,
      'infiniteDotRadius': 30,
      'linearSize': 30,
      'radius': 30,
      'fillRadius': 30,
      'infiniteThickness': 30,
    };
    final value = EditorProgressMetrics.fromJson(json);
    expect(value.toJson(), json);
    expect(
      () => EditorProgressMetrics.fromJson({'unknown': 1}),
      throwsFormatException,
    );
  });
  test('Radio 全部外观字段可往返，未知字段拒绝', () {
    final json = <String, dynamic>{
      'pressScale': 1,
      'durationMilliseconds': 600,
      'selectedColor': {'semantic': 'primary'},
      'disabledSelectedColor': {'semantic': 'primary'},
      'backgroundColor': {'semantic': 'primary'},
      'selectedBackgroundColor': {'semantic': 'primary'},
      'curve': 'linear',
      'border': {
        'color': {'semantic': 'outline'},
        'width': 2,
        'visible': false,
      },
      'selectedBorder': {
        'color': {'semantic': 'outline'},
        'width': 2,
        'visible': false,
      },
    };
    final value = EditorRadioVisual.fromJson(json);
    expect(value.toJson(), json);
    expect(EditorRadioVisual.fromJson(value.toJson()).toJson(), json);
    expect(
      () => EditorRadioVisual.fromJson({'unknown': 1}),
      throwsFormatException,
    );
  });
  test('Radio 全部尺寸字段可往返', () {
    final json = <String, dynamic>{
      'size': 30,
      'minimumTapTargetSize': 30,
      'indicatorSize': 30,
      'markSize': 30,
      'strokeWidth': 30,
      'radius': 30,
    };
    final value = EditorRadioMetrics.fromJson(json);
    expect(value.toJson(), json);
    expect(
      () => EditorRadioMetrics.fromJson({'unknown': 1}),
      throwsFormatException,
    );
  });
  test('Checkbox 全部外观字段可往返，未知字段拒绝', () {
    final json = <String, dynamic>{
      'pressScale': 1,
      'durationMilliseconds': 600,
      'activeColor': {'semantic': 'primary'},
      'inactiveColor': {'semantic': 'primary'},
      'checkColor': {'semantic': 'primary'},
      'disabledColor': {'semantic': 'primary'},
      'disabledCheckColor': {'semantic': 'primary'},
      'overlayColor': {'semantic': 'primary'},
      'curve': 'linear',
      'border': {
        'color': {'semantic': 'outline'},
        'width': 2,
        'visible': false,
      },
    };
    final value = EditorCheckboxVisual.fromJson(json);
    expect(value.toJson(), json);
    expect(EditorCheckboxVisual.fromJson(value.toJson()).toJson(), json);
    expect(
      () => EditorCheckboxVisual.fromJson({'unknown': 1}),
      throwsFormatException,
    );
  });
  test('Checkbox 全部尺寸字段可往返', () {
    final json = <String, dynamic>{
      'size': 30,
      'markStrokeWidth': 30,
      'roundedRadius': 30,
      'minimumTapTargetSize': 30,
      'circleRadius': 30,
    };
    final value = EditorCheckboxMetrics.fromJson(json);
    expect(value.toJson(), json);
    expect(
      () => EditorCheckboxMetrics.fromJson({'unknown': 1}),
      throwsFormatException,
    );
  });
  test('Switch 全部外观字段可往返，未知字段拒绝', () {
    final json = <String, dynamic>{
      'interactionThumbScale': 1,
      'durationMilliseconds': 600,
      'activeTrackColor': {'semantic': 'primary'},
      'inactiveTrackColor': {'semantic': 'primary'},
      'disabledTrackColor': {'semantic': 'primary'},
      'disabledActiveTrackColor': {'semantic': 'primary'},
      'disabledInactiveTrackColor': {'semantic': 'primary'},
      'activeThumbColor': {'semantic': 'primary'},
      'inactiveThumbColor': {'semantic': 'primary'},
      'disabledThumbColor': {'semantic': 'primary'},
      'disabledActiveThumbColor': {'semantic': 'primary'},
      'disabledInactiveThumbColor': {'semantic': 'primary'},
      'overlayColor': {'semantic': 'primary'},
      'curve': 'linear',
      'border': {
        'color': {'semantic': 'outline'},
        'width': 2,
        'visible': false,
      },
    };
    final value = EditorSwitchVisual.fromJson(json);
    expect(value.toJson(), json);
    expect(EditorSwitchVisual.fromJson(value.toJson()).toJson(), json);
    expect(
      () => EditorSwitchVisual.fromJson({'unknown': 1}),
      throwsFormatException,
    );
  });
  test('Switch 全部尺寸字段可往返', () {
    final json = <String, dynamic>{
      'width': 100,
      'height': 40,
      'thumbSize': 24,
      'thumbInset': 4,
      'minimumTapTargetSize': 30,
      'radius': 30,
      'thumbRadius': 30,
      'uncheckedThumbOffset': 4,
      'checkedThumbOffset': 72,
    };
    final value = EditorSwitchMetrics.fromJson(json);
    expect(value.toJson(), json);
    expect(
      () => EditorSwitchMetrics.fromJson({'unknown': 1}),
      throwsFormatException,
    );
  });

  test('六组控件保存导入同时保留四端、亮暗及对象 / 变体隔离', () {
    final d = EditorThemeDocument();
    for (final type in HyperDeviceType.values) {
      final factor = type.index + 1.0;
      final metrics = d.device(type);
      metrics.badgeMetrics.dotSize = 5 + factor;
      metrics.dividerMetrics.thickness = factor;
      metrics.progressMetrics.circularSize = 20 + factor;
      metrics.radioMetrics.size = 18 + factor;
      metrics.checkboxMetrics.markStrokeWidth = factor;
      metrics.switchMetrics.width = 60 + factor;
    }
    d.light.badge.badgeStyle.foregroundColor = const EditorColor(
      semantic: 'primary',
    );
    d.dark.badge.badgeStyle.foregroundColor = const EditorColor(
      argb: 0xffff0000,
    );
    d.light.badge.shadows = [];
    d.light.radio.radioStyle.selectedColor = const EditorColor(
      semantic: 'primary',
    );
    d.light.radioFilled.radioStyle.selectedColor = const EditorColor(
      argb: 0xff00ff00,
    );
    d.light.radioFilled.shadows = [];
    d.light.checkbox.checkboxStyle.checkColor = const EditorColor(
      semantic: 'primary',
    );
    d.light.checkboxRounded.checkboxStyle.checkColor = const EditorColor(
      argb: 0xffff0000,
    );
    d.light.checkboxRounded.shadows = [];
    d.light.progress.progressStyle.trackColor = const EditorColor(
      semantic: 'outline',
    );
    d.light.progressCircular.progressStyle.color = const EditorColor(
      argb: 0xff0000ff,
    );
    d.light.progressInfinite.progressStyle.durationMilliseconds = 950;
    d.light.switchControl.switchStyle.activeTrackColor = const EditorColor(
      argb: 0xff00ff00,
    );
    d.light.switchControl.shadows = [];
    d.light.divider.dividerStyle.textColor = const EditorColor(
      argb: 0xffff0000,
    );
    final loaded = EditorThemeDocument.decode(d.encode());
    expect(loaded.toJson(), d.toJson());
    final light = loaded.resolve(false), dark = loaded.resolve(true);
    for (final type in HyperDeviceType.values) {
      final factor = type.index + 1.0;
      final s = light.sizes.resolve(type);
      expect(s.badge.dotSize, 5 + factor);
      expect(s.divider.thickness, factor);
      expect(s.progress.circularSize, 20 + factor);
      expect(s.radio.size, 18 + factor);
      expect(s.checkbox.markStrokeWidth, factor);
      expect(s.switchSize.width, 60 + factor);
    }
    expect(
      light.radioTheme.resolve(HyperRadioVariant.filled).selectedColor,
      const Color(0xff00ff00),
    );
    expect(
      light.radioTheme.resolve(HyperRadioVariant.circle).selectedColor,
      light.colors.primary,
    );
    expect(
      light.radioTheme.resolve(HyperRadioVariant.filled).boxShadow,
      isEmpty,
    );
    expect(
      light.checkboxTheme.resolve(HyperCheckboxVariant.rounded).checkColor,
      const Color(0xffff0000),
    );
    expect(
      light.checkboxTheme.resolve(HyperCheckboxVariant.circle).checkColor,
      light.colors.primary,
    );
    expect(
      light.checkboxTheme.resolve(HyperCheckboxVariant.rounded).boxShadow,
      isEmpty,
    );
    expect(light.progressTheme.circularStyle.color, const Color(0xff0000ff));
    expect(light.progressTheme.linearStyle.color, isNull);
    expect(light.progressTheme.style.trackColor, light.colors.outline);
    expect(
      light.progressTheme.infiniteStyle.animationDuration,
      const Duration(milliseconds: 950),
    );
    expect(light.badgeTheme.style.foregroundColor, light.colors.primary);
    expect(dark.badgeTheme.style.foregroundColor, const Color(0xffff0000));
    expect(light.badgeTheme.style.boxShadow, isEmpty);
    expect(light.switchTheme.style!.thumbShadow, isEmpty);
    expect(light.switchTheme.style!.activeTrackColor, const Color(0xff00ff00));
    expect(light.dividerTheme.style.textStyle!.color, const Color(0xffff0000));
  });
  test('空覆盖与旧主题文件保持默认规格，恢复继承不输出字段', () {
    final d = EditorThemeDocument.decode(
      '{"formatVersion":1,"base":"lemon-hyper-v1","name":"old","devices":{}}',
    );
    final base = HyperThemeData.light(), resolved = d.resolve(false);
    for (final type in HyperDeviceType.values) {
      expect(
        resolved.sizes.resolve(type).radio,
        base.sizes.resolve(type).radio,
      );
      expect(
        resolved.sizes.resolve(type).checkbox,
        base.sizes.resolve(type).checkbox,
      );
      expect(
        resolved.sizes.resolve(type).switchSize,
        base.sizes.resolve(type).switchSize,
      );
      expect(
        resolved.sizes.resolve(type).progress,
        base.sizes.resolve(type).progress,
      );
      expect(
        resolved.sizes.resolve(type).divider,
        base.sizes.resolve(type).divider,
      );
    }
    d.light.badge.badgeStyle.backgroundColor = const EditorColor(
      semantic: 'primary',
    );
    d.light.badge.badgeStyle.backgroundColor = null;
    expect(d.light.toJson(), isEmpty);
    expect(d.toJson()['devices'], isEmpty);
  });
  test('状态重置只清除对应字段；共用叠加色范围明确', () {
    final radio = EditorRadioVisual()
      ..selectedColor = const EditorColor(semantic: 'primary')
      ..backgroundColor = const EditorColor(semantic: 'surface')
      ..disabledSelectedColor = const EditorColor(semantic: 'outline')
      ..durationMilliseconds = 400;
    radio.resetState('selected');
    expect(radio.selectedColor, isNull);
    expect(radio.backgroundColor, isNotNull);
    expect(radio.disabledSelectedColor, isNotNull);
    expect(radio.durationMilliseconds, 400);
    final checkbox = EditorCheckboxVisual()
      ..activeColor = const EditorColor(semantic: 'primary')
      ..inactiveColor = const EditorColor(semantic: 'surface')
      ..overlayColor = const EditorColor(semantic: 'outline')
      ..pressScale = .9;
    checkbox.resetState('pressed');
    expect(checkbox.pressScale, isNull);
    expect(checkbox.overlayColor, isNull);
    expect(checkbox.activeColor, isNotNull);
    expect(checkbox.inactiveColor, isNotNull);
    final toggle = EditorSwitchVisual()
      ..activeTrackColor = const EditorColor(semantic: 'primary')
      ..disabledTrackColor = const EditorColor(semantic: 'outline')
      ..inactiveTrackColor = const EditorColor(semantic: 'surface');
    toggle.resetState('disabled');
    expect(toggle.disabledTrackColor, isNull);
    expect(toggle.activeTrackColor, isNotNull);
    expect(toggle.inactiveTrackColor, isNotNull);
  });
  test('分割线渐变与稀疏文字覆盖保留继承排版', () {
    final d = EditorThemeDocument();
    d.light.divider.dividerStyle.gradient = EditorGradient(
      colors: [
        const EditorColor(semantic: 'primary'),
        const EditorColor(semantic: 'outline'),
      ],
      stops: [0, 1],
      kind: EditorGradientKind.sweep,
    );
    d.light.divider.dividerStyle.lineHeight = 4;
    final loaded = EditorThemeDocument.decode(d.encode()).resolve(false);
    expect(loaded.dividerTheme.style.textStyle?.height, isNull);
    expect(loaded.dividerTheme.style.gradient, isA<SweepGradient>());
    final merged =
        const HyperDividerStyle(
          textStyle: TextStyle(fontSize: 14, color: Colors.blue),
        ).merge(
          const HyperDividerStyle(
            textStyle: TextStyle(fontWeight: FontWeight.w600),
          ),
        );
    expect(merged.textStyle!.fontSize, 14);
    expect(merged.textStyle!.color, Colors.blue);
    expect(merged.textStyle!.fontWeight, FontWeight.w600);
  });
  test('徽标、分割线、进度、单选、复选与开关已确认，其余入口保持未确认，页面 id 唯一', () {
    const ids = {
      'hyper-badge',
      'hyper-divider',
      'hyper-progress-indicator',
      'hyper-radio',
      'hyper-checkbox',
      'hyper-switch',
    };
    final pending = gallerySections.singleWhere((s) => s.title == '未确认');
    for (final id in ids) {
      expect(
        pending.items.where((i) => i.id == id),
        hasLength(
          {
                'hyper-badge',
                'hyper-divider',
                'hyper-progress-indicator',
                'hyper-radio',
                'hyper-checkbox',
                'hyper-switch',
              }.contains(id)
              ? 0
              : 1,
        ),
      );
      if ({
        'hyper-badge',
        'hyper-divider',
        'hyper-progress-indicator',
        'hyper-radio',
        'hyper-checkbox',
        'hyper-switch',
      }.contains(id)) {
        expect(
          gallerySections
              .singleWhere(
                (s) =>
                    s.title ==
                    ((id == 'hyper-radio' ||
                            id == 'hyper-checkbox' ||
                            id == 'hyper-switch')
                        ? '选择控件'
                        : id == 'hyper-progress-indicator'
                        ? '反馈与状态'
                        : '文字与内容'),
              )
              .items
              .where((i) => i.id == id),
          hasLength(1),
        );
      }
      expect(galleryItems.where((i) => i.id == id), hasLength(1));
    }
  });
  test('拒绝非法开关几何和反向偏移，避免拖动 clamp 崩溃', () {
    final d = EditorThemeDocument();
    d.desktop.switchMetrics.width = 1;
    expect(() => EditorThemeDocument.decode(d.encode()), throwsFormatException);
    final metrics = EditorSwitchMetrics()
      ..uncheckedThumbOffset = 20
      ..checkedThumbOffset = 1;
    expect(
      () => metrics.resolve(const HyperSizeScheme.desktop().switchSize),
      throwsFormatException,
    );
  });
}
