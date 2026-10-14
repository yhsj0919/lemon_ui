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
