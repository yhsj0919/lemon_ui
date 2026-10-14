import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'editor_theme_document.dart';
import 'editor_button_fields.dart';

Curve? editorControlCurve(String? value) => switch (value) {
  'linear' => Curves.linear,
  'easeInOut' => Curves.easeInOut,
  'fastOutSlowIn' => Curves.fastOutSlowIn,
  _ => null,
};

/// BorderSide 控件只支持实线；不将虚线设置转换成另一种外观。
class EditorControlBorder {
  EditorColor? color;
  double? width;
  bool? visible;
  Map<String, Object?> toJson() => {
    if (color != null) 'color': color!.toJson(),
    if (width != null) 'width': width,
    if (visible != null) 'visible': visible,
  };
  static EditorControlBorder fromJson(Map<String, dynamic> j) {
    if (j.keys.any((k) => !{'color', 'width', 'visible'}.contains(k)) ||
        (j['visible'] != null && j['visible'] is! bool)) {
      throw const FormatException('无效控件边框');
    }
    return EditorControlBorder()
      ..color = j['color'] == null
          ? null
          : EditorColor.fromJson(j['color'] as Map<String, dynamic>)
      ..width = number(j['width'], min: 0, max: 20)
      ..visible = j['visible'] as bool?;
  }

  BorderSide? resolve(HyperColorScheme colors, {Color? fallbackColor}) {
    if (toJson().isEmpty) return null;
    if (visible == false || width == 0) return BorderSide.none;
    return BorderSide(
      color: color?.resolve(colors) ?? fallbackColor ?? colors.outline,
      width: width ?? 1,
    );
  }
}

class EditorBadgeVisual {
  double? borderWidth;
  double? durationMilliseconds;
  double? fontWeight;
  double? lineHeight;
  EditorColor? backgroundColor;
  EditorColor? foregroundColor;
  EditorColor? borderColor;
  String? curve;
  Map<String, Object?> toJson() => {
    if (borderWidth != null) 'borderWidth': borderWidth,
    if (durationMilliseconds != null)
      'durationMilliseconds': durationMilliseconds,
    if (fontWeight != null) 'fontWeight': fontWeight,
    if (lineHeight != null) 'lineHeight': lineHeight,
    if (curve != null) 'curve': curve,
    if (backgroundColor != null) 'backgroundColor': backgroundColor!.toJson(),
    if (foregroundColor != null) 'foregroundColor': foregroundColor!.toJson(),
    if (borderColor != null) 'borderColor': borderColor!.toJson(),
  };
  static EditorBadgeVisual fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'borderWidth',
        'durationMilliseconds',
        'fontWeight',
        'lineHeight',
        'backgroundColor',
        'foregroundColor',
        'borderColor',
        'curve',
      }.contains(k),
    )) {
      throw const FormatException('不支持的控件外观字段');
    }
    if (j['curve'] != null &&
        !['linear', 'easeInOut', 'fastOutSlowIn'].contains(j['curve'])) {
      throw const FormatException('无效 curve');
    }
    return EditorBadgeVisual()
      ..borderWidth = number(j['borderWidth'], min: 0, max: 20)
      ..durationMilliseconds = number(
        j['durationMilliseconds'],
        min: 0,
        max: 5000,
      )
      ..fontWeight = number(j['fontWeight'], min: 100, max: 900)
      ..lineHeight = number(j['lineHeight'], min: 0.5, max: 4)
      ..backgroundColor = j['backgroundColor'] == null
          ? null
          : EditorColor.fromJson(j['backgroundColor'] as Map<String, dynamic>)
      ..foregroundColor = j['foregroundColor'] == null
          ? null
          : EditorColor.fromJson(j['foregroundColor'] as Map<String, dynamic>)
      ..borderColor = j['borderColor'] == null
          ? null
          : EditorColor.fromJson(j['borderColor'] as Map<String, dynamic>)
      ..curve = j['curve'] as String?;
  }

  HyperBadgeStyle resolve(HyperColorScheme colors) => HyperBadgeStyle(
    backgroundColor: backgroundColor?.resolve(colors),
    foregroundColor: foregroundColor?.resolve(colors),
    borderColor: borderColor?.resolve(colors),
    borderWidth: borderWidth,
    duration: durationMilliseconds == null
        ? null
        : Duration(milliseconds: durationMilliseconds!.round()),
    curve: editorControlCurve(curve),
    textStyle: fontWeight == null && lineHeight == null
        ? null
        : TextStyle(
            fontSize: null,
            color: null,
            fontWeight: fontWeight == null
                ? null
                : FontWeight.values[((fontWeight! / 100).round() - 1).clamp(
                    0,
                    8,
                  )],
            height: lineHeight,
          ),
  );
}

