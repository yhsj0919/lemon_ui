import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

class HyperDropdownMenuPage extends StatefulWidget {
  const HyperDropdownMenuPage({super.key});

  @override
  State<HyperDropdownMenuPage> createState() => _HyperDropdownMenuPageState();
}

class _HyperDropdownMenuPageState extends State<HyperDropdownMenuPage> {
  String? _selected;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 360),
    padding: EdgeInsets.symmetric(
      horizontal: HyperTheme.sizesOf(context).pageHorizontalPadding,
      vertical: 72,
    ),
    child: Wrap(
      spacing: 24,
      runSpacing: 24,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HyperText('默认'),
            const SizedBox(height: 8),
            HyperDropdownMenu<String>(
              placeholder: '选择布局',
              value: _selected,
              options: const [
                HyperDropdownOption(value: 'compact', label: '紧凑布局'),
                HyperDropdownOption(value: 'comfortable', label: '舒适布局'),
                HyperDropdownOption(
                  value: 'experimental',
                  label: '实验布局',
                  enabled: false,
                ),
              ],
              onChanged: (value) => setState(() => _selected = value),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HyperText('局部主题'),
            const SizedBox(height: 8),
            HyperDropdownMenuTheme(
              data: HyperDropdownMenuThemeData(
                style: HyperDropdownMenuStyle(
                  arrowColor: HyperTheme.of(context).colors.textTertiary,
                ),
              ),
              child: HyperDropdownMenu<String>(
                value: _selected,
                options: const [
                  HyperDropdownOption(value: 'compact', label: '紧凑布局'),
                  HyperDropdownOption(value: 'comfortable', label: '舒适布局'),
                ],
                onChanged: (value) => setState(() => _selected = value),
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HyperText('实例覆盖'),
            const SizedBox(height: 8),
            HyperDropdownMenu<String>(
              value: _selected,
              options: const [
                HyperDropdownOption(value: 'compact', label: '紧凑布局'),
                HyperDropdownOption(value: 'comfortable', label: '舒适布局'),
              ],
              style: HyperDropdownMenuStyle(
                width: HyperTheme.sizesOf(context).dropdownMenu.width + 24,
                arrowSize:
                    HyperTheme.sizesOf(context).dropdownMenu.arrowSize + 4,
              ),
              onChanged: (value) => setState(() => _selected = value),
            ),
          ],
        ),
        const HyperDropdownMenu<String>(
          value: null,
          placeholder: '不可用',
          options: [HyperDropdownOption(value: 'disabled', label: '不可用')],
          onChanged: null,
        ),
        HyperText(_selected == null ? '尚未选择' : '当前值：$_selected'),
      ],
    ),
  );
}
