import 'editor_theme_document.dart';

class EditorExtendedVisual {
  EditorExtendedVisual();
  EditorColor? ratingActive;
  EditorColor? ratingInactive;
  EditorColor? ratingHover;
  EditorColor? ratingFocus;
  EditorColor? ratingDisabled;
  EditorColor? transferTitle;
  EditorColor? transferEmpty;
  EditorColor? transferBackground;
  EditorColor? transferBorder;
  EditorColor? resizableColor;
  EditorColor? resizableActive;
  EditorColor? resizableFocus;
  EditorColor? navigationText;
  EditorColor? navigationSelectedText;
  EditorColor? navigationBackground;
  EditorColor? navigationBorder;
  Map<String, Object?> toJson() => {
    if (ratingActive != null) 'ratingActive': ratingActive!.toJson(),
    if (ratingInactive != null) 'ratingInactive': ratingInactive!.toJson(),
    if (ratingHover != null) 'ratingHover': ratingHover!.toJson(),
    if (ratingFocus != null) 'ratingFocus': ratingFocus!.toJson(),
    if (ratingDisabled != null) 'ratingDisabled': ratingDisabled!.toJson(),
    if (transferTitle != null) 'transferTitle': transferTitle!.toJson(),
    if (transferEmpty != null) 'transferEmpty': transferEmpty!.toJson(),
    if (transferBackground != null)
      'transferBackground': transferBackground!.toJson(),
    if (transferBorder != null) 'transferBorder': transferBorder!.toJson(),
    if (resizableColor != null) 'resizableColor': resizableColor!.toJson(),
    if (resizableActive != null) 'resizableActive': resizableActive!.toJson(),
    if (resizableFocus != null) 'resizableFocus': resizableFocus!.toJson(),
    if (navigationText != null) 'navigationText': navigationText!.toJson(),
    if (navigationSelectedText != null)
      'navigationSelectedText': navigationSelectedText!.toJson(),
    if (navigationBackground != null)
      'navigationBackground': navigationBackground!.toJson(),
    if (navigationBorder != null)
      'navigationBorder': navigationBorder!.toJson(),
  };
  factory EditorExtendedVisual.fromJson(Map<String, dynamic> json) {
    final allowed = {
      'ratingActive',
      'ratingInactive',
      'ratingHover',
      'ratingFocus',
      'ratingDisabled',
      'transferTitle',
      'transferEmpty',
      'transferBackground',
      'transferBorder',
      'resizableColor',
      'resizableActive',
      'resizableFocus',
      'navigationText',
      'navigationSelectedText',
      'navigationBackground',
      'navigationBorder',
    };
    if (json.keys.any((key) => !allowed.contains(key))) {
      throw const FormatException('未知扩展控件字段');
    }
    final result = EditorExtendedVisual();
    result.ratingActive = json['ratingActive'] == null
        ? null
        : EditorColor.fromJson(json['ratingActive'] as Map<String, dynamic>);
    result.ratingInactive = json['ratingInactive'] == null
        ? null
        : EditorColor.fromJson(json['ratingInactive'] as Map<String, dynamic>);
    result.ratingHover = json['ratingHover'] == null
        ? null
        : EditorColor.fromJson(json['ratingHover'] as Map<String, dynamic>);
    result.ratingFocus = json['ratingFocus'] == null
        ? null
        : EditorColor.fromJson(json['ratingFocus'] as Map<String, dynamic>);
    result.ratingDisabled = json['ratingDisabled'] == null
        ? null
        : EditorColor.fromJson(json['ratingDisabled'] as Map<String, dynamic>);
    result.transferTitle = json['transferTitle'] == null
        ? null
        : EditorColor.fromJson(json['transferTitle'] as Map<String, dynamic>);
    result.transferEmpty = json['transferEmpty'] == null
        ? null
        : EditorColor.fromJson(json['transferEmpty'] as Map<String, dynamic>);
    result.transferBackground = json['transferBackground'] == null
        ? null
        : EditorColor.fromJson(
            json['transferBackground'] as Map<String, dynamic>,
          );
    result.transferBorder = json['transferBorder'] == null
        ? null
        : EditorColor.fromJson(json['transferBorder'] as Map<String, dynamic>);
    result.resizableColor = json['resizableColor'] == null
        ? null
        : EditorColor.fromJson(json['resizableColor'] as Map<String, dynamic>);
    result.resizableActive = json['resizableActive'] == null
        ? null
        : EditorColor.fromJson(json['resizableActive'] as Map<String, dynamic>);
    result.resizableFocus = json['resizableFocus'] == null
        ? null
        : EditorColor.fromJson(json['resizableFocus'] as Map<String, dynamic>);
    result.navigationText = json['navigationText'] == null
        ? null
        : EditorColor.fromJson(json['navigationText'] as Map<String, dynamic>);
    result.navigationSelectedText = json['navigationSelectedText'] == null
        ? null
        : EditorColor.fromJson(
            json['navigationSelectedText'] as Map<String, dynamic>,
          );
    result.navigationBackground = json['navigationBackground'] == null
        ? null
        : EditorColor.fromJson(
            json['navigationBackground'] as Map<String, dynamic>,
          );
    result.navigationBorder = json['navigationBorder'] == null
        ? null
        : EditorColor.fromJson(
            json['navigationBorder'] as Map<String, dynamic>,
          );
    return result;
  }
}

