#!/bin/bash

WORKSPACE=$1

declare -A WORKSPACE_APPS=(
  [2]="net.kovidgoyal.kitty"
  [8]="org.mozilla.librewolf"
  [9]="com.brave.Browser"
  [10]="com.google.Chrome"
)

APP=${WORKSPACE_APPS[$WORKSPACE]}

if [[ -n "$APP" ]]; then
  open -b "$APP"
fi
