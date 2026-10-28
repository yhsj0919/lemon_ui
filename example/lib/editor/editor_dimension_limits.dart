import 'package:flutter/widgets.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'editor_chart_fields.dart';

/// Editor bounds for surfaces whose dimensions are supplied by a parent layout.
/// Includes Popover surfaces: content and overlay constraints determine their
/// final size. This shared operation boundary is pending visual validation and
/// is not a component default or an official geometry specification.
const editorSurfaceRadiusLimit = 60.0;

void constrainEditorChartDimensions(
  EditorChartMetrics metrics,
  HyperChartSize inherited,
  Size viewport,
) {
  final current = metrics.resolve(inherited);
  if (metrics.radius != null) {
    metrics.radius = metrics.radius!.roundToDouble().clamp(
      0,
      editorRadiusLimit(current.barWidth),
    );
  }
  if (metrics.donutHoleRadius != null) {
    metrics.donutHoleRadius = metrics.donutHoleRadius!.roundToDouble().clamp(
      0,
      editorChartRadiusLimit(viewport, current.height, current.pieRadius),
    );
  }
}

/// 图表几何操作边界来自当前预览绘图区；不作为组件默认规格。
/// 环形外半径由环宽与内半径共同占用，图例的实际占位由布局进一步收缩。
double editorChartRadiusLimit(
  Size viewport,
  double height,
  double otherRadius,
) => ((viewport.width < height ? viewport.width : height) / 2 - otherRadius)
    .clamp(0, double.infinity)
    .floorToDouble();

// Clear-glass experiment operation bounds, pending visual review. Blur explores
// legibility across background rows; spread stays within the scene's 32px inset,
// leaving room for the existing shadow blur. These are not default design tokens.
const editorClearGlassBlurLimit = 32.0;
const editorClearGlassSpreadLimit = 12.0;

/// A rounded surface reaches a capsule/circle at half its shortest dimension.
double editorRadiusLimit(double extent) =>
    extent <= 0 ? 0 : (extent / 2).floorToDouble();

// Interaction ranges in logical pixels, separate from component defaults.
const editorLineThicknessLimit = 20.0;
const editorPatternSegmentLimit = 30.0;
const editorContentSpacingLimit = 64.0;
const editorContentIconLimit = 64.0;
const editorLayoutInsetLimit = 200.0;
const editorExplicitLineLengthLimit = 1000.0;

const editorProgressDiameterLimit = 200.0;
const editorWideTrackThicknessLimit = 64.0;

double editorProgressStrokeLimit(double diameter) =>
    editorRadiusLimit(diameter).clamp(0, editorLineThicknessLimit).toDouble();
double editorOrbitDotLimit(double diameter, double thickness) =>
    ((diameter - thickness) / 4).clamp(0, double.infinity).floorToDouble();

// Compact selection controls; editor bounds do not change theme defaults.
const editorSelectionMarkLimit = 64.0;
const editorTapTargetLimit = 96.0;
const editorSwitchWidthLimit = 128.0;
const editorSwitchHeightLimit = 64.0;

double editorSelectionStrokeLimit(double size) =>
    editorRadiusLimit(size).clamp(0, editorLineThicknessLimit).toDouble();

/// Sidebar icons must fit both the row height and collapsed column width.
double editorSidebarIconSizeLimit(
  HyperSizeScheme sizes, {
  double? itemHeight,
  double? collapsedWidth,
}) {
  final height = itemHeight ?? sizes.sidebar.itemHeight;
  final width = collapsedWidth ?? sizes.sidebar.collapsedWidth;
  return (height < width ? height : width).floorToDouble();
}

// Content/feedback/navigation editor bounds: bounded illustrations, readable
// panels, sidebars and breadcrumb items whose available width comes from a parent.
// These are editor operation limits, not official default dimensions; validate per demo.
const editorContentIllustrationLimit = 256.0;
const editorContentWidthLimit = 960.0;

// Scrollable content viewport editing bound; independent of component defaults.
// Matches the content preview operation extent, pending review on small devices.
const editorContentHeightLimit = 960.0;

// Capsule slider width operation boundary; vertical height is supplied by parent.
// Allows editing up to a wide control, not a device default or official specification.
const editorCapsuleWidthLimit = 128.0;

