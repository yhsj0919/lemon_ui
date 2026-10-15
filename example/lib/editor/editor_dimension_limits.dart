/// Editor bounds for surfaces whose dimensions are supplied by a parent layout.
const editorSurfaceRadiusLimit = 60.0;

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

// Content preview editor bounds: bounded illustration and readable content area.
// These are editor operation limits, not official default dimensions; validate per demo.
const editorContentIllustrationLimit = 256.0;
const editorContentWidthLimit = 960.0;

// Scrollable content viewport editing bound; independent of component defaults.
// Matches the content preview operation extent, pending review on small devices.
const editorContentHeightLimit = 960.0;

// Capsule slider width operation boundary; vertical height is supplied by parent.
// Allows editing up to a wide control, not a device default or official specification.
const editorCapsuleWidthLimit = 128.0;
