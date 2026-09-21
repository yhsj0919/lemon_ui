import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 展示 HyperContainer 的主题优先级、渐变和精确尺寸。
class HyperContainerPage extends StatefulWidget {
  const HyperContainerPage({super.key});

  @override
  State<HyperContainerPage> createState() => _HyperContainerPageState();
}

class _HyperContainerPageState extends State<HyperContainerPage> {
  bool _alternate = false;

  @override
  Widget build(BuildContext context) {
    final base = HyperThemeData.fromSeed(seedColor: const Color(0xFFFF6900));
    final themed = base.copyWith(
      containerTheme: HyperContainerThemeData(
        background: const HyperFill.color(Color(0xFFFFE4D1)),
        borderRadius: BorderRadius.circular(20),
        padding: const EdgeInsets.all(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
    );

    return HyperTheme(
      data: themed,
      child: Material(
        color: themed.colors.background,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'HyperContainer',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('实例属性优先于容器主题；尺寸直接使用明确的逻辑像素。'),
            const SizedBox(height: 20),
            FilledButton.tonal(
              onPressed: () => setState(() => _alternate = !_alternate),
              child: const Text('切换动画效果'),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                const _Sample(
                  title: '继承容器主题',
                  child: HyperContainer(
                    key: Key('themed-container'),
                    width: 220,
                    height: 120,
                    child: Text('220 × 120'),
                  ),
                ),
                _Sample(
                  title: '实例渐变覆盖',
                  child: HyperContainer(
                    key: const Key('gradient-container'),
                    width: 220,
                    height: 120,
                    alignment: Alignment.center,
                    background: HyperFill.gradient(
                      LinearGradient(
                        colors: _alternate
                            ? const [Color(0xFF7C4DFF), Color(0xFF00BCD4)]
                            : const [Color(0xFFFF6900), Color(0xFFFFC107)],
                      ),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(_alternate ? 40 : 12),
                    ),
                    child: const Text(
                      '实例属性',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const _Sample(
                  title: '显式清除背景和阴影',
                  child: HyperContainer(
                    key: Key('clear-container'),
                    width: 220,
                    height: 120,
                    background: HyperFill.none(),
                    boxShadow: [],
                    border: Border.fromBorderSide(
                      BorderSide(color: Color(0xFFFF6900), width: 2),
                    ),
                    child: Text('透明背景'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Sample extends StatelessWidget {
  const _Sample({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(title), const SizedBox(height: 10), child],
    );
  }
}
