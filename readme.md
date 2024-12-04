# VLC Metadata Logger Extension

## About:

This Lua script logs metadata from internet radio streams
to a text file stream_metadata.txt in user directory.

- Remember to deactivate it, so as to clean up the text file

## Disclaimer:

Despite that this plugin 'should' run on all platforms with vlc > 2.11,
it was developed and tested only on Linux operating system (so far)
YOUR MILLEAGE MAY VARY.

specs details (if needed somehow):
OS: NixOS 24.05 (Uakari)
hardware: HP ZBook Studio G3
processor: Intel® Core™ i7-6820HQ × 8

## Installation:

prerequisite: VLC media player, working internet connection.

1. Save file `meta_logger.lua` in VLC's lua/extensions directory:
   - Linux: `~/.local/share/vlc/lua/extensions/`
2. Open VLC media player (or Reopen by quiting and opening again)
3. Navigate to your favourite internet radio station and play it.
4. Navigate to `View` > `Stream metadata logger` and click it.
5. Done.

## Accessing Metadata

To access logged stream data, open `~/stream_metadata.txt`
I programmed this plugin (for the first time ever) over the weekend with a goal to
to roughly capture and log song metadata details (i.e. song title and artist)
plugin GUI (like [vlsub]{}) is fairly complicated for me, is yet to be implemented.

## Plans

### Log stream metadata to a file for later song download

Done.
File: `stream_metadata.txt`,
Location: `$HOME`.

### Auto-clean file for when weird network glitches occur

Done.
Will be performed once, on plugin deactivation.
Advice: deactivate the plugin before quiting VLC by clicking `View` > `Stream metadata logger`
Forgot to deactivate the plugin? don't sweat it, you can always do it next time :)

### Flag last entry as favourite on certain hotkey press

Not Ready yet.
How: adding a character (say `*`) to a line to flag it as favourite
Position: replace `| |` with `|*|` on the last entry
challenge: hotkey support on VLC plugins seems glitchy

### GUI interface for hustle-free click and download

Not Implemented.
Notes: been reading [vlsub]{https://github.com/exebetche/vlsub/blob/master/vlsub.lua} source code, still haven't figured out the ends of it. getting there.
what to implement on GUI:

- `filter` metadata on to a list based on dates (start date and end date)
- select using checkboxes, multiple metadata filtered on the list
- click `flag favourite` to flag selected metadata as favourite
- configure server to download music from ( example: tubidy.id)
- click `download`, for seamless download of the songs selected on the list