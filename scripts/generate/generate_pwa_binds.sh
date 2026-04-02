#!/bin/bash
# ~/.zpwa/scripts/generate/generate_pwa_binds.sh

# --- INITIALIZE ---
source "$HOME/.zpwa/variables/variables.sh"

# Ensure the binds directory exists
mkdir -p "$BINDS_DIR"

# --- GENERATE DYNAMIC BINDS (Sniffed from Omarchy) ---
ACTIONS=(
    "killactive"
    "walker"
    "rofi"
    "wofi"
    "omarchy-hyprland-window-close-all"
    "layoutmsg, togglesplit"
    "pseudo,"
    "togglefloating"
    "fullscreen, 0"
    "fullscreenstate, 0 2"
    "fullscreen, 1"
    "omarchy-hyprland-window-pop"
    "omarchy-hyprland-workspace-layout-toggle"
    "movefocus, l"
    "movefocus, r"
    "movefocus, u"
    "movefocus, d"
    "swapwindow, l"
    "swapwindow, r"
    "swapwindow, u"
    "swapwindow, d"
    "movetoworkspace, 1"
    "movetoworkspace, 2"
    "movetoworkspace, 3"
    "togglespecialworkspace, scratchpad"
    "movetoworkspacesilent, special:scratchpad"
    "workspace, e+1"
    "workspace, e-1"
    "workspace, previous"
    "cyclenext"
    "bringactivetotop"
    "resizeactive, -100 0"
    "resizeactive, 100 0"
    "resizeactive, 0 -100"
    "resizeactive, 0 100"
    "movewindow"
    "resizewindow"
    "omarchy-hyprland-monitor-scaling-cycle"
)

echo "# Automatically generated Tiling Binds" > "$DYNAMIC_OUT"
echo "# Makes select default Omarchy and User modified keybinds available in the submap" >> "$DYNAMIC_OUT"

for action in "${ACTIONS[@]}"; do
    # Uses FIND_BIND variable from variables.sh
    RESULT=$("$FIND_BIND" "$action")
    if [ -n "$RESULT" ]; then
        echo "$RESULT" >> "$DYNAMIC_OUT"
    fi
done

# --- GENERATE SILENCED BINDS (Browser Passes) ---
cat > "$SILENCED_OUT" <<EOF
# Prevents browser defaults from overriding system behavior
# Silences hardcoded gecko engine keybinds to harden PWA feel
bind = CTRL, T, pass,
bind = CTRL, N, pass,
bind = CTRL, W, pass,
bind = CTRL, F, pass,
bind = CTRL, P, pass,
EOF

# --- GENERATE EMERGENCY BINDS (The Exit Hatch) ---
cat > "$EMERGENCY_OUT" <<EOF
# Hard-coded escape to reset submap state
bindu = SUPER, Escape, submap, reset
EOF

# Ensure permissions are correct
chmod +x "$DYNAMIC_OUT" "$SILENCED_OUT" "$EMERGENCY_OUT"
