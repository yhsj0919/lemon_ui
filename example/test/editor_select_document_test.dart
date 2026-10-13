import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';

void main() {
  test('Select 尺寸四端独立，亮暗和两个表面独立保存', () {
    final doc = EditorThemeDocument();
    doc.desktop.selectMetrics
      ..width = 260
      ..arrowSize = 23
      ..popupSpacing = 9
      ..itemHeight = 48
      ..surfaceRadius = 15;
    doc.light.select.selectStyle
      ..arrowColor = const EditorColor(semantic: 'primary')
      ..selectedBackgroundColor = const EditorColor(argb: 0xffabcdef)
      ..searchDebounce = 350;
    doc.light.selectAnchor.background = const EditorColor(argb: 0xffaabbcc);
    doc.light.select.shadows = [];
    doc.desktop.selectMetrics
      ..minimumHeight = 44
      ..paddingHorizontal = 18
      ..paddingVertical = 7
      ..radius = 12
      ..minimumTapTargetSize = 48;
    doc.light.selectAnchor.buttonStyle
      ..hoveredOffsetY = -2
      ..pressedScale = .95
      ..disabledForeground = const EditorColor(argb: 0xff112233)
      ..animationMilliseconds = 180;
    doc.light.selectAnchor.hoveredShadow.shadows = [EditorShadow(blur: 8)];
    doc.light.selectAnchor.pressedShadow.shadows = [];
    doc.light.select.selectStyle
      ..showCheckmark = false
      ..checkPlacement = 'leading'
      ..checkIcon = 'star'
      ..checkSize = 22
      ..checkSpacing = 9
      ..checkColor = const EditorColor(argb: 0xffff0000);
    final restored = EditorThemeDocument.decode(doc.encode());
    expect(restored.encode(), doc.encode());
    final theme = restored.resolve(false);
    expect(
      theme.selectTheme.style!.selectionStyle!.menuStyle!.checkPlacement,
      HyperMenuCheckPlacement.leading,
    );
    expect(theme.autocompleteTheme.style.menuStyle!.checkIcon, Icons.star);
    expect(theme.autocompleteTheme.style.menuStyle!.checkSize, 22);
    expect(
      theme.selectTheme.style!.selectionStyle!.menuStyle!.showCheckmark,
      isFalse,
    );
    expect(theme.autocompleteTheme.style.menuStyle!.showCheckmark, isFalse);
    final metrics = theme.sizes.resolve(HyperDeviceType.desktop).select;
    expect(metrics.minimumHeight, 44);
    expect(metrics.paddingHorizontal, 18);
    expect(metrics.paddingVertical, 7);
    expect(metrics.radius, 12);
    expect(metrics.minimumTapTargetSize, 48);
    final trigger = theme.selectTheme.style!.buttonStyle!;
    expect(trigger.hoveredOffset, const Offset(0, -2));
    expect(trigger.pressedScale, .95);
    expect(trigger.pressedBoxShadow, isEmpty);
    expect(trigger.hoveredBoxShadow, hasLength(1));
    expect(trigger.disabledForegroundColor, const Color(0xff112233));
    expect(trigger.animationDuration, const Duration(milliseconds: 180));
    expect(metrics.width, 260);
    expect(metrics.itemHeight, 48);
    expect(metrics.popupSpacing, 9);
    expect(theme.selectTheme.style!.arrowColor, theme.colors.primary);
    expect(
      theme.selectTheme.style!.buttonStyle!.background!.color,
      const Color(0xffaabbcc),
    );
    expect(
      theme.selectTheme.style!.selectionStyle!.surfaceStyle!.boxShadow,
      isEmpty,
    );
    expect(
      theme
          .selectTheme
          .style!
          .selectionStyle!
          .menuStyle!
          .selectedBackgroundColor,
      const Color(0xffabcdef),
    );
    expect(
      theme.selectTheme.style!.selectionStyle!.searchDebounce,
      const Duration(milliseconds: 350),
    );
    expect(
      theme.sizes.resolve(HyperDeviceType.phone).select,
      EditorThemeDocument()
          .resolve(false)
          .sizes
          .resolve(HyperDeviceType.phone)
          .select,
    );
    expect(
      restored.resolve(true).selectTheme,
      EditorThemeDocument().resolve(true).selectTheme,
    );
    expect(theme.buttonTheme, EditorThemeDocument().resolve(false).buttonTheme);
    expect(
      theme.autocompleteTheme.style.inputStyle!.background!.color,
      const Color(0xffaabbcc),
    );
    expect(
      theme.autocompleteTheme.style.inputStyle!.duration,
      const Duration(milliseconds: 180),
    );
    expect(
      theme.autocompleteTheme.style.menuStyle!.selectedBackgroundColor,
      const Color(0xffabcdef),
    );
  });
}
