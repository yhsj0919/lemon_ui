import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperSelectFieldsPage extends StatefulWidget {
  const HyperSelectFieldsPage({super.key});
  @override
  State<HyperSelectFieldsPage> createState() => _PageState();
}

class _PageState extends State<HyperSelectFieldsPage> {
  static const _options = [
    HyperSelectOption(value: 'compact', label: '紧凑布局'),
    HyperSelectOption(value: 'comfortable', label: '舒适布局'),
    HyperSelectOption(value: 'wide', label: '宽屏布局'),
    HyperSelectOption(value: 'read', label: '阅读布局'),
    HyperSelectOption(value: 'locked', label: '实验布局（禁用）', enabled: false),
  ];
  String? _single, _auto;
  Set<String> _multiple = {'compact', 'comfortable', 'wide', 'read'};
  Set<String> _autoMultiple = {'compact', 'comfortable', 'wide'};
  Set<int> _remote = {37};
  int _requests = 0;
  bool _failNext = false;
  HyperSelectPresentation _presentation = HyperSelectPresentation.adaptive;
  late final _source = HyperSelectSource<int>.async(
    pagination: HyperSelectPagination.page,
    pageSize: 8,
    loader: (query) async {
      setState(() => _requests++);
      await Future<void>.delayed(const Duration(milliseconds: 450));
      if (_failNext) {
        _failNext = false;
        throw StateError('模拟请求失败');
      }
      final ids = List.generate(
        48,
        (i) => i + 1,
      ).where((id) => '成员 $id'.contains(query.text)).toList();
      final start = (query.page - 1) * query.pageSize;
      final page = ids.skip(start).take(query.pageSize).toList();
      return HyperSelectPage(
        options: [
          for (final id in page)
            HyperSelectOption(value: id, label: '成员 $id', enabled: id != 12),
        ],
        hasMore: start + page.length < ids.length,
      );
    },
  );
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    children: [
      DemoSection(
        title: '共用弹出方式（默认桌面锚定、手机弹窗）',
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final mode in HyperSelectPresentation.values)
              HyperChip.choice(
                label: switch (mode) {
                  HyperSelectPresentation.adaptive => '自动',
                  HyperSelectPresentation.anchored => '锚定',
                  HyperSelectPresentation.trailing => '尾部锚定',
                  HyperSelectPresentation.bottomSheet => '底部弹窗',
                  HyperSelectPresentation.fullScreen => '全屏页',
                },
                selected: mode == _presentation,
                onSelected: (_) => setState(() => _presentation = mode),
              ),
          ],
        ),
      ),
      DemoSection(
        title: '基础单选与整体禁用',
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            HyperSelect<String>(
              options: _options,
              value: _single,
              presentation: _presentation,
              onChanged: (value) => setState(() => _single = value),
            ),
            const HyperSelect<String>(
              options: _options,
              value: null,
              placeholder: '不可用',
              onChanged: null,
            ),
          ],
        ),
      ),
      DemoSection(
        title: '下拉：面板内搜索、单选可取消',
        child: HyperSelect<String>(
          options: _options,
          value: _single,
          searchable: true,
          allowDeselect: true,
          presentation: _presentation,
          onChanged: (value) => setState(() => _single = value),
        ),
      ),
      DemoSection(
        title: '多选：Chip 删除、+N 和选择上限',
        child: HyperSelect<String>.multiple(
          options: _options,
          values: _multiple,
          maximumSelection: 4,
          searchable: true,
          presentation: _presentation,
          onSelectionChanged: (values) => setState(() => _multiple = values),
        ),
      ),
      DemoSection(
        title: '自动填充：直接输入搜索',
        child: HyperAutocomplete<String>(
          options: _options,
          value: _auto,
          presentation: _presentation,
          onChanged: (value) => setState(() => _auto = value),
        ),
      ),
      DemoSection(
        title: '自动填充多选：输入、删除与 +N',
        child: HyperAutocomplete<String>.multiple(
          options: _options,
          values: _autoMultiple,
          presentation: _presentation,
          onSelectionChanged: (values) =>
              setState(() => _autoMultiple = values),
        ),
      ),
      DemoSection(
        title: '异步搜索、分页、失败重试与跨页选中',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HyperSelect<int>.multiple(
              source: _source,
              values: _remote,
              labelBuilder: (id) => '成员 $id',
              searchable: true,
              presentation: _presentation,
              onSelectionChanged: (values) => setState(() => _remote = values),
            ),
            Text('请求次数：$_requests；选中：${_remote.join('、')}'),
            HyperButton.text(
              label: const Text('下一次请求失败'),
              onPressed: () => setState(() => _failNext = true),
            ),
          ],
        ),
      ),
      DemoSection(
        title: '列表尾部选择（复用 PopupListTile）',
        child: HyperPopupListTile<String>(
          title: const Text('布局'),
          options: _options,
          value: _single,
          presentation: _presentation,
          allowDeselect: true,
          onChanged: (value) => setState(() => _single = value),
        ),
      ),
      DemoSection(
        title: '下拉主题与实例覆盖',
        child: HyperSelectTheme(
          data: HyperSelectThemeData(
            style: HyperSelectStyle(
              arrowColor: HyperTheme.of(context).colors.textTertiary,
            ),
          ),
          child: HyperSelect<String>(
            options: _options,
            value: _single,
            style: HyperSelectStyle(
              width: HyperTheme.sizesOf(context).select.width + 24,
            ),
            onChanged: (value) => setState(() => _single = value),
          ),
        ),
      ),
      DemoSection(
        title: '局部主题覆盖',
        child: HyperSelectionTheme(
          data: HyperSelectionThemeData(
            style: HyperSelectionStyle(
              maxPanelHeight: 240,
              chipSpacing: 6,
              surfaceStyle: HyperCardStyle(
                borderRadius: BorderRadius.circular(18),
              ),
              searchStyle: const HyperTextFieldStyle(height: 36),
            ),
          ),
          child: HyperSelect<String>(
            options: _options,
            value: _single,
            searchable: true,
            onChanged: (value) => setState(() => _single = value),
          ),
        ),
      ),
    ],
  );
}
