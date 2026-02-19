#!/usr/bin/env python3
"""
Tesla Control Script - Wrapper around TeslaPy CLI

This script provides convenient commands for controlling a Tesla vehicle
using the TeslaPy library installed at ~/TeslaPy
"""

import sys
import os
import subprocess
from pathlib import Path

# TeslaPy installation path
TESLAPY_DIR = Path.home() / "TeslaPy"
TESLAPY_CLI = TESLAPY_DIR / "cli.py"
TESLAPY_VENV = TESLAPY_DIR / ".venv" / "bin" / "python"
EMAIL = "guido.domenici@gmail.com"


def run_tesla_command(args, capture=False):
    """Execute TeslaPy CLI command with proper environment"""
    if not TESLAPY_VENV.exists():
        print(f"Error: TeslaPy venv not found at {TESLAPY_VENV}", file=sys.stderr)
        sys.exit(1)
    
    if not TESLAPY_CLI.exists():
        print(f"Error: TeslaPy CLI not found at {TESLAPY_CLI}", file=sys.stderr)
        sys.exit(1)
    
    cmd = [str(TESLAPY_VENV), str(TESLAPY_CLI), "-e", EMAIL] + args
    
    if capture:
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode != 0:
            print(f"Error running command: {' '.join(args)}", file=sys.stderr)
            print(result.stderr, file=sys.stderr)
            sys.exit(result.returncode)
        return result.stdout
    else:
        # Pass through stdout/stderr directly
        result = subprocess.run(cmd)
        if result.returncode != 0:
            sys.exit(result.returncode)


def print_usage():
    """Print usage information"""
    print("""Tesla Control Script

Usage: tesla_control.py <command> [args]

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
    tesla_control.py status
    tesla_control.py climate on
    tesla_control.py charge limit 80
    tesla_control.py location
""")


def main():
    if len(sys.argv) < 2:
        print_usage()
        sys.exit(1)
    
    command = sys.argv[1].lower()
    
    if command == "list":
        run_tesla_command(["-l"])
    
    elif command == "status":
        run_tesla_command(["-g"])
    
    elif command == "wake":
        print("Waking up vehicle...")
        run_tesla_command(["-w"])
        print("✅ Vehicle is awake")
    
    elif command == "climate":
        if len(sys.argv) < 3:
            print("Error: climate command requires 'on' or 'off'", file=sys.stderr)
            sys.exit(1)
        action = sys.argv[2].lower()
        if action == "on":
            print("Starting climate control...")
            run_tesla_command(["-c", "CLIMATE_ON"])
            print("✅ Climate control started")
        elif action == "off":
            print("Stopping climate control...")
            run_tesla_command(["-c", "CLIMATE_OFF"])
            print("✅ Climate control stopped")
        else:
            print(f"Invalid climate action: {action}. Use 'on' or 'off'", file=sys.stderr)
            sys.exit(1)
    
    elif command == "lock":
        if len(sys.argv) < 3:
            print("Error: lock command requires 'lock' or 'unlock'", file=sys.stderr)
            sys.exit(1)
        action = sys.argv[2].lower()
        if action == "lock":
            print("Locking doors...")
            run_tesla_command(["-c", "LOCK"])
            print("🔒 Doors locked")
        elif action == "unlock":
            print("Unlocking doors...")
            run_tesla_command(["-c", "UNLOCK"])
            print("🔓 Doors unlocked")
        else:
            print(f"Invalid lock action: {action}. Use 'lock' or 'unlock'", file=sys.stderr)
            sys.exit(1)
    
    elif command == "honk":
        print("Honking horn...")
        run_tesla_command(["-c", "HONK_HORN"])
        print("📣 Honked!")
    
    elif command == "flash":
        print("Flashing lights...")
        run_tesla_command(["-c", "FLASH_LIGHTS"])
        print("💡 Lights flashed!")
    
    elif command == "charge":
        if len(sys.argv) < 3:
            print("Error: charge command requires 'start', 'stop', or 'limit'", file=sys.stderr)
            sys.exit(1)
        action = sys.argv[2].lower()
        
        if action == "start":
            print("Starting charge...")
            run_tesla_command(["-c", "START_CHARGE"])
            print("🔌 Charging started")
        elif action == "stop":
            print("Stopping charge...")
            run_tesla_command(["-c", "STOP_CHARGE"])
            print("⏸️  Charging stopped")
        elif action == "limit":
            if len(sys.argv) < 4:
                print("Error: charge limit requires a percentage value", file=sys.stderr)
                sys.exit(1)
            try:
                limit = int(sys.argv[3])
                if not 50 <= limit <= 100:
                    print("Error: charge limit must be between 50 and 100", file=sys.stderr)
                    sys.exit(1)
                print(f"Setting charge limit to {limit}%...")
                run_tesla_command(["-c", "SET_CHARGE_LIMIT", "-k", f"percent={limit}"])
                print(f"✅ Charge limit set to {limit}%")
            except ValueError:
                print("Error: charge limit must be a number", file=sys.stderr)
                sys.exit(1)
        else:
            print(f"Invalid charge action: {action}. Use 'start', 'stop', or 'limit'", file=sys.stderr)
            sys.exit(1)
    
    elif command == "location":
        run_tesla_command(["-G"])
    
    else:
        print(f"Unknown command: {command}", file=sys.stderr)
        print_usage()
        sys.exit(1)


if __name__ == "__main__":
    main()
