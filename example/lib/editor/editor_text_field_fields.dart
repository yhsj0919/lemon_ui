import 'editor_button_fields.dart';

import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'editor_theme_document.dart';

class EditorTextFieldVisual {
  EditorBorder hoveredBorder = EditorBorder();
  EditorBorder focusedBorder = EditorBorder();
  EditorBorder errorBorder = EditorBorder();
  EditorBorder disabledBorder = EditorBorder();
  EditorColor? iconColor;
  EditorColor? cursorColor;
  EditorColor? hintColor;
  EditorColor? labelColor;
  EditorColor? counterColor;
  EditorColor? errorIconColor;
  EditorColor? hoverBorderColor;
  EditorColor? focusBorderColor;
  EditorColor? errorBorderColor;
  EditorColor? disabledForegroundColor;
  double? cursorWidth;
  double? cursorRadius;
  double? textFontSize;
  double? hintFontSize;
  double? labelFontSize;
  double? counterFontSize;
  double? durationMilliseconds;
  Map<String, Object?> toJson() => {
    if (disabledBorder.toJson().isNotEmpty)
      'disabledBorder': disabledBorder.toJson(),
    if (errorBorder.toJson().isNotEmpty) 'errorBorder': errorBorder.toJson(),
    if (focusedBorder.toJson().isNotEmpty)
      'focusedBorder': focusedBorder.toJson(),
    if (hoveredBorder.toJson().isNotEmpty)
      'hoveredBorder': hoveredBorder.toJson(),
    if (iconColor != null) 'iconColor': iconColor!.toJson(),
    if (cursorColor != null) 'cursorColor': cursorColor!.toJson(),
    if (hintColor != null) 'hintColor': hintColor!.toJson(),
    if (labelColor != null) 'labelColor': labelColor!.toJson(),
    if (counterColor != null) 'counterColor': counterColor!.toJson(),
    if (errorIconColor != null) 'errorIconColor': errorIconColor!.toJson(),
    if (hoverBorderColor != null)
      'hoverBorderColor': hoverBorderColor!.toJson(),
    if (focusBorderColor != null)
      'focusBorderColor': focusBorderColor!.toJson(),
    if (errorBorderColor != null)
      'errorBorderColor': errorBorderColor!.toJson(),
    if (disabledForegroundColor != null)
      'disabledForegroundColor': disabledForegroundColor!.toJson(),
    if (cursorWidth != null) 'cursorWidth': cursorWidth,
    if (cursorRadius != null) 'cursorRadius': cursorRadius,
    if (textFontSize != null) 'textFontSize': textFontSize,
    if (hintFontSize != null) 'hintFontSize': hintFontSize,
    if (labelFontSize != null) 'labelFontSize': labelFontSize,
    if (counterFontSize != null) 'counterFontSize': counterFontSize,
    if (durationMilliseconds != null)
      'durationMilliseconds': durationMilliseconds,
  };
  static EditorTextFieldVisual fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'hoveredBorder',
        'focusedBorder',
        'errorBorder',
        'disabledBorder',
        'iconColor',
        'cursorColor',
        'hintColor',
        'labelColor',
        'counterColor',
        'errorIconColor',
        'hoverBorderColor',
        'focusBorderColor',
        'errorBorderColor',
        'disabledForegroundColor',
        'cursorWidth',
        'cursorRadius',
        'textFontSize',
        'hintFontSize',
        'labelFontSize',
        'counterFontSize',
        'durationMilliseconds',
      }.contains(k),
    )) {
      throw const FormatException('不支持的输入框属性');
    }
    return EditorTextFieldVisual()
      ..disabledBorder = EditorBorder.fromJson(
        (j['disabledBorder'] as Map<String, dynamic>?) ?? {},
      )
      ..errorBorder = EditorBorder.fromJson(
        (j['errorBorder'] as Map<String, dynamic>?) ?? {},
      )
      ..focusedBorder = EditorBorder.fromJson(
        (j['focusedBorder'] as Map<String, dynamic>?) ?? {},
      )
      ..hoveredBorder = EditorBorder.fromJson(
        (j['hoveredBorder'] as Map<String, dynamic>?) ?? {},
      )
      ..iconColor = j['iconColor'] == null
          ? null
          : EditorColor.fromJson(j['iconColor'] as Map<String, dynamic>)
      ..cursorColor = j['cursorColor'] == null
          ? null
          : EditorColor.fromJson(j['cursorColor'] as Map<String, dynamic>)
      ..hintColor = j['hintColor'] == null
          ? null
          : EditorColor.fromJson(j['hintColor'] as Map<String, dynamic>)
      ..labelColor = j['labelColor'] == null
          ? null
          : EditorColor.fromJson(j['labelColor'] as Map<String, dynamic>)
      ..counterColor = j['counterColor'] == null
          ? null
          : EditorColor.fromJson(j['counterColor'] as Map<String, dynamic>)
      ..errorIconColor = j['errorIconColor'] == null
          ? null
          : EditorColor.fromJson(j['errorIconColor'] as Map<String, dynamic>)
      ..hoverBorderColor = j['hoverBorderColor'] == null
          ? null
          : EditorColor.fromJson(j['hoverBorderColor'] as Map<String, dynamic>)
      ..focusBorderColor = j['focusBorderColor'] == null
          ? null
          : EditorColor.fromJson(j['focusBorderColor'] as Map<String, dynamic>)
      ..errorBorderColor = j['errorBorderColor'] == null
          ? null
          : EditorColor.fromJson(j['errorBorderColor'] as Map<String, dynamic>)
      ..disabledForegroundColor = j['disabledForegroundColor'] == null
          ? null
          : EditorColor.fromJson(
              j['disabledForegroundColor'] as Map<String, dynamic>,
            )
      ..cursorWidth = number(j['cursorWidth'], min: 0, max: 600)
      ..cursorRadius = number(j['cursorRadius'], min: 0, max: 600)
      ..textFontSize = number(j['textFontSize'], min: 8, max: 600)
      ..hintFontSize = number(j['hintFontSize'], min: 8, max: 600)
      ..labelFontSize = number(j['labelFontSize'], min: 8, max: 600)
      ..counterFontSize = number(j['counterFontSize'], min: 8, max: 600)
      ..durationMilliseconds = number(
        j['durationMilliseconds'],
        min: 0,
        max: 5000,
      );
  }

  HyperTextFieldThemeData resolve(
    HyperColorScheme c, {
    EditorBorder? defaultBorder,
  }) {
    BoxBorder? stateBorder(EditorBorder state, Color color) {
      final values = {...?defaultBorder?.toJson(), ...state.toJson()};
      if (values.isEmpty) return null;
      values['color'] =
          state.color?.toJson() ?? EditorColor(argb: color.toARGB32()).toJson();
      return EditorBorder.fromJson(values).resolve(c);
    }

    return HyperTextFieldThemeData(
      style: HyperTextFieldStyle(
        iconColor: iconColor?.resolve(c),
        cursorColor: cursorColor?.resolve(c),
        errorIconColor: errorIconColor?.resolve(c),
        textStyle: textFontSize == null
            ? null
            : TextStyle(fontSize: textFontSize),
        hintStyle: hintFontSize == null && hintColor == null
            ? null
            : TextStyle(fontSize: hintFontSize, color: hintColor?.resolve(c)),
        labelStyle: labelFontSize == null && labelColor == null
            ? null
            : TextStyle(fontSize: labelFontSize, color: labelColor?.resolve(c)),
        counterStyle: counterFontSize == null && counterColor == null
            ? null
            : TextStyle(
                fontSize: counterFontSize,
                color: counterColor?.resolve(c),
              ),
        cursorWidth: cursorWidth,
        cursorRadius: cursorRadius == null
            ? null
            : Radius.circular(cursorRadius!),
        duration: durationMilliseconds == null
            ? null
            : Duration(milliseconds: durationMilliseconds!.round()),
      ),
      hovered: HyperTextFieldStyle(
        borderColor: hoverBorderColor?.resolve(c),
        border: stateBorder(
          hoveredBorder,
          hoverBorderColor?.resolve(c) ?? c.textSecondary,
        ),
      ),
      focused: HyperTextFieldStyle(
        borderColor: focusBorderColor?.resolve(c),
        border: stateBorder(
          focusedBorder,
          focusBorderColor?.resolve(c) ?? c.primary,
        ),
      ),
      error: HyperTextFieldStyle(
        borderColor: errorBorderColor?.resolve(c),
        border: stateBorder(
          errorBorder,
          errorBorderColor?.resolve(c) ?? c.error,
        ),
      ),
      disabled: HyperTextFieldStyle(
        border: stateBorder(disabledBorder, c.outline),
        foregroundColor: disabledForegroundColor?.resolve(c),
        iconColor: disabledForegroundColor?.resolve(c),
      ),
    );
  }
}

