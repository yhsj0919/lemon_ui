import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:lemon_ui/lemon_ui.dart';

import 'editor_theme_document.dart';

enum EditorFillKind { solid, gradient, none }

enum EditorBorderKind { solid, dashed, dotted, none }

class EditorBorder {
  EditorBorderKind? kind;
  EditorColor? color;
  double? width, dashLength, gapLength;
  Map<String, Object?> toJson() => {
    if (kind != null) 'kind': kind!.name,
    if (color != null) 'color': color!.toJson(),
    if (width != null) 'width': width,
    if (dashLength != null) 'dashLength': dashLength,
    if (gapLength != null) 'gapLength': gapLength,
  };
  static EditorBorder fromJson(Map<String, dynamic> json) {
    if (json.keys.any(
          (k) => !{
            'kind',
            'color',
            'width',
            'dashLength',
            'gapLength',
          }.contains(k),
        ) ||
        (json['kind'] != null &&
            !EditorBorderKind.values.any((v) => v.name == json['kind']))) {
      throw const FormatException('不支持的边框配置');
    }
    return EditorBorder()
      ..kind = json['kind'] == null
          ? null
          : EditorBorderKind.values.byName(json['kind'] as String)
      ..color = json['color'] == null
          ? null
          : EditorColor.fromJson(json['color'] as Map<String, dynamic>)
      ..width = number(json['width'], min: 0, max: 300)
      ..dashLength = number(json['dashLength'], min: .1, max: 100)
      ..gapLength = number(json['gapLength'], min: .1, max: 100);
  }

  BoxBorder? resolve(HyperColorScheme colors, {BorderSide? inherited}) {
    if (toJson().isEmpty) return null;
    if (kind == EditorBorderKind.none || width == 0) return const Border();
    final side = BorderSide(
      color: color?.resolve(colors) ?? inherited?.color ?? colors.outline,
      width: width ?? inherited?.width ?? 1,
    );
    return HyperLine(
      fill: HyperFill.color(side.color),
      thickness: side.width,
      pattern: switch (kind) {
        EditorBorderKind.dashed => HyperLinePattern.dashed,
        EditorBorderKind.dotted => HyperLinePattern.dotted,
        _ => HyperLinePattern.solid,
      },
      dashLength: dashLength ?? 6,
      gap: gapLength ?? 4,
    ).toBorder();
  }
}

enum EditorGradientKind { linear, radial, sweep }

