#!/bin/bash

osascript -e "tell application \"System Events\" to key code 111"
tmux refresh-client -S
