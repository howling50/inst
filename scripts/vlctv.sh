#!/bin/bash
VLCCMD="vlc --no-video-title-show --one-instance -f $HOME/.othercrap/greek.m3u"

if pgrep -f "$VLCCMD" >/dev/null; then
  pkill -f "$VLCCMD"
else
  $VLCCMD
fi