class EditorGradient {
  EditorGradient({
    required this.colors,
    required this.stops,
    this.angle = 0,
    this.kind = EditorGradientKind.linear,
    this.centerX = 0,
    this.centerY = 0,
    this.radius = .5,
    this.startAngle = 0,
    this.endAngle = 360,
  });
  List<EditorColor> colors;
  List<double> stops;
  double angle;
  EditorGradientKind kind;
  double centerX, centerY, radius, startAngle, endAngle;
  factory EditorGradient.fromGradient(Gradient value) {
    final model = EditorGradient(
      colors: value.colors.map((c) => EditorColor(argb: c.toARGB32())).toList(),
      stops:
          value.stops ??
          List.generate(
            value.colors.length,
            (i) => i / (value.colors.length - 1),
          ),
    );
    if (value is LinearGradient) {
      final begin = value.begin.resolve(TextDirection.ltr),
          end = value.end.resolve(TextDirection.ltr);
      model.angle =
          (math.atan2(end.y - begin.y, end.x - begin.x) * 180 / math.pi + 360) %
          360;
    } else if (value is RadialGradient) {
      final center = value.center.resolve(TextDirection.ltr);
      model
        ..kind = EditorGradientKind.radial
        ..centerX = center.x
        ..centerY = center.y
        ..radius = value.radius;
    } else if (value is SweepGradient) {
      final center = value.center.resolve(TextDirection.ltr);
      model
        ..kind = EditorGradientKind.sweep
        ..centerX = center.x
        ..centerY = center.y
        ..startAngle = value.startAngle * 180 / math.pi
        ..endAngle = value.endAngle * 180 / math.pi;
      if (value.transform case GradientRotation(:final radians)) {
        model.angle = radians * 180 / math.pi;
      }
    }
    return model;
  }
  Map<String, Object?> toJson() => {
    'colors': colors.map((c) => c.toJson()).toList(),
    'stops': stops,
    'angle': angle,
    if (kind != EditorGradientKind.linear) 'kind': kind.name,
    if (centerX != 0) 'centerX': centerX,
    if (centerY != 0) 'centerY': centerY,
    if (radius != .5) 'radius': radius,
    if (startAngle != 0) 'startAngle': startAngle,
    if (endAngle != 360) 'endAngle': endAngle,
  };
  static EditorGradient fromJson(Map<String, dynamic> json) {
    if (json.keys.any(
          (k) => !{
            'colors',
            'stops',
            'angle',
            'kind',
            'centerX',
            'centerY',
            'radius',
            'startAngle',
            'endAngle',
          }.contains(k),
        ) ||
        (json['kind'] != null &&
            !EditorGradientKind.values.any((v) => v.name == json['kind']))) {
      throw const FormatException('不支持的渐变属性');
    }
    final colors = (json['colors'] as List)
        .map((c) => EditorColor.fromJson(c as Map<String, dynamic>))
        .toList();
    final stops = (json['stops'] as List)
        .map((v) => number(v, min: 0, max: 1)!)
        .toList();
    if (colors.length < 2 ||
        colors.length != stops.length ||
        List.generate(
          stops.length - 1,
          (i) => stops[i] > stops[i + 1],
        ).any((v) => v)) {
      throw const FormatException('渐变至少需要两个节点，位置需依次递增');
    }
    final start = number(json['startAngle'], min: 0, max: 360) ?? 0;
    final end = number(json['endAngle'], min: 0, max: 360) ?? 360;
    if (end - start < .1 - 1e-9) {
      throw const FormatException('扫描渐变角度范围至少为 0.1 度');
    }
    return EditorGradient(
      colors: colors,
      stops: stops,
      angle: number(json['angle'], min: 0, max: 360) ?? 0,
      kind: json['kind'] == null
          ? EditorGradientKind.linear
          : EditorGradientKind.values.byName(json['kind'] as String),
      centerX: number(json['centerX'], min: -1, max: 1) ?? 0,
      centerY: number(json['centerY'], min: -1, max: 1) ?? 0,
      radius: number(json['radius'], min: .01, max: 2) ?? .5,
      startAngle: start,
      endAngle: end,
    );
  }

  Gradient resolve(HyperColorScheme scheme) {
    final radians = angle * math.pi / 180;
    final end = Alignment(math.cos(radians), math.sin(radians));
    final values = colors.map((c) => c.resolve(scheme)).toList();
    return switch (kind) {
      EditorGradientKind.radial => RadialGradient(
        center: Alignment(centerX, centerY),
        radius: radius,
        colors: values,
        stops: stops,
      ),
      EditorGradientKind.sweep => SweepGradient(
        center: Alignment(centerX, centerY),
        startAngle: startAngle * math.pi / 180,
        endAngle: endAngle * math.pi / 180,
        transform: GradientRotation(radians),
        colors: values,
        stops: stops,
      ),
      EditorGradientKind.linear => LinearGradient(
        begin: Alignment(-end.x, -end.y),
        end: end,
        colors: values,
        stops: stops,
      ),
    };
  }
}

class EditorButtonVisual {
  double? pressedScale;
  double? pressedOffsetY;
  double? pressedOffsetX;
  double? focusedScale;
  double? focusedOffsetY;
  double? focusedOffsetX;
  double? hoveredScale;
  double? hoveredOffsetY;
  double? hoveredOffsetX;
  EditorGradient? gradient;
  EditorColor? disabledBackground;
  EditorColor? disabledForeground;
  EditorColor? overlay;
  EditorColor? borderColor;
  EditorColor? progressColor;
  EditorColor? progressTrackColor;
  double? borderWidth;
  double? hoverOpacity;
  double? focusOpacity;
  double? pressOpacity;
  double? progressThickness;
  double? animationMilliseconds;

