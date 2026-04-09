#!/usr/bin/env python3
import subprocess, psutil, time

prev = psutil.net_io_counters()
time.sleep(1)
now = psutil.net_io_counters()

down = now.bytes_recv - prev.bytes_recv
up = now.bytes_sent - prev.bytes_sent

def fmt(b):
    kb = b / 1024
    mb = kb / 1024
    return f"{mb:.1f}MB/s" if mb >= 1 else f"{kb:.0f}KB/s" if kb >= 1 else "--"

label = f"↓ {fmt(down)}  ↑ {fmt(up)}"
subprocess.run(["sketchybar", "--set", "network_speed", f"label={label}"])
