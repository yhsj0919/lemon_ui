import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../button/hyper_button.dart';
import '../checkbox/hyper_checkbox.dart';
import '../checkbox/hyper_checkbox_style.dart';
import '../list_tile/hyper_checkbox_list_tile.dart';
import '../list_tile/hyper_list_tile.dart';
import '../text/hyper_text.dart';
import '../text_field/hyper_text_field.dart';
import '../card/hyper_card_style.dart';
import '../../foundation/hyper_fill.dart';
import '../surface/hyper_navigation_surface.dart';
import 'hyper_transfer_style.dart';
import 'hyper_transfer_theme.dart';

@immutable
class HyperTransferOption<T> {
  const HyperTransferOption({
    required this.value,
    required this.label,
    this.enabled = true,
    this.leading,
    this.description,
  });
  final T value;
  final String label;
  final bool enabled;
  final Widget? leading;
  final String? description;
}

/// Controlled target values; the component owns only search and checked rows.
class HyperTransfer<T> extends StatefulWidget {
  HyperTransfer({
    super.key,
    required List<HyperTransferOption<T>> options,
    required Set<T> value,
    this.onChanged,
    this.enabled = true,
    this.searchable = true,
    this.sourceTitle = '可选项',
    this.targetTitle = '已选择',
    this.emptyText = '暂无数据',
    this.searchHint = '搜索',
    this.addLabel = '移入',
    this.removeLabel = '移出',
    this.style,
  }) : options = List.unmodifiable(options),
       value = Set.unmodifiable(value) {
    if (options.map((o) => o.value).toSet().length != options.length) {
      throw ArgumentError('穿梭框选项的 value 必须唯一');
    }
  }
  final List<HyperTransferOption<T>> options;
  final Set<T> value;
  final ValueChanged<Set<T>>? onChanged;
  final bool enabled, searchable;
  final String sourceTitle,
      targetTitle,
      emptyText,
      searchHint,
      addLabel,
      removeLabel;
  final HyperTransferStyle? style;
  @override
  State<HyperTransfer<T>> createState() => _HyperTransferState<T>();
}

class _HyperTransferState<T> extends State<HyperTransfer<T>> {
  final _source = <T>{}, _target = <T>{};
  String _sourceQuery = '', _targetQuery = '';
  bool get interactive => widget.enabled && widget.onChanged != null;
  @override
  void didUpdateWidget(covariant HyperTransfer<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final movable = widget.options
        .where((o) => o.enabled)
        .map((o) => o.value)
        .toSet();
    _source.removeWhere(
      (v) => !movable.contains(v) || widget.value.contains(v),
    );
    _target.removeWhere(
      (v) => !movable.contains(v) || !widget.value.contains(v),
    );
  }

