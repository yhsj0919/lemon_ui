# 打包 macOS 示例客户端

工作流：`.github/workflows/build-macos.yml`，构建目录为 `example`。

1. 将工作流和需要打包的代码推送至 GitHub。手动运行入口需要工作流先存在于默认分支。
2. 打开仓库 **Actions → Build macOS client → Run workflow**，选择分支并运行。
3. 默认使用 Flutter `3.47.7`，与当前开发环境一致；可在运行时修改，所含 Dart 须满足项目的 `^3.13.0` 约束。
4. 成功后下载运行页底部的 `macOS-client-运行编号` 产物。

产物包括保留应用权限及符号链接的 `.app.zip`、含 Applications 快捷入口的 `.dmg` 和 `SHA256SUMS.txt` 校验文件。解压 ZIP 或挂载 DMG，将应用放入 Applications 后运行。实际架构写入运行摘要，以构建结果为准。当前项目最低系统版本为 macOS 12。

这是沿用项目 ad-hoc 签名的测试构建，无需配置 Apple 证书，也没有上传 App Store 或进行 Apple 公证。首次打开可能被 Gatekeeper 拦截；确认文件来自自己的构建后，可在系统“隐私与安全性”中允许打开。正式对外分发时再接入 Developer ID 签名和公证。

依赖中的 `lemon_x` 从 GitHub 公共仓库的固定提交获取；如果未来改为私有仓库，需要另外提供只读依赖访问凭据。工作流仅手动触发，不会在每次提交时消耗 macOS 构建额度。

参考：[Flutter macOS 构建与发布](https://docs.flutter.dev/deployment/macos)、[Flutter Action 配置](https://github.com/subosito/flutter-action)。
