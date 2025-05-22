# Mac 开发环境一键配置脚本

## 脚本功能

这个脚本用于快速配置 Mac 开发环境，特别适合 Go 后端开发人员。它提供了以下功能：

1. 自动安装和配置基础开发工具
2. 交互式安装过程，支持选择性安装
3. 彩色命令行输出，提升用户体验
4. 错误处理机制，支持部分失败跳过操作
5. 自动配置 zsh 环境

## 安装的工具

### 基础工具
- Homebrew（如果未安装）
- Git
- Zsh 及其插件：
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - zsh-completions
  - autojump

### 开发工具
- mise（版本管理工具）
- Go 1.18 和 1.22（通过 mise 安装）
- Miniconda（Python 环境管理）

### Mac 应用程序
- iTerm2
- Google Chrome
- Cursor

## 使用方法

1. 下载脚本：
```bash
curl -O https://raw.githubusercontent.com/yourusername/mac-dev-setup/main/mac-dev-setup.sh
```

2. 添加执行权限：
```bash
chmod +x mac-dev-setup.sh
```

3. 运行脚本：
```bash
./mac-dev-setup.sh
```

## 交互说明

脚本运行过程中会提供以下交互选项：

1. 每个工具的安装都会询问是否继续（y/n）
2. 安装完成后会询问是否配置 zsh 插件
3. 最后会询问是否设置 Go 1.22 为默认版本

## 注意事项

1. 脚本需要网络连接
2. 部分工具可能需要管理员权限
3. 安装过程可能需要较长时间，请耐心等待
4. 如果某个工具安装失败，脚本会继续安装其他工具
5. 安装完成后需要重启终端或运行 `source ~/.zshrc` 使配置生效

## 故障排除

如果遇到问题：

1. 确保网络连接正常
2. 检查是否有足够的磁盘空间
3. 查看是否有权限问题
4. 如果某个工具安装失败，可以手动安装该工具后继续运行脚本

## 自定义配置

如果需要自定义配置：

1. 编辑脚本中的 `main()` 函数
2. 修改 `.zshrc` 配置部分
3. 添加或删除需要安装的工具

## 贡献

欢迎提交 Issue 和 Pull Request 来改进脚本。 