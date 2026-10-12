import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'editor_theme_document.dart' show number;

class EditorPalette {
  Color? primary;
  Color? onPrimary;
  Color? primaryContainer;
  Color? onPrimaryContainer;
  Color? background;
  Color? onBackground;
  Color? surface;
  Color? onSurface;
  Color? surfaceElevated;
  Color? onSurfaceElevated;
  Color? surfaceMuted;
  Color? onSurfaceMuted;
  Color? textPrimary;
  Color? textSecondary;
  Color? textTertiary;
  Color? outline;
  Color? disabled;
  Color? stateLayer;
  Color? scrim;
  Color? error;
  Color? onError;
  Color? success;
  Color? onSuccess;
  Color? warning;
  Color? onWarning;
  HyperColorScheme resolve(HyperColorScheme base) => base.copyWith(
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,
    background: background,
    onBackground: onBackground,
    surface: surface,
    onSurface: onSurface,
    surfaceElevated: surfaceElevated,
    onSurfaceElevated: onSurfaceElevated,
    surfaceMuted: surfaceMuted,
    onSurfaceMuted: onSurfaceMuted,
    textPrimary: textPrimary,
    textSecondary: textSecondary,
    textTertiary: textTertiary,
    outline: outline,
    disabled: disabled,
    stateLayer: stateLayer,
    scrim: scrim,
    error: error,
    onError: onError,
    success: success,
    onSuccess: onSuccess,
    warning: warning,
    onWarning: onWarning,
  );
  Map<String, Object?> toJson() => {
    if (primary != null) 'primary': primary!.toARGB32(),
    if (onPrimary != null) 'onPrimary': onPrimary!.toARGB32(),
    if (primaryContainer != null)
      'primaryContainer': primaryContainer!.toARGB32(),
    if (onPrimaryContainer != null)
      'onPrimaryContainer': onPrimaryContainer!.toARGB32(),
    if (background != null) 'background': background!.toARGB32(),
    if (onBackground != null) 'onBackground': onBackground!.toARGB32(),
    if (surface != null) 'surface': surface!.toARGB32(),
    if (onSurface != null) 'onSurface': onSurface!.toARGB32(),
    if (surfaceElevated != null) 'surfaceElevated': surfaceElevated!.toARGB32(),
    if (onSurfaceElevated != null)
      'onSurfaceElevated': onSurfaceElevated!.toARGB32(),
    if (surfaceMuted != null) 'surfaceMuted': surfaceMuted!.toARGB32(),
    if (onSurfaceMuted != null) 'onSurfaceMuted': onSurfaceMuted!.toARGB32(),
    if (textPrimary != null) 'textPrimary': textPrimary!.toARGB32(),
    if (textSecondary != null) 'textSecondary': textSecondary!.toARGB32(),
    if (textTertiary != null) 'textTertiary': textTertiary!.toARGB32(),
    if (outline != null) 'outline': outline!.toARGB32(),
    if (disabled != null) 'disabled': disabled!.toARGB32(),
    if (stateLayer != null) 'stateLayer': stateLayer!.toARGB32(),
    if (scrim != null) 'scrim': scrim!.toARGB32(),
    if (error != null) 'error': error!.toARGB32(),
    if (onError != null) 'onError': onError!.toARGB32(),
    if (success != null) 'success': success!.toARGB32(),
    if (onSuccess != null) 'onSuccess': onSuccess!.toARGB32(),
    if (warning != null) 'warning': warning!.toARGB32(),
    if (onWarning != null) 'onWarning': onWarning!.toARGB32(),
  };
  EditorPalette();
  factory EditorPalette.fromJson(Map<String, dynamic> json) {
    const allowed = {
      'primary',
      'onPrimary',
      'primaryContainer',
      'onPrimaryContainer',
      'background',
      'onBackground',
      'surface',
      'onSurface',
      'surfaceElevated',
      'onSurfaceElevated',
      'surfaceMuted',
      'onSurfaceMuted',
      'textPrimary',
      'textSecondary',
      'textTertiary',
      'outline',
      'disabled',
      'stateLayer',
      'scrim',
      'error',
      'onError',
      'success',
      'onSuccess',
      'warning',
      'onWarning',
    };
    if (json.keys.any((key) => !allowed.contains(key))) {
      throw const FormatException("不支持的全局字段");
    }
    return EditorPalette()
      ..primary = json['primary'] == null
          ? null
          : Color(number(json['primary'], min: 0, max: 4294967295)!.toInt())
      ..onPrimary = json['onPrimary'] == null
          ? null
          : Color(number(json['onPrimary'], min: 0, max: 4294967295)!.toInt())
      ..primaryContainer = json['primaryContainer'] == null
          ? null
          : Color(
              number(
                json['primaryContainer'],
                min: 0,
                max: 4294967295,
              )!.toInt(),
            )
      ..onPrimaryContainer = json['onPrimaryContainer'] == null
          ? null
          : Color(
              number(
                json['onPrimaryContainer'],
                min: 0,
                max: 4294967295,
              )!.toInt(),
            )
      ..background = json['background'] == null
          ? null
          : Color(number(json['background'], min: 0, max: 4294967295)!.toInt())
      ..onBackground = json['onBackground'] == null
          ? null
          : Color(
              number(json['onBackground'], min: 0, max: 4294967295)!.toInt(),
            )
      ..surface = json['surface'] == null
          ? null
          : Color(number(json['surface'], min: 0, max: 4294967295)!.toInt())
      ..onSurface = json['onSurface'] == null
          ? null
          : Color(number(json['onSurface'], min: 0, max: 4294967295)!.toInt())
      ..surfaceElevated = json['surfaceElevated'] == null
          ? null
          : Color(
              number(json['surfaceElevated'], min: 0, max: 4294967295)!.toInt(),
            )
      ..onSurfaceElevated = json['onSurfaceElevated'] == null
          ? null
          : Color(
              number(
                json['onSurfaceElevated'],
                min: 0,
                max: 4294967295,
              )!.toInt(),
            )
      ..surfaceMuted = json['surfaceMuted'] == null
          ? null
          : Color(
              number(json['surfaceMuted'], min: 0, max: 4294967295)!.toInt(),
            )
      ..onSurfaceMuted = json['onSurfaceMuted'] == null
          ? null
          : Color(
              number(json['onSurfaceMuted'], min: 0, max: 4294967295)!.toInt(),
            )
      ..textPrimary = json['textPrimary'] == null
          ? null
          : Color(number(json['textPrimary'], min: 0, max: 4294967295)!.toInt())
      ..textSecondary = json['textSecondary'] == null
          ? null
          : Color(
              number(json['textSecondary'], min: 0, max: 4294967295)!.toInt(),
            )
      ..textTertiary = json['textTertiary'] == null
          ? null
          : Color(
              number(json['textTertiary'], min: 0, max: 4294967295)!.toInt(),
            )
      ..outline = json['outline'] == null
          ? null
          : Color(number(json['outline'], min: 0, max: 4294967295)!.toInt())
      ..disabled = json['disabled'] == null
          ? null
          : Color(number(json['disabled'], min: 0, max: 4294967295)!.toInt())
      ..stateLayer = json['stateLayer'] == null
          ? null
          : Color(number(json['stateLayer'], min: 0, max: 4294967295)!.toInt())
      ..scrim = json['scrim'] == null
          ? null
          : Color(number(json['scrim'], min: 0, max: 4294967295)!.toInt())
      ..error = json['error'] == null
          ? null
          : Color(number(json['error'], min: 0, max: 4294967295)!.toInt())
      ..onError = json['onError'] == null
          ? null
          : Color(number(json['onError'], min: 0, max: 4294967295)!.toInt())
      ..success = json['success'] == null
          ? null
          : Color(number(json['success'], min: 0, max: 4294967295)!.toInt())
      ..onSuccess = json['onSuccess'] == null
          ? null
          : Color(number(json['onSuccess'], min: 0, max: 4294967295)!.toInt())
      ..warning = json['warning'] == null
          ? null
          : Color(number(json['warning'], min: 0, max: 4294967295)!.toInt())
      ..onWarning = json['onWarning'] == null
          ? null
          : Color(number(json['onWarning'], min: 0, max: 4294967295)!.toInt());
  }
}

