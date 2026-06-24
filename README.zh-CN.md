# Chill, Codex.

> 让 Codex 别再把你的 Mac 弄得像准备起飞。

[![Test](https://github.com/cpiz/chill-codex/actions/workflows/test.yml/badge.svg)](https://github.com/cpiz/chill-codex/actions/workflows/test.yml)

**语言：** [English](README.md) | 简体中文 | [日本語](README.ja.md) | [한국어](README.ko.md)

![Chill Codex social preview](assets/social-preview.svg)

## 为什么会有这个项目

我喜欢 Codex，但也注意到一个很奇怪的现象：它跑长任务的时候，我的 Mac 有时会突然响得像准备起飞。

一开始我怀疑过很多东西：内存压力、WindowServer、显示缩放、其他 Electron 应用、后台工具。折腾了几天之后，一个 workaround 对我的机器确实有明显帮助：用 Chromium 的 reduced-motion 参数启动 Codex。

所以这个项目刻意做得很小。它不修补 Codex，不替换 Codex，也不假装自己是性能修复工具。它只是创建一个小启动器，让 Codex 以更冷静的模式启动。

Chill Codex 是一个很小的 macOS 安装脚本，用来生成 `Chill Codex.app` 启动器。它会用 reduced-motion Chromium 参数启动官方 Codex App，让 Codex 跑长任务时少一点动效、少一点渲染压力，也让你的 Mac 稍微冷静一点。

它不修改官方 Codex App，不替换二进制，不关闭自动更新，也不修改系统设置。它只是创建一个 wrapper app，启动时执行：

```sh
open -na /Applications/Codex.app --args --force-prefers-reduced-motion
```

## 它做什么

| 它会做 | 它不会做 |
| --- | --- |
| 创建一个小启动器 app | 不修补 Codex |
| 传递一个 Chromium 参数 | 不替换二进制 |
| 默认安装到 `~/Applications` | 不需要 `sudo` |
| 可用时复制 Codex app 图标 | 不关闭 Codex 自动更新 |

## 快速安装

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/cpiz/chill-codex/main/install.sh)"
```

安装完成后：

1. 退出已经运行的 Codex。
2. 打开 `~/Applications/Chill Codex.app`。
3. 如果希望以后默认这样启动，把 `Chill Codex.app` 固定到 Dock。

## 确认是否生效

通过 `Chill Codex.app` 启动 Codex 后，运行：

```sh
ps axww -o command | grep 'Codex.app/Contents/MacOS/Codex'
```

你应该能看到 Codex 主进程带有：

```text
/Applications/Codex.app/Contents/MacOS/Codex --force-prefers-reduced-motion
```

## 更审慎的安装方式

如果你不喜欢直接运行远程脚本，可以先下载、阅读，再执行：

```sh
curl -fsSLO https://raw.githubusercontent.com/cpiz/chill-codex/main/install.sh
less install.sh
sh install.sh
```

## 卸载

最简单的方式是删除：

```text
~/Applications/Chill Codex.app
```

也可以执行卸载脚本：

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/cpiz/chill-codex/main/uninstall.sh)"
```

卸载脚本只会删除带有 `chill-codex.generated` 标记的 app，避免误删同名的其他应用。

## 自定义路径

默认情况下，脚本会查找：

```text
/Applications/Codex.app
```

并安装到：

```text
~/Applications/Chill Codex.app
```

你可以用参数覆盖：

```sh
sh install.sh \
  --codex-app "/Applications/Codex.app" \
  --install-dir "$HOME/Applications" \
  --app-name "Chill Codex"
```

也可以用环境变量：

```sh
CODEX_APP_PATH="/Applications/Codex.app" \
CHILL_CODEX_INSTALL_DIR="$HOME/Applications" \
CHILL_CODEX_APP_NAME="Chill Codex" \
sh install.sh
```

## 原理

Codex 的模型推理在远端，但桌面 App 仍然会在本机运行 Electron/Chromium UI、本地服务、工具调用和窗口渲染。长任务过程中，如果界面持续动画、刷新或合成，macOS 的 GPU 和 WindowServer 可能会出现额外压力。

Chromium/Electron 支持 `--force-prefers-reduced-motion` 参数。Chill Codex 生成的 wrapper app 会用这个参数启动 Codex，让 Codex UI 更倾向于 reduced-motion 行为。

这个项目不保证风扇永远不转。它只解决一种很具体的 workaround：减少 Codex 长任务期间由 UI 动效和渲染造成的额外本机负载。

## 已知限制

Chill Codex 只控制它自己发起的启动命令。如果 Codex 在官方 App 内完成更新并自行重启，重启后的进程可能不会继续带上 `--force-prefers-reduced-motion`。

遇到这种情况时，完全退出 Codex，然后重新打开 `~/Applications/Chill Codex.app`。可以用[确认是否生效](#确认是否生效)里的命令检查参数是否存在。

## 本地开发

社交预览资源放在 `assets/` 中。GitHub 仓库 Social preview 图片使用 `assets/social-preview.png`。

运行测试：

```sh
sh test/install-test.sh
```

检查脚本语法：

```sh
sh -n install.sh
sh -n uninstall.sh
sh -n test/install-test.sh
```

## 兼容性

- 系统：macOS
- 默认 Codex 路径：`/Applications/Codex.app`
- 默认安装位置：`~/Applications/Chill Codex.app`

## 免责声明

Chill Codex 不是 OpenAI 官方项目。它不会修改、打补丁、破解或重新分发 Codex App。Codex App 后续版本如果改变 Chromium/Electron 启动参数行为，这个 workaround 可能需要调整。

## License

MIT