class EditorBadgeMetrics {
  double? dotSize;
  double? dotRadius;
  double? contentHeight;
  double? textSize;
  double? contentRadius;
  double? horizontalPadding;
  Map<String, Object?> toJson() => {
    if (dotSize != null) 'dotSize': dotSize,
    if (dotRadius != null) 'dotRadius': dotRadius,
    if (contentHeight != null) 'contentHeight': contentHeight,
    if (textSize != null) 'textSize': textSize,
    if (contentRadius != null) 'contentRadius': contentRadius,
    if (horizontalPadding != null) 'horizontalPadding': horizontalPadding,
  };
  static EditorBadgeMetrics fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'dotSize',
        'dotRadius',
        'contentHeight',
        'textSize',
        'contentRadius',
        'horizontalPadding',
      }.contains(k),
    )) {
      throw const FormatException('不支持的控件尺寸字段');
    }
    return EditorBadgeMetrics()
      ..dotSize = number(j['dotSize'], min: 0, max: 1000)
      ..dotRadius = number(j['dotRadius'], min: 0, max: 1000)
      ..contentHeight = number(j['contentHeight'], min: 0, max: 1000)
      ..textSize = number(j['textSize'], min: 0, max: 1000)
      ..contentRadius = number(j['contentRadius'], min: 0, max: 1000)
      ..horizontalPadding = number(j['horizontalPadding'], min: 0, max: 1000);
  }

  HyperBadgeSize resolve(HyperBadgeSize base) => base.copyWith(
    dotSize: dotSize,
    dotRadius: dotRadius,
    contentHeight: contentHeight,
    textSize: textSize,
    contentRadius: contentRadius,
    horizontalPadding: horizontalPadding,
  );
}

class EditorDividerVisual {
  double? fontSize;
  double? fontWeight;
  double? lineHeight;
  double? durationMilliseconds;
  EditorColor? color;
  EditorColor? textColor;
  EditorColor? iconColor;
  String? pattern;
  String? contentAlignment;
  String? curve;
  EditorGradient? gradient;
  Map<String, Object?> toJson() => {
    if (fontSize != null) 'fontSize': fontSize,
    if (fontWeight != null) 'fontWeight': fontWeight,
    if (lineHeight != null) 'lineHeight': lineHeight,
    if (durationMilliseconds != null)
      'durationMilliseconds': durationMilliseconds,
    if (pattern != null) 'pattern': pattern,
    if (contentAlignment != null) 'contentAlignment': contentAlignment,
    if (curve != null) 'curve': curve,
    if (color != null) 'color': color!.toJson(),
    if (textColor != null) 'textColor': textColor!.toJson(),
    if (iconColor != null) 'iconColor': iconColor!.toJson(),
    if (gradient != null) 'gradient': gradient!.toJson(),
  };
  static EditorDividerVisual fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'fontSize',
        'fontWeight',
        'lineHeight',
        'durationMilliseconds',
        'color',
        'textColor',
        'iconColor',
        'pattern',
        'contentAlignment',
        'curve',
        'gradient',
      }.contains(k),
    )) {
      throw const FormatException('不支持的控件外观字段');
    }
    if (j['pattern'] != null &&
        !['solid', 'dashed', 'dotted'].contains(j['pattern'])) {
      throw const FormatException('无效 pattern');
    }
    if (j['contentAlignment'] != null &&
        !['start', 'center', 'end'].contains(j['contentAlignment'])) {
      throw const FormatException('无效 contentAlignment');
    }
    if (j['curve'] != null &&
        !['linear', 'easeInOut', 'fastOutSlowIn'].contains(j['curve'])) {
      throw const FormatException('无效 curve');
    }
    return EditorDividerVisual()
      ..fontSize = number(j['fontSize'], min: 8, max: 64)
      ..fontWeight = number(j['fontWeight'], min: 100, max: 900)
      ..lineHeight = number(j['lineHeight'], min: 0.5, max: 4)
      ..durationMilliseconds = number(
        j['durationMilliseconds'],
        min: 0,
        max: 5000,
      )
      ..color = j['color'] == null
          ? null
          : EditorColor.fromJson(j['color'] as Map<String, dynamic>)
      ..textColor = j['textColor'] == null
          ? null
          : EditorColor.fromJson(j['textColor'] as Map<String, dynamic>)
      ..iconColor = j['iconColor'] == null
          ? null
          : EditorColor.fromJson(j['iconColor'] as Map<String, dynamic>)
      ..pattern = j['pattern'] as String?
      ..contentAlignment = j['contentAlignment'] as String?
      ..curve = j['curve'] as String?
      ..gradient = j['gradient'] == null
          ? null
          : EditorGradient.fromJson(j['gradient'] as Map<String, dynamic>);
  }

  HyperDividerStyle resolve(HyperColorScheme colors) => HyperDividerStyle(
    color: color?.resolve(colors),
    iconColor: iconColor?.resolve(colors),
    duration: durationMilliseconds == null
        ? null
        : Duration(milliseconds: durationMilliseconds!.round()),
    curve: editorControlCurve(curve),
    textStyle:
        fontSize == null &&
            fontWeight == null &&
            lineHeight == null &&
            textColor == null
        ? null
        : TextStyle(
            fontSize: fontSize,
            color: textColor?.resolve(colors),
            fontWeight: fontWeight == null
                ? null
                : FontWeight.values[((fontWeight! / 100).round() - 1).clamp(
                    0,
                    8,
                  )],
            height: lineHeight,
          ),
    gradient: gradient?.resolve(colors),
    pattern: pattern == null
        ? null
        : HyperDividerPattern.values.byName(pattern!),
    contentAlignment: contentAlignment == null
        ? null
        : HyperDividerContentAlignment.values.byName(contentAlignment!),
  );
}

