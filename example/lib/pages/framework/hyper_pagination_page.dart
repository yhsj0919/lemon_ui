import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperPaginationPage extends StatefulWidget {
  const HyperPaginationPage({super.key});
  @override
  State<HyperPaginationPage> createState() => _PageState();
}

class _PageState extends State<HyperPaginationPage> {
  int _page = 1, _compactPage = 1, _longPage = 50;
  bool _rtl = false;
  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    final colors = HyperTheme.of(context).colors;
    Widget section(String title, List<Widget> children) => DemoSection(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final child in children) ...[
            child,
            SizedBox(height: sizes.pagination.runSpacing),
          ],
        ],
      ),
    );
    return ListView(
      padding: EdgeInsets.all(sizes.pageHorizontalPadding),
      children: [
        const HyperText('Pagination', variant: HyperTextVariant.pageTitle),
        SizedBox(height: sizes.sectionSpacing),
        section('受控分页与首尾导航', [
          HyperPagination(
            pageCount: 20,
            currentPage: _page,
            showBoundaryButtons: true,
            onPageChanged: (value) => setState(() => _page = value),
          ),
          Text('当前页：$_page；页面自行获取对应数据。'),
        ]),
        section('简洁模式', [
          HyperPagination(
            pageCount: 8,
            currentPage: _compactPage,
            showPageNumbers: false,
            onPageChanged: (value) => setState(() => _compactPage = value),
          ),
        ]),
        section('大量页码与省略号', [
          HyperPagination(
            pageCount: 1000,
            currentPage: _longPage,
            siblingCount: 2,
            onPageChanged: (value) => setState(() => _longPage = value),
          ),
          Wrap(
            spacing: sizes.pagination.spacing,
            children: [
              HyperButton.text(
                label: const Text('第一页'),
                onPressed: () => setState(() => _longPage = 1),
              ),
              HyperButton.text(
                label: const Text('中间页'),
                onPressed: () => setState(() => _longPage = 500),
              ),
              HyperButton.text(
                label: const Text('最后一页'),
                onPressed: () => setState(() => _longPage = 1000),
              ),
            ],
          ),
        ]),
        section('禁用、单页与空数据', [
          HyperPagination(
            pageCount: 10,
            currentPage: 3,
            enabled: false,
            onPageChanged: (_) {},
          ),
          HyperPagination(pageCount: 1, currentPage: 1, onPageChanged: (_) {}),
          const HyperPagination(
            pageCount: 0,
            currentPage: 0,
            showPageNumbers: false,
          ),
        ]),
        section('主题覆盖与数字格式', [
          HyperPaginationTheme(
            data: HyperPaginationThemeData(
              style: HyperPaginationStyle(
                selectedStyle: HyperButtonStyle(
                  background: HyperFill.color(colors.surfaceMuted),
                  disabledBackground: HyperFill.color(colors.surfaceMuted),
                  foregroundColor: colors.textPrimary,
                  disabledForegroundColor: colors.textPrimary,
                ),
                buttonStyle: HyperButtonStyle(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            child: HyperPagination(
              pageCount: 20,
              currentPage: _page,
              pageLabelBuilder: (page) => page.toString().padLeft(2, '0'),
              onPageChanged: (value) => setState(() => _page = value),
            ),
          ),
        ]),
        section('RTL 布局', [
          HyperButton.text(
            label: Text(_rtl ? '切换 LTR' : '切换 RTL'),
            onPressed: () => setState(() => _rtl = !_rtl),
          ),
          Directionality(
            textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
            child: HyperPagination(
              pageCount: 20,
              currentPage: _page,
              showBoundaryButtons: true,
              onPageChanged: (value) => setState(() => _page = value),
            ),
          ),
        ]),
      ],
    );
  }
}
