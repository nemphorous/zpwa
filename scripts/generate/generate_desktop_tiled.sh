#!/bin/bash
source "$HOME/.zpwa/variables/variables.sh"

# Use the centralized DESKTOP_DIR variable
DESKTOP_FILE="$DESKTOP_DIR/webapp.$SAFE_NAME.desktop"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Name=$APP_NAME
Comment=Zen PWA for $APP_NAME
Exec=bash -c 'nohup "$PWA_MONITOR" > /dev/null 2>&1 & exec "$PROFILE_PATH/$SAFE_NAME" --no-remote --profile "$PROFILE_PATH" --class \"webapp.$SAFE_NAME\" --name \"webapp.$SAFE_NAME\" \"$APP_URL\"'
Terminal=false
Type=Application
Icon=$ICON_PATH
StartupWMClass=webapp.$SAFE_NAME
Categories=Network;WebBrowser;
EOF

chmod +x "$DESKTOP_FILE"