class EditorDividerMetrics {
  double? thickness;
  double? dashLength;
  double? contentGap;
  double? edgeExtent;
  double? iconSize;
  double? gap;
  double? length;
  double? indent;
  double? endIndent;
  double? radius;
  Map<String, Object?> toJson() => {
    if (thickness != null) 'thickness': thickness,
    if (dashLength != null) 'dashLength': dashLength,
    if (contentGap != null) 'contentGap': contentGap,
    if (edgeExtent != null) 'edgeExtent': edgeExtent,
    if (iconSize != null) 'iconSize': iconSize,
    if (gap != null) 'gap': gap,
    if (length != null) 'length': length,
    if (indent != null) 'indent': indent,
    if (endIndent != null) 'endIndent': endIndent,
    if (radius != null) 'radius': radius,
  };
  static EditorDividerMetrics fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'thickness',
        'dashLength',
        'contentGap',
        'edgeExtent',
        'iconSize',
        'gap',
        'length',
        'indent',
        'endIndent',
        'radius',
      }.contains(k),
    )) {
      throw const FormatException('不支持的控件尺寸字段');
    }
    return EditorDividerMetrics()
      ..thickness = number(j['thickness'], min: 0, max: 1000)
      ..dashLength = number(j['dashLength'], min: 0, max: 1000)
      ..contentGap = number(j['contentGap'], min: 0, max: 1000)
      ..edgeExtent = number(j['edgeExtent'], min: 0, max: 1000)
      ..iconSize = number(j['iconSize'], min: 0, max: 1000)
      ..gap = number(j['gap'], min: 0, max: 1000)
      ..length = number(j['length'], min: 0, max: 1000)
      ..indent = number(j['indent'], min: 0, max: 1000)
      ..endIndent = number(j['endIndent'], min: 0, max: 1000)
      ..radius = number(j['radius'], min: 0, max: 1000);
  }

  HyperDividerSize resolve(HyperDividerSize base) => base.copyWith(
    thickness: thickness,
    dashLength: dashLength,
    contentGap: contentGap,
    edgeExtent: edgeExtent,
    iconSize: iconSize,
    gap: gap,
    length: length,
    indent: indent,
    endIndent: endIndent,
    radius: radius,
  );
}

class EditorProgressVisual {
  double? durationMilliseconds;
  EditorColor? color;
  EditorColor? trackColor;
  String? variant;
  String? strokeCap;
  String? curve;
  Map<String, Object?> toJson() => {
    if (durationMilliseconds != null)
      'durationMilliseconds': durationMilliseconds,
    if (variant != null) 'variant': variant,
    if (strokeCap != null) 'strokeCap': strokeCap,
    if (curve != null) 'curve': curve,
    if (color != null) 'color': color!.toJson(),
    if (trackColor != null) 'trackColor': trackColor!.toJson(),
  };
  static EditorProgressVisual fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'durationMilliseconds',
        'color',
        'trackColor',
        'variant',
        'strokeCap',
        'curve',
      }.contains(k),
    )) {
      throw const FormatException('不支持的控件外观字段');
    }
    if (j['variant'] != null && !['thin', 'wide'].contains(j['variant'])) {
      throw const FormatException('无效 variant');
    }
    if (j['strokeCap'] != null &&
        !['round', 'butt', 'square'].contains(j['strokeCap'])) {
      throw const FormatException('无效 strokeCap');
    }
    if (j['curve'] != null &&
        !['linear', 'easeInOut', 'fastOutSlowIn'].contains(j['curve'])) {
      throw const FormatException('无效 curve');
    }
    return EditorProgressVisual()
      ..durationMilliseconds = number(
        j['durationMilliseconds'],
        min: 0,
        max: 5000,
      )
      ..color = j['color'] == null
          ? null
          : EditorColor.fromJson(j['color'] as Map<String, dynamic>)
      ..trackColor = j['trackColor'] == null
          ? null
          : EditorColor.fromJson(j['trackColor'] as Map<String, dynamic>)
      ..variant = j['variant'] as String?
      ..strokeCap = j['strokeCap'] as String?
      ..curve = j['curve'] as String?;
  }

  HyperProgressStyle resolve(HyperColorScheme colors) => HyperProgressStyle(
    color: color?.resolve(colors),
    trackColor: trackColor?.resolve(colors),
    animationDuration: durationMilliseconds == null
        ? null
        : Duration(milliseconds: durationMilliseconds!.round()),
    animationCurve: editorControlCurve(curve),
    variant: variant == null
        ? null
        : HyperProgressVariant.values.byName(variant!),
    strokeCap: strokeCap == null ? null : StrokeCap.values.byName(strokeCap!),
  );
}

