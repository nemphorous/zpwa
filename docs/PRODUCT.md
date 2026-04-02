# ZPWA: Product Philosophy & Technical Deep-Dive

### The Problem: The "Extension Tax"
Standard PWA solutions for Gecko-based browsers (like Zen) usually rely on browser extensions. These come with three fundamental flaws for power users:
1. **Resource Bloat:** Extensions run background scripts that consume RAM and CPU cycles for every open instance.
2. **Permission Creep:** Extensions often require broad access to your browsing data, history, and tabs.
3. **The "Non-Native" Gap:** Extensions cannot talk to your Window Manager. They cannot reliably handle Hyprland dispatchers, workspace logic, or system-level menu integration without a heavy "bridge" application.

### The Solution: ZPWA (Zen PWA Suite)
ZPWA is not a "plugin." It is a **System Orchestrator**. It treats the Zen Browser as a raw engine and your OS as the chassis. By using a "wrapper" approach, we achieve a level of integration that extensions physically cannot touch.


## How It Works: The Three Pillars

### 1. The Payload Injection Engine
Instead of "requesting" the browser to hide UI elements, ZPWA **commands** it. 
* **Atomic Profiles:** Every PWA generated via `zpwa install` receives its own isolated profile directory in `~/.zen/`.
* **Direct Injection:** ZPWA fires `.payload` files (pre-configured `prefs.js` and `userChrome.css`) directly into the profile before the process launches.
* **Result:** The browser engine starts in a "hardened" SSB (Single Site Browser) state. No address bar, no tab strips, and no UI flicker. It is just the web app and the window.

### 2. The Socket Calling Daemon
To bridge the gap between a browser process and the Omarchy desktop, ZPWA utilizes a proprietary socket calling daemon.
* **The Dictionary:** The system references `dispatchers/dispatchers.list` as a source of truth for keybind generation.
* **The Hook:** When you trigger a PWA-specific keybind in Hyprland, the signal is caught by the daemon and routed directly to the specific PWA’s PID.
* **Result:** This creates a "Native App" feel where the PWA responds to system-level commands with zero latency.

### 3. The Omarchy-First Architecture
ZPWA is built exclusively for the **Omarchy** ecosystem. It is designed to respect the opinionated filesystem hierarchy and configuration styles of an Omarchy install.
* **Walker Integration:** PWAs are automatically injected into your Walker application runner.
* **Hyprland Native:** Window rules are generated based on the PWA’s unique class, ensuring your window manager treats "YouTube Music" differently than a standard "Zen Browser" window.

## The Zero-Trust Privacy Standard
We take an extremely skeptic approach to software security.

* **No Data Collection:** ZPWA does not have a "backend." There is no telemetry, no usage tracking, no access to your data for all websites, no browsing activity collection and no "calling home."
* **No Middlemen:** We do not use third-party "PWA Stores" or cloud-syncing services. Your data, your cookies, and your sessions stay in your browser.
* **Auditable Code:** Because ZPWA is a collection of Bash/Rust scripts and raw `.payload` files, you can audit every single line of code and configuration change on your own machine at `/usr/share/zpwa/`.

## Performance Benchmarks
By removing the WebExtension layer and the standard browser UI overhead:
* **Faster Startup:** PWAs launch directly into the site without loading browser chrome.
* **Lower Memory Footprint:** Each instance runs only the necessary Gecko components for a single site.
* **System Unity:** Because ZPWA is local, it utilizes your system's `socat` and `sed` utilities for maximum efficiency.

## Summary
ZPWA is for the Omarchy user who wants the web to feel like a part of their OS, not a tab in their browser. It provides the **magic** of a native application with the **security** of a local, open-source script.

Despite being branded as a PWA creator, ZPWA functions as a de-bloated Gecko alternative to Electron.

Traditional "desktop" web apps (like Discord or Slack) force you to carry a redundant, 500MB Chromium binary for every single instance you run. ZPWA kills that tax. It treats your existing Zen Browser installation as a shared, high-performance engine, spinning up isolated profiles that share the same core. You get the process isolation of a standalone app and the deep integration of a native binary, without the 2GB RAM penalty of running five separate browser engines.

Basically: You already have the engine. ZPWA just gives you the keys to the chassis.