  Map<String, Object?> toJson() => {
    if (pressedScale != null) 'pressedScale': pressedScale,
    if (pressedOffsetY != null) 'pressedOffsetY': pressedOffsetY,
    if (pressedOffsetX != null) 'pressedOffsetX': pressedOffsetX,
    if (focusedScale != null) 'focusedScale': focusedScale,
    if (focusedOffsetY != null) 'focusedOffsetY': focusedOffsetY,
    if (focusedOffsetX != null) 'focusedOffsetX': focusedOffsetX,
    if (hoveredScale != null) 'hoveredScale': hoveredScale,
    if (hoveredOffsetY != null) 'hoveredOffsetY': hoveredOffsetY,
    if (hoveredOffsetX != null) 'hoveredOffsetX': hoveredOffsetX,
    if (gradient != null) 'gradient': gradient!.toJson(),
    if (disabledBackground != null)
      'disabledBackground': disabledBackground!.toJson(),
    if (disabledForeground != null)
      'disabledForeground': disabledForeground!.toJson(),
    if (overlay != null) 'overlay': overlay!.toJson(),
    if (borderColor != null) 'borderColor': borderColor!.toJson(),
    if (progressColor != null) 'progressColor': progressColor!.toJson(),
    if (progressTrackColor != null)
      'progressTrackColor': progressTrackColor!.toJson(),
    if (borderWidth != null) 'borderWidth': borderWidth,
    if (hoverOpacity != null) 'hoverOpacity': hoverOpacity,
    if (focusOpacity != null) 'focusOpacity': focusOpacity,
    if (pressOpacity != null) 'pressOpacity': pressOpacity,
    if (progressThickness != null) 'progressThickness': progressThickness,
    if (animationMilliseconds != null)
      'animationMilliseconds': animationMilliseconds,
  };
  static EditorButtonVisual fromJson(Map<String, dynamic> json) {
    final unknown = json.keys.where(
      (key) => !{
        'hoveredOffsetX',
        'hoveredOffsetY',
        'hoveredScale',
        'focusedOffsetX',
        'focusedOffsetY',
        'focusedScale',
        'pressedOffsetX',
        'pressedOffsetY',
        'pressedScale',
        'gradient',
        'disabledBackground',
        'disabledForeground',
        'overlay',
        'borderColor',
        'progressColor',
        'progressTrackColor',
        'borderWidth',
        'hoverOpacity',
        'focusOpacity',
        'pressOpacity',
        'progressThickness',
        'animationMilliseconds',
      }.contains(key),
    );
    if (unknown.isNotEmpty) {
      throw FormatException('不支持的按钮属性：${unknown.join(', ')}');
    }
    return EditorButtonVisual()
      ..pressedScale = number(json['pressedScale'], min: .5, max: 1.5)
      ..pressedOffsetY = number(json['pressedOffsetY'], min: -20, max: 20)
      ..pressedOffsetX = number(json['pressedOffsetX'], min: -20, max: 20)
      ..focusedScale = number(json['focusedScale'], min: .5, max: 1.5)
      ..focusedOffsetY = number(json['focusedOffsetY'], min: -20, max: 20)
      ..focusedOffsetX = number(json['focusedOffsetX'], min: -20, max: 20)
      ..hoveredScale = number(json['hoveredScale'], min: .5, max: 1.5)
      ..hoveredOffsetY = number(json['hoveredOffsetY'], min: -20, max: 20)
      ..hoveredOffsetX = number(json['hoveredOffsetX'], min: -20, max: 20)
      ..gradient = json['gradient'] == null
          ? null
          : EditorGradient.fromJson(json['gradient'] as Map<String, dynamic>)
      ..disabledBackground = json['disabledBackground'] == null
          ? null
          : EditorColor.fromJson(
              json['disabledBackground'] as Map<String, dynamic>,
            )
      ..disabledForeground = json['disabledForeground'] == null
          ? null
          : EditorColor.fromJson(
              json['disabledForeground'] as Map<String, dynamic>,
            )
      ..overlay = json['overlay'] == null
          ? null
          : EditorColor.fromJson(json['overlay'] as Map<String, dynamic>)
      ..borderColor = json['borderColor'] == null
          ? null
          : EditorColor.fromJson(json['borderColor'] as Map<String, dynamic>)
      ..progressColor = json['progressColor'] == null
          ? null
          : EditorColor.fromJson(json['progressColor'] as Map<String, dynamic>)
      ..progressTrackColor = json['progressTrackColor'] == null
          ? null
          : EditorColor.fromJson(
              json['progressTrackColor'] as Map<String, dynamic>,
            )
      ..borderWidth = number(json['borderWidth'], min: 0, max: 300)
      ..hoverOpacity = number(json['hoverOpacity'], min: 0, max: 1)
      ..focusOpacity = number(json['focusOpacity'], min: 0, max: 1)
      ..pressOpacity = number(json['pressOpacity'], min: 0, max: 1)
      ..progressThickness = number(json['progressThickness'], min: 0, max: 300)
      ..animationMilliseconds = number(
        json['animationMilliseconds'],
        min: 0,
        max: 5000,
      );
  }