// Animation editing boundary in milliseconds for feedback loops and transitions.
// Allows long skeleton cycles; editor operation limit, pending interactive review.
const editorReviewDurationLimit = 10000.0;

/// Text containers can grow or reflow, so their inherited font size is not a
/// geometric ceiling. Allow up to two largest display sizes for review; callers
/// may impose a narrower operation bound. This is provisional editor policy,
/// not an official font specification or a component default.
double editorReviewFontSizeLimit(double displaySize) =>
    (displaySize * 2).floorToDouble();

/// Preview geometry only; these are editor canvases, never device classification.
Size editorPreviewSize(HyperDeviceType type, {required bool landscape}) {
  var size = switch (type) {
    HyperDeviceType.phone => const Size(390, 844),
    HyperDeviceType.tablet => const Size(834, 1194),
    HyperDeviceType.desktop => const Size(1280, 800),
    HyperDeviceType.watch => const Size(220, 220),
  };
  if (landscape != (size.width > size.height)) size = size.flipped;
  return size;
}

/// Feedback/navigation operation bounds. Compact spacing/padding is capped at
/// one minimum interaction target, and compact heights/icons at the largest
/// control height. This is a provisional editing policy, not a default or an
/// official visual specification. Unbounded panel widths use the actual canvas;
/// sidebar editing reserves half the canvas for content. Pending device review.
({double min, double max}) editorReviewBounds(
  String object,
  String label,
  HyperSizeScheme s,
  Size viewport, {
  required double min,
  required double max,
  required double typographyDisplaySize,
}) {
  double smaller(double a, double b) => a < b ? a : b;
  if (label.contains('字号')) {
    max = smaller(max, editorReviewFontSizeLimit(typographyDisplaySize));
  } else if (label.contains('内边距') ||
      label.contains('间距') ||
      label.contains('留白') ||
      label == '层级缩进') {
    max = smaller(max, s.minimumInteractiveDimension);
  } else if (label.contains('图标尺寸')) {
    double limit = s.controlHeightLg;
    if (label.contains('关闭')) {
      limit = switch (object) {
        'notification' => s.notification.closeButtonSize,
        'alert' => s.alert.closeButtonSize,
        'banner' => s.alert.banner.closeButtonSize,
        _ => s.controlHeightSm,
      };
    }
    if (object == 'stepIndicator') limit = s.stepIndicator.nodeSize;
    if (object == 'stepperNavigation') {
      limit = s.stepIndicator.navigation.nodeSize;
    }
    max = smaller(max, limit);
  } else if (label == '未读标记尺寸') {
    max = smaller(max, s.notification.iconSize);
  } else if (label == '节点尺寸' ||
      label == '圆点尺寸' ||
      label == '选中圆点宽度' ||
      label == '最小高度' ||
      label == '条目最小高度' ||
      label == '关闭按钮尺寸' ||
      label == '最小宽度') {
    max = smaller(max, s.controlHeightXl);
  }
  if (object == 'sidebar' && label == '展开宽度') {
    max = smaller(max, viewport.width / 2);
  }
  if (object == 'sidebar' && label == '收起宽度') {
    max = smaller(max, s.sidebar.width);
  }
  if (object != 'drawer' &&
      label.contains('宽度') &&
      !label.contains('边框') &&
      !label.contains('微光')) {
    max = smaller(max, viewport.width - 2 * s.pageHorizontalPadding);
  }
  if (object == 'appBar') {
    if (label == '收起高度') max = smaller(max, s.appBar.mediumExpandedHeight);
    if (label == '中等展开高度') {
      min = s.appBar.collapsedHeight;
      max = smaller(max, s.appBar.expandedHeight);
    }
    if (label == '完整展开高度') {
      min = s.appBar.mediumExpandedHeight;
      max = viewport.height;
    }
  }
  return (min: min.ceilToDouble(), max: max.floorToDouble());
}

/// 抽屉边距复用紧凑间距的编辑边界：一个最小交互尺寸。
/// 这是便于微调的编辑器操作上限，待交互验证；不是屏幕约束、
/// 组件 API 上限或官方默认规格，不修改主题默认值及历史导入值。
double editorDrawerMarginLimit(HyperSizeScheme sizes) =>
    sizes.minimumInteractiveDimension.floorToDouble();

