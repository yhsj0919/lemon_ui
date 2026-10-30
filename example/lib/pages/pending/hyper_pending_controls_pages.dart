import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

Widget _preview(Widget child) => MaterialApp(
  home: HyperTheme(
    data: HyperThemeData.light(),
    child: Scaffold(body: child),
  ),
);
@Preview(name: '评分', group: '选择控件', size: Size(360, 640))
Widget ratingPreview() => _preview(const HyperRatingPage());
@Preview(name: '穿梭框', group: '选择控件', size: Size(360, 800))
Widget transferPreview() => _preview(const HyperTransferPage());
@Preview(name: '可调整分栏', group: '容器与表面', size: Size(640, 600))
Widget resizablePreview() => _preview(const HyperResizablePage());
@Preview(name: '可移动对话框', group: '反馈与状态', size: Size(640, 600))
Widget movableDialogPreview() => _preview(const HyperMovableDialogPage());
@Preview(name: '导航栏', group: '标签导航', size: Size(360, 800))
Widget navigationBarPreview() => _preview(const HyperNavigationBarPage());

class HyperRatingPage extends StatefulWidget {
  const HyperRatingPage({super.key});
  @override
  State<HyperRatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<HyperRatingPage> {
  double value = 3.5;
  final form = HyperFormController();
  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    children: [
      const HyperText('评分。默认样式；鼠标预览、点击半星、方向键调整，Home 清空、End 满分。'),
      DemoSection(
        title: '默认 · 半星与允许清空',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HyperRating(
              value: value,
              onChanged: (v) => setState(() => value = v),
              allowClear: true,
            ),
            HyperText('$value / 5'),
          ],
        ),
      ),
      DemoSection(
        title: '默认 · 只读',
        child: HyperRating(value: 3.5, readOnly: true),
      ),
      DemoSection(
        title: '默认 · 禁用',
        child: HyperRating(value: 2, enabled: false, onChanged: (_) {}),
      ),
      DemoSection(
        title: 'Form · 校验与重置',
        child: HyperForm(
          controller: form,
          child: HyperRatingFormField(
            name: 'rating',
            label: '评分',
            initialValue: 3.5,
            validator: (v) => (v ?? 0) < 1 ? '至少选择一星' : null,
          ),
        ),
      ),
      DemoSection(
        title: '实例 Style 覆盖 · 自定义颜色（非默认）',
        child: HyperRating(
          value: value,
          style: const HyperRatingStyle(activeColor: Colors.orange),
          onChanged: (v) => setState(() => value = v),
        ),
      ),
    ],
  );
}

class HyperTransferPage extends StatefulWidget {
  const HyperTransferPage({super.key});
  @override
  State<HyperTransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<HyperTransferPage> {
  Set<int> value = {1};
  final options = List.generate(
    8,
    (i) => HyperTransferOption(value: i, label: '项目 ${i + 1}', enabled: i != 7),
  );
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    children: [
      const HyperText('穿梭框。勾选后移入/移出；支持搜索、过滤结果全选和禁用项。窄空间上下排列，设备类别保持不变。'),
      DemoSection(
        title: '默认 · 受控目标集合',
        child: HyperTransfer(
          options: options,
          value: value,
          onChanged: (v) => setState(() => value = v),
        ),
      ),
      HyperText('目标值：${value.join(', ')}'),
      DemoSection(
        title: '实例配置 · 无搜索（非默认）',
        child: HyperTransfer(
          options: options.take(3).toList(),
          value: value,
          searchable: false,
          enabled: false,
        ),
      ),
    ],
  );
}

class HyperResizablePage extends StatefulWidget {
  const HyperResizablePage({super.key});
  @override
  State<HyperResizablePage> createState() => _ResizablePageState();
}

