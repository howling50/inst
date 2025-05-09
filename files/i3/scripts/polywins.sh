#!/bin/sh
# POLYWINS (Enhanced with Scratchpad Controls)

# SETTINGS {{{ ---

active_text_color="#c0caf5"
active_bg=
active_underline="#ECB3B2"

inactive_text_color="#250F0B"
inactive_bg=
inactive_underline=

separator="·"
show="window_class" # options: window_title, window_class, window_classname
forbidden_classes="Polybar Conky Gmrun"
empty_desktop_message="Desktop"

char_limit=20
max_windows=15
char_case="normal" # normal, upper, lower
add_spaces="true"

# --- }}}

main() {
	# If no argument passed...
	if [ -z "$2" ]; then
		xprop -root -spy _NET_CLIENT_LIST _NET_ACTIVE_WINDOW |
		while IFS= read -r _; do
			generate_window_list
		done
	else
		"$@"
	fi
}

# ON-CLICK FUNCTIONS {{{ ---

raise_or_minimize() {
	if [ "$(get_active_wid)" = "$1" ]; then
		wmctrl -ir "$1" -b toggle,hidden
	else
		wmctrl -ia "$1"
	fi
}

close() {
	wmctrl -ic "$1"
}

scratchpad_send() {
	i3-msg "[id=\"$1\"] move scratchpad"
}

scratchpad_show_window() {
	i3-msg scratchpad show, floating disable
}

# --- }}}

# WINDOW LIST SETUP {{{ ---

active_left="%{F$active_text_color}"
active_right="%{F-}"
inactive_left="%{F$inactive_text_color}"
inactive_right="%{F-}"
separator_fmt="%{F$inactive_text_color}$separator%{F-}"

# Underline and background styling omitted for brevity...

get_active_wid() {
	active_wid=$(xprop -root _NET_ACTIVE_WINDOW)
	active_wid="${active_wid#*# }"
	active_wid="${active_wid%,*}"
	while [ ${#active_wid} -lt 10 ]; do
		active_wid="0x0${active_wid#*x}"
	done
	echo "$active_wid"
}

get_active_workspace() {
	wmctrl -d |
	while IFS="[ .]" read -r number active_status _; do
		test "$active_status" = "*" && echo "$number" && break
	done
}

generate_window_list() {
	active_ws=$(get_active_workspace)
	active_wid=$(get_active_wid)
	count=0
	on_click="$0"

	while IFS="[ .\. ]" read -r wid ws cname cls host title; do
		# Skip unrelated workspaces
		if [ "$ws" != "$active_ws" ] && [ "$ws" != "-1" ]; then continue; fi
		# Skip forbidden classes
		case "$forbidden_classes" in *"$cls"*) continue ;; esac
		# Enforce max count
		if [ "$count" -ge "$max_windows" ]; then count=$((count+1)); continue; fi

		# Display name selection
		case "$show" in
			"window_class") name="$cls";;
			"window_classname") name="$cname";;
			"window_title") name="$title";;
		esac
		# Case conversion
		case "$char_case" in
			"lower") name=$(echo "$name" | tr '[:upper:]' '[:lower:]');;
			"upper") name=$(echo "$name" | tr '[:lower:]' '[:upper:]');;
		esac
		# Truncate
		[ ${#name} -gt $char_limit ] && name="${name:0:char_limit-1}…"
		# Spaces
		$add_spaces && name=" $name "
		# Styling
		if [ "$wid" = "$active_wid" ]; then
			display="${active_left}${name}${active_right}"
		else
			display="${inactive_left}${name}${inactive_right}"
		fi
		# Separator
		[ $count -ne 0 ] && printf "%s" "$separator_fmt"

		# Button bindings:
		# A1: left-click -> raise/minimize or show scratchpad
		if [ "$ws" = "-1" ]; then
			a1="scratchpad_show_window"
		else
			a1="raise_or_minimize"
		fi
		# A3: right-click -> send to scratchpad
		# A2: middle-click -> close
		printf "%%{A1:%s %s:}" "$on_click" "$a1 $wid"
		printf "%%{A3:%s %s:}" "$on_click" "scratchpad_send $wid"
		printf "%%{A2:%s %s:}" "$on_click" "close $wid"

		printf "%s" "$display"
		# Close click blocks
		printf "%%{A}%%{A}%%{A}"

		count=$((count+1))
	done <<-EOF
	$(wmctrl -lx)
	EOF

	# Overflow / empty messages
	[ $count -gt $max_windows ] && printf "+%s" "$((count-max_windows))"
	[ $count -eq 0 ] && printf "%s" "$empty_desktop_message"
	echo
}

# --- }}}

main "$@"