class EditorTextFieldMetrics {
  double? horizontalPadding;
  double? verticalPadding;
  double? iconSize;
  double? actionWidth;
  double? labelGap;
  double? errorMaxWidth;
  Map<String, Object?> toJson() => {
    if (horizontalPadding != null) 'horizontalPadding': horizontalPadding,
    if (verticalPadding != null) 'verticalPadding': verticalPadding,
    if (iconSize != null) 'iconSize': iconSize,
    if (actionWidth != null) 'actionWidth': actionWidth,
    if (labelGap != null) 'labelGap': labelGap,
    if (errorMaxWidth != null) 'errorMaxWidth': errorMaxWidth,
  };
  static EditorTextFieldMetrics fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'horizontalPadding',
        'verticalPadding',
        'iconSize',
        'actionWidth',
        'labelGap',
        'errorMaxWidth',
      }.contains(k),
    )) {
      throw const FormatException('不支持的输入框属性');
    }
    return EditorTextFieldMetrics()
      ..horizontalPadding = number(j['horizontalPadding'], min: 0, max: 600)
      ..verticalPadding = number(j['verticalPadding'], min: 0, max: 600)
      ..iconSize = number(j['iconSize'], min: 0, max: 600)
      ..actionWidth = number(j['actionWidth'], min: 0, max: 600)
      ..labelGap = number(j['labelGap'], min: 0, max: 600)
      ..errorMaxWidth = number(j['errorMaxWidth'], min: 0, max: 600);
  }

  HyperTextFieldSize resolve(HyperTextFieldSize base) => base.copyWith(
    horizontalPadding: horizontalPadding,
    verticalPadding: verticalPadding,
    iconSize: iconSize,
    actionWidth: actionWidth,
    labelGap: labelGap,
    errorMaxWidth: errorMaxWidth,
  );
}
