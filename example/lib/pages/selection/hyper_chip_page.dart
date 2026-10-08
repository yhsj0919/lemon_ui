import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperChipPage extends StatefulWidget {
  const HyperChipPage({super.key});
  @override
  State<HyperChipPage> createState() => _HyperChipPageState();
}

class _HyperChipPageState extends State<HyperChipPage> {
  int _actionCount = 0;
  String _choice = '全部';
  final Set<String> _filters = {'设计', '开发'};
  final List<String> _inputs = ['文档', '图片', '视频', '音频'];
  bool _personSelected = false;
  bool _personVisible = true;
  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    final theme = HyperTheme.of(context);
    Widget chips(List<Widget> children) => Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: sizes.compactSectionSpacing,
      runSpacing: sizes.compactSectionSpacing,
      children: children,
    );
    Widget section(String title, Widget child) =>
        DemoSection(title: title, child: child);
    return ListView(
      padding: EdgeInsets.all(sizes.pageHorizontalPadding),
      children: [
        Align(
          alignment: AlignmentDirectional.topStart,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const HyperText('Chip', variant: HyperTextVariant.pageTitle),
                SizedBox(height: sizes.sectionSpacing),
                section(
                  '操作标签',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      chips([
                        HyperChip.action(
                          label: '刷新',
                          icon: const Icon(Icons.refresh),
                          onPressed: () => setState(() => _actionCount++),
                        ),
                        HyperChip.action(
                          label: '排序',
                          icon: const Icon(Icons.sort),
                          onPressed: () => setState(() => _actionCount++),
                        ),
                        HyperChip.action(
                          label: '分享',
                          icon: const Icon(Icons.share_outlined),
                          onPressed: () => setState(() => _actionCount++),
                        ),
                      ]),
                      SizedBox(height: sizes.compactSectionSpacing),
                      HyperText('已触发 $_actionCount 次操作'),
                    ],
                  ),
                ),
                section(
                  '单选 · 内容类型',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      chips([
                        for (final item in ['全部', '文档', '图片', '视频'])
                          HyperChip.choice(
                            label: item,
                            selected: _choice == item,
                            onSelected: (selected) {
                              if (selected) setState(() => _choice = item);
                            },
                          ),
                      ]),
                      SizedBox(height: sizes.compactSectionSpacing),
                      HyperText('当前：$_choice'),
                    ],
                  ),
                ),
                section(
                  '多选 · 兴趣筛选',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      chips([
                        for (final item in ['设计', '开发', '摄影', '阅读', '音乐'])
                          HyperChip.filter(
                            label: item,
                            selected: _filters.contains(item),
                            onSelected: (selected) => setState(() {
                              if (selected) {
                                _filters.add(item);
                              } else {
                                _filters.remove(item);
                              }
                            }),
                          ),
                      ]),
                      SizedBox(height: sizes.compactSectionSpacing),
                      HyperText(
                        _filters.isEmpty ? '未选择兴趣' : '已选：${_filters.join('、')}',
                      ),
                    ],
                  ),
                ),
                section(
                  '可删除标签',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_inputs.isEmpty)
                        const HyperText('标签已全部移除。')
                      else
                        chips([
                          for (final item in _inputs)
                            HyperChip.input(
                              key: ValueKey(item),
                              label: item,
                              icon: const Icon(Icons.attach_file),
                              onDeleted: () =>
                                  setState(() => _inputs.remove(item)),
                            ),
                        ]),
                      SizedBox(height: sizes.compactSectionSpacing),
                      HyperButton.tonal(
                        onPressed: () => setState(() {
                          _inputs
                            ..clear()
                            ..addAll(['文档', '图片', '视频', '音频']);
                        }),
                        child: const HyperText('恢复标签'),
                      ),
                    ],
                  ),
                ),
                section(
                  '头像 · 选择与删除独立',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_personVisible)
                        HyperChip.input(
                          label: '林',
                          selected: _personSelected,
                          avatar: HyperAvatar(
                            text: '林',
                            style: HyperAvatarStyle(
                              size: sizes.chip.avatarSize,
                            ),
                          ),
                          onSelected: (value) =>
                              setState(() => _personSelected = value),
                          onDeleted: () =>
                              setState(() => _personVisible = false),
                        ),
                      SizedBox(height: sizes.compactSectionSpacing),
                      HyperText(
                        '选中：${_personSelected ? '是' : '否'}；可见：${_personVisible ? '是' : '否'}',
                      ),
                      SizedBox(height: sizes.compactSectionSpacing),
                      HyperButton.tonal(
                        onPressed: () => setState(() {
                          _personVisible = true;
                          _personSelected = false;
                        }),
                        child: const HyperText('重置'),
                      ),
                    ],
                  ),
                ),
                section(
                  '禁用与长文字',
                  chips([
                    const HyperChip.action(label: '禁用操作'),
                    HyperChip.filter(
                      label: '已选且禁用',
                      selected: true,
                      enabled: false,
                      onSelected: (_) {},
                    ),
                    HyperChip.input(
                      label: '禁止删除',
                      enabled: false,
                      onDeleted: () {},
                    ),
                    SizedBox(
                      width: 200,
                      child: HyperChip.action(
                        label: '这是一条超过可用宽度的标签内容',
                        icon: const Icon(Icons.text_fields),
                        onPressed: () => setState(() => _actionCount++),
                      ),
                    ),
                  ]),
                ),
                section(
                  '局部主题与实例覆盖',
                  HyperChipTheme(
                    data: HyperChipThemeData(
                      style: HyperChipStyle(radius: sizes.controlRadius),
                      selected: HyperChipStyle(
                        background: HyperFill.color(
                          theme.colors.success.withValues(alpha: .12),
                        ),
                        foregroundColor: theme.colors.success,
                      ),
                    ),
                    child: chips([
                      HyperChip.filter(
                        label: '主题选中态',
                        selected: _personSelected,
                        onSelected: (value) =>
                            setState(() => _personSelected = value),
                      ),
                      HyperChip.action(
                        label: '实例边框',
                        style: HyperChipStyle(
                          borderColor: theme.colors.outline,
                          borderWidth: 1,
                          background: const HyperFill.none(),
                        ),
                        onPressed: () => setState(() => _actionCount++),
                      ),
                    ]),
                  ),
                ),
                section(
                  '与静态 Tag 对照',
                  chips([
                    const HyperTag(label: '静态标签'),
                    HyperChip.action(
                      label: '可点击',
                      onPressed: () => setState(() => _actionCount++),
                    ),
                    HyperChip.filter(
                      label: '可选择',
                      selected: _personSelected,
                      onSelected: (value) =>
                          setState(() => _personSelected = value),
                    ),
                  ]),
                ),
                section(
                  '头像上的选中对勾',
                  chips([
                    HyperChip.choice(
                      label: '蓝色',
                      selected: _personSelected,
                      avatar: const HyperAvatar(
                        style: HyperAvatarStyle(backgroundColor: Colors.blue),
                      ),
                      style: const HyperChipStyle(
                        checkmarkPlacement:
                            HyperChipCheckmarkPlacement.avatarReplacement,
                        checkmarkColor: Colors.white,
                      ),
                      onSelected: (value) =>
                          setState(() => _personSelected = value),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
