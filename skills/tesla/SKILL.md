---
name: tesla
description: Control Tesla vehicles via TeslaPy API. Use for checking vehicle status, controlling climate, locking/unlocking doors, managing charging, getting location, honking horn, flashing lights, and any other Tesla vehicle control tasks.
---

# Tesla Vehicle Control

Control Tesla vehicles using the TeslaPy API wrapper. Provides comprehensive vehicle monitoring and control capabilities.

## Quick Start

The skill provides a convenient wrapper script `tesla.sh` that handles all Tesla API interactions.

### Basic Commands

```bash
# Get vehicle status (battery, charge, climate, locks)
scripts/tesla.sh status

# Wake up the vehicle (if asleep)
scripts/tesla.sh wake

# List all vehicles
scripts/tesla.sh list
```

## Climate Control

```bash
# Start climate control
scripts/tesla.sh climate on

# Stop climate control  
scripts/tesla.sh climate off
```

## Door Locks

```bash
# Lock doors
scripts/tesla.sh lock lock

# Unlock doors
scripts/tesla.sh lock unlock
```

## Charging Control

```bash
# Start charging
scripts/tesla.sh charge start

# Stop charging
scripts/tesla.sh charge stop

# Set charge limit (50-100%)
scripts/tesla.sh charge limit 80
```

## Location & Alerts

```bash
# Get vehicle location (includes Google Maps link)
scripts/tesla.sh location

# Honk horn
scripts/tesla.sh honk

# Flash lights
scripts/tesla.sh flash
```

## Common Patterns

### Pre-conditioning before trip

```bash
# Wake vehicle and start climate
scripts/tesla.sh wake
sleep 5
scripts/tesla.sh climate on
```

### Check if ready to drive

```bash
# Full status check
scripts/tesla.sh status
# Shows: battery level, range, charge state, climate, locks, odometer
```

### Find the car

```bash
# Get location with map link
scripts/tesla.sh location

# Or flash lights if nearby
scripts/tesla.sh flash
```

## Status Output Format

The `status` command provides formatted output:

```
🚗 Vehicle: ElectroNinja
📊 Status: online
🔋 Battery: 85% (245.3 miles)
⚡ Charge Limit: 80%
🔌 Charging: Disconnected
🌡️  Inside: 22°C | Outside: 15°C
❄️  Climate: OFF
🔒 Locked: Yes
📏 Odometer: 12345.6 miles
```

## Error Handling

If the vehicle is asleep, commands may fail. Wake it first:

```bash
scripts/tesla_control.py wake
# Wait a few seconds, then run your command
```

## Authentication

TeslaPy stores authentication tokens in `~/TeslaPy/cache.json`. If authentication expires, the CLI will prompt for re-authentication.

### Re-authentication Flow

If you see authentication errors, run any command manually to trigger the re-auth flow:

```bash
cd ~/TeslaPy
source .venv/bin/activate
python cli.py -e guido.domenici@gmail.com -l
```

The custom auth handler (lines 23-26 in `cli.py`) will:
1. Print an authentication URL to the console
2. Wait for you to open it in a browser
3. Ask you to paste back the redirect URL Tesla returns

**Example:**
```
Use browser to login. Page Not Found will be shown at success.
Open this URL: https://auth.tesla.com/oauth2/v3/authorize?...
Enter URL after authentication: [paste the URL here]
```

After successful authentication, the cache will be updated and all skill commands will work again.

## Technical Details

- Uses TeslaPy installed at `~/TeslaPy`
- Authenticated for: guido.domenici@gmail.com
- Vehicle: ElectroNinja (Model S 2019)
- Authentication cache: `~/TeslaPy/cache.json`
- All commands run from TeslaPy directory for cache access

## Available TeslaPy Commands

For advanced use, see [references/teslapy-commands.md](references/teslapy-commands.md) for the full list of TeslaPy API commands.