/// 四角不超过实际短边的一半，并使用统一表面圆角操作上限。
double editorDrawerRadiusLimit(double width, Size viewport, EdgeInsets margin) {
  final availableWidth = (viewport.width - margin.horizontal).clamp(
    0,
    double.infinity,
  );
  final availableHeight = (viewport.height - margin.vertical).clamp(
    0,
    double.infinity,
  );
  final panelWidth = width.clamp(0, availableWidth);
  return editorRadiusLimit(
    (panelWidth < availableHeight ? panelWidth : availableHeight).toDouble(),
  ).clamp(0, editorSurfaceRadiusLimit).toDouble();
}

// Wheel editor operation boundaries, pending device review. Width allows a
// standalone column; row height permits 5 rows in the existing 960px preview
// operation extent. These are not HyperOS/HiUI defaults or component API limits.
const editorWheelWidthLimit = 512.0;
const editorWheelItemExtentLimit = editorContentHeightLimit / 5;

// Wheel shape operation bounds: positive curvature/density and SDK-valid
// perspective (0, .01]. These are editor exploration limits, pending visual review.
const editorWheelDiameterRatioMin = 1.0;
const editorWheelDiameterRatioMax = 10.0;
const editorWheelPerspectiveMin = .001;
const editorWheelPerspectiveMax = .01;
const editorWheelSqueezeMin = .5;
const editorWheelSqueezeMax = 2.0;

// Calendar day minimum-height operation bound: six week rows fit within the
// existing 960px content preview operation extent, before header and spacing.
// This is a pending-review editor limit, independent of device defaults.
const editorCalendarDayExtentLimit = editorContentHeightLimit / 6;

// Form label/control bounds follow the preview's usable content width. These
// constrain editor operations, not API legality or platform default tokens.
double editorFormControlWidthLimit(double viewportWidth) =>
    viewportWidth.floorToDouble().clamp(1, double.infinity);
double editorFormLabelWidthLimit(
  double viewportWidth,
  double minimumControlWidth,
  double gap,
) => (viewportWidth - minimumControlWidth - gap).floorToDouble().clamp(
  0,
  double.infinity,
);

// Table editor operation boundaries, pending large-screen review.
// Columns may contain compound controls; 640 logical pixels allows an extended
// text field. Row extents allow multiline custom content up to the same height.
// These are editor limits, not official dimensions or component defaults.
const editorTableColumnWidthLimit = 640.0;
const editorTableRowExtentLimit = 320.0;

/// Icons must fit the row, header and control slot without scaling with text.
double editorTableIconLimit(double row, double header, double control) =>
    [row, header, control].reduce((a, b) => a < b ? a : b).floorToDouble();

/// Compact control spacing operation boundary, inherited from one interaction target.
/// Editor policy only; not a platform specification or component default.
double editorExtendedSpacingLimit(HyperSizeScheme sizes) =>
    sizes.minimumInteractiveDimension.floorToDouble();

/// A resize hit area may use at most half the smaller preview extent.
/// Shared with the rating hit-target editor; this is an operation boundary.
double editorExtendedHandleLimit(Size viewport) =>
    ((viewport.width < viewport.height ? viewport.width : viewport.height) / 2)
        .floorToDouble();

/// Transfer panel corner editor: at most half the configured shorter side.
double editorTransferRadiusLimit(double width, double height) =>
    editorRadiusLimit(width < height ? width : height);

/// Image status transition exploration boundary (milliseconds), pending review.
/// Independent of Motion defaults; allows disabling or slowing transitions.
const editorImageTransitionDurationLimit = 2000.0;

/// Crop handle thickness fits inside its length; no integer thickness exists
/// below one logical pixel of handle length. Not a component default.
double editorImageCropStrokeLimit(double handleLength) =>
    handleLength.floorToDouble();

/// Lift editor operation boundary: keep translation within half an interaction
/// target. This is an exploration limit, not a platform visual specification.
double editorMotionTranslationLimit(HyperSizeScheme sizes) =>
    (sizes.minimumInteractiveDimension / 2).floorToDouble();

/// Subtle lift-scale exploration range; pending user review, not default tokens.
const editorMotionMinimumScale = .9;
const editorMotionMaximumScale = 1.1;
const editorMotionDurationLimit = 2000.0;
