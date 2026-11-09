# Changelog

## Unreleased

- Dialog and movable dialog bodies now default to bounded layout
  (`scrollable: false`). Use `scrollable: true` for long natural-height content
  that needs the dialog's scrolling wrapper. Form and color-picker dialogs
  explicitly retain scrolling.

- Reset the package to a minimal skeleton.

## 0.0.1

- Integrate the patched extended_image 10.1.0 backend into the package's internal
  source tree, retaining its MIT license and patch history.
- Replace the image backend's local path dependency with hosted runtime
  dependencies, so image display, preview and editing ship with lemon_ui.
