#!/bin/bash
osascript -e 'tell application "System Events" to tell the front menu bar of process "SystemUIServer" to tell (first menu bar item whose description is "Siri") to perform action "AXPress"'
