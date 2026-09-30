import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'avatar_demo_images.dart';

class HyperAvatarPage extends StatelessWidget {
  const HyperAvatarPage({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final avatars = [
      for (final name in [
        '林',
        '陈',
        '李',
        '王',
        '赵',
        '周',
        '吴',
        '郑',
        '孙',
        '许',
        '何',
      ])
        HyperAvatar(text: name),
    ];
    final image = MemoryImage(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
      ),
    );
    const palette = [
      Color(0xFF3B82F6),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
      Color(0xFFF59E0B),
      Color(0xFF10B981),
    ];
    final coloredAvatars = [
      for (var i = 0; i < palette.length; i++)
        HyperAvatar(
          text: ['林', '陈', '李', '王', '赵'][i],
          style: HyperAvatarStyle(
            backgroundColor: palette[i],
            foregroundColor: Colors.white,
          ),
        ),
    ];
    final imageAvatars = [
      for (final data in avatarDemoImages)
        HyperAvatar(image: MemoryImage(base64Decode(data))),
    ];
    Widget section(String title, Widget child) => Padding(
      padding: EdgeInsets.only(bottom: sizes.sectionSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HyperText(title, variant: HyperTextVariant.sectionTitle),
          SizedBox(height: sizes.compactSectionSpacing),
          child,
        ],
      ),
    );
    return Material(
      color: theme.colors.background,
      child: ListView(
        padding: EdgeInsets.all(sizes.pageHorizontalPadding),
        children: [
          section(
            'HyperAvatar',
            Wrap(
              spacing: sizes.widgetGroup.spacing,
              children: [
                const HyperAvatar(text: '林'),
                const HyperAvatar(icon: Icon(Icons.face_outlined)),
                HyperAvatar(image: image, semanticsLabel: '本地图片示例'),
                HyperAvatar(
                  image: MemoryImage(Uint8List.fromList([0])),
                  text: '回退',
                ),
                const HyperAvatar(child: Icon(Icons.pets_outlined)),
              ],
            ),
          ),
          section(
            '尺寸与形状',
            Wrap(
              spacing: sizes.widgetGroup.spacing,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final size in HyperAvatarSizeVariant.values)
                  HyperAvatar(text: '林', size: size),
                const HyperAvatar(text: '陈', shape: HyperAvatarShape.rounded),
              ],
            ),
          ),
          section(
            '在线状态与角标',
            Wrap(
              spacing: sizes.sectionSpacing,
              children: [
                HyperBadgeAnchor(
                  position: HyperBadgePosition.bottomRight,
                  badge: HyperBadge(
                    style: HyperBadgeStyle(
                      backgroundColor: theme.colors.primary,
                    ),
                  ),
                  child: const HyperAvatar(text: '林'),
                ),
                const HyperBadgeAnchor(
                  badge: HyperBadge.number(count: 3),
                  child: HyperAvatar(text: '陈'),
                ),
              ],
            ),
          ),
          for (final layout in HyperAvatarGroupLayout.values.where(
            (value) => value != HyperAvatarGroupLayout.custom,
          ))
            section(
              switch (layout) {
                HyperAvatarGroupLayout.horizontal => '横向堆叠',
                HyperAvatarGroupLayout.row => '无重叠排列',
                HyperAvatarGroupLayout.vertical => '纵向堆叠',
                HyperAvatarGroupLayout.centered => '中心环绕',
                HyperAvatarGroupLayout.mosaic => '紧凑拼图',
                HyperAvatarGroupLayout.blended => '混色头像',
                HyperAvatarGroupLayout.windmill => '风车混色头像',
                HyperAvatarGroupLayout.custom => '自定义布局',
                HyperAvatarGroupLayout.circle5 => '圆形五角堆叠',
                HyperAvatarGroupLayout.grid4 => '四宫格',
                HyperAvatarGroupLayout.grid9 => '九宫格',
              },
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: HyperAvatarGroup(
                  avatars:
                      layout == HyperAvatarGroupLayout.blended ||
                          layout == HyperAvatarGroupLayout.windmill
                      ? coloredAvatars
                      : avatars,
                  layout: layout,
                ),
              ),
            ),
          section(
            '五个主色合成群组标识',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HyperAvatarGroup(
                  avatars: coloredAvatars,
                  layout: HyperAvatarGroupLayout.row,
                ),
                SizedBox(height: sizes.compactSectionSpacing),
                Wrap(
                  spacing: sizes.sectionSpacing,
                  children: [
                    HyperAvatarGroup(
                      avatars: coloredAvatars,
                      layout: HyperAvatarGroupLayout.blended,
                      groupSize: const Size.square(80),
                    ),
                    HyperAvatarGroup(
                      avatars: coloredAvatars,
                      layout: HyperAvatarGroupLayout.blended,
                      groupSize: const Size.square(80),
                      blendShape: HyperAvatarShape.rounded,
                    ),
                    HyperAvatarGroup(
                      avatars: coloredAvatars,
                      layout: HyperAvatarGroupLayout.blended,
                      blendColors: palette,
                      groupSize: const Size.square(80),
                      style: const HyperAvatarStyle(
                        foregroundColor: Colors.white,
                      ),
                      blendChild: const Icon(Icons.groups_outlined),
                    ),
                  ],
                ),
              ],
            ),
          ),
          section(
            '原色、柔和与风车对照',
            Wrap(
              spacing: sizes.sectionSpacing,
              runSpacing: sizes.compactSectionSpacing,
              children: [
                for (var index = 0; index < 3; index++)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HyperText(['原色', '柔和', '风车'][index]),
                      SizedBox(height: sizes.compactSectionSpacing),
                      HyperAvatarGroup(
                        avatars: coloredAvatars,
                        layout: index == 2
                            ? HyperAvatarGroupLayout.windmill
                            : HyperAvatarGroupLayout.blended,
                        groupSize: const Size.square(80),
                        style: HyperAvatarStyle(
                          blendSoftness: index == 0
                              ? 0
                              : index == 2
                              ? 0
                              : .45,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          section(
            '水滴风车材质',
            Wrap(
              spacing: sizes.sectionSpacing,
              children: [
                HyperAvatarGroup(
                  avatars: coloredAvatars,
                  layout: HyperAvatarGroupLayout.windmill,
                  groupSize: const Size.square(96),
                ),
                HyperAvatarGroup(
                  avatars: coloredAvatars,
                  layout: HyperAvatarGroupLayout.windmill,
                  blendColors: const [
                    Color(0xFF5387FA),
                    Color(0xFF23C7E8),
                    Color(0xFF09D9B1),
                    Color(0xFFFFD052),
                    Color(0xFFFF9656),
                    Color(0xFFF5789E),
                    Color(0xFFB068EF),
                  ],
                  style: const HyperAvatarStyle(
                    blendPetalRotation: -.30,
                    blendPetalOpacity: .65,
                  ),
                  groupSize: const Size.square(96),
                ),
              ],
            ),
          ),
          section(
            '从图片提取主色',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HyperAvatarGroup(
                  avatars: imageAvatars,
                  layout: HyperAvatarGroupLayout.row,
                ),
                SizedBox(height: sizes.compactSectionSpacing),
                HyperAvatarGroup(
                  avatars: imageAvatars,
                  layout: HyperAvatarGroupLayout.blended,
                  groupSize: const Size.square(80),
                ),
              ],
            ),
          ),
          for (final layout in [
            HyperAvatarGroupLayout.grid4,
            HyperAvatarGroupLayout.grid9,
            HyperAvatarGroupLayout.mosaic,
          ])
            section(
              '未满的${layout == HyperAvatarGroupLayout.grid4
                  ? '四宫格'
                  : layout == HyperAvatarGroupLayout.grid9
                  ? '九宫格'
                  : '紧凑拼图'}',
              Wrap(
                spacing: sizes.sectionSpacing,
                runSpacing: sizes.compactSectionSpacing,
                children: [
                  for (final count
                      in layout == HyperAvatarGroupLayout.grid9
                          ? [1, 2, 4, 5, 7, 8]
                          : [0, 1, 2, 3])
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HyperText('$count 个成员'),
                        SizedBox(height: sizes.compactSectionSpacing),
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: HyperAvatarGroup(
                              avatars: avatars.take(count).toList(),
                              layout: layout,
                              groupSize: const Size.square(80),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          section(
            '圆形拼图与九格拼图',
            Wrap(
              spacing: sizes.sectionSpacing,
              children: [
                HyperAvatarGroup(
                  avatars: avatars,
                  layout: HyperAvatarGroupLayout.mosaic,
                  groupSize: const Size.square(80),
                  mosaicShape: HyperAvatarShape.circle,
                ),
                HyperAvatarGroup(
                  avatars: avatars,
                  layout: HyperAvatarGroupLayout.mosaic,
                  mosaicColumns: 3,
                  groupSize: const Size.square(80),
                ),
              ],
            ),
          ),
          for (final layout in [
            HyperAvatarGroupLayout.horizontal,
            HyperAvatarGroupLayout.vertical,
          ])
            section(
              layout == HyperAvatarGroupLayout.horizontal ? '横向堆叠程度' : '纵向堆叠程度',
              Wrap(
                spacing: sizes.sectionSpacing,
                runSpacing: sizes.sectionSpacing,
                children: [
                  for (var level = 0; level < 3; level++)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HyperText(['不重叠', '默认堆叠', '紧密堆叠'][level]),
                        SizedBox(height: sizes.compactSectionSpacing),
                        HyperAvatarGroup(
                          avatars: coloredAvatars,
                          layout: layout,
                          maxVisible: 4,
                          style: HyperAvatarStyle(
                            overlap: sizes.avatar.overlap * level,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          section(
            '整组尺寸，内部自适应',
            Wrap(
              spacing: sizes.sectionSpacing,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final extent in [64.0, 96.0, 128.0])
                  HyperAvatarGroup(
                    avatars: avatars,
                    layout: HyperAvatarGroupLayout.centered,
                    groupSize: Size.square(extent),
                  ),
              ],
            ),
          ),
          section(
            '自定义位置和大小',
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: HyperAvatarGroup(
                avatars: avatars,
                maxVisible: 4,
                layout: HyperAvatarGroupLayout.custom,
                groupSize: const Size(160, 96),
                layoutBuilder: (context, count, extent) =>
                    HyperAvatarGroupGeometry(
                      size: const Size(160, 96),
                      slots: [
                        const Rect.fromLTWH(0, 16, 64, 64),
                        const Rect.fromLTWH(72, 0, 40, 40),
                        const Rect.fromLTWH(72, 48, 40, 40),
                        const Rect.fromLTWH(120, 28, 32, 32),
                      ].take(count).toList(),
                    ),
              ),
            ),
          ),
          section(
            '局部主题与自定义溢出',
            HyperAvatarTheme(
              data: HyperAvatarThemeData(
                style: HyperAvatarStyle(
                  backgroundColor: theme.colors.primaryContainer,
                  foregroundColor: theme.colors.onPrimaryContainer,
                ),
              ),
              child: HyperAvatarGroup(
                avatars: avatars,
                maxVisible: 3,
                overflowBuilder: (context, count) => HyperAvatar(
                  text: '+$count',
                  style: HyperAvatarStyle(
                    backgroundColor: theme.colors.primary,
                    foregroundColor: theme.colors.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
