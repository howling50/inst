--[[
Twitch.tv playlist parser v0.3.1 by Stefan Sundin
https://gist.github.com/stefansundin/c200324149bb00001fef5a252a120fc2
https://www.opencode.net/stefansundin/twitch.lua
https://addons.videolan.org/p/1167220/

Once installed, you can open a twitch.tv url using "Open Network Stream..."
Features:
- Load a channel and watch live: https://www.twitch.tv/speedgaming
- Load an archived video: https://www.twitch.tv/videos/113837699
- Load a clip: https://clips.twitch.tv/AmazonianKnottyLapwingSwiftRage

This playlist parser utilizes a proxy since v0.3.0 since Twitch completely shut down their old API.
VLC can't make POST requests so there isn't another way to work around the problem.
For information about the proxy please go to https://github.com/stefansundin/media-resolver
You can run the proxy on your own computer but you'll have to edit the proxy_host variable below.

Installation:
Put the file in the lua/playlist/ directory:
- On Windows: %APPDATA%/vlc/lua/playlist/
- On Mac: $HOME/Library/Application Support/org.videolan.vlc/lua/playlist/
- On Linux: ~/.local/share/vlc/lua/playlist/
- On Linux (snap package): ~/snap/vlc/current/.local/share/vlc/lua/playlist/
To install the addon for all users, put the file here instead:
- On Windows: C:/Program Files/VideoLAN/VLC/lua/playlist/
- On Mac: /Applications/VLC.app/Contents/MacOS/share/lua/playlist/
- On Linux: /usr/lib/vlc/lua/playlist/
- On Linux (snap package): /snap/vlc/current/usr/lib/vlc/lua/playlist/

On Linux, you can download and install with the following command:
mkdir -p ~/.local/share/vlc/lua/playlist/; curl -o ~/.local/share/vlc/lua/playlist/twitch.lua https://gist.githubusercontent.com/stefansundin/c200324149bb00001fef5a252a120fc2/raw/twitch.lua

On Mac, you can download and install with the following command:
mkdir -p "$HOME/Library/Application Support/org.videolan.vlc/lua/playlist/"; curl -o "$HOME/Library/Application Support/org.videolan.vlc/lua/playlist/twitch.lua" https://gist.githubusercontent.com/stefansundin/c200324149bb00001fef5a252a120fc2/raw/twitch.lua

Changelog:
- v0.3.1: Added back support for clips.
- v0.3.0: Twitch finally completely shut down their old API. Because VLC scripts can't easily make POST requests it currently requires a proxy to work. To simplify things I removed all features besides loading a live channel and archived videos. I could potentially add back some of the features in the future but I am unsure if I have the will to do it.
- v0.2.3: Fix loading the list of a channel's old videos. Remove support for clips as it is broken and not easy to fix.
- v0.2.2: Fix 1080p on archived videos. Add audio only stream.
- v0.2.1: Skip live videos when loading /<channel>/videos.
- v0.2.0: Support new URLs. Most things seem to be working again.
- v0.1.3: Minor fix that prevented me from running this on Ubuntu 18.04 (snap package).
- v0.1.2: Support for /directory/game/<name>/videos/<type>.
- v0.1.1: Support for /<channel>/clips, /directory/game/<name>/clips. Add ability to load the next page.
- v0.1.0: Rewrote almost the whole thing. Support for /communities/<name>, /directory/game/<name>, /<channel>/videos/, collections.
- v0.0.6: Support new go.twitch.tv urls (beta site).
- v0.0.5: Fix a couple of minor issues.
- v0.0.4: Support new twitch.tv/videos/ urls.
- v0.0.3: Support for Twitch Clips.
- v0.0.2: You can now pick the stream quality you want. The twitch URL will expand to multiple playlist items.

Handy references:
https://github.com/videolan/vlc/blob/master/share/lua/README.txt
https://github.com/videolan/vlc/blob/7f6786ab6c8fb624726a63f07d79c23892827dfb/share/lua/playlist/appletrailers.lua#L34
--]]

