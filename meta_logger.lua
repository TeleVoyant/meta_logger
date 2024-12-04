--[[
Stream Metadata Logger VLC Extension

About:
This Lua script logs metadata from internet radio streams
to a text file stream_metadata.txt in user directory.
* Remember to deactivate it, so as to clean up the text file

Disclaimer:
Despite that this plugin 'should' run on all platforms with vlc > 2.11,
it was developed and tested only on Linux operating system (so far)
YOUR MILLEAGE MAY VARY.

specs details (if needed somehow):
OS:        NixOS 24.05 (Uakari)
hardware:  HP ZBook Studio G3
processor: Intel® Core™ i7-6820HQ × 8

Installation:
prerequisite: VLC media player, working internet connection.
1. Save this file in VLC's lua/extensions directory:
   - Linux: ~/.local/share/vlc/lua/extensions/
2. Open VLC media player (or Reopen by quiting and opening again)
3. Navigate to your favourite internet radio station and play it.
4. Navigate to View > Stream metadata logger and click it.
5. Done.

To access logged stream data, open ~/stream_metadata.txt
I programmed this plugin (for the first time ever) over the weekend
to  roughly capture and log song metadata details (i.e. song title and artist)
plugin GUI is fairly complicated for me, is yet to be implemented.


LICENSE:
Copyright 2024 Daniel Tumaini
Authors:    Daniel Tumaini
Contact:    ditielo96.dtl@gmail.com

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
--]]

local log_file_path = "/home/niel/stream_metadata.txt"

function descriptor()
	return {
		title = "Stream Metadata Logger",
		version = "1.0",
		author = "Daniel Tumaini",
		url = "ditielo96.dtl@gmail.com",
		description = "Logs internet radio stream metadata to a text file",
		capabilities = { "input-listener" },
	}
end

local function read_last_entry()
	-- Open the file in read mode
	local file = io.open(log_file_path, "r")
	if not file then
		return nil, "Unable to open the file"
	end

	local last_line = nil

	-- Read the file line by line to find the last line
	for line in file:lines() do
		last_line = line
	end

	file:close()

	-- If the file is empty or last_line is nil, return nil
	if not last_line then
		return nil, "The file is empty"
	end

	-- Find the part after "| | "
	local metadata = last_line:match("| |%s*(.*)") or ""
	return metadata
end

local function cleanup_metadata_file()
	-- Read the entire file
	local file = io.open(log_file_path, "r")
	if not file then
		vlc.msg.dbg("Stream Metadata: Unable to open file for cleanup")
		return false
	end

	local dirty_lines = {} -- capture all lines
	local meh_lines = {}
	local clean_lines = {} -- capture clean lines

	-- Read all lines
	for line in file:lines() do
		table.insert(dirty_lines, line)
	end
	file:close()

	-- Phase 1: Filter out lines ending with "| | " or "| | - " or having empty metadata
	for _, line in ipairs(dirty_lines) do
		-- Check if the line does NOT end with "| | " or "| | - "
		if not line:match("| | %s*%-?%s*$") then
			table.insert(meh_lines, line)
		else
			vlc.msg.dbg("Stream Metadata: Removing empty line - " .. line)
		end
	end

	-- Phase 2: Filter out repetitive entries
	local prev_line = nil
	for _, line in ipairs(meh_lines) do
		-- check if prev_line is empty (indicating 1st iteration)
		if prev_line == nil then
			table.insert(clean_lines, line)
		else
			-- compare previous line content to the current
			if line:match("| |%s*(.+)") ~= prev_line:match("| |%s*(.+)") then
				table.insert(clean_lines, line)
			else
				vlc.msg.dbg("Stream Metadata: Removing dupe line - " .. line)
			end
		end
		prev_line = line -- increment before starting new iteration cycle
	end

	-- Write back the cleaned lines
	local write_file = io.open(log_file_path, "w")
	if write_file then
		for _, line in ipairs(clean_lines) do
			write_file:write(line .. "\n")
		end
		write_file:close()
		vlc.msg.dbg("Stream Metadata: Cleanup completed successfully")
		return true
	else
		vlc.msg.dbg("Stream Metadata: Unable to write cleaned file")
		return false
	end
end

local function meta_logger()
	local title = ""
	local now_playing = ""

	-- Traverse through the metadata: check if item holding metadata exists
	local item = vlc.input.item()
	if item then
		local metas = item:metas()
		-- Traverse through the metadata: capture title and now_playing
		for key, value in pairs(metas) do
			if key == "title" and value and tostring(value) ~= "" then
				title = tostring(value)
			end
			if key == "now_playing" and value and tostring(value) ~= "" then
				now_playing = tostring(value)
			end
		end
		vlc.msg.dbg("Stream Metadata: " .. title .. " | " .. now_playing)
	end

	if title == "" and now_playing == "" then
		vlc.msg.dbg("Stream Metadata: No metadata available")
		return
	end

	-- Checking for duplicate entries
	local last_now_playing, err = read_last_entry()
	if last_now_playing then
		if last_now_playing == now_playing then
			vlc.msg.dbg("Stream Metadata: Skipping dupe..")
			return
		end
	else
		vlc.msg.dbg("Stream Metadata: " .. err)
	end

	local log_file = io.open(log_file_path, "a") -- open in append mode

	if log_file then
		local timestamp = os.date("%Y-%m-%d %a %H:%M:%S %Z")
		local raw_timestamp = os.time()
		log_file:write(string.format("%s [%s] %s | | %s\n", raw_timestamp, timestamp, title, now_playing))
		log_file:close()
		vlc.msg.dbg("Stream Metadata logged successfully")
	else
		vlc.msg.dbg("Stream Metadata: Could not open log file for writing")
	end
end

function activate()
	vlc.msg.dbg("Stream Metadata Logger attempting to activate")

	-- Try to get current input
	local input = vlc.object.input()
	if not input then
		vlc.msg.dbg("Stream Metadata: No input object found during activation")
		return false
	end

	-- log metadata on first run, thereafter it will be called on metadata changes
	meta_logger()

	vlc.msg.info("Stream Metadata Logger activated")

	return true
end

function deactivate()
	vlc.msg.dbg("Stream Metadata Logger attempting to deactivate")

	-- calling the cleanup crew
	cleanup_metadata_file()

	vlc.msg.info("Stream Metadata Logger deactivated")
end

-- this will be called automatically whenever metadata changes
function meta_changed()
	meta_logger()
end
