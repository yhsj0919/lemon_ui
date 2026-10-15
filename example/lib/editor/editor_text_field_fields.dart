import 'editor_button_fields.dart';

import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'editor_theme_document.dart';

const editorFieldIcons = <String, IconData>{
  'close': Icons.close,
  'cancel': Icons.cancel_outlined,
  'visibility': Icons.visibility_outlined,
  'visibilityOff': Icons.visibility_off_outlined,
  'lock': Icons.lock_outline,
  'lockOpen': Icons.lock_open_outlined,
  'error': Icons.error_outline,
  'warning': Icons.warning_amber_outlined,
  'info': Icons.info_outline,
};

class EditorTextFieldVisual {
  final errorPopupShadow = EditorComponentShadow();
  int? textWeight;
  int? hintWeight;
  int? labelWeight;
  int? counterWeight;
  int? errorWeight;
  EditorColor? errorTextColor;
  EditorColor? errorPopupBackground;
  EditorColor? errorPopupBorderColor;
  String? verticalAlignment;
  String? motionCurve;
  String? errorPlacement;
  String? clearIconName;
  String? showPasswordIconName;
  String? hidePasswordIconName;
  String? errorIconName;
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
    if (errorPopupShadow.shadows != null)
      'errorPopupShadows': errorPopupShadow.shadows!
          .map((v) => v.toJson())
          .toList(),
    if (textWeight != null) 'textWeight': textWeight,
    if (hintWeight != null) 'hintWeight': hintWeight,
    if (labelWeight != null) 'labelWeight': labelWeight,
    if (counterWeight != null) 'counterWeight': counterWeight,
    if (errorWeight != null) 'errorWeight': errorWeight,
    if (errorTextColor != null) 'errorTextColor': errorTextColor!.toJson(),
    if (errorPopupBackground != null)
      'errorPopupBackground': errorPopupBackground!.toJson(),
    if (errorPopupBorderColor != null)
      'errorPopupBorderColor': errorPopupBorderColor!.toJson(),
    if (verticalAlignment != null) 'verticalAlignment': verticalAlignment,
    if (motionCurve != null) 'motionCurve': motionCurve,
    if (errorPlacement != null) 'errorPlacement': errorPlacement,
    if (clearIconName != null) 'clearIconName': clearIconName,
    if (showPasswordIconName != null)
      'showPasswordIconName': showPasswordIconName,
    if (hidePasswordIconName != null)
      'hidePasswordIconName': hidePasswordIconName,
    if (errorIconName != null) 'errorIconName': errorIconName,
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
        'errorPopupShadows',
        'textWeight',
        'hintWeight',
        'labelWeight',
        'counterWeight',
        'errorWeight',
        'errorTextColor',
        'errorPopupBackground',
        'errorPopupBorderColor',
        'verticalAlignment',
        'motionCurve',
        'errorPlacement',
        'clearIconName',
        'showPasswordIconName',
        'hidePasswordIconName',
        'errorIconName',
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
    String? choice(String key, Set<String> values) {
      final value = j[key];
      if (value == null) return null;
      if (value is! String || !values.contains(value)) {
        throw FormatException('无效输入框选项：$key');
      }
      return value;
    }

    return EditorTextFieldVisual()
      ..errorPopupShadow.shadows = (j['errorPopupShadows'] as List?)
          ?.map((v) => EditorShadow.fromJson(v as Map<String, dynamic>))
          .toList()
      ..textWeight = number(j['textWeight'], min: 100, max: 900)?.round()
      ..hintWeight = number(j['hintWeight'], min: 100, max: 900)?.round()
      ..labelWeight = number(j['labelWeight'], min: 100, max: 900)?.round()
      ..counterWeight = number(j['counterWeight'], min: 100, max: 900)?.round()
      ..errorWeight = number(j['errorWeight'], min: 100, max: 900)?.round()
      ..errorTextColor = j['errorTextColor'] == null
          ? null
          : EditorColor.fromJson(j['errorTextColor'] as Map<String, dynamic>)
      ..errorPopupBackground = j['errorPopupBackground'] == null
          ? null
          : EditorColor.fromJson(
              j['errorPopupBackground'] as Map<String, dynamic>,
            )
      ..errorPopupBorderColor = j['errorPopupBorderColor'] == null
          ? null
          : EditorColor.fromJson(
              j['errorPopupBorderColor'] as Map<String, dynamic>,
            )
      ..verticalAlignment = choice('verticalAlignment', {
        'top',
        'center',
        'bottom',
      })
      ..motionCurve = choice('motionCurve', {
        'linear',
        'easeInOut',
        'fastOutSlowIn',
      })
      ..errorPlacement = choice(
        'errorPlacement',
        HyperOverlayPlacement.values.map((v) => v.name).toSet(),
      )
      ..clearIconName = choice('clearIconName', editorFieldIcons.keys.toSet())
      ..showPasswordIconName = choice(
        'showPasswordIconName',
        editorFieldIcons.keys.toSet(),
      )
      ..hidePasswordIconName = choice(
        'hidePasswordIconName',
        editorFieldIcons.keys.toSet(),
      )
      ..errorIconName = choice('errorIconName', editorFieldIcons.keys.toSet())
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

