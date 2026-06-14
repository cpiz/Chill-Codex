#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TMP_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/chill-codex-test.XXXXXX")

cleanup() {
  rm -rf "$TMP_ROOT"
}
trap cleanup EXIT HUP INT TERM

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_file() {
  [ -f "$1" ] || fail "missing file: $1"
}

assert_dir() {
  [ -d "$1" ] || fail "missing directory: $1"
}

assert_executable() {
  [ -x "$1" ] || fail "not executable: $1"
}

assert_contains() {
  grep -F -- "$2" "$1" >/dev/null 2>&1 || fail "expected '$2' in $1"
}

FAKE_CODEX="$TMP_ROOT/fake/Codex ' Beta.app"
FAKE_HOME="$TMP_ROOT/home"
INSTALL_DIR="$FAKE_HOME/Applications"
APP_NAME="Chill & Codex"
WRAPPER_APP="$INSTALL_DIR/$APP_NAME.app"

mkdir -p "$FAKE_CODEX/Contents/MacOS" "$FAKE_CODEX/Contents/Resources" "$FAKE_HOME"
printf '#!/bin/sh\nexit 0\n' >"$FAKE_CODEX/Contents/MacOS/Codex"
chmod 755 "$FAKE_CODEX/Contents/MacOS/Codex"
printf 'fake-icon\n' >"$FAKE_CODEX/Contents/Resources/electron.icns"
cat >"$FAKE_CODEX/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleIconFile</key>
  <string>electron.icns</string>
</dict>
</plist>
PLIST

HOME="$FAKE_HOME" \
CODEX_APP_PATH="$FAKE_CODEX" \
CHILL_CODEX_INSTALL_DIR="$INSTALL_DIR" \
sh "$ROOT_DIR/install.sh" --app-name "$APP_NAME" >/dev/null

assert_dir "$WRAPPER_APP"
assert_file "$WRAPPER_APP/Contents/Info.plist"
assert_executable "$WRAPPER_APP/Contents/MacOS/chill-codex-launcher"
assert_file "$WRAPPER_APP/Contents/Resources/chill-codex.icns"
assert_file "$WRAPPER_APP/Contents/Resources/chill-codex.generated"
assert_contains "$WRAPPER_APP/Contents/Info.plist" "io.github.cpiz.chill-codex"
assert_contains "$WRAPPER_APP/Contents/Info.plist" "Chill &amp; Codex"
assert_contains "$WRAPPER_APP/Contents/MacOS/chill-codex-launcher" "--force-prefers-reduced-motion"
assert_contains "$WRAPPER_APP/Contents/MacOS/chill-codex-launcher" "CODEX_APP_DEFAULT="
sh -n "$WRAPPER_APP/Contents/MacOS/chill-codex-launcher"

if command -v plutil >/dev/null 2>&1; then
  plutil -lint "$WRAPPER_APP/Contents/Info.plist" >/dev/null
fi

HOME="$FAKE_HOME" \
CHILL_CODEX_INSTALL_DIR="$INSTALL_DIR" \
sh "$ROOT_DIR/uninstall.sh" --app-name "$APP_NAME" >/dev/null

[ ! -e "$WRAPPER_APP" ] || fail "wrapper app should have been removed"

printf 'All tests passed.\n'
