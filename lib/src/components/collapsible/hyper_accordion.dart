import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_accordion_model.dart';
import 'hyper_accordion_style.dart';
import 'hyper_accordion_theme.dart';
import 'hyper_collapsible.dart';
import 'hyper_collapsible_theme.dart';

class HyperAccordion extends StatelessWidget {
  const HyperAccordion({
    super.key,
    required this.items,
    required this.expandedIds,
    this.onExpandedChanged,
    this.mode = HyperAccordionMode.single,
    this.enabled = true,
    this.maintainState = true,
    this.style,
  });
  final List<HyperAccordionItem> items;
  final Set<Object> expandedIds;
  final ValueChanged<Set<Object>>? onExpandedChanged;
  final HyperAccordionMode mode;
  final bool enabled, maintainState;
  final HyperAccordionStyle? style;
  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final metrics = HyperTheme.sizesOf(context).accordion;
    final resolved = HyperAccordionStyle(
      spacing: metrics.spacing,
      dividerThickness: metrics.dividerThickness,
      dividerColor: theme.colors.outline,
      showDividers: false,
    ).merge(HyperAccordionTheme.of(context).style).merge(style);
    final selection = HyperAccordionSelection(
      items: items,
      expandedIds: expandedIds,
      mode: mode,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) ...[
            if (resolved.showDividers!)
              Divider(
                height: resolved.spacing,
                thickness: resolved.dividerThickness,
                color: resolved.dividerColor,
              )
            else
              SizedBox(height: resolved.spacing),
          ],
          HyperCollapsibleTheme(
            key: ValueKey(items[i].id),
            data: resolved.itemTheme ?? const HyperCollapsibleThemeData(),
            child: HyperCollapsible(
              header: items[i].header,
              expanded: selection.expanded.contains(items[i].id),
              enabled: enabled && items[i].enabled,
              maintainState: maintainState,
              leading: items[i].leading,
              trailing: items[i].trailing,
              style: items[i].style,
              onExpandedChanged: onExpandedChanged == null
                  ? null
                  : (_) => onExpandedChanged!(selection.toggle(items[i].id)),
              child: items[i].child,
            ),
          ),
        ],
      ],
    );
  }
}
