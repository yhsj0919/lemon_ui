import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

class HyperBottomSheetPage extends StatefulWidget {
  const HyperBottomSheetPage({super.key});
  @override
  State<HyperBottomSheetPage> createState() => _HyperBottomSheetPageState();
}

class _HyperBottomSheetPageState extends State<HyperBottomSheetPage> {
  String _result = '尚未操作';
  bool _reduced = false;

  Future<void> _open(
    BuildContext context, {
    HyperBottomSheetStyle? style,
    bool longContent = false,
    bool locked = false,
    bool input = false,
    Widget? handle,
  }) async {
    final result = await showHyperBottomSheet<String>(
      context: context,
      style: style,
      enableDrag: !locked,
      barrierDismissible: !locked,
      builder: (sheetContext) => HyperBottomSheet(
        title: const Text('底部面板'),
        showCloseButton: true,
        showDragHandle: !locked,
        dragHandle: handle,
        content: input
            ? const HyperTextField(
                label: '输入内容',
                hintText: '键盘出现时面板避让',
                maxLength: 20,
                showCounter: true,
              )
            : Text(
                longContent
                    ? List.generate(
                        28,
                        (i) => '第 ${i + 1} 条：拖动顶部区域关闭，正文独立滚动，操作区保持可见。',
                      ).join('\n\n')
                    : '可以从顶部区域下拉关闭，也可以通过按钮关闭并返回结果。',
              ),
        actions: [
          HyperButton.tonal(
            label: const Text('取消'),
            onPressed: () => Navigator.of(sheetContext).pop('取消'),
          ),
          HyperButton.filled(
            label: const Text('完成'),
            onPressed: () => Navigator.of(sheetContext).pop('完成'),
          ),
        ],
      ),
    );
    if (mounted) setState(() => _result = result ?? '已关闭');
  }

  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    final colors = HyperTheme.of(context).colors;
    Widget section(String title, List<Widget> children) => Padding(
      padding: EdgeInsets.only(bottom: sizes.sectionSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HyperText(title, variant: HyperTextVariant.sectionTitle),
          SizedBox(height: sizes.compactSectionSpacing),
          Wrap(
            spacing: sizes.bottomSheet.actionSpacing,
            runSpacing: sizes.bottomSheet.actionRunSpacing,
            children: children,
          ),
        ],
      ),
    );
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: _reduced),
      child: Builder(
        builder: (context) => ListView(
          padding: EdgeInsets.all(sizes.pageHorizontalPadding),
          children: [
            const HyperText(
              'Bottom Sheet',
              variant: HyperTextVariant.pageTitle,
            ),
            SizedBox(height: sizes.sectionSpacing),
            section('默认与关闭规则', [
              HyperButton.filled(
                label: const Text('默认面板'),
                onPressed: () => _open(context),
              ),
              HyperButton.tonal(
                label: const Text('关闭拖动与遮罩点击'),
                onPressed: () => _open(context, locked: true),
              ),
              HyperButton.tonal(
                label: const Text('长正文'),
                onPressed: () => _open(context, longContent: true),
              ),
            ]),
            Text('结果：$_result'),
            SizedBox(height: sizes.sectionSpacing),
            section('固定高度与高度上限', [
              HyperButton.tonal(
                label: const Text('高度 320'),
                onPressed: () => _open(
                  context,
                  style: const HyperBottomSheetStyle(height: 320),
                ),
              ),
              HyperButton.tonal(
                label: const Text('最多 400，长正文滚动'),
                onPressed: () => _open(
                  context,
                  longContent: true,
                  style: const HyperBottomSheetStyle(maxHeight: 400),
                ),
              ),
            ]),
            section('边框、圆角与纵向按钮', [
              HyperButton.tonal(
                label: const Text('自定义表面'),
                onPressed: () => _open(
                  context,
                  style: HyperBottomSheetStyle(
                    border: Border.all(color: colors.primary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    background: HyperFill.color(colors.surfaceMuted),
                    actionsDirection: Axis.vertical,
                    buttonTheme: HyperButtonThemeData(
                      style: HyperButtonStyle(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
            section('拖动条和局部主题', [
              HyperButton.tonal(
                label: const Text('自定义拖动条'),
                onPressed: () => _open(
                  context,
                  handle: const Icon(Icons.drag_handle, color: Colors.teal),
                ),
              ),
              HyperBottomSheetTheme(
                data: const HyperBottomSheetThemeData(
                  style: HyperBottomSheetStyle(
                    dragHandleColor: Colors.teal,
                    dragHandleSize: Size(40, 4),
                    titleStyle: TextStyle(color: Colors.teal),
                  ),
                ),
                child: Builder(
                  builder: (localContext) => HyperButton.tonal(
                    label: const Text('局部主题'),
                    onPressed: () => _open(localContext),
                  ),
                ),
              ),
            ]),
            section('正文内容与键盘避让', [
              HyperButton.tonal(
                label: const Text('包含输入框'),
                onPressed: () => _open(context, input: true),
              ),
              HyperButton.tonal(
                label: const Text('自带列表滚动'),
                onPressed: () => showHyperBottomSheet<void>(
                  context: context,
                  style: const HyperBottomSheetStyle(height: 360),
                  builder: (sheetContext) => HyperBottomSheet(
                    title: const Text('滚动列表'),
                    scrollable: false,
                    content: ListView.builder(
                      itemCount: 30,
                      itemBuilder: (context, index) =>
                          HyperListTile(title: Text('列表项 ${index + 1}')),
                    ),
                    actions: [
                      HyperButton.filled(
                        label: const Text('关闭'),
                        onPressed: () => Navigator.of(sheetContext).pop(),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            section('动画设置', [
              HyperButton.tonal(
                label: const Text('自定义进出时长和曲线'),
                onPressed: () => _open(
                  context,
                  style: const HyperBottomSheetStyle(
                    animationStyle: AnimationStyle(
                      duration: Duration(milliseconds: 400),
                      reverseDuration: Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                      reverseCurve: Curves.easeInCubic,
                    ),
                  ),
                ),
              ),
            ]),
            HyperSwitchListTile(
              title: const Text('减少动画'),
              value: _reduced,
              onChanged: (value) => setState(() => _reduced = value),
            ),
          ],
        ),
      ),
    );
  }
}