class EditorProgressMetrics {
  double? circularSize;
  double? circularThickness;
  double? linearThickness;
  double? wideLinearThickness;
  double? infiniteSize;
  double? infiniteDotRadius;
  double? linearSize;
  double? radius;
  double? fillRadius;
  double? infiniteThickness;
  Map<String, Object?> toJson() => {
    if (circularSize != null) 'circularSize': circularSize,
    if (circularThickness != null) 'circularThickness': circularThickness,
    if (linearThickness != null) 'linearThickness': linearThickness,
    if (wideLinearThickness != null) 'wideLinearThickness': wideLinearThickness,
    if (infiniteSize != null) 'infiniteSize': infiniteSize,
    if (infiniteDotRadius != null) 'infiniteDotRadius': infiniteDotRadius,
    if (linearSize != null) 'linearSize': linearSize,
    if (radius != null) 'radius': radius,
    if (fillRadius != null) 'fillRadius': fillRadius,
    if (infiniteThickness != null) 'infiniteThickness': infiniteThickness,
  };
  static EditorProgressMetrics fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'circularSize',
        'circularThickness',
        'linearThickness',
        'wideLinearThickness',
        'infiniteSize',
        'infiniteDotRadius',
        'linearSize',
        'radius',
        'fillRadius',
        'infiniteThickness',
      }.contains(k),
    )) {
      throw const FormatException('不支持的控件尺寸字段');
    }
    return EditorProgressMetrics()
      ..circularSize = number(j['circularSize'], min: 0, max: 1000)
      ..circularThickness = number(j['circularThickness'], min: 0, max: 1000)
      ..linearThickness = number(j['linearThickness'], min: 0, max: 1000)
      ..wideLinearThickness = number(
        j['wideLinearThickness'],
        min: 0,
        max: 1000,
      )
      ..infiniteSize = number(j['infiniteSize'], min: 0, max: 1000)
      ..infiniteDotRadius = number(j['infiniteDotRadius'], min: 0, max: 1000)
      ..linearSize = number(j['linearSize'], min: 0, max: 1000)
      ..radius = number(j['radius'], min: 0, max: 1000)
      ..fillRadius = number(j['fillRadius'], min: 0, max: 1000)
      ..infiniteThickness = number(j['infiniteThickness'], min: 0, max: 1000);
  }

  HyperProgressSize resolve(HyperProgressSize base) => base.copyWith(
    circularSize: circularSize,
    circularThickness: circularThickness,
    linearThickness: linearThickness,
    wideLinearThickness: wideLinearThickness,
    infiniteSize: infiniteSize,
    infiniteDotRadius: infiniteDotRadius,
    linearSize: linearSize,
    radius: radius,
    fillRadius: fillRadius,
    infiniteThickness: infiniteThickness,
  );
}

class EditorRadioVisual {
  double? pressScale;
  double? durationMilliseconds;
  EditorColor? selectedColor;
  EditorColor? disabledSelectedColor;
  EditorColor? backgroundColor;
  EditorColor? selectedBackgroundColor;
  String? curve;
  EditorControlBorder border = EditorControlBorder();
  EditorControlBorder selectedBorder = EditorControlBorder();
  void resetState(String state) {
    switch (state) {
      case 'selected':
        selectedColor = null;
        selectedBackgroundColor = null;
        selectedBorder = EditorControlBorder();
      case 'unselected':
        backgroundColor = null;
        border = EditorControlBorder();
      case 'disabled':
        disabledSelectedColor = null;
      case 'pressed':
        pressScale = null;
    }
  }

