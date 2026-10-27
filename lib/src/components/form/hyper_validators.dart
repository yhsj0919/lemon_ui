import 'package:characters/characters.dart';
import 'package:flutter/widgets.dart' show FormFieldValidator;

/// 可直接传给 Flutter 或 Hyper 表单字段的同步校验器。
abstract final class HyperValidators {
  /// null、空字符串、空集合无效；false 和 0 是有效值。
  /// 字符串默认先去除首尾空白；自定义对象的空值语义由业务校验器处理。
  static FormFieldValidator<T> required<T>({
    String message = '此项为必填',
    bool trim = true,
  }) => (value) {
    final empty =
        value == null ||
        (value is String && (trim ? value.trim() : value).isEmpty) ||
        (value is Iterable && value.isEmpty) ||
        (value is Map && value.isEmpty);
    return empty ? message : null;
  };

  /// 按用户可见字符计数；null 和空字符串跳过，请组合 required 约束必填。
  /// trim 仅影响校验计数，不修改字段原值。
  static FormFieldValidator<String> minLength(
    int min, {
    String? message,
    bool trim = false,
  }) {
    if (min < 0) throw ArgumentError.value(min, 'min', '不能小于 0');
    return (value) {
      final text = trim ? value?.trim() : value;
      if (text == null || text.isEmpty) return null;
      return text.characters.length < min ? message ?? '至少输入 $min 个字符' : null;
    };
  }

  /// 按用户可见字符计数；null 和空字符串跳过。
  static FormFieldValidator<String> maxLength(
    int max, {
    String? message,
    bool trim = false,
  }) {
    if (max < 0) throw ArgumentError.value(max, 'max', '不能小于 0');
    return (value) {
      final text = trim ? value?.trim() : value;
      if (text == null || text.isEmpty) return null;
      return text.characters.length > max ? message ?? '最多输入 $max 个字符' : null;
    };
  }

  /// 按顺序返回首个错误；空规则列表始终通过。
  static FormFieldValidator<T> compose<T>(
    Iterable<FormFieldValidator<T>> validators,
  ) {
    final rules = List<FormFieldValidator<T>>.unmodifiable(validators);
    return (value) {
      for (final rule in rules) {
        final error = rule(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
