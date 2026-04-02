#!/bin/bash

# --- SYSTEM & BINARIES ---
export ZEN_BIN="/opt/zen-browser-bin/zen-bin"

# --- DIRECTORY STRUCTURE ---
export BASE_DIR="$HOME/.zpwa"
export ZEN_DIR="$HOME/.zen"
export ICON_DIR="$HOME/.local/share/applications/icons"
export DESKTOP_DIR="$HOME/.local/share/applications"
export SCRIPT_DIR="$BASE_DIR/scripts"
export GEN_DIR="$SCRIPT_DIR/generate"
export PAYLOAD_DIR="$BASE_DIR/payloads"
export BINDS_DIR="$BASE_DIR/binds"
export DISPATCHER_DIR="$BASE_DIR/dispatchers"

# --- INTERNAL SCRIPT PATHS ---
export PWA_MONITOR="$SCRIPT_DIR/pwa_monitor.sh"
export FIND_BIND="$SCRIPT_DIR/find_bind.sh"
export GENERATE_BINDS="$GEN_DIR/generate_pwa_binds.sh"

# --- PAYLOADS ---
export MASTER_JS="$PAYLOAD_DIR/userjs.pwa.payload"
export MASTER_CSS="$PAYLOAD_DIR/userChrome.pwa.payload"
export MASTER_JSON="$PAYLOAD_DIR/shortcuts.pwa.payload"

# --- HYPRLAND / BIND CONFIGS ---
export DISPATCHER_LIST="$DISPATCHER_DIR/dispatchers.list"
export DYNAMIC_OUT="$BINDS_DIR/pwa_dynamic_binds.conf"
export SILENCED_OUT="$BINDS_DIR/pwa_silenced_binds.conf"
export EMERGENCY_OUT="$BINDS_DIR/pwa_emergency_binds.conf"

# --- SHARED FUNCTIONS ---
get_safe_name() {
    local input="$1"
    printf '%s' "$input" |
    iconv -f UTF-8 -t ASCII//TRANSLIT |
    tr '[:upper:]' '[:lower:]' |
    sed -E 's/[ _]+/-/g; s/[^a-z0-9-]//g; s/-+/-/g; s/^-+|-+$//g'
}
