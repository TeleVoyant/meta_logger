# VLC Metadata Logger Extension

## About:

This Lua script logs metadata from internet radio streams
to a text file stream_metadata.txt in user directory.

- Remember to deactivate it, so as to clean up the text file

## Background

I love listening to internet radio on VLC as i do some coding sessions.

I programmed this plugin (for the first time ever) over the weekend with a sole goal to
to roughly capture and log song metadata details (i.e. song title and artist) for later download

Often bangers are played, which then gets me on guilty road, getting me off my zen-mode
and start searching for the song name, before the next song is played and loose it forever.
this extension will log all that is played on a text file, so that i can focus on codes :)

## Disclaimer:

Despite that this plugin 'should' run on all platforms with vlc > 2.11,
it was developed and tested only on Linux operating system (so far)

YOUR MILLEAGE MAY VARY.

### specs details (if needed somehow):

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

plugin GUI (like [vlsub](https://github.com/exebetche/vlsub)) is fairly complicated for me, is yet to be implemented.

## Implementation Plans

Below are implementation Roadmap (This might change in the future)

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

Notes: been reading [vlsub](https://github.com/exebetche/vlsub/blob/master/vlsub.lua) source code, still haven't figured out the ends of it. getting there.

what to implement on GUI:

- `filter` metadata on to a list based on dates (start date and end date)
- select using checkboxes, multiple metadata filtered on the list
- click `flag favourite` to flag selected metadata as favourite
- configure server to download music from ( example: tubidy.id)
- click `download`, for seamless download of the songs selected on the list

## Thanks

Incase It's not obvious, This plugin was heavily inspired by [vlsub](https://github.com/exebetche/vlsub), Thanks [exebetche](https://github.com/exebetche).

## Issues and Contribution

Any Issues? perhaps Feature request? Open it on the Issues, I'll get back to you.

Wanna Contribute? Hit me up. I'm currently sketching contribution guidelines