class EditorTypography {
  double? displayLarge;
  double? displayMedium;
  double? displaySmall;
  double? pageTitle;
  double? sectionTitle;
  double? subsectionTitle;
  double? bodyLarge;
  double? bodySmall;
  double? breadcrumb;
  double? listTitle;
  double? listSubtitle;
  double? listTitleLineHeight;
  double? listSubtitleLineHeight;
  double? cardTitle;
  double? label;
  double? caption;
  HyperTypographyScheme resolve(HyperTypographyScheme base) => base.copyWith(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    pageTitle: pageTitle,
    sectionTitle: sectionTitle,
    subsectionTitle: subsectionTitle,
    bodyLarge: bodyLarge,
    bodySmall: bodySmall,
    breadcrumb: breadcrumb,
    listTitle: listTitle,
    listSubtitle: listSubtitle,
    listTitleLineHeight: listTitleLineHeight,
    listSubtitleLineHeight: listSubtitleLineHeight,
    cardTitle: cardTitle,
    label: label,
    caption: caption,
  );
  Map<String, Object?> toJson() => {
    if (displayLarge != null) 'displayLarge': displayLarge,
    if (displayMedium != null) 'displayMedium': displayMedium,
    if (displaySmall != null) 'displaySmall': displaySmall,
    if (pageTitle != null) 'pageTitle': pageTitle,
    if (sectionTitle != null) 'sectionTitle': sectionTitle,
    if (subsectionTitle != null) 'subsectionTitle': subsectionTitle,
    if (bodyLarge != null) 'bodyLarge': bodyLarge,
    if (bodySmall != null) 'bodySmall': bodySmall,
    if (breadcrumb != null) 'breadcrumb': breadcrumb,
    if (listTitle != null) 'listTitle': listTitle,
    if (listSubtitle != null) 'listSubtitle': listSubtitle,
    if (listTitleLineHeight != null) 'listTitleLineHeight': listTitleLineHeight,
    if (listSubtitleLineHeight != null)
      'listSubtitleLineHeight': listSubtitleLineHeight,
    if (cardTitle != null) 'cardTitle': cardTitle,
    if (label != null) 'label': label,
    if (caption != null) 'caption': caption,
  };
  EditorTypography();
  factory EditorTypography.fromJson(Map<String, dynamic> json) {
    const allowed = {
      'displayLarge',
      'displayMedium',
      'displaySmall',
      'pageTitle',
      'sectionTitle',
      'subsectionTitle',
      'bodyLarge',
      'bodySmall',
      'breadcrumb',
      'listTitle',
      'listSubtitle',
      'listTitleLineHeight',
      'listSubtitleLineHeight',
      'cardTitle',
      'label',
      'caption',
    };
    if (json.keys.any((key) => !allowed.contains(key))) {
      throw const FormatException("不支持的全局字段");
    }
    return EditorTypography()
      ..displayLarge = number(json['displayLarge'], min: 0, max: 500)
      ..displayMedium = number(json['displayMedium'], min: 0, max: 500)
      ..displaySmall = number(json['displaySmall'], min: 0, max: 500)
      ..pageTitle = number(json['pageTitle'], min: 0, max: 500)
      ..sectionTitle = number(json['sectionTitle'], min: 0, max: 500)
      ..subsectionTitle = number(json['subsectionTitle'], min: 0, max: 500)
      ..bodyLarge = number(json['bodyLarge'], min: 0, max: 500)
      ..bodySmall = number(json['bodySmall'], min: 0, max: 500)
      ..breadcrumb = number(json['breadcrumb'], min: 0, max: 500)
      ..listTitle = number(json['listTitle'], min: 0, max: 500)
      ..listSubtitle = number(json['listSubtitle'], min: 0, max: 500)
      ..listTitleLineHeight = number(
        json['listTitleLineHeight'],
        min: 0,
        max: 500,
      )
      ..listSubtitleLineHeight = number(
        json['listSubtitleLineHeight'],
        min: 0,
        max: 500,
      )
      ..cardTitle = number(json['cardTitle'], min: 0, max: 500)
      ..label = number(json['label'], min: 0, max: 500)
      ..caption = number(json['caption'], min: 0, max: 500);
  }
}

