#!/bin/sh
set -eu

APP_NAME_DEFAULT="Chill Codex"
MARKER_NAME="chill-codex.generated"

usage() {
  cat <<'USAGE'
Usage: sh uninstall.sh [options]

Remove the Chill Codex launcher app.

Options:
  --install-dir DIR    Directory containing the generated app. Default: ~/Applications
  --app-name NAME      Generated app name. Default: Chill Codex
  --help              Show this help message.

Environment variables:
  CHILL_CODEX_INSTALL_DIR
  CHILL_CODEX_APP_NAME
USAGE
}

die() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

strip_trailing_slash() {
  value=$1
  while [ "${value%/}" != "$value" ]; do
    value=${value%/}
  done
  printf '%s' "$value"
}

INSTALL_DIR="${CHILL_CODEX_INSTALL_DIR:-$HOME/Applications}"
APP_NAME="${CHILL_CODEX_APP_NAME:-$APP_NAME_DEFAULT}"

while [ $# -gt 0 ]; do
  case "$1" in
    --install-dir)
      [ $# -ge 2 ] || die "--install-dir requires a directory."
      INSTALL_DIR=$2
      shift 2
      ;;
    --app-name)
      [ $# -ge 2 ] || die "--app-name requires a name."
      APP_NAME=$2
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      die "Unknown option: $1"
      ;;
  esac
done

INSTALL_DIR="$(strip_trailing_slash "$INSTALL_DIR")"
WRAPPER_APP="$INSTALL_DIR/$APP_NAME.app"
MARKER_PATH="$WRAPPER_APP/Contents/Resources/$MARKER_NAME"

if [ ! -e "$WRAPPER_APP" ]; then
  printf 'Nothing to remove: %s does not exist.\n' "$WRAPPER_APP"
  exit 0
fi

if [ ! -f "$MARKER_PATH" ]; then
  die "$WRAPPER_APP was not created by chill-codex. Refusing to remove it."
fi

rm -rf "$WRAPPER_APP"
printf 'Removed: %s\n' "$WRAPPER_APP"
