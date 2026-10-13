import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperDropdownPage extends StatefulWidget {
  const HyperDropdownPage({super.key});
  @override
  State<HyperDropdownPage> createState() => _State();
}

class _State extends State<HyperDropdownPage> {
  String label = '全部（2041）';
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    children: [
      DemoSection(
        title: '默认自定义面板',
        child: HyperDropdown(
          label: Text(label),
          panelBuilder: (context, close) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HyperText('这里可以放任意 Widget'),
              HyperButton.text(
                label: const Text('应用筛选'),
                onPressed: () {
                  setState(() => label = '已筛选');
                  close();
                },
              ),
            ],
          ),
        ),
      ),
      DemoSection(
        title: '分组与多级筛选（复用 Menu）',
        child: HyperDropdown(
          label: Text(label),
          panelBuilder: (context, close) => HyperMenu(
            showSurface: false,
            items: const [
              HyperMenuItem(
                id: 'all',
                label: '全部（2041）',
                leading: Icon(Icons.folder_outlined),
              ),
              HyperMenuItem(
                id: 'district',
                label: '行政区',
                children: [
                  HyperMenuItem(id: 'wanxia', label: '历下区（123）'),
                  HyperMenuItem(id: 'licheng', label: '历城区（12）'),
                ],
              ),
              HyperMenuItem(
                id: 'online',
                label: '在线（1340）',
                leading: Icon(Icons.phone_android),
              ),
            ],
            onSelected: (id) {
              setState(() => label = id);
              close();
            },
          ),
        ),
      ),
    ],
  );
}