class EditorLayout {
  double? paddingLeft, paddingTop, paddingRight, paddingBottom;
  double? navigationItemSpacing;
  double? controlHeightXs;
  double? controlHeightSm;
  double? controlHeightMd;
  double? controlHeightLg;
  double? controlHeightXl;
  double? minimumInteractiveDimension;
  double? controlRadius;
  double? surfaceRadius;
  double? overlayRadius;
  double? overlaySpacing;
  double? pageHorizontalPadding;
  double? compactSectionSpacing;
  double? sectionSpacing;
  double? toolbarCompactHeight;
  double? toolbarHeight;
  double? toolbarEmphasizedHeight;
  double? iconSize;
  HyperSizeScheme resolve(HyperSizeScheme base) => base.copyWith(
    controlPadding: EdgeInsets.fromLTRB(
      paddingLeft ?? base.controlPadding.resolve(TextDirection.ltr).left,
      paddingTop ?? base.controlPadding.resolve(TextDirection.ltr).top,
      paddingRight ?? base.controlPadding.resolve(TextDirection.ltr).right,
      paddingBottom ?? base.controlPadding.resolve(TextDirection.ltr).bottom,
    ),
    navigationItemSpacing: navigationItemSpacing,
    controlHeightXs: controlHeightXs,
    controlHeightSm: controlHeightSm,
    controlHeightMd: controlHeightMd,
    controlHeightLg: controlHeightLg,
    controlHeightXl: controlHeightXl,
    minimumInteractiveDimension: minimumInteractiveDimension,
    controlRadius: controlRadius,
    surfaceRadius: surfaceRadius,
    overlayRadius: overlayRadius,
    overlaySpacing: overlaySpacing,
    pageHorizontalPadding: pageHorizontalPadding,
    compactSectionSpacing: compactSectionSpacing,
    sectionSpacing: sectionSpacing,
    toolbarCompactHeight: toolbarCompactHeight,
    toolbarHeight: toolbarHeight,
    toolbarEmphasizedHeight: toolbarEmphasizedHeight,
    iconSize: iconSize,
  );
  Map<String, Object?> toJson() => {
    if (paddingLeft != null) 'paddingLeft': paddingLeft,
    if (paddingTop != null) 'paddingTop': paddingTop,
    if (paddingRight != null) 'paddingRight': paddingRight,
    if (paddingBottom != null) 'paddingBottom': paddingBottom,

    if (navigationItemSpacing != null)
      'navigationItemSpacing': navigationItemSpacing,
    if (controlHeightXs != null) 'controlHeightXs': controlHeightXs,
    if (controlHeightSm != null) 'controlHeightSm': controlHeightSm,
    if (controlHeightMd != null) 'controlHeightMd': controlHeightMd,
    if (controlHeightLg != null) 'controlHeightLg': controlHeightLg,
    if (controlHeightXl != null) 'controlHeightXl': controlHeightXl,
    if (minimumInteractiveDimension != null)
      'minimumInteractiveDimension': minimumInteractiveDimension,
    if (controlRadius != null) 'controlRadius': controlRadius,
    if (surfaceRadius != null) 'surfaceRadius': surfaceRadius,
    if (overlayRadius != null) 'overlayRadius': overlayRadius,
    if (overlaySpacing != null) 'overlaySpacing': overlaySpacing,
    if (pageHorizontalPadding != null)
      'pageHorizontalPadding': pageHorizontalPadding,
    if (compactSectionSpacing != null)
      'compactSectionSpacing': compactSectionSpacing,
    if (sectionSpacing != null) 'sectionSpacing': sectionSpacing,
    if (toolbarCompactHeight != null)
      'toolbarCompactHeight': toolbarCompactHeight,
    if (toolbarHeight != null) 'toolbarHeight': toolbarHeight,
    if (toolbarEmphasizedHeight != null)
      'toolbarEmphasizedHeight': toolbarEmphasizedHeight,
    if (iconSize != null) 'iconSize': iconSize,
  };
  EditorLayout();
  factory EditorLayout.fromJson(Map<String, dynamic> json) {
    const allowed = {
      'paddingLeft',
      'paddingTop',
      'paddingRight',
      'paddingBottom',
      'navigationItemSpacing',
      'controlHeightXs',
      'controlHeightSm',
      'controlHeightMd',
      'controlHeightLg',
      'controlHeightXl',
      'minimumInteractiveDimension',
      'controlRadius',
      'surfaceRadius',
      'overlayRadius',
      'overlaySpacing',
      'pageHorizontalPadding',
      'compactSectionSpacing',
      'sectionSpacing',
      'toolbarCompactHeight',
      'toolbarHeight',
      'toolbarEmphasizedHeight',
      'iconSize',
    };
    if (json.keys.any((key) => !allowed.contains(key))) {
      throw const FormatException("不支持的全局字段");
    }
    return EditorLayout()
      ..paddingLeft = number(json['paddingLeft'], min: 0, max: 200)
      ..paddingTop = number(json['paddingTop'], min: 0, max: 200)
      ..paddingRight = number(json['paddingRight'], min: 0, max: 200)
      ..paddingBottom = number(json['paddingBottom'], min: 0, max: 200)
      ..navigationItemSpacing = number(
        json['navigationItemSpacing'],
        min: 0,
        max: 500,
      )
      ..controlHeightXs = number(json['controlHeightXs'], min: 0, max: 500)
      ..controlHeightSm = number(json['controlHeightSm'], min: 0, max: 500)
      ..controlHeightMd = number(json['controlHeightMd'], min: 0, max: 500)
      ..controlHeightLg = number(json['controlHeightLg'], min: 0, max: 500)
      ..controlHeightXl = number(json['controlHeightXl'], min: 0, max: 500)
      ..minimumInteractiveDimension = number(
        json['minimumInteractiveDimension'],
        min: 0,
        max: 500,
      )
      ..controlRadius = number(json['controlRadius'], min: 0, max: 500)
      ..surfaceRadius = number(json['surfaceRadius'], min: 0, max: 500)
      ..overlayRadius = number(json['overlayRadius'], min: 0, max: 500)
      ..overlaySpacing = number(json['overlaySpacing'], min: 0, max: 500)
      ..pageHorizontalPadding = number(
        json['pageHorizontalPadding'],
        min: 0,
        max: 500,
      )
      ..compactSectionSpacing = number(
        json['compactSectionSpacing'],
        min: 0,
        max: 500,
      )
      ..sectionSpacing = number(json['sectionSpacing'], min: 0, max: 500)
      ..toolbarCompactHeight = number(
        json['toolbarCompactHeight'],
        min: 0,
        max: 500,
      )
      ..toolbarHeight = number(json['toolbarHeight'], min: 0, max: 500)
      ..toolbarEmphasizedHeight = number(
        json['toolbarEmphasizedHeight'],
        min: 0,
        max: 500,
      )
      ..iconSize = number(json['iconSize'], min: 0, max: 500);
  }
}