    FontWeight? weight(int? value) => value == null
        ? null
        : FontWeight.values[(value / 100).round().clamp(1, 9) - 1];
    return HyperTextFieldThemeData(
      style: HyperTextFieldStyle(
        textAlignVertical: switch (verticalAlignment) {
          'top' => TextAlignVertical.top,
          'center' => TextAlignVertical.center,
          'bottom' => TextAlignVertical.bottom,
          _ => null,
        },
        curve: switch (motionCurve) {
          'linear' => Curves.linear,
          'easeInOut' => Curves.easeInOut,
          'fastOutSlowIn' => Curves.fastOutSlowIn,
          _ => null,
        },
        errorPlacement: errorPlacement == null
            ? null
            : HyperOverlayPlacement.values.byName(errorPlacement!),
        clearIcon: editorFieldIcons[clearIconName],
        showPasswordIcon: editorFieldIcons[showPasswordIconName],
        hidePasswordIcon: editorFieldIcons[hidePasswordIconName],
        errorIcon: editorFieldIcons[errorIconName],
        errorTextStyle: TextStyle(
          color: errorTextColor?.resolve(c),
          fontWeight: weight(errorWeight),
        ),
        errorPopupStyle:
            errorPopupBackground == null &&
                errorPopupBorderColor == null &&
                errorPopupShadow.shadows == null
            ? null
            : HyperCardStyle(
                boxShadow: errorPopupShadow.shadows
                    ?.map((v) => v.resolve(c))
                    .toList(),
                background: errorPopupBackground == null
                    ? null
                    : HyperFill.color(errorPopupBackground!.resolve(c)),
                border: errorPopupBorderColor == null
                    ? null
                    : Border.all(color: errorPopupBorderColor!.resolve(c)),
              ),
        iconColor: iconColor?.resolve(c),
        cursorColor: cursorColor?.resolve(c),
        errorIconColor: errorIconColor?.resolve(c),
        textStyle: TextStyle(
          fontSize: textFontSize,
          fontWeight: weight(textWeight),
        ),
        hintStyle: TextStyle(
          fontSize: hintFontSize,
          color: hintColor?.resolve(c),
          fontWeight: weight(hintWeight),
        ),
        labelStyle: TextStyle(
          fontSize: labelFontSize,
          color: labelColor?.resolve(c),
          fontWeight: weight(labelWeight),
        ),
        counterStyle: TextStyle(
          fontSize: counterFontSize,
          color: counterColor?.resolve(c),
          fontWeight: weight(counterWeight),
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
  double? errorFontSize;
  double? errorPopupRadius;
  double? errorPopupPadding;
  double? errorPopupBorderWidth;
  double? horizontalPadding;
  double? verticalPadding;
  double? iconSize;
  double? actionWidth;
  double? labelGap;
  double? errorMaxWidth;
  Map<String, Object?> toJson() => {
    if (errorFontSize != null) 'errorFontSize': errorFontSize,
    if (errorPopupRadius != null) 'errorPopupRadius': errorPopupRadius,
    if (errorPopupPadding != null) 'errorPopupPadding': errorPopupPadding,
    if (errorPopupBorderWidth != null)
      'errorPopupBorderWidth': errorPopupBorderWidth,
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
        'errorFontSize',
        'errorPopupRadius',
        'errorPopupPadding',
        'errorPopupBorderWidth',
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
      ..errorFontSize = number(j['errorFontSize'], min: 0, max: 600)
      ..errorPopupRadius = number(j['errorPopupRadius'], min: 0, max: 600)
      ..errorPopupPadding = number(j['errorPopupPadding'], min: 0, max: 600)
      ..errorPopupBorderWidth = number(
        j['errorPopupBorderWidth'],
        min: 0,
        max: 600,
      )
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
