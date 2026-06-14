# Chill, Codex.

> Codex が Mac を離陸準備中のように鳴らすのを落ち着かせます。

[![Test](https://github.com/cpiz/chill-codex/actions/workflows/test.yml/badge.svg)](https://github.com/cpiz/chill-codex/actions/workflows/test.yml)

**言語:** [English](README.md) | [简体中文](README.zh-CN.md) | 日本語 | [한국어](README.ko.md)

![Chill Codex social preview](assets/social-preview.svg)

## このプロジェクトがある理由

Codex は気に入っていますが、長時間のセッション中に Mac がまるで離陸準備をしているような音を立て始めることがありました。

最初は、メモリプレッシャー、WindowServer、ディスプレイスケーリング、他の Electron アプリ、バックグラウンドツールなど、いろいろな原因を疑いました。数日調べた結果、自分の環境では Codex を Chromium の reduced-motion フラグ付きで起動する workaround が実際に効果的でした。

そのため、このプロジェクトは意図的に小さくしています。Codex にパッチを当てたり、Codex を置き換えたり、性能修正ツールのふりをしたりはしません。Codex をより落ち着いたモードで起動する小さなランチャーを作るだけです。

Chill Codex は、`Chill Codex.app` ランチャーを作成する小さな macOS 用インストールスクリプトです。公式 Codex アプリを reduced-motion の Chromium フラグ付きで起動し、長時間の Codex セッション中の UI モーションやレンダリング負荷を抑えます。

公式 Codex アプリの変更、バイナリの置き換え、自動更新の無効化、システム設定の変更は行いません。作成する wrapper app は、起動時に次のコマンドを実行します。

```sh
open -na /Applications/Codex.app --args --force-prefers-reduced-motion
```

## 何をするか

| すること | しないこと |
| --- | --- |
| 小さなランチャー app を作成する | Codex にパッチを当てない |
| Chromium フラグを 1 つ渡す | バイナリを置き換えない |
| 既定で `~/Applications` にインストールする | `sudo` を要求しない |
| 可能な場合は Codex app のアイコンをコピーする | Codex の自動更新を無効化しない |

## クイックインストール

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/cpiz/chill-codex/main/install.sh)"
```

インストール後:

1. Codex がすでに起動している場合は終了します。
2. `~/Applications/Chill Codex.app` を開きます。
3. 既定の起動方法にしたい場合は、`Chill Codex.app` を Dock に追加します。

## 動作確認

`Chill Codex.app` から Codex を起動した後、次を実行します。

```sh
ps axww -o command | grep 'Codex.app/Contents/MacOS/Codex'
```

Codex のメインプロセスに次の引数が含まれていれば有効です。

```text
/Applications/Codex.app/Contents/MacOS/Codex --force-prefers-reduced-motion
```

## より慎重なインストール

リモートスクリプトを直接実行したくない場合は、先にダウンロードして内容を確認してから実行できます。

```sh
curl -fsSLO https://raw.githubusercontent.com/cpiz/chill-codex/main/install.sh
less install.sh
sh install.sh
```

## アンインストール

最も簡単な方法は、次を削除することです。

```text
~/Applications/Chill Codex.app
```

アンインストールスクリプトも利用できます。

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/cpiz/chill-codex/main/uninstall.sh)"
```

アンインストールスクリプトは `chill-codex.generated` マーカーを持つ app bundle だけを削除するため、同名の無関係なアプリは削除しません。

## パスのカスタマイズ

既定では、インストーラーは次を探します。

```text
/Applications/Codex.app
```

ランチャーのインストール先は次です。

```text
~/Applications/Chill Codex.app
```

オプションで変更できます。

```sh
sh install.sh \
  --codex-app "/Applications/Codex.app" \
  --install-dir "$HOME/Applications" \
  --app-name "Chill Codex"
```

環境変数でも変更できます。

```sh
CODEX_APP_PATH="/Applications/Codex.app" \
CHILL_CODEX_INSTALL_DIR="$HOME/Applications" \
CHILL_CODEX_APP_NAME="Chill Codex" \
sh install.sh
```

## 仕組み

Codex のモデル推論はリモートで実行されますが、デスクトップアプリはローカルの Electron/Chromium UI、ローカルサービス、ツール呼び出し、ウィンドウレンダリングを実行します。長時間のセッションでは、頻繁なアニメーション、更新、合成が macOS の GPU と WindowServer に追加の負荷をかけることがあります。

Chromium/Electron は `--force-prefers-reduced-motion` フラグをサポートしています。Chill Codex が生成するランチャーは、このフラグ付きで Codex を起動し、UI を reduced-motion の挙動に寄せます。

このプロジェクトは、ファンが絶対に回らないことを保証するものではありません。対象は、Codex の長時間タスク中に UI モーションやレンダリングが生む追加のローカル負荷を減らすという限定的な workaround です。

## 開発

ソーシャルプレビュー用のアセットは `assets/` にあります。GitHub リポジトリの Social preview 画像には `assets/social-preview.png` を使います。

テストを実行します。

```sh
sh test/install-test.sh
```

スクリプト構文を確認します。

```sh
sh -n install.sh
sh -n uninstall.sh
sh -n test/install-test.sh
```

## 互換性

- システム: macOS
- 既定の Codex パス: `/Applications/Codex.app`
- 既定のインストール先: `~/Applications/Chill Codex.app`

## 免責事項

Chill Codex は OpenAI の公式プロジェクトではありません。Codex アプリの変更、パッチ適用、解析回避、再配布は行いません。将来の Codex リリースで Chromium/Electron の起動フラグの挙動が変わった場合、この workaround は調整が必要になる可能性があります。

## License

MIT