function parse_json(str)
  vlc.msg.dbg("Parsing JSON: " .. str)
  local json = require("dkjson")
  return json.decode(str)
end

function get_json(url)
  vlc.msg.info("Getting JSON from " .. url)

  local stream = vlc.stream(url)
  local data = ""
  local line = ""

  if not stream then return false end

  while true do
    line = stream:readline()
    if not line then break end
    data = data .. line
  end

  return parse_json(data)
end

function get_streams(item)
  vlc.msg.info("Getting streams from " .. item.path)
  -- #EXTM3U
  -- #EXT-X-TWITCH-INFO:NODE="video-edge-c9010c.lax03",MANIFEST-NODE-TYPE="legacy",MANIFEST-NODE="video-edge-c9010c.lax03",SUPPRESS="false",SERVER-TIME="1483827093.91",USER-IP="76.94.205.190",SERVING-ID="4529b3c0570a46c8b3ed902f68b8368f",CLUSTER="lax03",ABS="false",BROADCAST-ID="24170411392",STREAM-TIME="5819.9121151",MANIFEST-CLUSTER="lax03"
  -- #EXT-X-MEDIA:TYPE=VIDEO,GROUP-ID="chunked",NAME="Source",AUTOSELECT=YES,DEFAULT=YES
  -- #EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=2838000,RESOLUTION=1280x720,VIDEO="chunked"

  local stream = vlc.stream(item.path)
  if not stream then
    return { { path="", name="Error fetching streams" } }
  end

  local items = {}
  local name = "error"
  -- local resolution = "error"

  while true do
    local line = stream:readline()
    if not line then break end
    if string.find(line, "^#.*NAME=") then
      name = string.match(line, "NAME=\"?([a-zA-Z0-9_ \\(\\)]+)\"?")
      if name == "audio_only" then
        name = "Audio Only"
      end
    -- elseif string.find(line, "^#.*RESOLUTION=") then
    --   resolution = string.match(line, "RESOLUTION=\"?([0-9x]+)\"?")
    elseif string.find(line, "^http") then
      -- Make a copy and overwrite some attributes
      local new_item = {}
      for k, v in pairs(item) do
        new_item[k] = v
      end
      new_item.path = line
      new_item.name = item.name.." ["..name.."]"
      table.insert(items, new_item)

      -- Uncomment the line below to only have the first stream appear (i.e. best quality)
      -- break
    end
  end

  return items
end

function url_encode(str)
  str = string.gsub(str, "\n", "\r\n")
  str = string.gsub(str, "([^%w %-%_%.%~])", function(c) return string.format("%%%02X", string.byte(c)) end)
  str = string.gsub(str, " ", "+")
  return str
end

function proxy_resolve(url)
  local proxy_host = "https://media-resolver.fly.dev"
  -- If you are running your own media resolver then comment out the line above and uncomment the line below:
  -- local proxy_host = "http://localhost:8080"
  return proxy_host.."/resolve?v=1&output=json&url="..url_encode(url)
end

function string.starts(haystack, needle)
  return string.sub(haystack, 1, string.len(needle)) == needle
end

function probe()
  return (vlc.access == "http" or vlc.access == "https") and (string.starts(vlc.path, "www.twitch.tv/") or string.starts(vlc.path, "go.twitch.tv/") or string.starts(vlc.path, "player.twitch.tv/") or string.starts(vlc.path, "clips.twitch.tv/"))
end

function parse()
  local url = vlc.access.."://"..vlc.path
  local data = get_json(proxy_resolve(url))
  if data.error then
    return { { path="", name="Error: "..data.error } }
  end

  local items = {}
  for _, item in ipairs(data) do
    if string.find(item.path, ".m3u8") then
      -- We resolve m3u8 files into quality options here because we won't get a chance to do it later
      for _, stream in ipairs(get_streams(item)) do
        table.insert(items, stream)
      end
    else
      table.insert(items, item)
    end
  end
  return items
end
