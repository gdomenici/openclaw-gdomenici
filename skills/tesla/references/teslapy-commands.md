# TeslaPy API Commands Reference

This document lists all available TeslaPy API commands for direct use when the wrapper script doesn't provide the needed functionality.

## Direct TeslaPy Usage

```bash
cd ~/TeslaPy
source .venv/bin/activate
python cli.py -e guido.domenici@gmail.com <COMMAND> [args]
```

## Vehicle Commands

### Status & Information
- `VEHICLE_DATA` - Get all vehicle data (comprehensive status)
- `VEHICLE_STATE` - Get vehicle state (locks, odometer, etc.)
- `CHARGE_STATE` - Get charging state
- `CLIMATE_STATE` - Get climate state
- `DRIVE_STATE` - Get drive state (location, speed, heading)
- `GUI_SETTINGS` - Get GUI settings

### Climate Control
- `CLIMATE_ON` - Start climate control
- `CLIMATE_OFF` - Stop climate control
- `SET_TEMPS` - Set temperature (args: driver_temp passenger_temp)
- `SEAT_HEATER` - Control seat heater (args: seat_position level)
- `STEERING_WHEEL_HEATER` - Toggle steering wheel heater
- `MAX_DEFROST` - Toggle max defrost

### Charging
- `START_CHARGE` - Start charging
- `STOP_CHARGE` - Stop charging
- `SET_CHARGE_LIMIT` - Set charge limit (args: percent)
- `SET_CHARGING_AMPS` - Set charging amps
- `CHARGE_PORT_DOOR_OPEN` - Open charge port
- `CHARGE_PORT_DOOR_CLOSE` - Close charge port

### Locks & Access
- `LOCK` - Lock doors
- `UNLOCK` - Unlock doors
- `ACTUATE_TRUNK` - Open/close trunk (args: which_trunk)
- `ACTUATE_FRUNK` - Open frunk

### Alerts
- `HONK_HORN` - Honk horn
- `FLASH_LIGHTS` - Flash lights

### Remote Control
- `REMOTE_START` - Enable remote driving (requires password)
- `TRIGGER_HOMELINK` - Trigger HomeLink (args: lat lon)

### Windows & Sunroof
- `WINDOW_CONTROL` - Control windows (args: command lat lon)
- `SUN_ROOF_CONTROL` - Control sunroof (args: state)

### Sentry & Valet
- `SET_SENTRY_MODE` - Enable/disable Sentry Mode (args: on/off)
- `SET_VALET_MODE` - Enable/disable Valet Mode (args: on/off password)
- `RESET_VALET_PIN` - Reset valet PIN

### Speed Limit
- `SPEED_LIMIT_ACTIVATE` - Activate speed limit (args: pin)
- `SPEED_LIMIT_DEACTIVATE` - Deactivate speed limit (args: pin)
- `SPEED_LIMIT_SET_LIMIT` - Set speed limit (args: limit_mph)
- `SPEED_LIMIT_CLEAR_PIN` - Clear speed limit PIN (args: pin)

### Software Updates
- `SCHEDULE_SOFTWARE_UPDATE` - Schedule software update (args: offset_sec)
- `CANCEL_SOFTWARE_UPDATE` - Cancel scheduled software update

### Media
- `MEDIA_TOGGLE_PLAYBACK` - Toggle media playback
- `MEDIA_NEXT_TRACK` - Next track
- `MEDIA_PREVIOUS_TRACK` - Previous track
- `MEDIA_NEXT_FAVORITE` - Next favorite
- `MEDIA_PREVIOUS_FAVORITE` - Previous favorite
- `MEDIA_VOLUME_UP` - Volume up
- `MEDIA_VOLUME_DOWN` - Volume down

### Navigation
- `NAVIGATION_REQUEST` - Send navigation destination (args: address)
- `NAVIGATION_SC_REQUEST` - Navigate to Supercharger

### Other
- `WAKE_UP` - Wake up vehicle
- `SHARE` - Share data (for support)

## Command Examples

### Set specific temperature
```bash
python cli.py -e guido.domenici@gmail.com SET_TEMPS 22 22
```

### Open charge port
```bash
python cli.py -e guido.domenici@gmail.com CHARGE_PORT_DOOR_OPEN
```

### Enable Sentry Mode
```bash
python cli.py -e guido.domenici@gmail.com SET_SENTRY_MODE on
```

### Navigate to address
```bash
python cli.py -e guido.domenici@gmail.com NAVIGATION_REQUEST "Amsterdam Central Station"
```

### Control windows (vent)
```bash
python cli.py -e guido.domenici@gmail.com WINDOW_CONTROL vent 52.370216 4.895168
```

## Response Format

All commands return JSON responses. Use `jq` for parsing:

```bash
python cli.py -e guido.domenici@gmail.com VEHICLE_DATA | jq '.response.charge_state.battery_level'
```

## Error Handling

- If vehicle is asleep, use `WAKE_UP` first
- Some commands require the vehicle to be in a specific state
- Authentication tokens are cached in `~/.cache/teslapy/`

## Rate Limits

- Tesla API has rate limits (~200 requests per 15 minutes)
- Frequent polling can trigger rate limiting
- Use `VEHICLE_DATA` for comprehensive status rather than multiple individual calls
