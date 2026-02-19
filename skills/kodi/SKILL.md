---
name: kodi
description: Control Kodi media center via HTTP JSON-RPC API. Use for playing/pausing media, volume control, navigation, checking what's playing, browsing library, and system operations on the LibreELEC Raspberry Pi installation.
---

# Kodi Remote Control

Control Kodi media center running on LibreELEC (Raspberry Pi) via HTTP JSON-RPC API.

## Connection Details

- **Host:** 100.78.70.92 (Tailscale)
- **HTTP API:** Port 8080, no authentication, no SSL
- **SSH:** `root@100.78.70.92` (key-based auth)

## Quick Start

```bash
# Test connection
scripts/kodi.sh ping

# Check what's playing
scripts/kodi.sh status

# Playback controls
scripts/kodi.sh play
scripts/kodi.sh pause
scripts/kodi.sh stop
```

## Playback Control

```bash
# Play/pause toggle
scripts/kodi.sh play

# Stop playback
scripts/kodi.sh stop

# Next/previous track or episode
scripts/kodi.sh next
scripts/kodi.sh previous

# Seek controls
scripts/kodi.sh forward      # Skip forward 30s
scripts/kodi.sh backward     # Skip backward 30s
scripts/kodi.sh seek 120     # Seek to specific position in seconds
```

## Volume Control

```bash
# Get current volume
scripts/kodi.sh volume

# Set volume (0-100)
scripts/kodi.sh volume 50

# Volume adjustments
scripts/kodi.sh vol-up
scripts/kodi.sh vol-down
scripts/kodi.sh mute         # Toggle mute
```

## Navigation

```bash
# Directional navigation
scripts/kodi.sh up
scripts/kodi.sh down
scripts/kodi.sh left
scripts/kodi.sh right

# Selection and menus
scripts/kodi.sh select       # Select current item
scripts/kodi.sh back         # Go back
scripts/kodi.sh home         # Go to home screen
scripts/kodi.sh menu         # Open context menu
scripts/kodi.sh info         # Show info screen

# Text input
scripts/kodi.sh text "search query"
```

## Library & Status

```bash
# Current status
scripts/kodi.sh status       # Show now playing with progress

# Browse library
scripts/kodi.sh movies       # List movies
scripts/kodi.sh tv-shows     # List TV shows
scripts/kodi.sh recent       # Recently added content

# Library maintenance
scripts/kodi.sh scan-library
scripts/kodi.sh clean-library
```

## System Operations

```bash
# Connection test
scripts/kodi.sh ping

# System control
scripts/kodi.sh shutdown
scripts/kodi.sh reboot
```

## Status Output Format

The `status` command shows detailed playback information:

```
🎬 Movie: Inception
   Position: 1:23:45 / 2:28:00 (58%) ▶️

📺 TV: Breaking Bad S5E14 - Ozymandias
   Position: 0:32:10 / 0:47:00 (68%) ⏸️ PAUSED

🎵 Music: Pink Floyd - Comfortably Numb
   Position: 3:24 / 6:23 (53%) ▶️
```

## Common Patterns

### Check and control playback

```bash
# See what's playing
scripts/kodi.sh status

# Pause if playing
scripts/kodi.sh pause

# Resume playback
scripts/kodi.sh play
```

### Adjust volume

```bash
# Check current volume
scripts/kodi.sh volume

# Set to comfortable level
scripts/kodi.sh volume 40
```

### Navigate and search

```bash
# Go to home
scripts/kodi.sh home

# Navigate to search
scripts/kodi.sh down
scripts/kodi.sh select

# Enter search text
scripts/kodi.sh text "breaking bad"
```

## Technical Details

- **API:** Kodi JSON-RPC v2.0 over HTTP
- **Endpoint:** `http://100.78.70.92:8080/jsonrpc`
- **Authentication:** None
- **Transport:** HTTP POST with JSON payload
- **Dependencies:** `curl`, `jq` for JSON parsing

## Troubleshooting

### Connection issues

```bash
# Test basic connectivity
ping -c 1 100.78.70.92

# Test Kodi API
scripts/kodi.sh ping

# Test SSH access
ssh root@100.78.70.92 "systemctl status kodi"
```

### Common errors

- **"Nothing playing"**: No active media player (not an error)
- **Connection refused**: Kodi service may be down, check SSH
- **Timeout**: Network connectivity issue or Tailscale problem

## API Reference

For advanced operations not covered by the wrapper, see [references/kodi-api.md](references/kodi-api.md).
