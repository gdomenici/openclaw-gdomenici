# Kodi JSON-RPC API Reference

Complete reference for Kodi JSON-RPC API v12 (compatible with Kodi 19+).

## Connection

**Endpoint:** `http://100.78.70.92:8080/jsonrpc`  
**Method:** POST  
**Content-Type:** application/json

## Request Format

```json
{
  "jsonrpc": "2.0",
  "method": "Method.Name",
  "params": { },
  "id": 1
}
```

## Response Format

```json
{
  "id": 1,
  "jsonrpc": "2.0",
  "result": { }
}
```

## Player Methods

### Player.GetActivePlayers
Get list of active players (video, audio, picture).

```json
{"jsonrpc": "2.0", "method": "Player.GetActivePlayers", "id": 1}
```

### Player.GetItem
Get currently playing item with details.

```json
{
  "jsonrpc": "2.0",
  "method": "Player.GetItem",
  "params": {
    "playerid": 1,
    "properties": ["title", "album", "artist", "duration", "thumbnail", "file", "fanart", "streamdetails"]
  },
  "id": 1
}
```

### Player.GetProperties
Get playback properties (time, speed, percentage, etc).

```json
{
  "jsonrpc": "2.0",
  "method": "Player.GetProperties",
  "params": {
    "playerid": 1,
    "properties": ["time", "totaltime", "percentage", "speed", "position"]
  },
  "id": 1
}
```

### Player.PlayPause
Toggle or set play/pause state.

```json
{"jsonrpc": "2.0", "method": "Player.PlayPause", "params": {"playerid": 1}, "id": 1}
{"jsonrpc": "2.0", "method": "Player.PlayPause", "params": {"playerid": 1, "play": false}, "id": 1}
```

### Player.Stop
Stop playback.

```json
{"jsonrpc": "2.0", "method": "Player.Stop", "params": {"playerid": 1}, "id": 1}
```

### Player.GoTo
Go to next/previous item or specific position.

```json
{"jsonrpc": "2.0", "method": "Player.GoTo", "params": {"playerid": 1, "to": "next"}, "id": 1}
{"jsonrpc": "2.0", "method": "Player.GoTo", "params": {"playerid": 1, "to": "previous"}, "id": 1}
{"jsonrpc": "2.0", "method": "Player.GoTo", "params": {"playerid": 1, "to": 5}, "id": 1}
```

### Player.Seek
Seek to position.

```json
// Seek by seconds
{"jsonrpc": "2.0", "method": "Player.Seek", "params": {"playerid": 1, "value": {"seconds": 120}}, "id": 1}

// Seek by percentage
{"jsonrpc": "2.0", "method": "Player.Seek", "params": {"playerid": 1, "value": {"percentage": 50}}, "id": 1}

// Predefined jumps
{"jsonrpc": "2.0", "method": "Player.Seek", "params": {"playerid": 1, "value": "smallforward"}, "id": 1}
{"jsonrpc": "2.0", "method": "Player.Seek", "params": {"playerid": 1, "value": "smallbackward"}, "id": 1}
{"jsonrpc": "2.0", "method": "Player.Seek", "params": {"playerid": 1, "value": "bigforward"}, "id": 1}
{"jsonrpc": "2.0", "method": "Player.Seek", "params": {"playerid": 1, "value": "bigbackward"}, "id": 1}
```

### Player.SetSpeed
Control playback speed.

```json
{"jsonrpc": "2.0", "method": "Player.SetSpeed", "params": {"playerid": 1, "speed": 1}, "id": 1}
{"jsonrpc": "2.0", "method": "Player.SetSpeed", "params": {"playerid": 1, "speed": 2}, "id": 1}
```

### Player.SetAudioStream
Switch audio stream.

```json
{"jsonrpc": "2.0", "method": "Player.SetAudioStream", "params": {"playerid": 1, "stream": "next"}, "id": 1}
```

### Player.SetSubtitle
Control subtitles.

```json
// Enable subtitles
{"jsonrpc": "2.0", "method": "Player.SetSubtitle", "params": {"playerid": 1, "subtitle": "on"}, "id": 1}

// Disable subtitles
{"jsonrpc": "2.0", "method": "Player.SetSubtitle", "params": {"playerid": 1, "subtitle": "off"}, "id": 1}

// Next subtitle
{"jsonrpc": "2.0", "method": "Player.SetSubtitle", "params": {"playerid": 1, "subtitle": "next"}, "id": 1}
```

