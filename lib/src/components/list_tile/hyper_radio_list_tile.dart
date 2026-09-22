import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../radio/hyper_radio.dart';
import '../radio/hyper_radio_style.dart';
import 'hyper_list_tile.dart';
import 'hyper_list_tile_style.dart';

/// 整行参与单选交互的列表项。
///
/// 列表项本身已经提供完整点击区域，因此尾部 Radio 只保留视觉尺寸，
/// 不再用独立的最小点击区域改变圆环的可见位置。
class HyperRadioListTile<T> extends StatelessWidget {
  const HyperRadioListTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.leading,
    this.variant = HyperRadioVariant.circle,
    this.toggleable = false,
    this.density = HyperListTileDensity.standard,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
    this.style,
    this.radioStyle,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final HyperRadioVariant variant;
  final bool toggleable;
  final HyperListTileDensity density;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? semanticLabel;
  final HyperListTileStyle? style;
  final HyperRadioStyle? radioStyle;

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final interactive = enabled && onChanged != null;
    final radioSize = HyperTheme.sizesOf(context).radio.size;
    final resolvedRadioStyle = HyperRadioStyle(minimumTapTargetSize: radioSize)
        .merge(radioStyle);
    final radio = switch (variant) {
      HyperRadioVariant.checkmark => HyperRadio<T>.checkmark(
        value: value,
        groupValue: groupValue,
        onChanged: interactive ? onChanged : null,
        toggleable: toggleable,
        style: resolvedRadioStyle,
      ),
      HyperRadioVariant.circle => HyperRadio<T>.circle(
        value: value,
        groupValue: groupValue,
        onChanged: interactive ? onChanged : null,
        toggleable: toggleable,
        style: resolvedRadioStyle,
      ),
      HyperRadioVariant.filled => HyperRadio<T>.filled(
        value: value,
        groupValue: groupValue,
        onChanged: interactive ? onChanged : null,
        toggleable: toggleable,
        style: resolvedRadioStyle,
      ),
    };

    return Semantics(
      selected: _selected,
      inMutuallyExclusiveGroup: true,
      child: HyperListTile(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: ExcludeSemantics(child: radio),
        density: density,
        onTap: interactive
            ? () => onChanged?.call(_selected && toggleable ? null : value)
            : null,
        enabled: enabled,
        autofocus: autofocus,
        focusNode: focusNode,
        semanticLabel: semanticLabel,
        style: style,
      ),
    );
  }
}
