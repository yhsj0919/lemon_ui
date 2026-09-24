import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../switch/hyper_switch.dart';
import '../switch/hyper_switch_style.dart';
import 'hyper_list_tile.dart';
import 'hyper_list_tile_style.dart';

/// 整行参与开关交互的列表项。
///
/// 列表项提供完整点击区域，尾部 Switch 只保留视觉尺寸和拖动区域，避免独立
/// 点击热区影响行高或尾部对齐。
class HyperSwitchListTile extends StatelessWidget {
  const HyperSwitchListTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.leading,
    this.density = HyperListTileDensity.standard,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
    this.style,
    this.switchStyle,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final HyperListTileDensity density;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? semanticLabel;
  final HyperListTileStyle? style;
  final HyperSwitchStyle? switchStyle;

  @override
  Widget build(BuildContext context) {
    final interactive = enabled && onChanged != null;
    final switchHeight = HyperTheme.sizesOf(context).switchSize.height;
    final resolvedSwitchStyle = HyperSwitchStyle(
      minimumTapTargetSize:
          switchStyle?.minimumTapTargetSize ??
          switchStyle?.height ??
          switchHeight,
    ).merge(switchStyle);

    return Semantics(
      toggled: value,
      enabled: interactive,
      child: HyperListTile(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: ExcludeSemantics(
          child: HyperSwitch(
            value: value,
            onChanged: interactive ? onChanged : null,
            style: resolvedSwitchStyle,
          ),
        ),
        density: density,
        onTap: interactive ? () => onChanged?.call(!value) : null,
        enabled: enabled,
        autofocus: autofocus,
        focusNode: focusNode,
        semanticLabel: semanticLabel,
        style: style,
      ),
    );
  }
}