  void move(bool add) {
    if (!interactive) return;
    final checked = add ? _source : _target;
    final permitted = widget.options
        .where((o) => o.enabled && checked.contains(o.value))
        .map((o) => o.value)
        .toSet();
    if (permitted.isEmpty) return;
    final next = {...widget.value};
    if (add) {
      next.addAll(permitted);
    } else {
      next.removeAll(permitted);
    }
    setState(checked.clear);
    widget.onChanged!(Set.unmodifiable(next));
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context), sizes = HyperTheme.sizesOf(context);
    final style = HyperTransferTheme.of(context).style.merge(widget.style);
    final gap = style.gap ?? sizes.form.gap;
    final panelHeight = style.panelHeight ?? sizes.selection.maxPanelHeight;
    final panelWidth = style.panelWidth ?? sizes.menu.width;
    final checkSize = style.checkboxStyle?.size ?? sizes.menu.iconSize;
    final checkboxStyle = HyperCheckboxStyle(
      size: checkSize,
      markSize: math.min(checkSize, sizes.checkbox.markSize ?? checkSize),
      minimumTapTargetSize: checkSize,
    ).merge(style.checkboxStyle);
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : theme.motion.fastDuration;
    Widget panel(bool target, double availableWidth) {
      final checked = target ? _target : _source;
      final query = (target ? _targetQuery : _sourceQuery).trim().toLowerCase();
      final options = widget.options
          .where((o) => widget.value.contains(o.value) == target)
          .toList();
      final known = widget.options.map((o) => o.value).toSet();
      if (target) {
        // Preserve remotely selected identities; unknown entries are not silently removed.
        options.addAll(
          widget.value
              .where((v) => !known.contains(v))
              .map(
                (v) =>
                    HyperTransferOption(value: v, label: '$v', enabled: false),
              ),
        );
      }
      final visible = options
          .where(
            (o) => '${o.label} ${o.description ?? ''}'.toLowerCase().contains(
              query,
            ),
          )
          .toList();
      final selectable = visible
          .where((o) => o.enabled)
          .map((o) => o.value)
          .toSet();
      final selectedCount = selectable.intersection(checked).length;
      double textHeight(String text, TextStyle? textStyle, double width) {
        final painter = TextPainter(
          text: TextSpan(text: text, style: textStyle),
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout(maxWidth: math.max(1, width));
        final height = painter.height;
        painter.dispose();
        return height;
      }

      final padding =
          style.surfaceStyle?.padding?.resolve(Directionality.of(context)) ??
          EdgeInsets.all(sizes.menu.padding);
      final titleHeight = textHeight(
        '${target ? widget.targetTitle : widget.sourceTitle} (${options.length})',
        theme.textTheme.bodyMedium?.merge(style.titleStyle),
        availableWidth - padding.horizontal - sizes.minimumInteractiveDimension,
      );
      final searchLine = textHeight(
        widget.searchHint,
        theme.textTheme.labelLarge?.merge(style.searchStyle?.textStyle),
        availableWidth - padding.horizontal,
      );
      final searchPadding =
          style.searchStyle?.padding?.resolve(Directionality.of(context)) ??
          EdgeInsets.symmetric(vertical: sizes.textField.verticalPadding);
      final searchHeight = math.max(
        style.searchStyle?.minimumHeight ?? sizes.textField.minimumHeight,
        searchLine +
            searchPadding.vertical +
            (style.searchStyle?.borderWidth ?? 1) * 2,
      );
      final minHeight =
          math.max(titleHeight, sizes.minimumInteractiveDimension) +
          (widget.searchable ? searchHeight + gap * 2 : 0) +
          sizes.listTile.compactMinHeight;
      return HyperNavigationSurface(
        inheritMaterial: true,
        style: HyperCardStyle(
          background: HyperFill.color(theme.colors.surfaceElevated),
          border: Border.all(
            color: theme.colors.outline,
            width: sizes.divider.thickness,
          ),
          borderRadius: BorderRadius.circular(sizes.card.radius),
          padding: EdgeInsets.all(sizes.menu.padding),
        ).merge(style.surfaceStyle),
        child: SizedBox(
          height: math.max(panelHeight, minHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  HyperCheckbox.rounded(
                    style: checkboxStyle.merge(
                      HyperCheckboxStyle(
                        minimumTapTargetSize: sizes.minimumInteractiveDimension,
                      ),
                    ),
                    value: selectedCount == 0
                        ? false
                        : selectedCount == selectable.length
                        ? true
                        : null,
                    tristate: true,
                    semanticLabel:
                        '全选${target ? widget.targetTitle : widget.sourceTitle}',
                    onChanged: !interactive || selectable.isEmpty
                        ? null
                        : (_) => setState(() {
                            if (selectedCount == selectable.length) {
                              checked.removeAll(selectable);
                            } else {
                              checked.addAll(selectable);
                            }
                          }),
                  ),
                  Expanded(
                    child: HyperText(
                      '${target ? widget.targetTitle : widget.sourceTitle} (${options.length})',
                      style: style.titleStyle,
                    ),
                  ),
                ],
              ),
              if (widget.searchable)
                Padding(
                  padding: EdgeInsets.only(top: gap, bottom: gap),
                  child: HyperTextField(
                    key: ValueKey(
                      target
                          ? 'transfer-target-search'
                          : 'transfer-source-search',
                    ),
                    hintText: widget.searchHint,
                    enabled: widget.enabled,
                    style: style.searchStyle,
                    onChanged: (text) => setState(() {
                      if (target) {
                        _targetQuery = text;
                      } else {
                        _sourceQuery = text;
                      }
                    }),
                  ),
                ),
              Expanded(
                child: visible.isEmpty
                    ? Center(
                        child: HyperText(
                          widget.emptyText,
                          style: style.emptyStyle,
                        ),
                      )
                    : ListView.separated(
                        separatorBuilder: (_, index) => SizedBox(
                          height:
                              style.itemSpacing ?? sizes.transfer.itemSpacing,
                        ),
                        itemCount: visible.length,
                        itemBuilder: (_, index) {
                          final option = visible[index];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(
                              style.itemRadius ?? sizes.menu.itemRadius,
                            ),
                            child: AnimatedContainer(
                              duration: duration,
                              curve: theme.motion.fastCurve,
                              color: checked.contains(option.value)
                                  ? style.selectedItemColor ??
                                        theme.colors.primary.withValues(
                                          alpha: .08,
                                        )
                                  : Colors.transparent,
                              child: HyperCheckboxListTile(
                                key: ValueKey((target, option.value)),
                                title: Text(option.label),
                                subtitle: option.description == null
                                    ? null
                                    : Text(option.description!),
                                leading: option.leading,
                                value: checked.contains(option.value),
                                density: HyperListTileDensity.compact,
                                enabled: interactive && option.enabled,
                                style: style.itemStyle,
                                variant: HyperCheckboxVariant.rounded,
                                checkboxStyle: checkboxStyle,
                                onChanged: !interactive || !option.enabled
                                    ? null
                                    : (_) => setState(() {
                                        if (!checked.add(option.value)) {
                                          checked.remove(option.value);
                                        }
                                      }),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      );
    }

    final actions = Wrap(
      spacing: gap,
      runSpacing: gap,
      children: [
        HyperButton.filled(
          onPressed: interactive && _source.isNotEmpty
              ? () => move(true)
              : null,
          style: style.actionStyle,
          label: Text(widget.addLabel),
        ),
        HyperButton.outlined(
          onPressed: interactive && _target.isNotEmpty
              ? () => move(false)
              : null,
          style: style.actionStyle,
          label: Text(widget.removeLabel),
        ),
      ],
    );
    return LayoutBuilder(
      builder: (_, constraints) {
        final stacked =
            constraints.maxWidth <
            panelWidth * 2 + gap * 2 + sizes.button.minimumSize.width;
        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              panel(false, constraints.maxWidth),
              Padding(
                padding: EdgeInsets.symmetric(vertical: gap),
                child: actions,
              ),
              panel(true, constraints.maxWidth),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: panel(
                false,
                (constraints.maxWidth -
                        sizes.button.minimumSize.width -
                        gap * 2) /
                    2,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: gap),
              child: SizedBox(
                width: sizes.button.minimumSize.width,
                child: actions,
              ),
            ),
            Expanded(
              child: panel(
                true,
                (constraints.maxWidth -
                        sizes.button.minimumSize.width -
                        gap * 2) /
                    2,
              ),
            ),
          ],
        );
      },
    );
  }
}
