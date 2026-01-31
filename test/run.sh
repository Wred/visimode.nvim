#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"

nvim --headless -c "set rtp+=$PLUGIN_DIR" -c "luafile $SCRIPT_DIR/visimode_spec.lua" -c "q"