class _ResizablePageState extends State<HyperResizablePage> {
  final controller = HyperResizableController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    Widget pane(String text) => Center(child: HyperText(text));
    return ListView(
      padding: EdgeInsets.all(sizes.pageHorizontalPadding),
      children: [
        const HyperText(
          '可调整分栏。拖动分隔条；聚焦后方向键逐像素调整，Shift 加速。双击或 Enter 收起/恢复可折叠面板。',
        ),
        DemoSection(
          title: '默认 · 水平分栏',
          child: SizedBox(
            height: sizes.selection.maxPanelHeight,
            child: HyperResizable(
              controller: controller,
              panes: [
                HyperResizablePane(child: pane('左侧内容'), collapsible: true),
                HyperResizablePane(child: pane('右侧内容')),
              ],
            ),
          ),
        ),
        HyperButton.text(
          onPressed: () =>
              controller.setCollapsed(0, !controller.collapsed.contains(0)),
          label: const Text('收起 / 恢复左侧'),
        ),
        DemoSection(
          title: '垂直布局 · 父布局指定高度',
          child: SizedBox(
            height: sizes.selection.maxPanelHeight,
            child: HyperResizable(
              direction: Axis.vertical,
              panes: [
                HyperResizablePane(child: pane('上方内容')),
                HyperResizablePane(child: pane('下方内容')),
              ],
            ),
          ),
        ),
        DemoSection(
          title: '实例约束 · 最小宽度不足时滚动',
          child: SizedBox(
            height: sizes.selection.maxPanelHeight,
            child: HyperResizable(
              panes: [
                for (var i = 0; i < 3; i++)
                  HyperResizablePane(
                    minimumExtent: sizes.form.minimumControlWidth,
                    child: pane('面板 ${i + 1}'),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class HyperMovableDialogPage extends StatefulWidget {
  const HyperMovableDialogPage({super.key});
  @override
  State<HyperMovableDialogPage> createState() => _MovableDialogPageState();
}

class _MovableDialogPageState extends State<HyperMovableDialogPage> {
  final controller = HyperMovableDialogController();
  bool _showClose = true, _showMaximize = true, _customButtons = false;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    children: [
      const HyperText('拖动标题移动，拖动四边或四角自由调整宽高。正文仍可选择文字和输入。双击标题最大化或还原，Home 复位位置。'),
      Wrap(
        spacing: HyperTheme.sizesOf(context).form.gap,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              HyperSwitch(
                value: _showClose,
                onChanged: (value) => setState(() => _showClose = value),
              ),
              const HyperText('显示关闭按钮'),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              HyperSwitch(
                value: _showMaximize,
                onChanged: (value) => setState(() => _showMaximize = value),
              ),
              const HyperText('显示最大化按钮'),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              HyperSwitch(
                value: _customButtons,
                onChanged: (value) => setState(() => _customButtons = value),
              ),
              const HyperText('实例覆盖 · 自定义按钮'),
            ],
          ),
        ],
      ),
      DemoSection(
        title: '默认 · 移动、调整大小与窗口边界',
        child: HyperButton.filled(
          label: const Text('打开可移动对话框'),
          onPressed: () async {
            await showHyperMovableDialog<void>(
              context: context,
              builder: (dialogContext) => HyperMovableDialog(
                controller: controller,
                showCloseButton: _showClose,
                showMaximizeButton: _showMaximize,
                closeButtonBuilder: _customButtons
                    ? (context, close) => HyperButton.text(
                        onPressed: close,
                        label: const Text('关闭窗口'),
                      )
                    : null,
                maximizeButtonBuilder: _customButtons
                    ? (context, maximized, toggle) => HyperButton.text(
                        onPressed: toggle,
                        label: Text(maximized ? '还原窗口' : '放大窗口'),
                      )
                    : null,
                title: const HyperText('拖动标题移动'),
                content: const HyperTextArea(
                  initialValue: '这里可以编辑多行内容。',
                  minLines: 3,
                ),
                actions: [
                  HyperButton.text(
                    onPressed: controller.reset,
                    label: const Text('复位'),
                  ),
                  HyperButton.filled(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    label: const Text('关闭'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      const HyperText('控制器保留位置与手动尺寸，最大化后可还原；外观继承对话框主题。'),
    ],
  );
}

class HyperNavigationBarPage extends StatefulWidget {
  const HyperNavigationBarPage({super.key});
  @override
  State<HyperNavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<HyperNavigationBarPage> {
  int selected = 0;
  bool collapsed = true;
  double _railInset(BuildContext context) =>
      ((50 - HyperTheme.of(context).sizes.desktop.sidebar.itemHeight) / 2)
          .clamp(0, 50);
  double _railWidth(BuildContext context) =>
      HyperTheme.sizesOf(context).sidebar.itemHeight + _railInset(context) * 2;
  static const destinations = [
    HyperNavigationDestination(
      value: 0,
      label: '首页',
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
    ),
    HyperNavigationDestination(
      value: 1,
      label: '发现',
      icon: Icon(Icons.explore_outlined),
    ),
    HyperNavigationDestination(
      value: 2,
      label: '个人',
      icon: Icon(Icons.person_outline),
    ),
    HyperNavigationDestination(
      value: 3,
      label: '禁用',
      icon: Icon(Icons.block),
      enabled: false,
    ),
  ];
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    children: [
      const HyperText(
        '底部／侧向导航栏。侧向导航复用 Sidebar 展开与折叠，底部导航沿用同一主题规格，背景继承统一高级材质。页面和路由由调用方管理。',
      ),
      DemoSection(
        title: '默认 · 底部横向导航',
        child: HyperNavigationBar(
          destinations: destinations,
          selectedValue: selected,
          onSelected: (v) => setState(() => selected = v),
        ),
      ),
      HyperText('当前页面：${destinations[selected].label}'),
      HyperButton.text(
        label: Text(collapsed ? '展开侧栏' : '折叠侧栏'),
        onPressed: () => setState(() => collapsed = !collapsed),
      ),
      DemoSection(
        title: '局部主题测试 · 桌面宽 50，其他设备随按钮拓宽，四边等距',
        child: HyperSidebarTheme(
          data: HyperSidebarThemeData(
            style: HyperSidebarStyle(
              collapsedWidth: _railWidth(context),
              horizontalPadding: (_railInset(context) * 2) / 2,
              verticalPadding: (_railInset(context) * 2) / 2,
            ),
          ),
          child: SizedBox(
            width: collapsed
                ? _railWidth(context)
                : HyperTheme.sizesOf(context).sidebar.width,
            height:
                HyperTheme.sizesOf(context).sidebar.itemHeight *
                    destinations.length +
                (collapsed
                        ? HyperTheme.sizesOf(context).sidebar.collapsedRowGap ??
                              HyperTheme.sizesOf(context).navigationItemSpacing
                        : HyperTheme.sizesOf(context).sidebar.rowGap ??
                              HyperTheme.sizesOf(context)
                                  .navigationItemSpacing) *
                    (destinations.length - 1) +
                (_railInset(context) * 2),
            child: HyperNavigationBar(
              destinations: destinations,
              selectedValue: selected,
              direction: Axis.vertical,
              collapsed: collapsed,
              onSelected: (v) => setState(() => selected = v),
            ),
          ),
        ),
      ),
      DemoSection(
        title: '标签配置 · 仅选中项显示',
        child: HyperNavigationBar(
          destinations: destinations,
          labelVisibility: HyperNavigationLabelVisibility.selected,
          selectedValue: selected,
          onSelected: (v) => setState(() => selected = v),
        ),
      ),
    ],
  );
}
