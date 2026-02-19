#!/bin/bash
# Kodi Remote Control Script via HTTP JSON-RPC API

KODI_HOST="100.78.70.92"
KODI_PORT="8080"
KODI_URL="http://${KODI_HOST}:${KODI_PORT}/jsonrpc"

# JSON-RPC request wrapper
kodi_rpc() {
    local method="$1"
    local params="$2"
    
    if [ -z "$params" ]; then
        params="{}"
    fi
    
    curl -s -H "Content-Type: application/json" -d "{
        \"jsonrpc\": \"2.0\",
        \"method\": \"$method\",
        \"params\": $params,
        \"id\": 1
    }" "$KODI_URL"
}

# Parse command
CMD="${1:-}"
shift || true

case "$CMD" in
    # Player controls
    play)
        kodi_rpc "Player.PlayPause" '{"playerid": 1}' > /dev/null
        echo "▶️ Play/Pause toggled"
        ;;
    
    pause)
        kodi_rpc "Player.PlayPause" '{"playerid": 1, "play": false}' > /dev/null
        echo "⏸️ Paused"
        ;;
    
    stop)
        kodi_rpc "Player.Stop" '{"playerid": 1}' > /dev/null
        echo "⏹️ Stopped"
        ;;
    
    next)
        kodi_rpc "Player.GoTo" '{"playerid": 1, "to": "next"}' > /dev/null
        echo "⏭️ Next"
        ;;
    
    previous|prev)
        kodi_rpc "Player.GoTo" '{"playerid": 1, "to": "previous"}' > /dev/null
        echo "⏮️ Previous"
        ;;
    
    # Volume controls
    volume)
        LEVEL="${1:-}"
        if [ -z "$LEVEL" ]; then
            # Get current volume
            RESULT=$(kodi_rpc "Application.GetProperties" '{"properties": ["volume", "muted"]}')
            echo "$RESULT"
        else
            kodi_rpc "Application.SetVolume" "{\"volume\": $LEVEL}" > /dev/null
            echo "🔊 Volume set to ${LEVEL}%"
        fi
        ;;
    
    mute)
        kodi_rpc "Application.SetMute" '{"mute": "toggle"}' > /dev/null
        echo "🔇 Mute toggled"
        ;;
    
    vol-up)
        kodi_rpc "Application.SetVolume" '{"volume": "increment"}' > /dev/null
        echo "🔊 Volume up"
        ;;
    
    vol-down)
        kodi_rpc "Application.SetVolume" '{"volume": "decrement"}' > /dev/null
        echo "🔉 Volume down"
        ;;
    
    # Navigation
    up)
        kodi_rpc "Input.Up" '{}' > /dev/null
        echo "⬆️ Up"
        ;;
    
    down)
        kodi_rpc "Input.Down" '{}' > /dev/null
        echo "⬇️ Down"
        ;;
    
    left)
        kodi_rpc "Input.Left" '{}' > /dev/null
        echo "⬅️ Left"
        ;;
    
    right)
        kodi_rpc "Input.Right" '{}' > /dev/null
        echo "➡️ Right"
        ;;
    
    select|enter)
        kodi_rpc "Input.Select" '{}' > /dev/null
        echo "✅ Select"
        ;;
    
    back)
        kodi_rpc "Input.Back" '{}' > /dev/null
        echo "🔙 Back"
        ;;
    
    home)
        kodi_rpc "Input.Home" '{}' > /dev/null
        echo "🏠 Home"
        ;;
    
    context|menu)
        kodi_rpc "Input.ContextMenu" '{}' > /dev/null
        echo "📋 Context menu"
        ;;
    
    info)
        kodi_rpc "Input.Info" '{}' > /dev/null
        echo "ℹ️ Info"
        ;;
    
    # Status & info
    status|now-playing)
        RESULT=$(kodi_rpc "Player.GetActivePlayers" '{}')
        
        if echo "$RESULT" | grep -q '"result":\[\]'; then
            echo "⏹️ Nothing playing"
        else
            # Get player info - show raw for now without jq
            echo "📺 Kodi is playing something"
            echo "$RESULT"
        fi
        ;;
    
    # Library
    movies)
        echo "🎬 Movies (raw JSON - install jq for pretty output):"
        kodi_rpc "VideoLibrary.GetMovies" '{"properties": ["title", "year"], "sort": {"order": "descending", "method": "dateadded"}, "limits": {"end": 20}}'
        ;;
    
    tv-shows|shows)
        echo "📺 TV Shows (raw JSON - install jq for pretty output):"
        kodi_rpc "VideoLibrary.GetTVShows" '{"properties": ["title", "year"], "sort": {"order": "ascending", "method": "title"}, "limits": {"end": 20}}'
        ;;
    
    recent)
        echo "🆕 Recently added (raw JSON - install jq for pretty output):"
        kodi_rpc "VideoLibrary.GetRecentlyAddedMovies" '{"properties": ["title", "year"], "limits": {"end": 10}}'
        ;;
    
    # System
    shutdown)
        echo "🔴 Shutting down Kodi system..."
        kodi_rpc "System.Shutdown" '{}'
        ;;
    
    reboot)
        echo "🔄 Rebooting Kodi system..."
        kodi_rpc "System.Reboot" '{}'
        ;;
    
    scan-library)
        echo "🔍 Scanning video library..."
        kodi_rpc "VideoLibrary.Scan" '{}'
        ;;
    
    clean-library)
        echo "🧹 Cleaning video library..."
        kodi_rpc "VideoLibrary.Clean" '{}'
        ;;
    
    # Playback
    seek)
        SECONDS="${1:-10}"
        kodi_rpc "Player.Seek" "{\"playerid\": 1, \"value\": {\"seconds\": $SECONDS}}" > /dev/null
        echo "⏩ Seeked ${SECONDS}s"
        ;;
    
    forward)
        kodi_rpc "Player.Seek" '{"playerid": 1, "value": "smallforward"}' > /dev/null
        echo "⏩ Forward 30s"
        ;;
    
    backward|rewind)
        kodi_rpc "Player.Seek" '{"playerid": 1, "value": "smallbackward"}' > /dev/null
        echo "⏪ Backward 30s"
        ;;
    
    # Input text
    text)
        TEXT="$*"
        if [ -z "$TEXT" ]; then
            echo "Error: text command requires text argument" >&2
            exit 1
        fi
        kodi_rpc "Input.SendText" "{\"text\": \"$TEXT\", \"done\": false}" > /dev/null
        echo "⌨️ Sent text: $TEXT"
        ;;
    
    # Show notification
    notify)
        TITLE="${1:-OpenClaw}"
        shift || true
        MESSAGE="$*"
        if [ -z "$MESSAGE" ]; then
            MESSAGE="Hello from OpenClaw!"
        fi
        kodi_rpc "GUI.ShowNotification" "{\"title\": \"$TITLE\", \"message\": \"$MESSAGE\", \"displaytime\": 5000}" > /dev/null
        echo "📢 Notification sent"
        ;;
    
    # Ping/test
    ping)
        RESULT=$(kodi_rpc "JSONRPC.Ping" '{}')
        if echo "$RESULT" | grep -q '"result":"pong"'; then
            echo "✅ Kodi is responding (pong)"
            exit 0
        else
            echo "❌ Kodi not responding"
            echo "Response: $RESULT"
            exit 1
        fi
        ;;
    
    # Raw command
    raw)
        METHOD="$1"
        shift || true
        PARAMS="$*"
        if [ -z "$PARAMS" ]; then
            PARAMS="{}"
        fi
        kodi_rpc "$METHOD" "$PARAMS"
        ;;
    
    # Help
    help|--help|-h|"")
        cat << 'EOF'
