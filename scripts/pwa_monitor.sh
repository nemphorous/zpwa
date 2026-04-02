#!/bin/bash

# --- SINGLE INSTANCE GUARD ---
exec 200>>"/tmp/pwa_monitor.lock"

flock -n 200 || exit 0

# --- VERBOSE CHECK ---
VERBOSE=false
if [[ "$1" == "-v" || "$1" == "--verbose" ]]; then
    VERBOSE=true
    echo "󱖫 PWA Monitor: Verbose Mode Enabled"
fi

last_class=""

handle() {
  case $1 in
    activewindowv2*)
      class=$(hyprctl activewindow -j | jq -r '.class')
      $VERBOSE && echo "DEBUG: Focused window class is: '$class'"

      if [[ "$class" =~ ^webapp\. ]]; then
        if [ "$last_class" != "pwa" ]; then
          $VERBOSE && echo "STATUS: Entering PWA_MUTE submap..."
          hyprctl dispatch submap pwa_mute
          last_class="pwa"
        fi
      else
        if [ "$last_class" == "pwa" ]; then
          $VERBOSE && echo "STATUS: Resetting to Global submap..."
          hyprctl dispatch submap reset
          last_class="not_pwa"
        fi
      fi
      ;;

    closewindow*)
      total_pwa_count=$(hyprctl clients -j | jq '[.[] | select(.class | startswith("webapp."))] | length')
      $VERBOSE && echo "DEBUG: Total PWA count: $total_pwa_count"

      if [ "$total_pwa_count" -eq 0 ]; then
        $VERBOSE && echo "STATUS: No PWA instances remaining. Exiting monitor."
        hyprctl dispatch submap reset
        exit 0
      fi
      ;;
  esac
}

# --- SOCKET HUNTING ---
HYPR_SOCKET=$(ls -d "$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" 2>/dev/null | head -n 1)

if [ -z "$HYPR_SOCKET" ]; then
    HYPR_SOCKET=$(ls -d /tmp/hypr/*/.socket2.sock 2>/dev/null | head -n 1)
fi

if [ -z "$HYPR_SOCKET" ]; then
    echo "ERROR: Could not find Hyprland socket."
    exit 1
fi

$VERBOSE && echo "FOUND SOCKET: $HYPR_SOCKET"

# --- THE LISTENER ---
while read -r line; do 
    handle "$line"
done < <(socat -U - UNIX-CONNECT:"$HYPR_SOCKET")
