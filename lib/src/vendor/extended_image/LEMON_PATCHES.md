# Lemon UI vendored image backend

Base: extended_image 10.1.0 from the local pub cache, upstream https://github.com/fluttercandies/extended_image. Original MIT license and upstream sources are preserved. Sources live inside lemon_ui at lib/src/vendor/extended_image. Self-imports use that internal namespace; no backend declarations are exported from lemon_ui.dart. This leaves unrelated consumers of hosted extended_image (universal_image / table dependencies) unchanged.

## Bounded crop dragging (2026-10-28)

Upstream `ExtendedImageCropLayerState.moveUpdate` can expand a crop beyond the visible image/layout and then re-fit/recenter it. Even a purely horizontal free-crop mouse drag therefore changes its vertical extent at the edge. There is no public configuration to disable that expansion.

The optional `EditorConfig.constrainCropRect` defaults to false for upstream compatibility. Lemon UI enables it by default for HyperImageEditor. It constrains the candidate to the current transformed image bounds BEFORE the native image-intersection and auto-center paths. The viewport is not a crop boundary: dragging beyond it retains native automatic fitting, allowing a zoomed crop to expand back to the full source. Free cropping clips only the moved edges. Fixed-ratio candidates interpolate from the prior valid rectangle to the first boundary intersection, preserving the native aspect-ratio calculation and anchors. Zoom, image panning, rotation, undo/redo, pointer hit testing and export are unchanged.

The patch changes editor_config.dart and crop_layer.dart and adds crop_rect_boundary.dart. Root tests cover real mouse drags, geometry boundaries, fixed ratios and editor export. Keep the opt-in default and tests when updating the base. Remove the local patch when upstream provides equivalent bounded-handle behavior and the regressions pass against it.

The backend is ordinary library source shipped with lemon_ui; no Git or path dependency is required and no Pub cache source is edited. Its runtime imports, extended_image_library and vector_math, are declared as hosted dependencies in the root pubspec. The original MIT copyright and license are retained in LICENSE. UPSTREAM_README.md and CHANGELOG.md are historical upstream reference, not the public Lemon UI API.

To return to upstream: verify crop-boundary, flip-frame, crop-mask, undo/export, native paging and Hero regressions against an official extended_image release; replace the internal barrel imports in lib/src/components/image with the hosted package, migrate dependency-specific tests, then remove this directory and any root runtime dependencies no longer directly imported. Keep Hyper APIs and their tests stable.

## Axis-correct flip animation (2026-10-28)

The controller flip method accepts vertical=false. Animated flips use an eased, transient paint transform on the requested screen axis; crop geometry stays settled until a single final commit. Vertical flips no longer combine an immediate half-turn with a horizontal animation. The render image explicitly invalidates paint on transient frames and their completion. History excludes the transient transform; reset clears it. Tests cover intermediate axes, stable crop geometry, final export and undo.

Transform animations no longer set the crop pointer-down flag, so the rule-of-thirds guides are reserved for actual pointer editing. HyperImageEditor uses the global standard motion duration (default 240 ms) rather than fast duration (120 ms). Pixel-level widget tests capture successive public-controller animation frames in both axes and verify visible image content contracts continuously; flip and rotation frames keep crop guides off.

The crop-layer painted opening and frame now follow the same transient flip matrix as the image, in layout coordinates. The outside mask continues to cover the full viewport, preventing white strips between the shrinking image and a stationary opening. Hit testing and source crop geometry remain unchanged. Pixel tests compare the exposed strip with the outside mask for both axes.