## Application Methods

### Application.GetProperties
Get application properties (volume, muted, name, version).

```json
{
  "jsonrpc": "2.0",
  "method": "Application.GetProperties",
  "params": {"properties": ["volume", "muted", "name", "version"]},
  "id": 1
}
```

### Application.SetVolume
Set volume level.

```json
// Set specific volume (0-100)
{"jsonrpc": "2.0", "method": "Application.SetVolume", "params": {"volume": 50}, "id": 1}

// Increment/decrement
{"jsonrpc": "2.0", "method": "Application.SetVolume", "params": {"volume": "increment"}, "id": 1}
{"jsonrpc": "2.0", "method": "Application.SetVolume", "params": {"volume": "decrement"}, "id": 1}
```

### Application.SetMute
Mute or unmute.

```json
{"jsonrpc": "2.0", "method": "Application.SetMute", "params": {"mute": "toggle"}, "id": 1}
{"jsonrpc": "2.0", "method": "Application.SetMute", "params": {"mute": true}, "id": 1}
```

## Input Methods

### Input Navigation
```json
{"jsonrpc": "2.0", "method": "Input.Up", "id": 1}
{"jsonrpc": "2.0", "method": "Input.Down", "id": 1}
{"jsonrpc": "2.0", "method": "Input.Left", "id": 1}
{"jsonrpc": "2.0", "method": "Input.Right", "id": 1}
{"jsonrpc": "2.0", "method": "Input.Select", "id": 1}
{"jsonrpc": "2.0", "method": "Input.Back", "id": 1}
{"jsonrpc": "2.0", "method": "Input.Home", "id": 1}
{"jsonrpc": "2.0", "method": "Input.ContextMenu", "id": 1}
{"jsonrpc": "2.0", "method": "Input.Info", "id": 1}
```

### Input.SendText
Send text to active input field.

```json
{"jsonrpc": "2.0", "method": "Input.SendText", "params": {"text": "search query", "done": false}, "id": 1}
```

### Input.ShowOSD
Show on-screen display.

```json
{"jsonrpc": "2.0", "method": "Input.ShowOSD", "id": 1}
```

## VideoLibrary Methods

### VideoLibrary.GetMovies
Get list of movies.

```json
{
  "jsonrpc": "2.0",
  "method": "VideoLibrary.GetMovies",
  "params": {
    "properties": ["title", "year", "rating", "runtime", "genre", "director", "plot"],
    "sort": {"order": "ascending", "method": "title"},
    "limits": {"start": 0, "end": 50}
  },
  "id": 1
}
```

### VideoLibrary.GetTVShows
Get list of TV shows.

```json
{
  "jsonrpc": "2.0",
  "method": "VideoLibrary.GetTVShows",
  "params": {
    "properties": ["title", "year", "rating", "genre", "plot"],
    "sort": {"order": "ascending", "method": "title"}
  },
  "id": 1
}
```

### VideoLibrary.GetEpisodes
Get episodes for a TV show.

```json
{
  "jsonrpc": "2.0",
  "method": "VideoLibrary.GetEpisodes",
  "params": {
    "tvshowid": 1,
    "properties": ["title", "season", "episode", "rating", "firstaired"],
    "sort": {"order": "ascending", "method": "episode"}
  },
  "id": 1
}
```

### VideoLibrary.GetRecentlyAddedMovies
Get recently added movies.

```json
{
  "jsonrpc": "2.0",
  "method": "VideoLibrary.GetRecentlyAddedMovies",
  "params": {
    "properties": ["title", "year", "dateadded"],
    "limits": {"end": 20}
  },
  "id": 1
}
```

### VideoLibrary.Scan
Scan video library for new content.

```json
{"jsonrpc": "2.0", "method": "VideoLibrary.Scan", "id": 1}
{"jsonrpc": "2.0", "method": "VideoLibrary.Scan", "params": {"directory": "/path/to/media"}, "id": 1}
```

### VideoLibrary.Clean
Clean video library (remove missing items).

