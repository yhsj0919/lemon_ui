# 数字输入

`HyperNumberInput` 使用受控的 `double? value` 与 `onChanged`。支持 minimum、maximum、
step、precision（0–15）、enabled、readOnly、showClearButton、focusNode。
上下键和尾部按钮按 step 调节；精度舍入后钳制到范围，清空返回 null。
完整数字输入即时通知，临时的负号或小数点保留到提交/失焦；无法解析时恢复受控值。
输入使用小数点，不接受分组符或指数格式。

四端外观继承文本输入框与图标按钮主题；style 与 stepperStyle 是对应实例覆盖。
`HyperNumberFormField` 直接支持 Form 校验、重置与错误提示，inputStyle 配置输入外观，
通用 style 配置字段标签布局。示例位于“输入控件 → 数字输入 NumberInput”和表单页面。
