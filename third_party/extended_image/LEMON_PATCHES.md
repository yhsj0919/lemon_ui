# Lemon UI local patch

Base: extended_image 10.1.0 from the local pub cache, upstream https://github.com/fluttercandies/extended_image. Original MIT license and upstream sources are preserved. The package namespace is lemon_extended_image; self-imports are renamed accordingly so the patched editor does not override unrelated transitive consumers of hosted extended_image (universal_image / table dependencies).

## Bounded crop dragging (2026-10-28)

Upstream `ExtendedImageCropLayerState.moveUpdate` can expand a crop beyond the visible image/layout and then re-fit/recenter it. Even a purely horizontal free-crop mouse drag therefore changes its vertical extent at the edge. There is no public configuration to disable that expansion.

The optional `EditorConfig.constrainCropRect` defaults to false for upstream compatibility. Lemon UI enables it by default for HyperImageEditor. It constrains the candidate to the current transformed image bounds BEFORE the native image-intersection and auto-center paths. The viewport is not a crop boundary: dragging beyond it retains native automatic fitting, allowing a zoomed crop to expand back to the full source. Free cropping clips only the moved edges. Fixed-ratio candidates interpolate from the prior valid rectangle to the first boundary intersection, preserving the native aspect-ratio calculation and anchors. Zoom, image panning, rotation, undo/redo, pointer hit testing and export are unchanged.

The patch changes editor_config.dart and crop_layer.dart and adds crop_rect_boundary.dart. Root tests cover real mouse drags, geometry boundaries, fixed ratios and editor export. Keep the opt-in default and tests when updating the base. Remove the local patch when upstream provides equivalent bounded-handle behavior and the regressions pass against it.

The root dependency points to this vendored package so checkouts/builds are reproducible; no Pub cache source is edited. Publishing Lemon UI to pub.dev will require publishing the patched dependency or waiting for its upstream equivalent, because hosted packages cannot contain path dependencies.

## Axis-correct flip animation (2026-10-28)

The controller flip method accepts vertical=false. Animated flips use an eased, transient paint transform on the requested screen axis; crop geometry stays settled until a single final commit. Vertical flips no longer combine an immediate half-turn with a horizontal animation. The render image explicitly invalidates paint on transient frames and their completion. History excludes the transient transform; reset clears it. Tests cover intermediate axes, stable crop geometry, final export and undo.

Transform animations no longer set the crop pointer-down flag, so the rule-of-thirds guides are reserved for actual pointer editing. HyperImageEditor uses the global standard motion duration (default 240 ms) rather than fast duration (120 ms). Pixel-level widget tests capture successive public-controller animation frames in both axes and verify visible image content contracts continuously; flip and rotation frames keep crop guides off.

The crop-layer painted opening and frame now follow the same transient flip matrix as the image, in layout coordinates. The outside mask continues to cover the full viewport, preventing white strips between the shrinking image and a stationary opening. Hit testing and source crop geometry remain unchanged. Pixel tests compare the exposed strip with the outside mask for both axes.