  Map<String, Object?> toJson() => {
    if (pressScale != null) 'pressScale': pressScale,
    if (durationMilliseconds != null)
      'durationMilliseconds': durationMilliseconds,
    if (curve != null) 'curve': curve,
    if (selectedColor != null) 'selectedColor': selectedColor!.toJson(),
    if (disabledSelectedColor != null)
      'disabledSelectedColor': disabledSelectedColor!.toJson(),
    if (backgroundColor != null) 'backgroundColor': backgroundColor!.toJson(),
    if (selectedBackgroundColor != null)
      'selectedBackgroundColor': selectedBackgroundColor!.toJson(),
    if (border.toJson().isNotEmpty) 'border': border.toJson(),
    if (selectedBorder.toJson().isNotEmpty)
      'selectedBorder': selectedBorder.toJson(),
  };
  static EditorRadioVisual fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'pressScale',
        'durationMilliseconds',
        'selectedColor',
        'disabledSelectedColor',
        'backgroundColor',
        'selectedBackgroundColor',
        'curve',
        'border',
        'selectedBorder',
      }.contains(k),
    )) {
      throw const FormatException('不支持的控件外观字段');
    }
    if (j['curve'] != null &&
        !['linear', 'easeInOut', 'fastOutSlowIn'].contains(j['curve'])) {
      throw const FormatException('无效 curve');
    }
    return EditorRadioVisual()
      ..pressScale = number(j['pressScale'], min: 0.5, max: 1.5)
      ..durationMilliseconds = number(
        j['durationMilliseconds'],
        min: 0,
        max: 5000,
      )
      ..selectedColor = j['selectedColor'] == null
          ? null
          : EditorColor.fromJson(j['selectedColor'] as Map<String, dynamic>)
      ..disabledSelectedColor = j['disabledSelectedColor'] == null
          ? null
          : EditorColor.fromJson(
              j['disabledSelectedColor'] as Map<String, dynamic>,
            )
      ..backgroundColor = j['backgroundColor'] == null
          ? null
          : EditorColor.fromJson(j['backgroundColor'] as Map<String, dynamic>)
      ..selectedBackgroundColor = j['selectedBackgroundColor'] == null
          ? null
          : EditorColor.fromJson(
              j['selectedBackgroundColor'] as Map<String, dynamic>,
            )
      ..curve = j['curve'] as String?
      ..border = EditorControlBorder.fromJson(
        (j['border'] as Map<String, dynamic>?) ?? {},
      )
      ..selectedBorder = EditorControlBorder.fromJson(
        (j['selectedBorder'] as Map<String, dynamic>?) ?? {},
      );
  }

  HyperRadioStyle resolve(HyperColorScheme colors) => HyperRadioStyle(
    selectedColor: selectedColor?.resolve(colors),
    disabledSelectedColor: disabledSelectedColor?.resolve(colors),
    backgroundColor: backgroundColor?.resolve(colors),
    selectedBackgroundColor: selectedBackgroundColor?.resolve(colors),
    pressScale: pressScale,
    duration: durationMilliseconds == null
        ? null
        : Duration(milliseconds: durationMilliseconds!.round()),
    curve: editorControlCurve(curve),
    border: border.resolve(colors),
    selectedBorder: selectedBorder.resolve(
      colors,
      fallbackColor: colors.primary,
    ),
  );
}

class EditorRadioMetrics {
  double? size;
  double? minimumTapTargetSize;
  double? indicatorSize;
  double? markSize;
  double? strokeWidth;
  double? radius;
  Map<String, Object?> toJson() => {
    if (size != null) 'size': size,
    if (minimumTapTargetSize != null)
      'minimumTapTargetSize': minimumTapTargetSize,
    if (indicatorSize != null) 'indicatorSize': indicatorSize,
    if (markSize != null) 'markSize': markSize,
    if (strokeWidth != null) 'strokeWidth': strokeWidth,
    if (radius != null) 'radius': radius,
  };
  static EditorRadioMetrics fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'size',
        'minimumTapTargetSize',
        'indicatorSize',
        'markSize',
        'strokeWidth',
        'radius',
      }.contains(k),
    )) {
      throw const FormatException('不支持的控件尺寸字段');
    }
    return EditorRadioMetrics()
      ..size = number(j['size'], min: 0, max: 1000)
      ..minimumTapTargetSize = number(
        j['minimumTapTargetSize'],
        min: 0,
        max: 1000,
      )
      ..indicatorSize = number(j['indicatorSize'], min: 0, max: 1000)
      ..markSize = number(j['markSize'], min: 0, max: 1000)
      ..strokeWidth = number(j['strokeWidth'], min: 0, max: 1000)
      ..radius = number(j['radius'], min: 0, max: 1000);
  }

  HyperRadioSize resolve(HyperRadioSize base) => base.copyWith(
    size: size,
    minimumTapTargetSize: minimumTapTargetSize,
    indicatorSize: indicatorSize,
    markSize: markSize,
    strokeWidth: strokeWidth,
    radius: radius,
  );
}

class EditorCheckboxVisual {
  double? pressScale;
  double? durationMilliseconds;
  EditorColor? activeColor;
  EditorColor? inactiveColor;
  EditorColor? checkColor;
  EditorColor? disabledColor;
  EditorColor? disabledCheckColor;
  EditorColor? overlayColor;
  String? curve;
  EditorControlBorder border = EditorControlBorder();
  void resetState(String state) {
    switch (state) {
      case 'selected':
        activeColor = null;
        checkColor = null;
      case 'unselected':
        inactiveColor = null;
      case 'disabled':
        disabledColor = null;
        disabledCheckColor = null;
      case 'hovered':
        overlayColor = null;
      case 'pressed':
        overlayColor = null;
        pressScale = null;
    }
  }

