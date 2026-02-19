#!/bin/bash
# Tesla Control Script - Wrapper around TeslaPy CLI

TESLAPY_DIR="$HOME/TeslaPy"
TESLAPY_CLI="$TESLAPY_DIR/cli.py"
TESLAPY_PYTHON="$TESLAPY_DIR/.venv/bin/python"
EMAIL="guido.domenici@gmail.com"

# Check if TeslaPy is available
if [ ! -f "$TESLAPY_PYTHON" ]; then
    echo "Error: TeslaPy venv not found at $TESLAPY_PYTHON" >&2
    exit 1
fi

if [ ! -f "$TESLAPY_CLI" ]; then
    echo "Error: TeslaPy CLI not found at $TESLAPY_CLI" >&2
    exit 1
fi

# Wrapper function - run from TeslaPy directory for cache access
tesla_cmd() {
    (cd "$TESLAPY_DIR" && "$TESLAPY_PYTHON" "$TESLAPY_CLI" -e "$EMAIL" "$@")
}

# Parse command
CMD="${1:-}"
shift || true

case "$CMD" in
    list)
        tesla_cmd -l
        ;;
    
    status)
        tesla_cmd -g
        ;;
    
    wake)
        echo "Waking up vehicle..."
        tesla_cmd -w
        echo "✅ Vehicle is awake"
        ;;
    
    climate)
        ACTION="${1:-}"
        case "$ACTION" in
            on)
                echo "Starting climate control..."
                tesla_cmd -c CLIMATE_ON
                echo "✅ Climate control started"
                ;;
            off)
                echo "Stopping climate control..."
                tesla_cmd -c CLIMATE_OFF
                echo "✅ Climate control stopped"
                ;;
            *)
                echo "Error: climate command requires 'on' or 'off'" >&2
                exit 1
                ;;
        esac
        ;;
    
    lock)
        ACTION="${1:-}"
        case "$ACTION" in
            lock)
                echo "Locking doors..."
                tesla_cmd -c LOCK
                echo "🔒 Doors locked"
                ;;
            unlock)
                echo "Unlocking doors..."
                tesla_cmd -c UNLOCK
                echo "🔓 Doors unlocked"
                ;;
            *)
                echo "Error: lock command requires 'lock' or 'unlock'" >&2
                exit 1
                ;;
        esac
        ;;
    
    honk)
        echo "Honking horn..."
        tesla_cmd -c HONK_HORN
        echo "📣 Honked!"
        ;;
    
    flash)
        echo "Flashing lights..."
        tesla_cmd -c FLASH_LIGHTS
        echo "💡 Lights flashed!"
        ;;
    
    charge)
        ACTION="${1:-}"
        case "$ACTION" in
            start)
                echo "Starting charge..."
                tesla_cmd -c START_CHARGE
                echo "🔌 Charging started"
                ;;
            stop)
                echo "Stopping charge..."
                tesla_cmd -c STOP_CHARGE
                echo "⏸️  Charging stopped"
                ;;
            limit)
                LIMIT="${2:-}"
                if [ -z "$LIMIT" ]; then
                    echo "Error: charge limit requires a percentage value" >&2
                    exit 1
                fi
                if [ "$LIMIT" -lt 50 ] || [ "$LIMIT" -gt 100 ]; then
                    echo "Error: charge limit must be between 50 and 100" >&2
                    exit 1
                fi
                echo "Setting charge limit to $LIMIT%..."
                tesla_cmd -c SET_CHARGE_LIMIT -k "percent=$LIMIT"
                echo "✅ Charge limit set to $LIMIT%"
                ;;
            *)
                echo "Error: charge command requires 'start', 'stop', or 'limit'" >&2
                exit 1
                ;;
        esac
        ;;
    
    location)
        tesla_cmd -G
        ;;
    
    help|--help|-h|"")
        cat << 'EOF'
Tesla Control Script

Usage: tesla.sh <command> [args]

Commands:
    list                List all vehicles
    status              Get detailed vehicle status
    wake                Wake up the vehicle
    climate on|off      Start/stop climate control
    lock lock|unlock    Lock or unlock doors
    honk                Honk the horn
    flash               Flash the lights
    charge start|stop   Start/stop charging
    charge limit <50-100>  Set charge limit percentage
    location            Get vehicle location

Examples:
    tesla.sh status
    tesla.sh climate on
    tesla.sh charge limit 80
    tesla.sh location
EOF
        ;;
    
    *)
        echo "Unknown command: $CMD" >&2
        echo "Use 'tesla.sh help' for usage information" >&2
        exit 1
        ;;
esac
