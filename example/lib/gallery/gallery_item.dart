import 'package:flutter/material.dart';

/// Demo 菜单中的主要使用场景，不限制组件在其他设备上使用。
enum GalleryAudience { common, mobile, desktop }

extension GalleryAudienceLabel on GalleryAudience {
  String get label => switch (this) {
    GalleryAudience.common => '公共',
    GalleryAudience.mobile => '手机／平板',
    GalleryAudience.desktop => '桌面',
  };
}

/// 组件演示页的注册信息。
@immutable
final class GalleryItem {
  const GalleryItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.builder,
    this.ownsAppBar = false,
  });

  /// 跨版本保持稳定的页面标识。
  final String id;

  /// 菜单和标题栏显示的名称。
  final String title;

  /// 页面用途的简短说明。
  final String description;

  /// 菜单项使用的图标数据。
  final IconData icon;

  /// 创建独立演示页。
  final WidgetBuilder builder;

  /// 页面自行绘制顶栏时，Gallery 不再额外叠加一层顶栏。
  final bool ownsAppBar;
}

/// 菜单中的组件分类。
@immutable
final class GallerySection {
  const GallerySection({
    required this.title,
    required this.items,
    this.audience = GalleryAudience.common,
  });

  /// 分类名称。
  final String title;

  /// 菜单所属场景；组件仍由统一主题适配各端。
  final GalleryAudience audience;

  /// 当前分类下的演示页。
  final List<GalleryItem> items;
}
