import 'package:flutter/material.dart';

/// 组件演示页的注册信息。
@immutable
final class GalleryItem {
  const GalleryItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.builder,
  });

  /// 跨版本保持稳定的页面标识。
  final String id;

  /// 菜单和标题栏显示的名称。
  final String title;

  /// 页面用途的简短说明。
  final String description;

  /// 前期菜单使用的 Flutter 原生图标。
  final IconData icon;

  /// 创建独立演示页。
  final WidgetBuilder builder;
}

/// 菜单中的组件分类。
@immutable
final class GallerySection {
  const GallerySection({required this.title, required this.items});

  /// 分类名称。
  final String title;

  /// 当前分类下的演示页。
  final List<GalleryItem> items;
}
