#!/bin/bash
TARGET_FILE="$1"
PAYLOAD_FILE="$2"
OMARCHY_MASTER="$HOME/.local/share/omarchy/bin/omarchy-menu"

# Load variables from payload
source "$PAYLOAD_FILE"

ensure_function_exists() {
    local func_name="$1"
    if [[ ! -f "$OMARCHY_MASTER" ]]; then
        echo "Error: Omarchy master menu not found at $OMARCHY_MASTER"
        return 1
    fi
    
    if ! grep -q "$func_name" "$TARGET_FILE"; then
        echo -e "\n# Backfilled $func_name by ZPWA" >> "$TARGET_FILE"
        # Anchor awk to the start of the line for precise extraction
        awk "/^$func_name/,/^}/" "$OMARCHY_MASTER" >> "$TARGET_FILE"
    fi
}

ensure_function_exists "show_install_menu()"
ensure_function_exists "show_remove_menu()"

if ! grep -q "omarchy-zenapp-install" "$TARGET_FILE"; then
    # Function to escape newlines for sed
    prep_for_sed() {
        echo -e "$1" | sed ':a;N;$!ba;s/\n/\\n/g'
    }

    # Process variables to handle the \n characters safely
    S_ICON=$(prep_for_sed "$INST_SEARCH_ICON")
    R_ICON=$(prep_for_sed "$INST_REPLACE_ICON")
    
    S_IFUNC=$(prep_for_sed "$INST_SEARCH_FUNC")
    R_IFUNC=$(prep_for_sed "$INST_REPLACE_FUNC")
    
    S_RFUNC=$(prep_for_sed "$RM_SEARCH_FUNC")
    R_RFUNC=$(prep_for_sed "$RM_REPLACE_FUNC")

    # Execute sed with escaped variables and comma delimiter
    sed -i "s,$S_ICON,$R_ICON,g" "$TARGET_FILE"
    sed -i "s,$S_IFUNC,$R_IFUNC,g" "$TARGET_FILE"
    sed -i "s,$S_RFUNC,$R_RFUNC,g" "$TARGET_FILE"
    
    echo "✔ Replace Menu logic applied."
else
    echo "Menu already contains Zen entries. Skipping."
fi