enum EditorCurve { linear, easeOut, easeOutCubic, easeInOutCubic }

Curve resolveEditorCurve(EditorCurve value) => switch (value) {
  EditorCurve.linear => Curves.linear,
  EditorCurve.easeOut => Curves.easeOut,
  EditorCurve.easeOutCubic => Curves.easeOutCubic,
  EditorCurve.easeInOutCubic => Curves.easeInOutCubic,
};

class EditorBehavior {
  double? fastDuration;
  double? standardDuration;
  double? emphasizedDuration;
  double? springMass;
  double? springStiffness;
  double? springDamping;
  double? transitionFadeFraction;
  double? minimumContrastRatio;
  EditorCurve? fastCurve;
  EditorCurve? standardCurve;
  EditorCurve? emphasizedCurve;
  HyperMaterialQuality? quality;
  HyperContrastMode? contrastMode;
  bool? reduceTransparency;
  Color? lightForeground, darkForeground;
  EditorBehavior();
  Map<String, Object?> toJson() => {
    if (fastDuration != null) 'fastDuration': fastDuration,
    if (standardDuration != null) 'standardDuration': standardDuration,
    if (emphasizedDuration != null) 'emphasizedDuration': emphasizedDuration,
    if (springMass != null) 'springMass': springMass,
    if (springStiffness != null) 'springStiffness': springStiffness,
    if (springDamping != null) 'springDamping': springDamping,
    if (transitionFadeFraction != null)
      'transitionFadeFraction': transitionFadeFraction,
    if (minimumContrastRatio != null)
      'minimumContrastRatio': minimumContrastRatio,
    if (fastCurve != null) 'fastCurve': fastCurve!.name,
    if (standardCurve != null) 'standardCurve': standardCurve!.name,
    if (emphasizedCurve != null) 'emphasizedCurve': emphasizedCurve!.name,
    if (quality != null) 'quality': quality!.name,
    if (contrastMode != null) 'contrastMode': contrastMode!.name,
    if (reduceTransparency != null) 'reduceTransparency': reduceTransparency,
    if (lightForeground != null) 'lightForeground': lightForeground!.toARGB32(),
    if (darkForeground != null) 'darkForeground': darkForeground!.toARGB32(),
  };
  factory EditorBehavior.fromJson(Map<String, dynamic> j) {
    const allowed = {
      'fastDuration',
      'standardDuration',
      'emphasizedDuration',
      'springMass',
      'springStiffness',
      'springDamping',
      'transitionFadeFraction',
      'minimumContrastRatio',
      'fastCurve',
      'standardCurve',
      'emphasizedCurve',
      'quality',
      'contrastMode',
      'reduceTransparency',
      'lightForeground',
      'darkForeground',
    };
    if (j.keys.any((k) => !allowed.contains(k))) {
      throw const FormatException("不支持的行为字段");
    }
    return EditorBehavior()
      ..fastDuration = number(j['fastDuration'], min: 0, max: 2000)
      ..standardDuration = number(j['standardDuration'], min: 0, max: 2000)
      ..emphasizedDuration = number(j['emphasizedDuration'], min: 0, max: 2000)
      ..springMass = number(j['springMass'], min: 0.01, max: 100)
      ..springStiffness = number(j['springStiffness'], min: 0.01, max: 2000)
      ..springDamping = number(j['springDamping'], min: 0, max: 200)
      ..transitionFadeFraction = number(
        j['transitionFadeFraction'],
        min: 0.01,
        max: 0.99,
      )
      ..minimumContrastRatio = number(
        j['minimumContrastRatio'],
        min: 1,
        max: 21,
      )
      ..fastCurve = j['fastCurve'] == null
          ? null
          : EditorCurve.values.byName(j['fastCurve'] as String)
      ..standardCurve = j['standardCurve'] == null
          ? null
          : EditorCurve.values.byName(j['standardCurve'] as String)
      ..emphasizedCurve = j['emphasizedCurve'] == null
          ? null
          : EditorCurve.values.byName(j['emphasizedCurve'] as String)
      ..quality = j['quality'] == null
          ? null
          : HyperMaterialQuality.values.byName(j['quality'] as String)
      ..contrastMode = j['contrastMode'] == null
          ? null
          : HyperContrastMode.values.byName(j['contrastMode'] as String)
      ..reduceTransparency = j['reduceTransparency'] as bool?
      ..lightForeground = j['lightForeground'] == null
          ? null
          : Color(
              number(j['lightForeground'], min: 0, max: 4294967295)!.toInt(),
            )
      ..darkForeground = j['darkForeground'] == null
          ? null
          : Color(
              number(j['darkForeground'], min: 0, max: 4294967295)!.toInt(),
            );
  }
}
