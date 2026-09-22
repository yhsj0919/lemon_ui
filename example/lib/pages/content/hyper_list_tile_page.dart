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
  String _selectedVpn = 'astral';

  @override
  Widget build(BuildContext context) {
    final colors = HyperTheme.of(context).colors;
    return Material(
      color: colors.background,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const HyperText('HyperListTile', variant: HyperTextVariant.pageTitle),
          const SizedBox(height: 8),
          const HyperText('基础排布不附加语义；进入下一级由导航列表项统一处理。'),
          const SizedBox(height: 28),
          const HyperText('默认与紧凑', variant: HyperTextVariant.sectionTitle),
          const SizedBox(height: 12),
          _TileCard(
            child: HyperListTile(
              title: const HyperText('默认高度'),
              trailing: const HyperText('56'),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 8),
          _TileCard(
            child: HyperListTile(
              density: HyperListTileDensity.compact,
              title: const HyperText('紧凑高度'),
              trailing: const HyperText('48'),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 28),
          const HyperText('进入下一级', variant: HyperTextVariant.sectionTitle),
          const SizedBox(height: 12),
          _TileCard(
            child: HyperNavigationListTile(
              leading: const Icon(Icons.wifi),
              title: const Text('Text + Icon'),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 8),
          _TileCard(
            child: HyperNavigationListTile(
              leading: const HyperIcon(Icons.bluetooth),
              title: const HyperText('HyperText + HyperIcon'),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 28),
          const HyperText('正文层级', variant: HyperTextVariant.sectionTitle),
          const SizedBox(height: 12),
          _TileCard(
            child: HyperNavigationListTile(
              leading: const HyperIcon(Icons.backup_outlined),
              title: const HyperText('桌面备份密码'),
              subtitle: const HyperText('桌面完整备份当前未设置密码保护'),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 8),
          _TileCard(
            child: HyperNavigationListTile(
              title: const HyperText('WLAN'),
              description: const HyperText('Xiaomi_5G'),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 28),
          const HyperText('尾部控件', variant: HyperTextVariant.sectionTitle),
          const SizedBox(height: 12),
          _TileCard(
            child: HyperListTile(
              title: const HyperText('保持亮屏'),
              subtitle: const HyperText('充电时屏幕不会休眠'),
              trailing: HyperSwitch(
                value: _switchValue,
                onChanged: (value) => setState(() => _switchValue = value),
              ),
              onTap: () => setState(() => _switchValue = !_switchValue),
            ),
          ),
          const SizedBox(height: 8),
          _TileCard(
            child: HyperCheckboxListTile(
              value: _checkboxValue,
              onChanged: (value) =>
                  setState(() => _checkboxValue = value ?? false),
              title: const HyperText('允许通知'),
            ),
          ),
          const SizedBox(height: 28),
          const HyperText('整行单选', variant: HyperTextVariant.sectionTitle),
          const SizedBox(height: 12),
          _TileCard(
            child: HyperRadioListTile<String>(
              value: 'astral',
              groupValue: _selectedVpn,
              onChanged: (value) => setState(() => _selectedVpn = value!),
              leading: const HyperIcon(Icons.vpn_key_outlined),
              title: const HyperText('astral'),
            ),
          ),
          const SizedBox(height: 8),
          _TileCard(
            child: HyperRadioListTile<String>(
              value: 'easytier',
              groupValue: _selectedVpn,
              onChanged: (value) => setState(() => _selectedVpn = value!),
              leading: const HyperIcon(Icons.flutter_dash),
              title: const HyperText('EasyTier Flutter Demo'),
            ),
          ),
          const SizedBox(height: 8),
          const _TileCard(
            child: HyperListTile(
              enabled: false,
              title: HyperText('不可用列表项'),
              subtitle: HyperText('标题、说明和尾部内容共同使用禁用状态。'),
              trailing: HyperIcon(Icons.block),
            ),
          ),
        ],
      ),
    );
  }
}

class _TileCard extends StatelessWidget {
  const _TileCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      HyperContainer(padding: EdgeInsets.zero, child: child);
}
