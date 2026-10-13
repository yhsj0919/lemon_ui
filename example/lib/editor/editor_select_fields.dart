import 'editor_theme_document.dart';

class EditorSelectVisual {
  String? checkPlacement, checkIcon;
  EditorColor? checkColor;
  double? checkSize, checkSpacing;
  bool? showCheckmark;
  EditorColor? arrowColor;
  EditorColor? disabledArrowColor;
  EditorColor? selectedBackgroundColor;
  EditorColor? selectedForegroundColor;
  EditorColor? activeBackgroundColor;
  EditorColor? optionForegroundColor;
  EditorColor? disabledOptionColor;
  EditorColor? searchHintColor;
  double? labelFontSize;
  double? optionFontSize;
  double? searchFontSize;
  double? searchDebounce;
  double? durationMilliseconds;
  Map<String, Object?> toJson() => {
    if (checkPlacement != null) 'checkPlacement': checkPlacement,
    if (checkIcon != null) 'checkIcon': checkIcon,
    if (checkColor != null) 'checkColor': checkColor!.toJson(),
    if (checkSize != null) 'checkSize': checkSize,
    if (checkSpacing != null) 'checkSpacing': checkSpacing,
    if (showCheckmark != null) 'showCheckmark': showCheckmark,
    if (arrowColor != null) 'arrowColor': arrowColor!.toJson(),
    if (disabledArrowColor != null)
      'disabledArrowColor': disabledArrowColor!.toJson(),
    if (selectedBackgroundColor != null)
      'selectedBackgroundColor': selectedBackgroundColor!.toJson(),
    if (selectedForegroundColor != null)
      'selectedForegroundColor': selectedForegroundColor!.toJson(),
    if (activeBackgroundColor != null)
      'activeBackgroundColor': activeBackgroundColor!.toJson(),
    if (optionForegroundColor != null)
      'optionForegroundColor': optionForegroundColor!.toJson(),
    if (disabledOptionColor != null)
      'disabledOptionColor': disabledOptionColor!.toJson(),
    if (searchHintColor != null) 'searchHintColor': searchHintColor!.toJson(),
    if (labelFontSize != null) 'labelFontSize': labelFontSize,
    if (optionFontSize != null) 'optionFontSize': optionFontSize,
    if (searchFontSize != null) 'searchFontSize': searchFontSize,
    if (searchDebounce != null) 'searchDebounce': searchDebounce,
    if (durationMilliseconds != null)
      'durationMilliseconds': durationMilliseconds,
  };
  static EditorSelectVisual fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'checkPlacement',
        'checkIcon',
        'checkColor',
        'checkSize',
        'checkSpacing',
        'showCheckmark',
        'arrowColor',
        'disabledArrowColor',
        'selectedBackgroundColor',
        'selectedForegroundColor',
        'activeBackgroundColor',
        'optionForegroundColor',
        'disabledOptionColor',
        'searchHintColor',
        'labelFontSize',
        'optionFontSize',
        'searchFontSize',
        'searchDebounce',
        'durationMilliseconds',
      }.contains(k),
    )) {
      throw const FormatException('不支持的选择器属性');
    }
    if (j['showCheckmark'] != null && j['showCheckmark'] is! bool) {
      throw const FormatException('选中对勾配置必须为布尔值');
    }
    if (j['checkPlacement'] != null &&
        !['leading', 'trailing'].contains(j['checkPlacement'])) {
      throw const FormatException('无效选中图标位置');
    }
    if (j['checkIcon'] != null &&
        !['check', 'doneAll', 'radio', 'star'].contains(j['checkIcon'])) {
      throw const FormatException('无效选中图标');
    }
    return EditorSelectVisual()
      ..checkPlacement = j['checkPlacement'] as String?
      ..checkIcon = j['checkIcon'] as String?
      ..checkColor = j['checkColor'] == null
          ? null
          : EditorColor.fromJson(j['checkColor'] as Map<String, dynamic>)
      ..checkSize = number(j['checkSize'], min: 0, max: 80)
      ..checkSpacing = number(j['checkSpacing'], min: 0, max: 80)
      ..showCheckmark = j['showCheckmark'] as bool?
      ..arrowColor = j['arrowColor'] == null
          ? null
          : EditorColor.fromJson(j['arrowColor'] as Map<String, dynamic>)
      ..disabledArrowColor = j['disabledArrowColor'] == null
          ? null
          : EditorColor.fromJson(
              j['disabledArrowColor'] as Map<String, dynamic>,
            )
      ..selectedBackgroundColor = j['selectedBackgroundColor'] == null
          ? null
          : EditorColor.fromJson(
              j['selectedBackgroundColor'] as Map<String, dynamic>,
            )
      ..selectedForegroundColor = j['selectedForegroundColor'] == null
          ? null
          : EditorColor.fromJson(
              j['selectedForegroundColor'] as Map<String, dynamic>,
            )
      ..activeBackgroundColor = j['activeBackgroundColor'] == null
          ? null
          : EditorColor.fromJson(
              j['activeBackgroundColor'] as Map<String, dynamic>,
            )
      ..optionForegroundColor = j['optionForegroundColor'] == null
          ? null
          : EditorColor.fromJson(
              j['optionForegroundColor'] as Map<String, dynamic>,
            )
      ..disabledOptionColor = j['disabledOptionColor'] == null
          ? null
          : EditorColor.fromJson(
              j['disabledOptionColor'] as Map<String, dynamic>,
            )
      ..searchHintColor = j['searchHintColor'] == null
          ? null
          : EditorColor.fromJson(j['searchHintColor'] as Map<String, dynamic>)
      ..labelFontSize = number(j['labelFontSize'], min: 8, max: 1000)
      ..optionFontSize = number(j['optionFontSize'], min: 8, max: 1000)
      ..searchFontSize = number(j['searchFontSize'], min: 8, max: 1000)
      ..searchDebounce = number(j['searchDebounce'], min: 0, max: 5000)
      ..durationMilliseconds = number(
        j['durationMilliseconds'],
        min: 0,
        max: 5000,
      );
  }
}

