# Contributing

Thanks for helping improve Chill Codex.

This project is intentionally small. The best contributions keep it easy to inspect, easy to uninstall, and easy to trust.

## Project Scope

Chill Codex should remain:

- A tiny macOS launcher generator for Codex.
- A shell-script-first project.
- Safe by default: no `sudo`, no patching, no replacing Codex binaries.
- Easy to audit before running.

Please avoid expanding the project into a general-purpose CLI, GUI app, package manager, or all-Electron-app launcher unless there is a clear maintainer decision to change the scope.

## Development

Run the checks before opening a pull request:

```sh
sh -n install.sh
sh -n uninstall.sh
sh -n test/install-test.sh
sh test/install-test.sh
```

If you change any README file, update all language versions:

- `README.md`
- `README.zh-CN.md`
- `README.ja.md`
- `README.ko.md`

Keep commands, paths, installation URLs, disclaimers, and verification steps aligned across translations.

## Pull Requests

Good pull requests usually include:

- A short explanation of the user-facing problem.
- The smallest change that solves it.
- Updated tests when installer or uninstaller behavior changes.
- Updated docs when commands, paths, flags, or support boundaries change.

## Reporting Behavior

When reporting a bug, include:

- macOS version.
- Codex version if available.
- How Codex was installed.
- The exact install command you ran.
- The output of:

```sh
ps axww -o command | grep 'Codex.app/Contents/MacOS/Codex'
```

Do not include tokens, private workspace paths, or logs that contain sensitive content.
