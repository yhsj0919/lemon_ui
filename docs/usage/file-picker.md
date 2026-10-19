# 文件选择与上传界面

上传状态通过 uploadState(file) 返回 HyperFileUploadState，支持 waiting、uploading、
success、failed、canceled。progress 为 0–1 或 null（不确定进度），errorText 显示失败原因。
onRetry / onCancel 只发出业务操作通知，不修改任务、不取消网络请求；移除文件也由调用方
在 onChanged 中清理上传任务。状态与文件值分开，不会因进度变化将 Form 标记为已修改。
thumbnailBuilder 可提供受控预览；Demo 对已知大小不超过 10 MB 的图片使用第三方文件句柄
读取缩略图，其余显示普通文件图标。读取失败或图片解码失败回退图标。
Form 字段同样透传状态、重试、取消和缩略图接口。
Demo 的进度及失败重试完全本地模拟，不发送文件。

参考 E:/lemon_shadcn 的 AppFilePicker，HyperFilePicker 只封装界面与文件列表，
提供 dropzone / simple 两种外观。pick 回调与 dropBuilder 适配第三方实现，公共库
不创建文件系统访问、网络上传或自建拖放引擎。示例使用 file_picker 13.1.0、
desktop_drop 0.7.1、cross_file；0.8.4 的 dbus 约束与现有 file_picker Linux 依赖冲突，
采用兼容版本而不使用 dependency_overrides。

HyperFileSelection 保存 name、size 和原始 source 句柄；不预读整份文件字节。
allowedExtensions、maxFileSize、maxFiles 在选择和拖放入口执行相同检查；
开启大小限制时拒绝未知大小的文件。multiple=false 用新文件替换，取消选择保持原值。
trailingBuilder 可展示调用方控制的进度、成功、失败和重试操作，实际上传由业务完成。
元数据限制不替代服务端文件校验。

HyperFileFormField 使用不可变 List 值，支持必填/异步校验、禁用和重置。
界面复用 Card、Button、IconButton、文字与 Form 间距的现有四端主题（来源 D，待确认），
表面可用 style / pickerStyle 覆盖。新增入口位于“未确认 → 文件选择 Upload”。
原生文件选择及系统拖入需在各目标平台实际运行验证；widget 测试使用注入的 pick。
