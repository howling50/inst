#!/bin/bash
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
rm /tmp/polybar*
rm /tmp/ipc-polybar*
polybar main &