class EditorSelectMetrics {
  double? minimumTapTargetSize;
  double? radius;
  double? paddingVertical;
  double? paddingHorizontal;
  double? minimumHeight;
  double? width;
  double? arrowSize;
  double? arrowSpacing;
  double? maxPanelHeight;
  double? chipSpacing;
  double? minimumInputWidth;
  double? popupSpacing;
  double? itemHeight;
  double? itemPadding;
  double? itemSpacing;
  double? itemRadius;
  double? surfaceRadius;
  Map<String, Object?> toJson() => {
    if (minimumTapTargetSize != null)
      'minimumTapTargetSize': minimumTapTargetSize,
    if (radius != null) 'radius': radius,
    if (paddingVertical != null) 'paddingVertical': paddingVertical,
    if (paddingHorizontal != null) 'paddingHorizontal': paddingHorizontal,
    if (minimumHeight != null) 'minimumHeight': minimumHeight,
    if (width != null) 'width': width,
    if (arrowSize != null) 'arrowSize': arrowSize,
    if (arrowSpacing != null) 'arrowSpacing': arrowSpacing,
    if (maxPanelHeight != null) 'maxPanelHeight': maxPanelHeight,
    if (chipSpacing != null) 'chipSpacing': chipSpacing,
    if (minimumInputWidth != null) 'minimumInputWidth': minimumInputWidth,
    if (popupSpacing != null) 'popupSpacing': popupSpacing,
    if (itemHeight != null) 'itemHeight': itemHeight,
    if (itemPadding != null) 'itemPadding': itemPadding,
    if (itemSpacing != null) 'itemSpacing': itemSpacing,
    if (itemRadius != null) 'itemRadius': itemRadius,
    if (surfaceRadius != null) 'surfaceRadius': surfaceRadius,
  };
  static EditorSelectMetrics fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'minimumHeight',
        'paddingHorizontal',
        'paddingVertical',
        'radius',
        'minimumTapTargetSize',
        'width',
        'arrowSize',
        'arrowSpacing',
        'maxPanelHeight',
        'chipSpacing',
        'minimumInputWidth',
        'popupSpacing',
        'itemHeight',
        'itemPadding',
        'itemSpacing',
        'itemRadius',
        'surfaceRadius',
      }.contains(k),
    )) {
      throw const FormatException('不支持的选择器属性');
    }
    return EditorSelectMetrics()
      ..minimumTapTargetSize = number(
        j['minimumTapTargetSize'],
        min: 0,
        max: 1000,
      )
      ..radius = number(j['radius'], min: 0, max: 1000)
      ..paddingVertical = number(j['paddingVertical'], min: 0, max: 1000)
      ..paddingHorizontal = number(j['paddingHorizontal'], min: 0, max: 1000)
      ..minimumHeight = number(j['minimumHeight'], min: 0, max: 1000)
      ..width = number(j['width'], min: 0, max: 1000)
      ..arrowSize = number(j['arrowSize'], min: 0, max: 1000)
      ..arrowSpacing = number(j['arrowSpacing'], min: 0, max: 1000)
      ..maxPanelHeight = number(j['maxPanelHeight'], min: 0, max: 1000)
      ..chipSpacing = number(j['chipSpacing'], min: 0, max: 1000)
      ..minimumInputWidth = number(j['minimumInputWidth'], min: 0, max: 1000)
      ..popupSpacing = number(j['popupSpacing'], min: 0, max: 1000)
      ..itemHeight = number(j['itemHeight'], min: 0, max: 1000)
      ..itemPadding = number(j['itemPadding'], min: 0, max: 1000)
      ..itemSpacing = number(j['itemSpacing'], min: 0, max: 1000)
      ..itemRadius = number(j['itemRadius'], min: 0, max: 1000)
      ..surfaceRadius = number(j['surfaceRadius'], min: 0, max: 1000);
  }
}