  HyperButtonStyle resolve(HyperColorScheme colors) => HyperButtonStyle(
    hoveredOffset: hoveredOffsetX == null && hoveredOffsetY == null
        ? null
        : Offset(hoveredOffsetX ?? 0, hoveredOffsetY ?? 0),
    hoveredScale: hoveredScale,
    focusedOffset: focusedOffsetX == null && focusedOffsetY == null
        ? null
        : Offset(focusedOffsetX ?? 0, focusedOffsetY ?? 0),
    focusedScale: focusedScale,
    pressedOffset: pressedOffsetX == null && pressedOffsetY == null
        ? null
        : Offset(pressedOffsetX ?? 0, pressedOffsetY ?? 0),
    pressedScale: pressedScale,
    background: gradient == null
        ? null
        : HyperFill.gradient(gradient!.resolve(colors)),
    disabledBackground: disabledBackground == null
        ? null
        : HyperFill.color(disabledBackground!.resolve(colors)),
    disabledForegroundColor: disabledForeground?.resolve(colors),
    overlayColor: overlay?.resolve(colors),
    border: borderColor == null && borderWidth == null
        ? null
        : borderWidth == 0
        ? BorderSide.none
        : BorderSide(
            color: borderColor?.resolve(colors) ?? colors.outline,
            width: borderWidth ?? 1,
          ),
    hoverOverlayOpacity: hoverOpacity,
    focusOverlayOpacity: focusOpacity,
    pressOverlayOpacity: pressOpacity,
    progressColor: progressColor?.resolve(colors),
    progressTrackColor: progressTrackColor?.resolve(colors),
    progressThickness: progressThickness,
    animationDuration: animationMilliseconds == null
        ? null
        : Duration(milliseconds: animationMilliseconds!.round()),
  );
}

class EditorButtonMetrics {
  double? smallMinimumWidth, largeMinimumWidth, smallWidth, width, largeWidth;
  double? minimumWidth;
  double? smallHeight;
  double? largeHeight;
  double? paddingHorizontal;
  double? paddingVertical;
  double? smallPaddingHorizontal;
  double? smallPaddingVertical;
  double? largePaddingHorizontal;
  double? largePaddingVertical;
  double? iconSize;
  double? iconSpacing;
  double? progressSize;

