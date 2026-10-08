import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

/// 展示文件路径导航、高亮与长路径滚动。
class HyperBreadcrumbPage extends StatefulWidget {
  const HyperBreadcrumbPage({super.key});

  @override
  State<HyperBreadcrumbPage> createState() => _HyperBreadcrumbPageState();
}

class _HyperBreadcrumbPageState extends State<HyperBreadcrumbPage> {
  int _highlightIndex = 2;

  static const _items = [
    HyperBreadcrumbItem(path: 'storage', label: '内部存储设备'),
    HyperBreadcrumbItem(path: 'baidu'),
    HyperBreadcrumbItem(path: 'flyflow'),
  ];

  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    return ListView(
      padding: EdgeInsets.all(sizes.pageHorizontalPadding),
      children: [
        DemoSection(
          title: '文件路径',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HyperBreadcrumb(
                items: _items,
                highlightIndex: _highlightIndex,
                onItemTap: (index) => setState(() => _highlightIndex = index),
              ),
            ],
          ),
        ),
        DemoSection(
          title: '长路径',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HyperBreadcrumb(
                items: const [
                  HyperBreadcrumbItem(path: 'storage', label: '内部存储设备'),
                  HyperBreadcrumbItem(path: 'documents', label: '文档'),
                  HyperBreadcrumbItem(path: 'project', label: '项目文件夹'),
                  HyperBreadcrumbItem(path: 'assets', label: '图片资源'),
                  HyperBreadcrumbItem(path: 'current', label: '当前目录'),
                ],
                onItemTap: (_) {},
              ),
            ],
          ),
        ),
        DemoSection(
          title: '主题覆盖',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HyperBreadcrumbTheme(
                data: const HyperBreadcrumbThemeData(
                  style: HyperBreadcrumbStyle(
                    backgroundColor: Color(0xFFE9EDF3),
                    highlightBackgroundColor: Color(0xFFFFE9B7),
                    disabledBackgroundColor: Color(0xFFF2F2F2),
                    textStyle: TextStyle(fontSize: 13),
                  ),
                ),
                child: HyperBreadcrumb(
                  items: const [
                    HyperBreadcrumbItem(path: 'storage', label: '内部存储设备'),
                    HyperBreadcrumbItem(
                      path: 'archive',
                      label: '归档',
                      enabled: false,
                    ),
                    HyperBreadcrumbItem(path: 'current', label: '当前目录'),
                  ],
                  onItemTap: (_) {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