Kodi Remote Control Script

Usage: kodi.sh <command> [args]

Playback:
    play                Play/pause toggle
    pause               Pause playback
    stop                Stop playback
    next                Next track/episode
    previous            Previous track/episode
    forward             Skip forward 30s
    backward            Skip backward 30s
    seek <seconds>      Seek to position

Volume:
    volume [0-100]      Get or set volume
    mute                Toggle mute
    vol-up              Increase volume
    vol-down            Decrease volume

Navigation:
    up, down, left, right    Navigate UI
    select, enter            Select item
    back                     Go back
    home                     Go to home screen
    menu                     Open context menu
    info                     Show info
    text <string>            Send text input

Status:
    status              Show now playing
    movies              List movies (raw JSON)
    tv-shows            List TV shows (raw JSON)
    recent              Recently added (raw JSON)

System:
    ping                Test connection
    notify [title] <msg>    Show notification
    scan-library        Scan video library
    clean-library       Clean library
    shutdown            Shutdown system
    reboot              Reboot system

Advanced:
    raw <method> [params]   Send raw JSON-RPC command

Examples:
    kodi.sh play
    kodi.sh volume 50
    kodi.sh status
    kodi.sh text "search query"
    kodi.sh notify "Hello" "This is a test"
    kodi.sh raw Player.GetActivePlayers

Note: Install jq for prettier output formatting
EOF
        ;;
    
    *)
        echo "Unknown command: $CMD" >&2
        echo "Use 'kodi.sh help' for usage information" >&2
        exit 1
        ;;
esac