  Map<String, Object?> toJson() => {
    if (smallMinimumWidth != null) 'smallMinimumWidth': smallMinimumWidth,
    if (largeMinimumWidth != null) 'largeMinimumWidth': largeMinimumWidth,
    if (smallWidth != null) 'smallWidth': smallWidth,
    if (width != null) 'width': width,
    if (largeWidth != null) 'largeWidth': largeWidth,
    if (minimumWidth != null) 'minimumWidth': minimumWidth,
    if (smallHeight != null) 'smallHeight': smallHeight,
    if (largeHeight != null) 'largeHeight': largeHeight,
    if (paddingHorizontal != null) 'paddingHorizontal': paddingHorizontal,
    if (paddingVertical != null) 'paddingVertical': paddingVertical,
    if (smallPaddingHorizontal != null)
      'smallPaddingHorizontal': smallPaddingHorizontal,
    if (smallPaddingVertical != null)
      'smallPaddingVertical': smallPaddingVertical,
    if (largePaddingHorizontal != null)
      'largePaddingHorizontal': largePaddingHorizontal,
    if (largePaddingVertical != null)
      'largePaddingVertical': largePaddingVertical,
    if (iconSize != null) 'iconSize': iconSize,
    if (iconSpacing != null) 'iconSpacing': iconSpacing,
    if (progressSize != null) 'progressSize': progressSize,
  };
  static EditorButtonMetrics fromJson(Map<String, dynamic> json) {
    final unknown = json.keys.where(
      (key) => !{
        'smallMinimumWidth',
        'largeMinimumWidth',
        'smallWidth',
        'width',
        'largeWidth',
        'minimumWidth',
        'smallHeight',
        'largeHeight',
        'paddingHorizontal',
        'paddingVertical',
        'smallPaddingHorizontal',
        'smallPaddingVertical',
        'largePaddingHorizontal',
        'largePaddingVertical',
        'iconSize',
        'iconSpacing',
        'progressSize',
      }.contains(key),
    );
    if (unknown.isNotEmpty) {
      throw FormatException('不支持的按钮属性：${unknown.join(', ')}');
    }
    return EditorButtonMetrics()
      ..smallMinimumWidth = number(json['smallMinimumWidth'], min: 0, max: 300)
      ..largeMinimumWidth = number(json['largeMinimumWidth'], min: 0, max: 300)
      ..smallWidth = number(json['smallWidth'], min: 0, max: 600)
      ..width = number(json['width'], min: 0, max: 600)
      ..largeWidth = number(json['largeWidth'], min: 0, max: 600)
      ..minimumWidth = number(json['minimumWidth'], min: 0, max: 300)
      ..smallHeight = number(json['smallHeight'], min: 0, max: 300)
      ..largeHeight = number(json['largeHeight'], min: 0, max: 300)
      ..paddingHorizontal = number(json['paddingHorizontal'], min: 0, max: 300)
      ..paddingVertical = number(json['paddingVertical'], min: 0, max: 300)
      ..smallPaddingHorizontal = number(
        json['smallPaddingHorizontal'],
        min: 0,
        max: 300,
      )
      ..smallPaddingVertical = number(
        json['smallPaddingVertical'],
        min: 0,
        max: 300,
      )
      ..largePaddingHorizontal = number(
        json['largePaddingHorizontal'],
        min: 0,
        max: 300,
      )
      ..largePaddingVertical = number(
        json['largePaddingVertical'],
        min: 0,
        max: 300,
      )
      ..iconSize = number(json['iconSize'], min: 0, max: 300)
      ..iconSpacing = number(json['iconSpacing'], min: 0, max: 300)
      ..progressSize = number(json['progressSize'], min: 0, max: 300);
  }

  HyperButtonSize resolve(HyperButtonSize base) => base.copyWith(
    smallMinimumWidth: smallMinimumWidth ?? base.smallMinimumWidth,
    largeMinimumWidth: largeMinimumWidth ?? base.largeMinimumWidth,
    smallWidth: smallWidth ?? base.smallWidth,
    width: width ?? base.width,
    largeWidth: largeWidth ?? base.largeWidth,
    minimumSize: Size(
      minimumWidth ?? base.minimumSize.width,
      base.minimumSize.height,
    ),
    smallHeight: smallHeight,
    largeHeight: largeHeight,
    padding: paddingHorizontal == null && paddingVertical == null
        ? null
        : EdgeInsets.symmetric(
            horizontal:
                paddingHorizontal ??
                base.padding.resolve(TextDirection.ltr).left,
            vertical:
                paddingVertical ?? base.padding.resolve(TextDirection.ltr).top,
          ),
    smallPadding: smallPaddingHorizontal == null && smallPaddingVertical == null
        ? null
        : EdgeInsets.symmetric(
            horizontal:
                smallPaddingHorizontal ??
                base.smallPadding.resolve(TextDirection.ltr).left,
            vertical:
                smallPaddingVertical ??
                base.smallPadding.resolve(TextDirection.ltr).top,
          ),
    largePadding: largePaddingHorizontal == null && largePaddingVertical == null
        ? null
        : EdgeInsets.symmetric(
            horizontal:
                largePaddingHorizontal ??
                base.largePadding.resolve(TextDirection.ltr).left,
            vertical:
                largePaddingVertical ??
                base.largePadding.resolve(TextDirection.ltr).top,
          ),
    iconSize: iconSize,
    iconSpacing: iconSpacing,
    progressSize: progressSize,
  );
}