  Map<String, Object?> toJson() => {
    if (pressScale != null) 'pressScale': pressScale,
    if (durationMilliseconds != null)
      'durationMilliseconds': durationMilliseconds,
    if (curve != null) 'curve': curve,
    if (activeColor != null) 'activeColor': activeColor!.toJson(),
    if (inactiveColor != null) 'inactiveColor': inactiveColor!.toJson(),
    if (checkColor != null) 'checkColor': checkColor!.toJson(),
    if (disabledColor != null) 'disabledColor': disabledColor!.toJson(),
    if (disabledCheckColor != null)
      'disabledCheckColor': disabledCheckColor!.toJson(),
    if (overlayColor != null) 'overlayColor': overlayColor!.toJson(),
    if (border.toJson().isNotEmpty) 'border': border.toJson(),
  };
  static EditorCheckboxVisual fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'pressScale',
        'durationMilliseconds',
        'activeColor',
        'inactiveColor',
        'checkColor',
        'disabledColor',
        'disabledCheckColor',
        'overlayColor',
        'curve',
        'border',
      }.contains(k),
    )) {
      throw const FormatException('不支持的控件外观字段');
    }
    if (j['curve'] != null &&
        !['linear', 'easeInOut', 'fastOutSlowIn'].contains(j['curve'])) {
      throw const FormatException('无效 curve');
    }
    return EditorCheckboxVisual()
      ..pressScale = number(j['pressScale'], min: 0.5, max: 1.5)
      ..durationMilliseconds = number(
        j['durationMilliseconds'],
        min: 0,
        max: 5000,
      )
      ..activeColor = j['activeColor'] == null
          ? null
          : EditorColor.fromJson(j['activeColor'] as Map<String, dynamic>)
      ..inactiveColor = j['inactiveColor'] == null
          ? null
          : EditorColor.fromJson(j['inactiveColor'] as Map<String, dynamic>)
      ..checkColor = j['checkColor'] == null
          ? null
          : EditorColor.fromJson(j['checkColor'] as Map<String, dynamic>)
      ..disabledColor = j['disabledColor'] == null
          ? null
          : EditorColor.fromJson(j['disabledColor'] as Map<String, dynamic>)
      ..disabledCheckColor = j['disabledCheckColor'] == null
          ? null
          : EditorColor.fromJson(
              j['disabledCheckColor'] as Map<String, dynamic>,
            )
      ..overlayColor = j['overlayColor'] == null
          ? null
          : EditorColor.fromJson(j['overlayColor'] as Map<String, dynamic>)
      ..curve = j['curve'] as String?
      ..border = EditorControlBorder.fromJson(
        (j['border'] as Map<String, dynamic>?) ?? {},
      );
  }

  HyperCheckboxStyle resolve(HyperColorScheme colors) => HyperCheckboxStyle(
    activeColor: activeColor?.resolve(colors),
    inactiveColor: inactiveColor?.resolve(colors),
    checkColor: checkColor?.resolve(colors),
    disabledColor: disabledColor?.resolve(colors),
    disabledCheckColor: disabledCheckColor?.resolve(colors),
    overlayColor: overlayColor?.resolve(colors),
    pressScale: pressScale,
    duration: durationMilliseconds == null
        ? null
        : Duration(milliseconds: durationMilliseconds!.round()),
    curve: editorControlCurve(curve),
    border: border.resolve(colors),
  );
}

class EditorCheckboxMetrics {
  double? size;
  double? markStrokeWidth;
  double? roundedRadius;
  double? minimumTapTargetSize;
  double? circleRadius;
  Map<String, Object?> toJson() => {
    if (size != null) 'size': size,
    if (markStrokeWidth != null) 'markStrokeWidth': markStrokeWidth,
    if (roundedRadius != null) 'roundedRadius': roundedRadius,
    if (minimumTapTargetSize != null)
      'minimumTapTargetSize': minimumTapTargetSize,
    if (circleRadius != null) 'circleRadius': circleRadius,
  };
  static EditorCheckboxMetrics fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'size',
        'markStrokeWidth',
        'roundedRadius',
        'minimumTapTargetSize',
        'circleRadius',
      }.contains(k),
    )) {
      throw const FormatException('不支持的控件尺寸字段');
    }
    return EditorCheckboxMetrics()
      ..size = number(j['size'], min: 0, max: 1000)
      ..markStrokeWidth = number(j['markStrokeWidth'], min: 0, max: 1000)
      ..roundedRadius = number(j['roundedRadius'], min: 0, max: 1000)
      ..minimumTapTargetSize = number(
        j['minimumTapTargetSize'],
        min: 0,
        max: 1000,
      )
      ..circleRadius = number(j['circleRadius'], min: 0, max: 1000);
  }

  HyperCheckboxSize resolve(HyperCheckboxSize base) => base.copyWith(
    size: size,
    markStrokeWidth: markStrokeWidth,
    roundedRadius: roundedRadius,
    minimumTapTargetSize: minimumTapTargetSize,
    circleRadius: circleRadius,
  );
}

