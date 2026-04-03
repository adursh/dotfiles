#!/usr/bin/env bash

APP="${1:-$(basename "$0")}"
MSG="${2:-Reloaded}"

USER_ID=$(id -u)

launchctl asuser "$USER_ID" osascript \
  -e "display notification \"$MSG\" with title \"$APP\""
