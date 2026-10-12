import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

class HyperColorPickerPage extends StatefulWidget {
  const HyperColorPickerPage({super.key});
  @override
  State<HyperColorPickerPage> createState() => _HyperColorPickerPageState();
}

class _HyperColorPickerPageState extends State<HyperColorPickerPage> {
  Color? _color;
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    children: [
      const HyperText('颜色选择器'),
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: HyperColorPickerField(
          value: _color ?? HyperTheme.of(context).colors.primary,
          onChanged: (color) => setState(() => _color = color),
        ),
      ),
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: HyperButton.outlined(
          child: const Text('打开选色弹窗'),
          onPressed: () async {
            final color = await showHyperColorPickerDialog(
              context: context,
              initialColor: _color ?? HyperTheme.of(context).colors.primary,
            );
            if (color != null && mounted) setState(() => _color = color);
          },
        ),
      ),
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: HyperColorPicker(
          value: _color ?? HyperTheme.of(context).colors.primary,
          onChanged: (value) => setState(() => _color = value),
        ),
      ),
    ],
  );
}