class EditorSwitchVisual {
  double? interactionThumbScale;
  double? durationMilliseconds;
  EditorColor? activeTrackColor;
  EditorColor? inactiveTrackColor;
  EditorColor? disabledTrackColor;
  EditorColor? disabledActiveTrackColor;
  EditorColor? disabledInactiveTrackColor;
  EditorColor? activeThumbColor;
  EditorColor? inactiveThumbColor;
  EditorColor? disabledThumbColor;
  EditorColor? disabledActiveThumbColor;
  EditorColor? disabledInactiveThumbColor;
  EditorColor? overlayColor;
  String? curve;
  EditorControlBorder border = EditorControlBorder();
  void resetState(String state) {
    switch (state) {
      case 'selected':
        activeTrackColor = null;
        activeThumbColor = null;
      case 'unselected':
        inactiveTrackColor = null;
        inactiveThumbColor = null;
      case 'disabled':
        disabledTrackColor = null;
        disabledActiveTrackColor = null;
        disabledInactiveTrackColor = null;
        disabledThumbColor = null;
        disabledActiveThumbColor = null;
        disabledInactiveThumbColor = null;
      case 'hovered':
        overlayColor = null;
        interactionThumbScale = null;
      case 'pressed':
        overlayColor = null;
        interactionThumbScale = null;
    }
  }

  Map<String, Object?> toJson() => {
    if (interactionThumbScale != null)
      'interactionThumbScale': interactionThumbScale,
    if (durationMilliseconds != null)
      'durationMilliseconds': durationMilliseconds,
    if (curve != null) 'curve': curve,
    if (activeTrackColor != null)
      'activeTrackColor': activeTrackColor!.toJson(),
    if (inactiveTrackColor != null)
      'inactiveTrackColor': inactiveTrackColor!.toJson(),
    if (disabledTrackColor != null)
      'disabledTrackColor': disabledTrackColor!.toJson(),
    if (disabledActiveTrackColor != null)
      'disabledActiveTrackColor': disabledActiveTrackColor!.toJson(),
    if (disabledInactiveTrackColor != null)
      'disabledInactiveTrackColor': disabledInactiveTrackColor!.toJson(),
    if (activeThumbColor != null)
      'activeThumbColor': activeThumbColor!.toJson(),
    if (inactiveThumbColor != null)
      'inactiveThumbColor': inactiveThumbColor!.toJson(),
    if (disabledThumbColor != null)
      'disabledThumbColor': disabledThumbColor!.toJson(),
    if (disabledActiveThumbColor != null)
      'disabledActiveThumbColor': disabledActiveThumbColor!.toJson(),
    if (disabledInactiveThumbColor != null)
      'disabledInactiveThumbColor': disabledInactiveThumbColor!.toJson(),
    if (overlayColor != null) 'overlayColor': overlayColor!.toJson(),
    if (border.toJson().isNotEmpty) 'border': border.toJson(),
  };
  static EditorSwitchVisual fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'interactionThumbScale',
        'durationMilliseconds',
        'activeTrackColor',
        'inactiveTrackColor',
        'disabledTrackColor',
        'disabledActiveTrackColor',
        'disabledInactiveTrackColor',
        'activeThumbColor',
        'inactiveThumbColor',
        'disabledThumbColor',
        'disabledActiveThumbColor',
        'disabledInactiveThumbColor',
        'overlayColor',
        'curve',
        'border',
      }.contains(k),
    )) {
      throw const FormatException('不支持的控件外观字段');
    }
    if (j['curve'] != null &&
        !['linear', 'easeInOut', 'fastOutSlowIn'].contains(j['curve'])) {
      throw const FormatException('无效 curve');
    }
    return EditorSwitchVisual()
      ..interactionThumbScale = number(
        j['interactionThumbScale'],
        min: 0.5,
        max: 2,
      )
      ..durationMilliseconds = number(
        j['durationMilliseconds'],
        min: 0,
        max: 5000,
      )
      ..activeTrackColor = j['activeTrackColor'] == null
          ? null
          : EditorColor.fromJson(j['activeTrackColor'] as Map<String, dynamic>)
      ..inactiveTrackColor = j['inactiveTrackColor'] == null
          ? null
          : EditorColor.fromJson(
              j['inactiveTrackColor'] as Map<String, dynamic>,
            )
      ..disabledTrackColor = j['disabledTrackColor'] == null
          ? null
          : EditorColor.fromJson(
              j['disabledTrackColor'] as Map<String, dynamic>,
            )
      ..disabledActiveTrackColor = j['disabledActiveTrackColor'] == null
          ? null
          : EditorColor.fromJson(
              j['disabledActiveTrackColor'] as Map<String, dynamic>,
            )
      ..disabledInactiveTrackColor = j['disabledInactiveTrackColor'] == null
          ? null
          : EditorColor.fromJson(
              j['disabledInactiveTrackColor'] as Map<String, dynamic>,
            )
      ..activeThumbColor = j['activeThumbColor'] == null
          ? null
          : EditorColor.fromJson(j['activeThumbColor'] as Map<String, dynamic>)
      ..inactiveThumbColor = j['inactiveThumbColor'] == null
          ? null
          : EditorColor.fromJson(
              j['inactiveThumbColor'] as Map<String, dynamic>,
            )
      ..disabledThumbColor = j['disabledThumbColor'] == null
          ? null
          : EditorColor.fromJson(
              j['disabledThumbColor'] as Map<String, dynamic>,
            )
      ..disabledActiveThumbColor = j['disabledActiveThumbColor'] == null
          ? null
          : EditorColor.fromJson(
              j['disabledActiveThumbColor'] as Map<String, dynamic>,
            )
      ..disabledInactiveThumbColor = j['disabledInactiveThumbColor'] == null
          ? null
          : EditorColor.fromJson(
              j['disabledInactiveThumbColor'] as Map<String, dynamic>,
            )
      ..overlayColor = j['overlayColor'] == null
          ? null
          : EditorColor.fromJson(j['overlayColor'] as Map<String, dynamic>)
      ..curve = j['curve'] as String?
      ..border = EditorControlBorder.fromJson(
        (j['border'] as Map<String, dynamic>?) ?? {},
      );
  }

  HyperSwitchStyle resolve(HyperColorScheme colors) => HyperSwitchStyle(
    activeTrackColor: activeTrackColor?.resolve(colors),
    inactiveTrackColor: inactiveTrackColor?.resolve(colors),
    disabledTrackColor: disabledTrackColor?.resolve(colors),
    disabledActiveTrackColor: disabledActiveTrackColor?.resolve(colors),
    disabledInactiveTrackColor: disabledInactiveTrackColor?.resolve(colors),
    activeThumbColor: activeThumbColor?.resolve(colors),
    inactiveThumbColor: inactiveThumbColor?.resolve(colors),
    disabledThumbColor: disabledThumbColor?.resolve(colors),
    disabledActiveThumbColor: disabledActiveThumbColor?.resolve(colors),
    disabledInactiveThumbColor: disabledInactiveThumbColor?.resolve(colors),
    overlayColor: overlayColor?.resolve(colors),
    interactionThumbScale: interactionThumbScale,
    duration: durationMilliseconds == null
        ? null
        : Duration(milliseconds: durationMilliseconds!.round()),
    curve: editorControlCurve(curve),
    border: border.resolve(colors),
  );
}

