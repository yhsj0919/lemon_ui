import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperSliderPage extends StatefulWidget {
  const HyperSliderPage({super.key});
  @override
  State<HyperSliderPage> createState() => _HyperSliderPageState();
}

class _HyperSliderPageState extends State<HyperSliderPage> {
  final List<double> _volumes = [.25, .42, .31, .31, .66];
  static const _volumeLabels = ['媒体', '铃声', '闹钟', '通知', '超级小爱'];
  static const _volumeIcons = [
    Icons.bluetooth,
    Icons.notifications_none,
    Icons.alarm,
    Icons.notifications,
    Icons.auto_awesome,
  ];
  RangeValues _range = const RangeValues(.2, .8);
  RangeValues _steppedRange = const RangeValues(.25, .75);
  double _vertical = .65;
  double _stepped = .4;
  double _continuousWithPoints = .37;
  double _thin = .48;
  RangeValues _thinRange = const RangeValues(.3, .7);
  double _volumePanel = .48;
  double _brightnessPanel = .72;
  bool _volumeMoreSelected = false;
  bool _headphonesMuted = false;

  String percent(double value) => '${(value * 100).round()}%';
  String rangeLabel(RangeValues values) =>
      '${percent(values.start)} – ${percent(values.end)}';

  Widget example(
    String title,
    Widget control, {
    String? value,
    String? hint,
    IconData? icon,
  }) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: sizes.iconSize,
                color: theme.colors.textTertiary,
              ),
              SizedBox(width: sizes.compactSectionSpacing),
            ],
            Expanded(child: HyperText(title)),
            if (value != null)
              HyperText(
                value,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colors.textSecondary,
                ),
              ),
          ],
        ),
        SizedBox(height: sizes.compactSectionSpacing),
        control,
        if (hint != null) ...[
          SizedBox(height: sizes.compactSectionSpacing),
          HyperText(
            hint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget section(String title, List<Widget> examples) {
    final sizes = HyperTheme.sizesOf(context);
    return DemoSection(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < examples.length; i++) ...[
            if (i > 0) SizedBox(height: sizes.sectionSpacing),
            examples[i],
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    Widget capsule(String title, double value, HyperCapsuleSlider slider) =>
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HyperText(title),
            SizedBox(height: sizes.compactSectionSpacing),
            slider,
            SizedBox(height: sizes.compactSectionSpacing),
            HyperText(percent(value)),
          ],
        );
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
                const HyperText('Slider', variant: HyperTextVariant.pageTitle),
                SizedBox(height: sizes.sectionSpacing),
                section('音量调节', [
                  for (var i = 0; i < _volumes.length; i++)
                    example(
                      _volumeLabels[i],
                      HyperSlider(
                        value: _volumes[i],
                        onChanged: (value) =>
                            setState(() => _volumes[i] = value),
                        semanticFormatterCallback: percent,
                      ),
                      value: percent(_volumes[i]),
                      icon: _volumeIcons[i],
                    ),
                ]),
                section('普通细轨道', [
                  example(
                    '单值 · 越界回弹',
                    HyperElasticOverscrollRegion(
                      axis: Axis.horizontal,
                      maxExtent: sizes.slider.capsuleOverscrollExtent,
                      child: HyperSlider(
                        variant: HyperSliderVariant.thin,
                        value: _thin,
                        onChanged: (value) => setState(() => _thin = value),
                      ),
                    ),
                    value: percent(_thin),
                  ),
                  example(
                    '范围',
                    HyperRangeSlider(
                      variant: HyperSliderVariant.thin,
                      values: _thinRange,
                      onChanged: (values) =>
                          setState(() => _thinRange = values),
                    ),
                    value: rangeLabel(_thinRange),
                  ),
                ]),
                section('刻度与步进', [
                  example(
                    '步进吸附',
                    HyperSlider(
                      value: _stepped,
                      divisions: 5,
                      showDivisionPoints: true,
                      onChanged: (value) => setState(() => _stepped = value),
                    ),
                    value: percent(_stepped),
                    hint: '每格 20%，拖动时吸附到刻度。',
                  ),
                  example(
                    '连续拖动',
                    HyperSlider(
                      value: _continuousWithPoints,
                      divisions: 5,
                      snapToDivisions: false,
                      showDivisionPoints: true,
                      onChanged: (value) =>
                          setState(() => _continuousWithPoints = value),
                    ),
                    value: percent(_continuousWithPoints),
                    hint: '显示刻度点，不吸附。',
                  ),
                ]),
                section('范围滑块', [
                  example(
                    '连续范围',
                    HyperRangeSlider(
                      values: _range,
                      onChanged: (values) => setState(() => _range = values),
                    ),
                    value: rangeLabel(_range),
                  ),
                  example(
                    '步进范围',
                    HyperRangeSlider(
                      values: _steppedRange,
                      divisions: 4,
                      showDivisionPoints: true,
                      onChanged: (values) =>
                          setState(() => _steppedRange = values),
                    ),
                    value: rangeLabel(_steppedRange),
                  ),
                ]),
                section('垂直滑块', [
                  example(
                    '显示刻度 · 连续拖动',
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: sizes.compactSectionSpacing,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: HyperVerticalSlider(
                          height: 180,
                          value: _vertical,
                          divisions: 5,
                          snapToDivisions: false,
                          showDivisionPoints: true,
                          onChanged: (value) =>
                              setState(() => _vertical = value),
                        ),
                      ),
                    ),
                    value: percent(_vertical),
                  ),
                ]),
                section('胶囊滑块', [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: sizes.compactSectionSpacing,
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: sizes.sectionSpacing * 2,
                      runSpacing: sizes.sectionSpacing,
                      children: [
                        capsule(
                          '音量',
                          _volumePanel,
                          HyperCapsuleSlider(
                            height: 200,
                            value: _volumePanel,
                            onChanged: (value) =>
                                setState(() => _volumePanel = value),
                            style: const HyperSliderStyle(
                              capsuleTopIconTurns: .5,
                            ),
                            topIcon: Icon(
                              _volumeMoreSelected
                                  ? Icons.tune
                                  : Icons.more_horiz,
                            ),
                            onTopIconPressed: () => setState(
                              () => _volumeMoreSelected = !_volumeMoreSelected,
                            ),
                            bottomIcon: Icon(
                              _headphonesMuted
                                  ? Icons.headset_off
                                  : Icons.headphones,
                            ),
                            onBottomIconPressed: () => setState(
                              () => _headphonesMuted = !_headphonesMuted,
                            ),
                          ),
                        ),
                        capsule(
                          '亮度',
                          _brightnessPanel,
                          HyperCapsuleSlider(
                            height: 200,
                            value: _brightnessPanel,
                            onChanged: (value) =>
                                setState(() => _brightnessPanel = value),
                            style: const HyperSliderStyle(
                              capsuleBottomIconTurns: .5,
                            ),
                            topIcon: const Icon(Icons.brightness_auto_outlined),
                            bottomIcon: const Icon(Icons.wb_sunny_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
                section('禁用与主题覆盖', [
                  example(
                    '禁用',
                    const HyperSlider(value: .35, onChanged: null),
                    value: '35%',
                  ),
                  example(
                    '局部主题',
                    HyperSliderTheme(
                      data: HyperSliderThemeData(
                        style: HyperSliderStyle(
                          activeTrackColor: theme.colors.success,
                          thumbOutlineColor: theme.colors.success,
                        ),
                      ),
                      child: HyperSlider(
                        value: _volumes.first,
                        onChanged: (value) =>
                            setState(() => _volumes[0] = value),
                      ),
                    ),
                    value: percent(_volumes.first),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