```json
{"jsonrpc": "2.0", "method": "VideoLibrary.Clean", "id": 1}
```

## AudioLibrary Methods

### AudioLibrary.GetArtists
```json
{
  "jsonrpc": "2.0",
  "method": "AudioLibrary.GetArtists",
  "params": {
    "properties": ["genre", "formed"],
    "sort": {"order": "ascending", "method": "artist"}
  },
  "id": 1
}
```

### AudioLibrary.GetAlbums
```json
{
  "jsonrpc": "2.0",
  "method": "AudioLibrary.GetAlbums",
  "params": {
    "properties": ["title", "artist", "year", "rating"],
    "sort": {"order": "ascending", "method": "title"}
  },
  "id": 1
}
```

## System Methods

### System.Shutdown
Shut down the system.

```json
{"jsonrpc": "2.0", "method": "System.Shutdown", "id": 1}
```

### System.Reboot
Reboot the system.

```json
{"jsonrpc": "2.0", "method": "System.Reboot", "id": 1}
```

### System.Suspend
Suspend/sleep the system.

```json
{"jsonrpc": "2.0", "method": "System.Suspend", "id": 1}
```

### System.Hibernate
Hibernate the system.

```json
{"jsonrpc": "2.0", "method": "System.Hibernate", "id": 1}
```

## Playlist Methods

### Playlist.GetPlaylists
Get available playlists.

```json
{"jsonrpc": "2.0", "method": "Playlist.GetPlaylists", "id": 1}
```

### Playlist.GetItems
Get items in a playlist.

```json
{
  "jsonrpc": "2.0",
  "method": "Playlist.GetItems",
  "params": {
    "playlistid": 1,
    "properties": ["title", "album", "artist", "duration"]
  },
  "id": 1
}
```

### Playlist.Add
Add item to playlist.

```json
{
  "jsonrpc": "2.0",
  "method": "Playlist.Add",
  "params": {
    "playlistid": 1,
    "item": {"movieid": 5}
  },
  "id": 1
}
```

### Playlist.Clear
Clear playlist.

```json
{"jsonrpc": "2.0", "method": "Playlist.Clear", "params": {"playlistid": 1}, "id": 1}
```

## GUI Methods

### GUI.ShowNotification
Show a notification.

```json
{
  "jsonrpc": "2.0",
  "method": "GUI.ShowNotification",
  "params": {
    "title": "Hello",
    "message": "This is a notification",
    "displaytime": 5000
  },
  "id": 1
}
```

### GUI.ActivateWindow
Activate a specific window.

```json
{"jsonrpc": "2.0", "method": "GUI.ActivateWindow", "params": {"window": "videos"}, "id": 1}
{"jsonrpc": "2.0", "method": "GUI.ActivateWindow", "params": {"window": "music"}, "id": 1}
{"jsonrpc": "2.0", "method": "GUI.ActivateWindow", "params": {"window": "home"}, "id": 1}
```

## Common Player IDs

- **0**: Picture player
- **1**: Video player  
- **2**: Audio player

## Useful Properties

### Video properties
`title`, `year`, `rating`, `runtime`, `genre`, `director`, `writer`, `studio`, `plot`, `plotoutline`, `tagline`, `thumbnail`, `fanart`, `file`, `dateadded`, `lastplayed`, `playcount`

### Audio properties
`title`, `artist`, `album`, `year`, `genre`, `duration`, `rating`, `thumbnail`, `fanart`, `file`

### Player properties
`time`, `totaltime`, `percentage`, `speed`, `position`, `repeat`, `shuffled`, `canseek`, `canchangespeed`, `canrepeat`, `canshuffle`

## Curl Examples

```bash
# Test ping
curl -s -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"JSONRPC.Ping","id":1}' http://100.78.70.92:8080/jsonrpc

# Get active players
curl -s -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"Player.GetActivePlayers","id":1}' http://100.78.70.92:8080/jsonrpc

# Toggle play/pause
curl -s -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"Player.PlayPause","params":{"playerid":1},"id":1}' http://100.78.70.92:8080/jsonrpc
```

## Documentation Links

- Official Kodi JSON-RPC API: https://kodi.wiki/view/JSON-RPC_API
- API v12 Specification: https://kodi.wiki/view/JSON-RPC_API/v12