class EditorExtendedMetrics {
  EditorExtendedMetrics();
  double? ratingIconSize;
  double? ratingGap;
  double? ratingHitExtent;
  double? transferHeight;
  double? transferWidth;
  double? transferGap;
  double? transferRadius;
  double? resizableHandleExtent;
  double? resizableThickness;
  double? navigationIconSize;
  double? navigationGap;
  double? navigationItemSpacing;
  double? navigationRadius;
  Map<String, Object?> toJson() => {
    if (ratingIconSize != null) 'ratingIconSize': ratingIconSize,
    if (ratingGap != null) 'ratingGap': ratingGap,
    if (ratingHitExtent != null) 'ratingHitExtent': ratingHitExtent,
    if (transferHeight != null) 'transferHeight': transferHeight,
    if (transferWidth != null) 'transferWidth': transferWidth,
    if (transferGap != null) 'transferGap': transferGap,
    if (transferRadius != null) 'transferRadius': transferRadius,
    if (resizableHandleExtent != null)
      'resizableHandleExtent': resizableHandleExtent,
    if (resizableThickness != null) 'resizableThickness': resizableThickness,
    if (navigationIconSize != null) 'navigationIconSize': navigationIconSize,
    if (navigationGap != null) 'navigationGap': navigationGap,
    if (navigationItemSpacing != null)
      'navigationItemSpacing': navigationItemSpacing,
    if (navigationRadius != null) 'navigationRadius': navigationRadius,
  };
  factory EditorExtendedMetrics.fromJson(Map<String, dynamic> json) {
    final allowed = {
      'ratingIconSize',
      'ratingGap',
      'ratingHitExtent',
      'transferHeight',
      'transferWidth',
      'transferGap',
      'transferRadius',
      'resizableHandleExtent',
      'resizableThickness',
      'navigationIconSize',
      'navigationGap',
      'navigationItemSpacing',
      'navigationRadius',
    };
    if (json.keys.any((key) => !allowed.contains(key))) {
      throw const FormatException('未知扩展控件字段');
    }
    final result = EditorExtendedMetrics();
    result.ratingIconSize = json['ratingIconSize'] == null
        ? null
        : _dimension(json['ratingIconSize']);
    result.ratingGap = json['ratingGap'] == null
        ? null
        : _dimension(json['ratingGap']);
    result.ratingHitExtent = json['ratingHitExtent'] == null
        ? null
        : _dimension(json['ratingHitExtent']);
    result.transferHeight = json['transferHeight'] == null
        ? null
        : _dimension(json['transferHeight']);
    result.transferWidth = json['transferWidth'] == null
        ? null
        : _dimension(json['transferWidth']);
    result.transferGap = json['transferGap'] == null
        ? null
        : _dimension(json['transferGap']);
    result.transferRadius = json['transferRadius'] == null
        ? null
        : _dimension(json['transferRadius']);
    result.resizableHandleExtent = json['resizableHandleExtent'] == null
        ? null
        : _dimension(json['resizableHandleExtent']);
    result.resizableThickness = json['resizableThickness'] == null
        ? null
        : _dimension(json['resizableThickness']);
    result.navigationIconSize = json['navigationIconSize'] == null
        ? null
        : _dimension(json['navigationIconSize']);
    result.navigationGap = json['navigationGap'] == null
        ? null
        : _dimension(json['navigationGap']);
    result.navigationItemSpacing = json['navigationItemSpacing'] == null
        ? null
        : _dimension(json['navigationItemSpacing']);
    result.navigationRadius = json['navigationRadius'] == null
        ? null
        : _dimension(json['navigationRadius']);
    return result;
  }
}

double _dimension(dynamic value) {
  if (value is! num || !value.isFinite || value < 0) {
    throw const FormatException('尺寸须有限且非负');
  }
  return value.toDouble();
}
