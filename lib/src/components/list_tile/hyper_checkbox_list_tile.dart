import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../checkbox/hyper_checkbox.dart';
import '../checkbox/hyper_checkbox_style.dart';
import 'hyper_list_tile.dart';
import 'hyper_list_tile_style.dart';

/// 整行参与复选交互的列表项。
///
/// 列表项提供完整点击区域，尾部 Checkbox 只占视觉尺寸，因此其可见外框
/// 与其他尾部内容使用相同的结束边距。
class HyperCheckboxListTile extends StatelessWidget {
  const HyperCheckboxListTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.leading,
    this.variant = HyperCheckboxVariant.circle,
    this.tristate = false,
    this.density = HyperListTileDensity.standard,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
    this.style,
    this.checkboxStyle,
  }) : assert(tristate || value != null);

  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final HyperCheckboxVariant variant;
  final bool tristate;
  final HyperListTileDensity density;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? semanticLabel;
  final HyperListTileStyle? style;
  final HyperCheckboxStyle? checkboxStyle;

  @override
  Widget build(BuildContext context) {
    final interactive = enabled && onChanged != null;
    final checkboxSize = HyperTheme.sizesOf(context).checkbox.size;
    final resolvedCheckboxStyle = HyperCheckboxStyle(
      minimumTapTargetSize: checkboxSize,
    ).merge(checkboxStyle);
    final checkbox = switch (variant) {
      HyperCheckboxVariant.circle => HyperCheckbox.circle(
        value: value,
        onChanged: interactive ? onChanged : null,
        tristate: tristate,
        style: resolvedCheckboxStyle,
      ),
      HyperCheckboxVariant.rounded => HyperCheckbox.rounded(
        value: value,
        onChanged: interactive ? onChanged : null,
        tristate: tristate,
        style: resolvedCheckboxStyle,
      ),
    };

    return Semantics(
      checked: value,
      enabled: interactive,
      child: HyperListTile(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: ExcludeSemantics(child: checkbox),
        density: density,
        onTap: interactive ? () => onChanged?.call(_nextValue()) : null,
        enabled: enabled,
        autofocus: autofocus,
        focusNode: focusNode,
        semanticLabel: semanticLabel,
        style: style,
      ),
    );
  }

  bool? _nextValue() {
    if (!tristate) return value != true;
    return switch (value) {
      false => true,
      true => null,
      null => false,
    };
  }
}
