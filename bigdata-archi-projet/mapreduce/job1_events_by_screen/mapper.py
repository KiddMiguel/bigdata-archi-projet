#!/usr/bin/env python3
import sys

for line in sys.stdin:
    line = line.strip()
    if not line:
        continue

    parts = line.split()
    # DATE TIME USER SCREEN EVENT HTTP_CODE RESPONSE_TIME
    if len(parts) != 7:
        continue

    screen = parts[3]
    sys.stdout.write(screen + "\t1\n")
