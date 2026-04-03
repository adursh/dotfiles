#!/usr/bin/env python3
import time, psutil

prev = psutil.net_io_counters()
time.sleep(1)
now = psutil.net_io_counters()

down = now.bytes_recv - prev.bytes_recv
up = now.bytes_sent - prev.bytes_sent

def format_speed(bytes_per_sec):
    kb = bytes_per_sec / 1024
    mb = kb / 1024
    return f"{mb:.1f}MB" if mb >= 1 else f"{kb:.0f}KB "

# FontAwesome: Upload = \uf062, Download = \uf063
print(f"\uf063 {format_speed(down)}  \uf062 {format_speed(up)}")
