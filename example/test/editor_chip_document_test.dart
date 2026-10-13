import 'package:lemon_ui_example/editor/editor_chip_fields.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_button_fields.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';

void main() {
  test('标签配色和减淡比例按状态与亮暗保存', () {
    final doc = EditorThemeDocument();
    doc.light.chip.chipStyle
      ..colorVariant = 'soft'
      ..baseColor = const EditorColor(semantic: 'primary')
      ..backgroundFade = .8
      ..borderFade = .4
      ..foregroundFade = .1;
    doc.light.chipSelected.chipStyle
      ..colorVariant = 'filled'
      ..foregroundMode = 'white';
    final loaded = EditorThemeDocument.decode(doc.encode());
    expect(loaded.encode(), doc.encode());
    final theme = loaded.resolve(false);
    final common = theme.chipTheme.style.resolvePalette(
      theme.colors,
      theme.contrastTheme,
    );
    expect(
      common.background!.color,
      Color.lerp(theme.colors.primary, theme.colors.surface, .8),
    );
    expect(
      common.borderColor,
      Color.lerp(theme.colors.primary, theme.colors.surface, .4),
    );
    expect(
      common.foregroundColor,
      Color.lerp(theme.colors.primary, theme.colors.surface, .1),
    );
    expect(
      theme.chipTheme.selected.foregroundMode,
      HyperChipForegroundMode.white,
    );
    expect(loaded.resolve(true).chipTheme.style.colorVariant, isNull);
    expect(
      () => EditorChipVisual.fromJson({'backgroundFade': 1.5}),
      throwsFormatException,
    );
  });

  test('标签各状态边框样式保存并解析，旧配置保留', () {
    final doc = EditorThemeDocument();
    doc.light.chip.border
      ..kind = EditorBorderKind.dashed
      ..width = 2
      ..dashLength = 7
      ..gapLength = 3;
    doc.light.chipSelected.border.kind = EditorBorderKind.dotted;
    doc.light.chipPressed.border.kind = EditorBorderKind.none;
    doc.light.chipFocused.chipStyle
      ..borderColor = const EditorColor(argb: 0xffff0000)
      ..borderWidth = 3;
    final loaded = EditorThemeDocument.decode(doc.encode());
    expect(loaded.encode(), doc.encode());
    final theme = loaded.resolve(false).chipTheme;
    expect(theme.style.boxBorder, isA<HyperLineBorder>());
    expect(
      (theme.style.boxBorder as HyperLineBorder).line.pattern,
      HyperLinePattern.dashed,
    );
    expect(
      (theme.selected.boxBorder as HyperLineBorder).line.pattern,
      HyperLinePattern.dotted,
    );
    expect(theme.pressed.boxBorder, const Border());
    expect(theme.focused.borderWidth, 3);
    expect(theme.focused.borderColor, const Color(0xffff0000));
    expect(loaded.resolve(true).chipTheme.style.boxBorder, isNull);
  });

  test('标签尺寸状态配置保存回读，设备和亮暗独立', () {
    final doc = EditorThemeDocument();
    doc.desktop.chipMetrics
      ..height = 34
      ..deleteTargetWidth = 30
      ..radius = 9;
    doc.light.chip.chipStyle
      ..fontSize = 15
      ..deleteIcon = 'delete'
      ..showCheckmark = false;
    doc.light.chipSelected.chipStyle
      ..foreground = const EditorColor(argb: 0xff123456)
      ..checkPlacement = 'avatarReplacement';
    doc.light.chipPressed.shadows = [];
    final loaded = EditorThemeDocument.decode(doc.encode());
    expect(loaded.encode(), doc.encode());
    final theme = loaded.resolve(false);
    expect(theme.sizes.desktop.chip.height, 34);
    expect(theme.sizes.desktop.chip.radius, 9);
    expect(theme.chipTheme.style.deleteIcon, Icons.delete_outline);
    expect(theme.chipTheme.style.showCheckmark, isFalse);
    expect(theme.chipTheme.selected.foregroundColor, const Color(0xff123456));
    expect(theme.chipTheme.pressed.boxShadow, isEmpty);
    expect(
      theme.sizes.phone.chip,
      EditorThemeDocument().resolve(false).sizes.phone.chip,
    );
    expect(
      loaded.resolve(true).chipTheme,
      EditorThemeDocument().resolve(true).chipTheme,
    );
  });
}
