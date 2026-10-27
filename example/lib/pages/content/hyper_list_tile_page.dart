import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 并列展示基础列表项与具有明确导航语义的列表项。
class HyperListTilePage extends StatefulWidget {
  const HyperListTilePage({super.key});

  @override
  State<HyperListTilePage> createState() => _HyperListTilePageState();
}

class _HyperListTilePageState extends State<HyperListTilePage> {
  bool _switchValue = true;
  bool _checkboxValue = true;
  String _selectedLayout = 'standard';
  String _selectedLogLevel = 'info';

  @override
  Widget build(BuildContext context) {
    final colors = HyperTheme.of(context).colors;
    final metrics = HyperTheme.sizesOf(context).listTile;
    final override = HyperListTileTheme.of(context).style;
    return Material(
      color: colors.background,
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: HyperTheme.sizesOf(context).pageHorizontalPadding,
          vertical: 24,
        ),
        children: [
          const HyperText('列表项', variant: HyperTextVariant.pageTitle),
          const SizedBox(height: 8),
          const HyperText('基础排布不附加语义；进入下一级由导航列表项统一处理。'),
          const SizedBox(height: 28),
          Padding(
            padding: EdgeInsets.only(
              bottom: HyperTheme.sizesOf(context).sectionSpacing,
            ),
            child: HyperListGroup(
              title: Text('默认与紧凑'),
              titlePosition: HyperCardTitlePosition.inside,
              children: [
                HyperListTile(
                  title: const HyperText('默认最小高度'),
                  trailing: HyperText(
                    '${override?.minHeight ?? metrics.minHeight}',
                  ),
                  onTap: () {},
                ),
                HyperListTile(
                  density: HyperListTileDensity.compact,
                  title: const HyperText('紧凑最小高度'),
                  trailing: HyperText(
                    '${override?.minHeight ?? metrics.compactMinHeight}',
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: HyperTheme.sizesOf(context).sectionSpacing,
            ),
            child: HyperListGroup(
              title: Text('进入下一级'),
              titlePosition: HyperCardTitlePosition.inside,
              children: [
                HyperNavigationListTile(
                  leading: const Icon(Icons.wifi),
                  title: const Text('Text + Icon'),
                  onTap: () {},
                ),
                HyperNavigationListTile(
                  leading: const HyperIcon(Icons.bluetooth),
                  title: const HyperText('HyperText + HyperIcon'),
                  onTap: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: HyperTheme.sizesOf(context).sectionSpacing,
            ),
            child: HyperListGroup(
              title: Text('正文层级'),
              titlePosition: HyperCardTitlePosition.inside,
              children: [
                HyperNavigationListTile(
                  leading: const HyperIcon(Icons.backup_outlined),
                  title: const HyperText('桌面备份密码'),
                  subtitle: const HyperText('桌面完整备份当前未设置密码保护'),
                  onTap: () {},
                ),
                HyperNavigationListTile(
                  title: const HyperText('WLAN'),
                  description: const HyperText('Xiaomi_5G'),
                  onTap: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: HyperTheme.sizesOf(context).sectionSpacing,
            ),
            child: HyperListGroup(
              title: Text('尾部控件'),
              titlePosition: HyperCardTitlePosition.inside,
              children: [
                HyperSwitchListTile(
                  value: _switchValue,
                  onChanged: (value) => setState(() => _switchValue = value),
                  title: const HyperText('保持亮屏'),
                  subtitle: const HyperText('充电时屏幕不会休眠'),
                ),
                HyperCheckboxListTile(
                  value: _checkboxValue,
                  onChanged: (value) =>
                      setState(() => _checkboxValue = value ?? false),
                  title: const HyperText('允许通知'),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: HyperTheme.sizesOf(context).sectionSpacing,
            ),
            child: HyperListGroup(
              title: Text('整行单选'),
              titlePosition: HyperCardTitlePosition.inside,
              children: [
                HyperRadioListTile<String>(
                  value: 'standard',
                  groupValue: _selectedLayout,
                  onChanged: (value) =>
                      setState(() => _selectedLayout = value!),
                  leading: const HyperIcon(Icons.view_agenda_outlined),
                  title: const HyperText('标准布局'),
                ),
                HyperRadioListTile<String>(
                  value: 'compact',
                  groupValue: _selectedLayout,
                  onChanged: (value) =>
                      setState(() => _selectedLayout = value!),
                  leading: const HyperIcon(Icons.view_compact_outlined),
                  title: const HyperText('紧凑布局'),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: HyperTheme.sizesOf(context).sectionSpacing,
            ),
            child: HyperListGroup(
              title: Text('浮窗选项'),
              titlePosition: HyperCardTitlePosition.inside,
              children: [
                HyperPopupListTile<String>(
                  title: const HyperText('启用蓝牙堆栈日志'),
                  subtitle: HyperText(switch (_selectedLogLevel) {
                    'detail' => '详细',
                    'debug' => '调试',
                    'info' => '信息',
                    'warning' => '警告',
                    _ => '错误',
                  }),
                  value: _selectedLogLevel,
                  options: const [
                    HyperSelectOption(value: 'detail', label: '详细'),
                    HyperSelectOption(value: 'debug', label: '调试'),
                    HyperSelectOption(value: 'info', label: '信息'),
                    HyperSelectOption(value: 'warning', label: '警告'),
                    HyperSelectOption(value: 'error', label: '错误'),
                  ],
                  onChanged: (value) => setState(
                    () => _selectedLogLevel = value ?? _selectedLogLevel,
                  ),
                ),
                HyperListTile(
                  enabled: false,
                  title: HyperText('不可用列表项'),
                  subtitle: HyperText('标题、说明和尾部内容共同使用禁用状态。'),
                  trailing: HyperIcon(Icons.block),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
