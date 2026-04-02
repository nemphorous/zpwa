#!/bin/bash
# find_bind.sh - Omarchy Dynamic Keybind Linker

# --- INITIALIZE ---
source "$HOME/.zpwa/variables/variables.sh"
ACTION=$1

# --- SOURCE & PREP DISPATCHERS ---
if [ ! -f "$DISPATCHER_LIST" ]; then
    echo "Error: Dispatcher list not found at $DISPATCHER_LIST" >&2
    exit 1
fi

# Read file, ignore comments/empty lines, and join with '|' for regex
DISPATCHERS=$(grep -vE '^[[:space:]]*#|^[[:space:]]*$' "$DISPATCHER_LIST" | tr '\n' '|' | sed 's/|$//')

# --- SEARCH LOCATIONS ---
LOCATIONS=(
    "$HOME/.config/hypr/bindings.conf"
    "$HOME/.config/hypr/hyprland.conf"
    "$HOME/.config/hypr/monitors.conf"
    "$HOME/.config/hypr/input.conf"
    "$HOME/.config/hypr/looknfeel.conf"
    "$HOME/.config/hypr/autostart.conf"
    "$HOME/.local/share/omarchy/default/hypr/bindings/tiling-v2.conf"
    "$HOME/.local/share/omarchy/default/hypr/bindings/utilities.conf"
    "$HOME/.local/share/omarchy/default/hypr/bindings/media.conf"
    "$HOME/.local/share/omarchy/default/hypr/bindings/clipboard.conf"
)

for loc in "${LOCATIONS[@]}"; do
    if [ -f "$loc" ]; then
        # Hardened Grep: Matches lines starting with 'bind' to ignore 'unbind'
        RAW_LINE=$(grep -E "^[[:space:]]*bind[a-z]*[[:space:]]*=" "$loc" | grep -v '^[[:space:]]*#' | grep -F "$ACTION" | head -n 1)

        if [ -n "$RAW_LINE" ]; then
            PREFIX=$(echo "$RAW_LINE" | grep -q "bindm" && echo "bindm" || echo "bind")

            # Trim leading whitespace and trailing newline
            CLEAN_RAW=$(echo "$RAW_LINE" | sed -E 's/^[[:space:]]*//; s/[[:space:]]*$//')

            # --- THE SURGICAL SPLIT ---
            # Extract Keys: MOD, KEY
            KEYS=$(echo "$CLEAN_RAW" | cut -d'=' -f2 | cut -d',' -f1,2 | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')

            # Extract Action: Pivot at the LAST valid dispatcher
            ACTION_PART=$(echo "$CLEAN_RAW" | sed -E "s/.*,[[:space:]]*($DISPATCHERS)([[:space:]]*,|[[:space:]]+|$)/\1 /")

            # Fallback if sed fails
            if [[ "$ACTION_PART" == "$CLEAN_RAW" ]]; then
                ACTION_PART=$(echo "$CLEAN_RAW" | grep -oE "\b($DISPATCHERS)\b.*$" | tail -n 1)
            fi

            # --- RECONSTRUCTION & CLEANUP ---
            if [ -n "$KEYS" ] && [ -n "$ACTION_PART" ]; then
                CLEAN_ACTION=$(echo "$ACTION_PART" | sed -E 's/[[:space:]]+/ /g')

                # Insert mandatory comma after dispatcher
                FINAL_LINE=$(echo "$CLEAN_ACTION" | sed -E "s/^($DISPATCHERS)[[:space:]]+/\1, /; s/,[[:space:]]*$//")

                echo "$PREFIX = $KEYS, $FINAL_LINE"
                exit 0
            fi
        fi
    fi
done

exit 0
