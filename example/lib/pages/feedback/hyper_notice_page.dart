import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperNoticePage extends StatefulWidget {
  const HyperNoticePage({super.key});
  @override
  State<HyperNoticePage> createState() => _HyperNoticePageState();
}

class _HyperNoticePageState extends State<HyperNoticePage> {
  bool _alertVisible = true;
  bool _bannerVisible = true;
  bool _advanced = false;
  bool _reduced = false;
  HyperNoticeSeverity _severity = HyperNoticeSeverity.info;
  String _result = '尚未操作';
  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    final colors = HyperTheme.of(context).colors;
    final material = HyperSurfaceMaterial.frostedGlass(
      background: HyperFill.color(
        colors.surfaceElevated.withValues(alpha: .65),
      ),
      fallback: HyperSurfaceMaterial.solid(
        background: HyperFill.color(colors.surfaceElevated),
      ),
    );
    Widget section(String title, List<Widget> children) => DemoSection(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: sizes.alert.spacing),
            children[i],
          ],
        ],
      ),
    );
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: _reduced),
      child: HyperMaterialTheme(
        data: HyperMaterialThemeData(
          quality: _advanced
              ? HyperMaterialQuality.advanced
              : HyperMaterialQuality.standard,
        ),
        child: ListView(
          padding: EdgeInsets.all(sizes.pageHorizontalPadding),
          children: [
            const HyperText(
              'Alert / Banner',
              variant: HyperTextVariant.pageTitle,
            ),
            SizedBox(height: sizes.sectionSpacing),
            section('Alert · 四种状态', [
              for (final pair in <HyperNoticeSeverity, String>{
                HyperNoticeSeverity.info: '信息：设置将在下次启动时生效。',
                HyperNoticeSeverity.success: '成功：文件已保存。',
                HyperNoticeSeverity.warning: '警告：剩余空间不足，请及时清理。',
                HyperNoticeSeverity.error: '错误：连接失败，请稍后重试。',
              }.entries)
                HyperAlert(severity: pair.key, content: Text(pair.value)),
            ]),
            section('Banner · 标题、正文与操作', [
              HyperBanner(
                severity: HyperNoticeSeverity.warning,
                title: const Text('当前处于离线状态'),
                content: const Text('本地修改仍会保留，连接恢复后可同步。Banner 留在页面内，不创建浮层。'),
                actions: [
                  HyperButton.text(
                    label: const Text('重新连接'),
                    onPressed: () => setState(() => _result = '已触发重连'),
                  ),
                ],
              ),
              HyperBanner(
                severity: HyperNoticeSeverity.success,
                content: const Text('所有修改已同步。'),
                showIcon: false,
              ),
            ]),
            section('关闭与连续过渡', [
              HyperAlert(
                title: const Text('受控提示'),
                content: const Text('关闭仅发出回调，由页面修改 visible。'),
                severity: _severity,
                visible: _alertVisible,
                onClose: () => setState(() => _alertVisible = false),
              ),
              HyperBanner(
                title: const Text('页面横幅'),
                content: const Text('隐藏时收起自身高度，同时移除交互和语义。'),
                visible: _bannerVisible,
                onClose: () => setState(() => _bannerVisible = false),
              ),
              Wrap(
                spacing: sizes.alert.actionSpacing,
                runSpacing: sizes.alert.actionRunSpacing,
                children: [
                  HyperButton.tonal(
                    label: const Text('切换 Alert'),
                    onPressed: () =>
                        setState(() => _alertVisible = !_alertVisible),
                  ),
                  HyperButton.tonal(
                    label: const Text('切换 Banner'),
                    onPressed: () =>
                        setState(() => _bannerVisible = !_bannerVisible),
                  ),
                  HyperButton.tonal(
                    label: const Text('切换状态'),
                    onPressed: () => setState(
                      () => _severity =
                          HyperNoticeSeverity.values[(_severity.index + 1) %
                              HyperNoticeSeverity.values.length],
                    ),
                  ),
                ],
              ),
            ]),
            section('自定义内容与局部主题', [
              HyperAlert(
                showIcon: false,
                title: const Text('自定义正文'),
                content: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('• 正文接受任意 Widget'), Text('• 操作区自动换行')],
                ),
                actions: [
                  HyperButton.tonal(label: const Text('知道了'), onPressed: () {}),
                  HyperButton.text(label: const Text('查看帮助'), onPressed: () {}),
                ],
              ),
              HyperAlertTheme(
                data: const HyperAlertThemeData(
                  style: HyperNoticeStyle(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  info: HyperNoticeStyle(
                    iconColor: Colors.teal,
                    titleStyle: TextStyle(color: Colors.teal),
                  ),
                ),
                child: const HyperAlert(
                  title: Text('独立局部主题'),
                  content: Text('只修改 Alert，Banner 保留自身主题。'),
                ),
              ),
              HyperBanner(
                content: const Text('Banner 也可显式使用圆角和边框'),
                icon: const Icon(Icons.lightbulb_outline),
                style: HyperNoticeStyle(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.outline),
                ),
              ),
            ]),
            section('统一高级材质', [
              Row(
                children: [
                  const Expanded(child: Text('高级材质质量')),
                  HyperSwitch(
                    value: _advanced,
                    onChanged: (value) => setState(() => _advanced = value),
                  ),
                ],
              ),
              HyperAlert(
                title: const Text('磨砂玻璃 Alert'),
                content: const Text('质量和降级由统一主题控制。'),
                style: HyperNoticeStyle(material: material),
              ),
              HyperBanner(
                title: const Text('玻璃 Banner'),
                content: const Text('正文区域可使用相同的材质配方。'),
                style: HyperNoticeStyle(material: material),
              ),
            ]),
            Row(
              children: [
                const Expanded(child: Text('减少动画')),
                HyperSwitch(
                  value: _reduced,
                  onChanged: (value) => setState(() => _reduced = value),
                ),
              ],
            ),
            SizedBox(height: sizes.compactSectionSpacing),
            Text(_result),
          ],
        ),
      ),
    );
  }
}
