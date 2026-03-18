#!/bin/bash

# === CONFIG ===
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"
LOCK_FILE="/tmp/matugen_wppicker.lock"

# === Prevent concurrent matugen runs (mkdir is atomic on Linux) ===
if ! mkdir "$LOCK_FILE" 2>/dev/null; then
    notify-send "Wallpaper" "Already applying a wallpaper, please wait." 2>/dev/null || true
    exit 1
fi
trap 'rm -rf "$LOCK_FILE"' EXIT

cd "$WALLPAPER_DIR" || exit 1

# === handle spaces name
IFS=$'\n'

# === ICON-PREVIEW SELECTION WITH ROFI, SORTED BY NEWEST ===
SELECTED_WALL=$(for a in $(ls -t *.jpg *.png *.gif *.jpeg 2>/dev/null); do echo -en "$a\0icon\x1f$a\n"; done | rofi -dmenu -p "")
[ -z "$SELECTED_WALL" ] && exit 1
SELECTED_PATH="$WALLPAPER_DIR/$SELECTED_WALL"

# === SET WALLPAPER (runs once, lock ensures no concurrent execution) ===
matugen image "$SELECTED_PATH"

# === CREATE SYMLINK ===
mkdir -p "$(dirname "$SYMLINK_PATH")"
ln -sf "$SELECTED_PATH" "$SYMLINK_PATH"

