# ZPWA Cleanup & Manual Removal Guide

## Semi-Automated Uninstall

The preferred method for removal is the built-in revert logic. This is designed to surgically roll back the environment without touching your personal Zen Browser profiles or unrelated Hyprland configs.

```bash
zpwa revert
```

**What this does:**

This command works as a combination medium of both restore command variants. Every run of any system modifying commands creates a timestamped backup of the users dotfiles before any changes are made, viewable and available at the `~/.zpwa/snapshots/` directory. Utilizing the automatically generated backups, the restore commands and by proxy the revert command prompt the user to choose a timestamped backup of their configuration files to a state before ZPWA was used.

> Uninstalling ZPWA will not remove any "PWAs" created with ZPWA, unless the user manually uninstalls each PWA either individually, in batches, or all encompassing using `zpwa rm [--all]`. It is not recommended to keep ZPWA generated single site browsers as their functionality is heavily dependent on the proprietary PWA monitor and keybind integration. The uninstallation of ZPWA does not automatically remove generated apps for data integrity purposes, the final say is up to the user. It is also important to note that ZPWA does not integrate into Zen's `profiles.ini`, as such ZPWA apps will not show up in, and cannot be managed by about:config within Zen. To remove an SSB/PWA after uninstalling each profile is visible and removable from `~/.zen/` and clearly labeled with the webapp. prefix followed by the user decided application name. (e.g. webapp.protonmail) 

## Manual "Non-Linear" Removal

If you have already deleted the zpwa binary or uninstalled the package via a package manager without running revert first, your system may still have orphan configurations. Cleaning this up manually is straightforward because ZPWA does not scatter files across your system.

### 1. Remove Configuration Blocks

ZPWA uses clear markers to avoid corrupting your existing dotfiles. Open the following files and delete the marked sections:

**Hyprland Binds:** Check `~/.config/hypr/bindings.conf` | Look for the `# --- ZEN PWA ---` block.

**Menu Integrations:** Check `~/.config/omarchy/extensions/menu.sh` | Look for the `show_install_menu()` and `show_remove_menu()` functions.

If your `~/.zpwa` directory is still intact, the snapshots folder has timestamped backups that you can refer to before moving onto directory deletion.

### 2. Delete the Directories

Once the config blocks are gone, the software only exists in two specific locations. Run these to finish the cleanup:

```bash
# Source directory for zpwa setup
sudo rm -rf /usr/share/zpwa/
# Primary user directory from which zpwa functions
rm -rf ~/.zpwa/
```
### 3. Binary Cleanup

If you installed via Git/Makepkg and did not use a package manager:

```bash
# The zpwa cli exists in the users bin only as a symlink
sudo rm /usr/bin/zpwa
```

## Post-Cleanup State

The profiles still exist on system as your appname with the `webapp.` prefix attached inside of `~/.zen`. While the profiles will still be accessible via the generated .desktop file, the hardening features present within zpwa will not be available, and may reduce user experience.

To further remove installed webapps if not done through the zpwa cli suite before uninstallation, the launch shortcut/.desktop file can be found in `.local/share/applications` with its attached icon at `.local/share/applications/icons`.

Once these steps are completed, your Omarchy environment is functionally identical to its pre-ZPWA state. We do not modify the Zen Browser binary itself, nor do we touch the global /etc/ directory. All modifications are strictly contained within the user's .config and the package's specific shared directories.
