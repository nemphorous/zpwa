#!/bin/bash
TARGET_FILE="$1"
PAYLOAD_FILE="$2"
OMARCHY_MASTER="$HOME/.local/share/omarchy/bin/omarchy-menu"

source "$PAYLOAD_FILE"

ensure_function_exists() {
    local func_name="$1"

    if [[ ! -f "$OMARCHY_MASTER" ]]; then
        echo "Error: Omarchy master menu not found at $OMARCHY_MASTER"
        return 1
    fi

    if ! grep -q "${func_name%%(*}" "$TARGET_FILE"; then
        echo -e "\n# Backfilled $func_name by ZPWA" >> "$TARGET_FILE"

        local pattern="^${func_name%%(*}[[:space:]]*\\(\\)"
        awk "/$pattern/,/^[[:space:]]*}/" "$OMARCHY_MASTER" >> "$TARGET_FILE"
    fi
}

ensure_function_exists "show_install_menu()"
ensure_function_exists "show_remove_menu()"

if ! grep -q "omarchy-zenapp-install" "$TARGET_FILE"; then

    export S_ICON="$INST_SEARCH_ICON" R_ICON="$INST_REPLACE_ICON"
    export S_IFUNC="$INST_SEARCH_FUNC" R_IFUNC="$INST_REPLACE_FUNC"
    export S_RFUNC="$RM_SEARCH_FUNC" R_RFUNC="$RM_REPLACE_FUNC"

    perl -i -0777 -pe 's/\Q$ENV{S_ICON}\E/$ENV{R_ICON}/g' "$TARGET_FILE"

    perl -i -0777 -pe 'BEGIN { $r = $ENV{R_IFUNC}; $r =~ s/\\n/\n/g; $ENV{R_IFUNC_REAL} = $r; }
                       s/\Q$ENV{S_IFUNC}\E/$ENV{R_IFUNC_REAL}/g' "$TARGET_FILE"

    perl -i -0777 -pe 'BEGIN { $r = $ENV{R_RFUNC}; $r =~ s/\\n/\n/g; $ENV{R_RFUNC_REAL} = $r; }
                       s/\Q$ENV{S_RFUNC}\E/$ENV{R_RFUNC_REAL}/g' "$TARGET_FILE"

    echo "✔ Replace Menu logic applied."
else
    echo "Menu already contains Zen entries. Skipping."
fi
