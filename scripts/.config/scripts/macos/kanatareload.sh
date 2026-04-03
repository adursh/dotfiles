#!/usr/bin/env bash
USER_ID=$(id -u "nvc")
launchctl asuser "$USER_ID" osascript -e 'display notification "Kanata reloaded" with title "Kanata"'