class EditorSwitchMetrics {
  double? width;
  double? height;
  double? thumbSize;
  double? thumbInset;
  double? minimumTapTargetSize;
  double? radius;
  double? thumbRadius;
  double? uncheckedThumbOffset;
  double? checkedThumbOffset;
  Map<String, Object?> toJson() => {
    if (width != null) 'width': width,
    if (height != null) 'height': height,
    if (thumbSize != null) 'thumbSize': thumbSize,
    if (thumbInset != null) 'thumbInset': thumbInset,
    if (minimumTapTargetSize != null)
      'minimumTapTargetSize': minimumTapTargetSize,
    if (radius != null) 'radius': radius,
    if (thumbRadius != null) 'thumbRadius': thumbRadius,
    if (uncheckedThumbOffset != null)
      'uncheckedThumbOffset': uncheckedThumbOffset,
    if (checkedThumbOffset != null) 'checkedThumbOffset': checkedThumbOffset,
  };
  static EditorSwitchMetrics fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'width',
        'height',
        'thumbSize',
        'thumbInset',
        'minimumTapTargetSize',
        'radius',
        'thumbRadius',
        'uncheckedThumbOffset',
        'checkedThumbOffset',
      }.contains(k),
    )) {
      throw const FormatException('不支持的控件尺寸字段');
    }
    return EditorSwitchMetrics()
      ..width = number(j['width'], min: 0, max: 1000)
      ..height = number(j['height'], min: 0, max: 1000)
      ..thumbSize = number(j['thumbSize'], min: 0, max: 1000)
      ..thumbInset = number(j['thumbInset'], min: 0, max: 1000)
      ..minimumTapTargetSize = number(
        j['minimumTapTargetSize'],
        min: 0,
        max: 1000,
      )
      ..radius = number(j['radius'], min: 0, max: 1000)
      ..thumbRadius = number(j['thumbRadius'], min: 0, max: 1000)
      ..uncheckedThumbOffset = number(
        j['uncheckedThumbOffset'],
        min: 0,
        max: 1000,
      )
      ..checkedThumbOffset = number(j['checkedThumbOffset'], min: 0, max: 1000);
  }

  HyperSwitchSize resolve(HyperSwitchSize base) {
    final result = base.copyWith(
      width: width,
      height: height,
      thumbSize: thumbSize,
      thumbInset: thumbInset,
      minimumTapTargetSize: minimumTapTargetSize,
      radius: radius,
      thumbRadius: thumbRadius,
      uncheckedThumbOffset: uncheckedThumbOffset,
      checkedThumbOffset: checkedThumbOffset,
    );
    final travelEnd =
        result.checkedThumbOffset ??
        result.width - result.thumbSize - result.thumbInset;
    final travelStart = result.uncheckedThumbOffset ?? result.thumbInset;
    if (result.width < result.thumbSize + 2 * result.thumbInset ||
        result.height < result.thumbSize ||
        travelEnd < travelStart ||
        travelStart < 0 ||
        travelEnd > result.width - result.thumbSize) {
      throw const FormatException('开关尺寸需容纳滑块和边缘距离，开启偏移不得小于关闭偏移');
    }
    return result;
  }
}
